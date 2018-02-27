package tools.vitruv.extensions.delta

import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException

class ApplyDeltaModulForwardsHandler extends AbstractHandler {
	
	override execute(ExecutionEvent event) throws ExecutionException {
		new ApplyDeltaModul().applyForwards()
		return null

	}
	
}
