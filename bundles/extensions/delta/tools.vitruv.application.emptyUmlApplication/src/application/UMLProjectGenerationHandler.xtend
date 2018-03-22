package application

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException

class UMLProjectGenerationHandler extends AbstractHandler{
	
	override execute(ExecutionEvent event) throws ExecutionException {
		new UMLProjectGeneration().createProjectAndVsum();
		return null
	}
	
}
