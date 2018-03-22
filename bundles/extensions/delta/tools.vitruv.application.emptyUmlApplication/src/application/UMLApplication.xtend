package application

import mir.reactions.UmlToUmlChangePropagationSpecification
import tools.vitruv.framework.applications.AbstractVitruvApplication

class UMLApplication extends AbstractVitruvApplication {
	
	override getChangePropagationSpecifications() {
		return #{new UmlToUmlChangePropagationSpecification()}
	}
	
	override getName() {
		return "UML";
	}
	
	


}