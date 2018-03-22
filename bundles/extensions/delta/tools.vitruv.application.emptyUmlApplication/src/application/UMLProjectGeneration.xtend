package application

import mir.reactions.UmlToUmlChangePropagationSpecification
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilder
import tools.vitruv.domains.emf.builder.VitruviusEmfBuilderApplicator
import tools.vitruv.framework.change.processing.ChangePropagationSpecification
import tools.vitruv.framework.domains.VitruvDomain
import tools.vitruv.framework.tuid.TuidManager
import tools.vitruv.framework.ui.monitorededitor.ProjectBuildUtils
import tools.vitruv.framework.userinteraction.impl.UserInteractor
import tools.vitruv.framework.vsum.InternalVirtualModel
import tools.vitruv.testutils.util.TestUtil

import static edu.kit.ipd.sdq.commons.util.org.eclipse.core.resources.IProjectUtil.*
import tools.vitruv.domains.uml.UmlDomainProvider

class UMLProjectGeneration {
	    
	
	val VitruvDomain umlDomain = new UmlDomainProvider().getDomain();
	def createProjectAndVsum() {
		TuidManager.instance.reinitialize();
        val project = createTestProject("MyProject");
        val virtualModel = createVirtualModel("MyVsumProject");
        virtualModel.userInteractor = new UserInteractor();
		val VitruviusEmfBuilderApplicator emfBuilder = new VitruviusEmfBuilderApplicator();
		emfBuilder.addToProject(project , virtualModel.folder, #["uml"]);
		// build the project
		ProjectBuildUtils.issueIncrementalBuild(project, VitruviusEmfBuilder.BUILDER_ID);
		return project
	}	
		
	private def InternalVirtualModel createVirtualModel(String vsumName) {
		val metamodels = this.getDomains();
		val project = ResourcesPlugin.workspace.root.getProject(vsumName);
		if (!project.exists) {
			project.create(null);
		}
    	project.open(null);
		val virtualModel = TestUtil.createVirtualModel(project.location.toFile, false, metamodels, createChangePropagationSpecifications(), new UserInteractor());
//		var set = new ResourceSetImpl();
//		set.getPackageRegistry().put(UMLPackage.eNS_URI, UMLPackage.eINSTANCE); 
//		set.getResourceFactoryRegistry().getExtensionToFactoryMap().put(UMLResource.FILE_EXTENSION, UMLResource.Factory.INSTANCE);
//		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put(UMLResource.FILE_EXTENSION, UMLResource.Factory.INSTANCE);
//		var res = set.getResource(URI.createFileURI("C:\\Users\\nkopp\\runtime-EclipseApplication\\MyProject\\model\\model.uml"), true);
//		var uuidResolver = virtualModel.uuidGeneratorAndResolver;
//		for(o : res.getContents()) {
////			uuidResolver.registerEObject("_g6QagP-GEeeZ0deT6szOWw",o)
////			println(uuidResolver.getUuid(o))
//		}
		return virtualModel;
	}
	
	protected def Iterable<VitruvDomain> getDomains() {
		return #[umlDomain];
	}
	
	protected def Iterable<ChangePropagationSpecification> createChangePropagationSpecifications() {
		return #[new UmlToUmlChangePropagationSpecification()];
	}
	
	protected def IProject createTestProject(String projectName) throws CoreException {
        var project = getWorkspaceProject(projectName);
        if (!project.exists()) {
            project = TestUtil.createPlatformProject(projectName, false);
        }
   		return project;
	}
	
	
	
}