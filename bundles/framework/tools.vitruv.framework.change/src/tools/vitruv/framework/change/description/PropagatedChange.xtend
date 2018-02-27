package tools.vitruv.framework.change.description

import org.eclipse.xtend.lib.annotations.Data
import tools.vitruv.framework.uuid.UuidResolver
import tools.vitruv.framework.uuid.UuidGeneratorAndResolver

@Data
class PropagatedChange {
	private val VitruviusChange originalChange;
	private val VitruviusChange consequentialChanges;
	
	override toString() '''
	Original change:
		«originalChange»
	Consequential change: «consequentialChanges»
	'''
	
	def applyBackward(UuidResolver uuidResolver) {
		consequentialChanges.unresolveIfApplicable;
		originalChange.unresolveIfApplicable;
		consequentialChanges.resolveAfterAndApplyBackward(uuidResolver);
		originalChange.resolveAfterAndApplyBackward(uuidResolver);
	}
	
	def applyForward(UuidGeneratorAndResolver uuidResolver) {
		consequentialChanges.unresolveIfApplicable;
		originalChange.unresolveIfApplicable;
		consequentialChanges.resolveBeforeAndApplyForward(uuidResolver);
		originalChange.resolveBeforeAndApplyForward(uuidResolver)
	}
	
}