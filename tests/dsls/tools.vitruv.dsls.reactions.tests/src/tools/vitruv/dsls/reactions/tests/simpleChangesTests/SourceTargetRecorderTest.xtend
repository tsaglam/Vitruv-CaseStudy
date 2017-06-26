package tools.vitruv.dsls.reactions.tests.simpleChangesTests

import allElementTypes.AllElementTypesFactory
import allElementTypes.Root
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.ObjectInputStream
import java.io.ObjectOutputStream
import java.util.List
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.junit.Assert
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder
import tools.vitruv.framework.change.copy.ChangeCopyFactory
import tools.vitruv.framework.change.description.impl.EMFModelChangeImpl
import tools.vitruv.framework.util.datatypes.VURI
import tools.vitruv.framework.versioning.SourceTargetRecorder
import tools.vitruv.framework.versioning.VersioningXtendFactory
import tools.vitruv.framework.versioning.commit.ChangeMatch
import tools.vitruv.framework.versioning.impl.SourceTargetRecorderImpl
import tools.vitruv.framework.vsum.InternalModelRepository
import tools.vitruv.framework.vsum.InternalTestVirtualModel

import static org.hamcrest.CoreMatchers.equalTo
import static org.hamcrest.CoreMatchers.is
import static org.junit.Assert.assertThat

class SourceTargetRecorderTest extends AbstractVersioningTest {
	static val logger = Logger::getLogger(SourceTargetRecorderTest)
	static val newTestSourceModelName = "EachTestModelSource2"
	static val newTestTargetModelName = "EachTestModelTarget2"
	static val nonRootObjectContainerName = "NonRootObjectContainer"
	SourceTargetRecorder stRecorder

	@Rule
	public val tempFolder = new TemporaryFolder

	override setup() {
		super.setup
		logger.level = Level::DEBUG
		// Setup sourceTargetRecorder 
		stRecorder = VersioningXtendFactory::instance.createSourceTargetRecorder(virtualModel)
		stRecorder.registerObserver
	}

	override cleanup() {
		super.cleanup
		stRecorder = null
	}

	override unresolveChanges() {
		true
	}

