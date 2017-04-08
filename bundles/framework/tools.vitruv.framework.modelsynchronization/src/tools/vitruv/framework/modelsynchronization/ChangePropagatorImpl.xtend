package tools.vitruv.framework.modelsynchronization

import java.util.ArrayList
import java.util.Collections
import java.util.HashSet
import java.util.List
import java.util.Set
import java.util.concurrent.Callable
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.change.description.CompositeContainerChange
import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.change.processing.ChangePropagationSpecification
import tools.vitruv.framework.change.processing.ChangePropagationSpecificationProvider
import tools.vitruv.framework.correspondence.CorrespondenceProviding
import tools.vitruv.framework.metamodel.MetamodelRepository
import tools.vitruv.framework.metamodel.ModelRepository
import tools.vitruv.framework.util.command.ChangePropagationResult
import tools.vitruv.framework.util.command.EMFCommandBridge
import tools.vitruv.framework.util.datatypes.Pair
import tools.vitruv.framework.util.datatypes.VURI

class ChangePropagatorImpl implements ChangePropagator {
	static Logger logger = Logger.getLogger(ChangePropagatorImpl.getSimpleName())
	final MetamodelRepository metamodelRepository;
	final ModelRepository modelProviding
	final ChangePropagationSpecificationProvider changePropagationProvider
	final CorrespondenceProviding correspondenceProviding
	Set<ChangePropagationListener> changePropagationListeners
	
	new(ModelRepository modelProviding, ChangePropagationSpecificationProvider changePropagationProvider,
		MetamodelRepository metamodelRepository, CorrespondenceProviding correspondenceProviding) {
		this.modelProviding = modelProviding
		this.changePropagationProvider = changePropagationProvider
		this.correspondenceProviding = correspondenceProviding
		this.changePropagationListeners = new HashSet<ChangePropagationListener>()
		this.metamodelRepository = metamodelRepository;
	}

	override void addChangePropagationListener(ChangePropagationListener propagationListener) {
		if (propagationListener !== null) {
			this.changePropagationListeners.add(propagationListener)
		}
	}

	override void removeChangePropagationListener(ChangePropagationListener propagationListener) {
		this.changePropagationListeners.remove(propagationListener)
	}

	override synchronized List<List<VitruviusChange>> propagateChange(VitruviusChange change) {
		if (change == null || !change.containsConcreteChange()) {
			logger.info('''The change does not contain any changes to synchronize: «change»''')
			return Collections.emptyList()
		}
		if (!change.validate()) {
			throw new IllegalArgumentException('''Change contains changes from different models: «change»''')
		}

		this.modelProviding.forceReloadModelIfExisting(change.URI)
		startChangePropagation(change);

		modelProviding.createRecordingCommandAndExecuteCommandOnTransactionalDomain(
			new Callable<Void>() {
				override call() throws Exception {
					change.resolveAfterAndApplyBackward(modelProviding.resourceSet);
					return null
				}
            }
        )

		var List<List<VitruviusChange>> result = new ArrayList<List<VitruviusChange>>()
		val changedResourcesTracker = new ChangedResourcesTracker();
		propagateSingleChange(change, result, changedResourcesTracker);
		changedResourcesTracker.markNonSourceResourceAsChanged();
		finishChangePropagation(change)
		return result
	}

	private def void startChangePropagation(VitruviusChange change) {
		logger.info('''Started synchronizing change: «change»''')
		for (ChangePropagationListener syncListener : this.changePropagationListeners) {
			syncListener.startedChangePropagation()
		}	
	}

	private def void finishChangePropagation(VitruviusChange change) {
		for (ChangePropagationListener syncListener : this.changePropagationListeners) {
			syncListener.finishedChangePropagation()
		}
		logger.info('''Finished synchronizing change: «change»''')
	}

	private def dispatch void propagateSingleChange(CompositeContainerChange change, List<List<VitruviusChange>> commandExecutionChanges,
		ChangedResourcesTracker changedResourcesTracker) {
		for (VitruviusChange innerChange : ((change as CompositeContainerChange)).getChanges()) {
			propagateSingleChange(innerChange, commandExecutionChanges, changedResourcesTracker)
		}
	}

	private def dispatch void propagateSingleChange(TransactionalChange change, 
		List<List<VitruviusChange>> commandExecutionChanges, ChangedResourcesTracker changedResourcesTracker) {
			
		val command = EMFCommandBridge.createVitruviusTransformationRecordingCommand([|
			change.applyForward
			return null
		])
		modelProviding.executeRecordingCommandOnTransactionalDomain(command);
		
		val changeMetamodel = metamodelRepository.getMetamodel(change.URI.fileExtension);
		for (propagationSpecification : changePropagationProvider.getChangePropagationSpecifications(changeMetamodel.URI)) {
			propagateChangeForChangePropagationSpecification(change, propagationSpecification, commandExecutionChanges, changedResourcesTracker);
		}
	}
	
	private def void propagateChangeForChangePropagationSpecification(TransactionalChange change, ChangePropagationSpecification propagationSpecification,
			List<List<VitruviusChange>> commandExecutionChanges, ChangedResourcesTracker changedResourcesTracker) {
		val correspondenceModel = correspondenceProviding.getCorrespondenceModel(propagationSpecification.metamodelPair.first, propagationSpecification.metamodelPair.second);
		// TODO HK: Clone the changes for each synchronization! Should even be cloned for
		// each consistency repair routines that uses it,
		// or: make them read only, i.e. give them a read-only interface!
		val command = EMFCommandBridge.createVitruviusTransformationRecordingCommand([|
			return propagationSpecification.propagateChange(change, correspondenceModel);
		])
		modelProviding.executeRecordingCommandOnTransactionalDomain(command);
		val propagationResult = command.transformationResult;
				
		// Store modification information
		val changedEObjects = command.getAffectedObjects().filter(EObject)
		changedEObjects.forEach[changedResourcesTracker.addInvolvedModelResource(it.eResource)];
		changedResourcesTracker.addSourceResourceOfChange(change);
		
		// FIXME HK Put this to the correct place, if change replay to the VSUM is integrated:
		// Propagation result execution has to be performed after modification information extraction
		// because otherwise some resources do potentially not exist anymore 
		this.executePropagationResult(propagationResult)	
	}
	
	def private void executePropagationResult(ChangePropagationResult transformationResult) {
		if (null === transformationResult) {
			logger.info("Current TransformationResult is null. Can not save new root EObjects or delete VURIs.")
			return;
		}
		for (VURI vuriToDelete : transformationResult.getVurisToDelete()) {
			modelProviding.deleteModel(vuriToDelete)
		}
		for (Pair<EObject, VURI> createdEObjectVURIPair : transformationResult.getRootEObjectsToSave()) {
			modelProviding.createModel(createdEObjectVURIPair.getSecond(), createdEObjectVURIPair.getFirst())
		}
	}
}
