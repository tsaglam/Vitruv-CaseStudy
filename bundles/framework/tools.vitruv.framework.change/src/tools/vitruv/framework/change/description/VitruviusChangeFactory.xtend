package tools.vitruv.framework.change.description

import tools.vitruv.framework.change.description.impl.VitruviusChangeFactoryImpl
import tools.vitruv.framework.util.datatypes.VURI
import org.eclipse.emf.ecore.change.ChangeDescription
import tools.vitruv.framework.change.echange.EChange
import org.eclipse.emf.ecore.resource.Resource

interface VitruviusChangeFactory {
	VitruviusChangeFactory factoryInstance = VitruviusChangeFactoryImpl::init

	public enum FileChangeKind {
		Create,
		Delete
	}

	static def VitruviusChangeFactory getInstance() {
		factoryInstance
	}

	/**
	 * Generates a change from the given {@link ChangeDescription}. This factory method has to be called when the model
	 * is in the state right before the change described by the recorded {@link ChangeDescription}.
	 */
	def TransactionalChange createEMFModelChange(ChangeDescription changeDescription, VURI vuri)

	def TransactionalChange createLegacyEMFModelChange(ChangeDescription changeDescription, VURI vuri)

	def ConcreteChange createConcreteApplicableChange(EChange change, VURI vuri)

	def ConcreteChange createConcreteChange(EChange change, VURI vuri)

	def ConcreteChange createFileChange(FileChangeKind kind, Resource changedFileResource)

	def CompositeContainerChange createCompositeContainerChange()

	def CompositeTransactionalChange createCompositeTransactionalChange()

	def TransactionalChange createEmptyChange(VURI vuri)

	def CompositeContainerChange createCompositeChange(Iterable<? extends VitruviusChange> innerChanges)

}
