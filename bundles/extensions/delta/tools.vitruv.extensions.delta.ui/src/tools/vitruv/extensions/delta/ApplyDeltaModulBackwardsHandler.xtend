package tools.vitruv.extensions.delta

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException

class ApplyDeltaModulBackwardsHandler extends AbstractHandler {
	
	override execute(ExecutionEvent event) throws ExecutionException {
		new ApplyDeltaModul().applyBackwards()	
		return null
	}
	
}
