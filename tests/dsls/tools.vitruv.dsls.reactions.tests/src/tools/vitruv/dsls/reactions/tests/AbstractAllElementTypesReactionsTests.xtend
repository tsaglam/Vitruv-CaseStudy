package tools.vitruv.dsls.reactions.tests

import allElementTypes.AllElementTypesFactory
import allElementTypes.NonRootObjectContainerHelper
import tools.vitruv.framework.tests.VitruviusApplicationTest
import tools.vitruv.framework.testutils.domains.AllElementTypesDomainProvider
import tools.vitruv.framework.util.datatypes.VURI

abstract class AbstractAllElementTypesReactionsTests extends VitruviusApplicationTest {
	protected static val MODEL_FILE_EXTENSION = new AllElementTypesDomainProvider().domain.fileExtensions.get(0);

	protected override getVitruvDomains() {
		return #[new AllElementTypesDomainProvider().domain];
	}

	protected static final def String getProjectModelPath(String modelName) {
		'''model/«modelName».«MODEL_FILE_EXTENSION»'''
	}

	protected def VURI calculateVURI(String path) {
		VURI::getInstance('''«currentTestProject.name»/«path.projectModelPath»''')
	}

	protected static final def void createAndAddNonRoot(String id, NonRootObjectContainerHelper container) {
		val nonRoot = AllElementTypesFactory::eINSTANCE.createNonRoot
		nonRoot.id = id
		container.nonRootObjectsContainment.add(nonRoot)
	}

}