	@Test
	def testAddPathToRecorded() {
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container)]

		val resourcePlatformPath = '''«currentTestProject.name»/«TEST_TARGET_MODEL_NAME.projectModelPath»'''
		val resourceVuri = VURI::getInstance(resourcePlatformPath)
		(stRecorder as SourceTargetRecorderImpl).addPathToRecorded(resourceVuri)

		rootElement.saveAndSynchronizeChanges

		assertModelsEqual
		val changes = (stRecorder as SourceTargetRecorderImpl).getChanges(resourceVuri)
		Assert::assertEquals(4, changes.length)
	}

	@Test
	def testSingleChangeSynchronization() {
		val resourcePlatformPath = '''«currentTestProject.name»/«TEST_TARGET_MODEL_NAME.projectModelPath»'''
		val resourceVuri = VURI::getInstance(resourcePlatformPath)
		(stRecorder as SourceTargetRecorderImpl).addPathToRecorded(resourceVuri)

		// Create container and synchronize 
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges

		NON_CONTAINMENT_NON_ROOT_IDS.forEach [
			createAndAddNonRoot(container)
			rootElement.saveAndSynchronizeChanges
			assertModelsEqual
		]
	}

	@Test
	def void testRecordOriginalAndCorrespondentChanges() {
		// Paths and VURIs
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		val sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		// Create container and synchronize 
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges
		val changesMatches = stRecorder.getChangeMatches(sourceVURI)
		assertThat(changesMatches.length, is(1))

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach [
			createAndAddNonRoot(container)
			rootElement.saveAndSynchronizeChanges
			assertModelsEqual
		]
		assertThat(changesMatches.length, is(4))
		assertThat(changesMatches.forall[sourceVURI == originalVURI], is(true))
		assertThat(changesMatches.forall[null !== targetToCorrespondentChanges.get(targetVURI)], is(true))
		val message = changesMatches.filter[0 == targetToCorrespondentChanges.get(targetVURI).length].map [
			toString
		].reduce[p1, p2|p1 + p2]
		assertThat(message, changesMatches.forall [
			0 < targetToCorrespondentChanges.get(targetVURI).length
		], is(true))
	}

	@Test
	def void testRecordOriginalAndCorrespondentChangesSingleSaveAndSynchronize() {
		// Paths and VURIs
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		val sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		// Create container and synchronize 
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges

		val changesMatches = stRecorder.getChangeMatches(sourceVURI)
		assertThat(changesMatches.length, is(1))

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container)]
		rootElement.saveAndSynchronizeChanges
		assertModelsEqual
		assertThat(changesMatches.length, is(4))
		assertThat(changesMatches.forall[sourceVURI == originalVURI], is(true))
		assertThat(changesMatches.forall[null !== targetToCorrespondentChanges.get(targetVURI)], is(true))
		val message = changesMatches.filter[0 == targetToCorrespondentChanges.get(targetVURI).length].map [
			toString
		].reduce[p1, p2|p1 + p2]
		assertThat(message, changesMatches.forall [
			0 < targetToCorrespondentChanges.get(targetVURI).length
		], is(true))

	}

	@Test
	def void echangesShouldBeUnresolved() {
		// Paths and VURIs
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		val sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		// Create container and synchronize 
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges

		val changesMatches = stRecorder.getChangeMatches(sourceVURI)
		assertThat(changesMatches.length, is(1))

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container)]
		rootElement.saveAndSynchronizeChanges
		assertModelsEqual
		assertThat(changesMatches.length, is(4))
		changesMatches.forEach[assertThat(originalChange.EChanges.forall[!resolved], is(true))]

	}

	@Test
	def void testReapplyAsList() {
		// Paths and VURIs
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		val sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		// Create container and synchronize 
		assertThat(rootElement.eContents.length, is(0))
		assertThat(rootElement.nonRootObjectContainerHelper, equalTo(null))
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges

		assertThat(rootElement.eContents.length, is(1))
		assertThat(stRecorder.getChangeMatches(sourceVURI).length, is(1))

		val newSourceVURI = newTestSourceModelName.calculateVURI
		val newRoot = AllElementTypesFactory::eINSTANCE.createRoot
		newRoot.id = newTestSourceModelName
		newTestSourceModelName.projectModelPath.createAndSynchronizeModel(newRoot)

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container)]
		rootElement.saveAndSynchronizeChanges
		assertModelsEqual
		assertThat(stRecorder.getChangeMatches(sourceVURI).length, is(4))

		val changeMatches = stRecorder.getChangeMatches(sourceVURI)
		assertThat(changeMatches.length, is(4))
		val originalChanges = changeMatches.map[originalChange]
		assertThat(originalChanges.length, is(4))
		val pair = new Pair(sourceVURI.EMFUri.toString, newSourceVURI.EMFUri.toString)
		val eChangeCopier = ChangeCopyFactory::instance.createEChangeCopier(#[pair])
		val copiedChanges = originalChanges.filter[it instanceof EMFModelChangeImpl].map [
			it as EMFModelChangeImpl
		].map[eChangeCopier.copyEMFModelChangeToList(it, newSourceVURI)].flatten.toList
		assertThat(copiedChanges.length, is(8))

		virtualModel.propagateChange(copiedChanges.get(0))
		assertThatNonRootObjectContainerIsCreated
		virtualModel.propagateChange(copiedChanges.get(1))
		assertThatNonRootObjectContainerHasRightId

		for (i : 0 ..< 3) {
			virtualModel.propagateChange(copiedChanges.get(2 + i * 2))
			assertThatNonRootObjectHasBeenInsertedInContainer(i)
			virtualModel.propagateChange(copiedChanges.get(3 + i * 2))
			assertThatNonRootObjectHasBeenInsertedInContainerAndRightId(i)
		}
		resourceSet.resources.forEach[save(#{})]
		logger.debug("hi")
	}

	@Test
	def void testReapply() {
		// Paths and VURIs
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		val sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		// Create container and synchronize 
		assertThat(rootElement.eContents.length, is(0))
		assertThat(rootElement.nonRootObjectContainerHelper, equalTo(null))
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = "NonRootObjectContainer"
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges

		assertThat(rootElement.eContents.length, is(1))
		assertThat(stRecorder.getChangeMatches(sourceVURI).length, is(1))

		val newSourceVURI = newTestSourceModelName.calculateVURI
		val newRoot = AllElementTypesFactory::eINSTANCE.createRoot
		newRoot.id = newTestSourceModelName
		newTestSourceModelName.projectModelPath.createAndSynchronizeModel(newRoot)

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container)]
		rootElement.saveAndSynchronizeChanges
		assertModelsEqual
		assertThat(stRecorder.getChangeMatches(sourceVURI).length, is(4))

		val changeMatches = stRecorder.getChangeMatches(sourceVURI)
		assertThat(changeMatches.length, is(4))
		val originalChanges = changeMatches.map[originalChange]
		assertThat(originalChanges.length, is(4))
		val pair = new Pair(sourceVURI.EMFUri.toString, newSourceVURI.EMFUri.toString)
		val eChangeCopier = ChangeCopyFactory::instance.createEChangeCopier(#[pair])
		val copiedChanges = originalChanges.filter[it instanceof EMFModelChangeImpl].map [
			it as EMFModelChangeImpl
		].map[eChangeCopier.copyEMFModelChangeToSingleChange(it, newSourceVURI)].toList
		assertThat(copiedChanges.length, is(4))

		virtualModel.propagateChange(copiedChanges.get(0))
		assertThatNonRootObjectContainerHasRightId

		for (i : 0 ..< 3) {
			virtualModel.propagateChange(copiedChanges.get(i + 1))
			assertThatNonRootObjectHasBeenInsertedInContainerAndRightId(i, true)
		}
		resourceSet.resources.forEach[save(#{})]
	}

	@Test
	def void testSezializeChangeMatches() {
		// Paths and VURIs
		val targetVURI = TEST_TARGET_MODEL_NAME.calculateVURI
		val sourceVURI = TEST_SOURCE_MODEL_NAME.calculateVURI

		stRecorder.recordOriginalAndCorrespondentChanges(sourceVURI, #[targetVURI])

		// Create container and synchronize 
		val container = AllElementTypesFactory::eINSTANCE.createNonRootObjectContainerHelper
		container.id = nonRootObjectContainerName
		rootElement.nonRootObjectContainerHelper = container
		rootElement.saveAndSynchronizeChanges
		assertThat(stRecorder.getChangeMatches(sourceVURI).length, is(1))

		// Create and add non roots
		NON_CONTAINMENT_NON_ROOT_IDS.forEach[createAndAddNonRoot(container)]
		rootElement.saveAndSynchronizeChanges
		assertModelsEqual
		val changeMatches = stRecorder.getChangeMatches(sourceVURI)
		assertThat(changeMatches.length, is(4))

		// Serialize change matches 
		val serializationPath = '''changeMatches.ser'''
		val yourFile = tempFolder.newFile(serializationPath)
		val fileOut = new FileOutputStream(yourFile, false)
		val out = new ObjectOutputStream(fileOut)
		out.writeObject(changeMatches)
		out.close
		fileOut.close

		val fileIn = new FileInputStream(yourFile)
		val in = new ObjectInputStream(fileIn)
		val deserializedChangeMatches = in.readObject as List<ChangeMatch>
		in.close
		fileIn.close

		assertThat(deserializedChangeMatches.length, is(4))
		// TODO PS Fix VURI 
		assertThat(deserializedChangeMatches.forall[sourceVURI == originalVURI], is(true))
	// assertThat(deserializedChangeMatches.forall[null !== targetToCorrespondentChanges.get(targetVURI)], is(true))
	// assertThat(deserializedChangeMatches.forall[1 == targetToCorrespondentChanges.size], is(true))
	}

	private def assertThatNonRootObjectContainerIsCreated() {
		assertThat("Container has not been created", sourceRootIterator.exists [
			null !== nonRootObjectContainerHelper && nonRootObjectContainerName != nonRootObjectContainerHelper.id
		], is(true))
	}

	private def assertThatNonRootObjectContainerHasRightId() {
		assertThat(sourceRootIterator.exists [
			nonRootObjectContainerName == nonRootObjectContainerHelper.id &&
				nonRootObjectContainerHelper.eContents.size === 0
		], is(true))
	}

	private def assertThatNonRootObjectHasBeenInsertedInContainer(int numberOfInsertedElement) {
		assertThat(sourceRootIterator.filter [
			nonRootObjectContainerName == nonRootObjectContainerHelper.id
		].map[nonRootObjectContainerHelper].filter[nonRootObjectsContainment.size === numberOfInsertedElement + 1].map [
			nonRootObjectsContainment.get(numberOfInsertedElement)
		].exists [
			id != NON_CONTAINMENT_NON_ROOT_IDS.get(numberOfInsertedElement)
		], is(true))
	}

	private def assertThatNonRootObjectHasBeenInsertedInContainerAndRightId(int numberOfInsertedElement) {
		assertThatNonRootObjectHasBeenInsertedInContainerAndRightId(numberOfInsertedElement, false)
	}

	private def assertThatNonRootObjectHasBeenInsertedInContainerAndRightId(int numberOfInsertedElement,
		boolean testTarget) {
		val x = [ Iterable<Root> iter |
			iter.filter [
				nonRootObjectContainerName == nonRootObjectContainerHelper.id
			].map[nonRootObjectContainerHelper].filter[nonRootObjectsContainment.size === numberOfInsertedElement + 1].
				map [
					nonRootObjectsContainment.get(numberOfInsertedElement)
				].exists [
					id == NON_CONTAINMENT_NON_ROOT_IDS.get(numberOfInsertedElement)
				]
		]
		assertThat(x.apply(sourceRootIterator), is(true))
		if (testTarget)
			assertThat(x.apply(targetRootIterator), is(true))
	}

	private def getResourceSet() {
		val internalModel = virtualModel as InternalTestVirtualModel
		val internalModelRepository = internalModel.modelRepository as InternalModelRepository
		val resourceSet = internalModelRepository.resourceSet
		return resourceSet
	}

	private def getSourceRootIterator() {
		newTestSourceModelName.rootIterator
	}

	private def getTargetRootIterator() {
		newTestTargetModelName.rootIterator
	}

	private def getRootIterator(String name) {
		resourceSet.resources.filter[URI.toString.contains(name)].map[contents].flatten.filter [
			it instanceof Root
		].map[it as Root].filter [
			id == newTestSourceModelName
		]
	}

}