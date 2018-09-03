package tools.vitruv.framework.uuid.tests

import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtend.lib.annotations.Accessors
import tools.vitruv.framework.uuid.UuidGeneratorAndResolver
import tools.vitruv.framework.uuid.UuidGeneratorAndResolverImpl
import org.eclipse.emf.ecore.resource.Resource
import java.io.File
import allElementTypes.AllElementTypesFactory
import static org.junit.Assert.*
import allElementTypes.Root
import tools.vitruv.testutils.VitruviusTest
import tools.vitruv.framework.util.bridges.EMFBridge
import tools.vitruv.framework.util.ResourceSetUtil
import org.junit.runners.Parameterized.Parameters
import java.util.Collection
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

@RunWith(Parameterized)
class UuidTest extends VitruviusTest {
	@Parameters
	public def static Collection<Object> data() {
        return #[false, true];
    }
	
	@Accessors(PROTECTED_GETTER)
	var ResourceSet resourceSet;
	
	var Resource testResource;
	var Root root;
	
	var UuidGeneratorAndResolver uuidGeneratorAndResolver;
	
	public new(boolean useResource) {
		this.resourceSet = new ResourceSetImpl();
		ResourceSetUtil.addExistingFactoriesToResourceSet(resourceSet);
		val resource = if (useResource) {
			val resource = this.resourceSet.createResource(EMFBridge.getEmfFileUriForFile(new File(currentTestProjectFolder, "test.uuid")));
			assertNotNull(resource);
			resource;
		} else {
			null;
		}
		this.uuidGeneratorAndResolver = new UuidGeneratorAndResolverImpl(new ResourceSetImpl(), resource, true);
		initializeResource;	
	}
	
	private def initializeResource() {
		this.testResource = this.resourceSet.createResource(EMFBridge.getEmfFileUriForFile(new File(currentTestProjectFolder, "uuidTest.allElementTypes")));
		root = AllElementTypesFactory.eINSTANCE.createRoot;
		this.testResource.contents += root;
		val containerHelper = AllElementTypesFactory.eINSTANCE.createNonRootObjectContainerHelper
		root.nonRootObjectContainerHelper = containerHelper;
		val rootUuid = uuidGeneratorAndResolver.generateUuid(root);
		uuidGeneratorAndResolver.generateUuid(containerHelper);
		assertEquals(root, uuidGeneratorAndResolver.getEObject(rootUuid));
	}
	
	protected def createElement() {
		val element = AllElementTypesFactory.eINSTANCE.createNonRoot
		root.nonRootObjectContainerHelper.nonRootObjectsContainment += element
		uuidGeneratorAndResolver.generateUuid(element);
	}
	
}