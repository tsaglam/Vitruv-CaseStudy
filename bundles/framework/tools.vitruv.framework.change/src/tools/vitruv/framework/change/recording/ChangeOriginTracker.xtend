package tools.vitruv.framework.change.recording

import tools.vitruv.framework.change.echange.EChange
import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Data
import tools.vitruv.framework.change.recording.ChangeOriginTracker.ChangeSequence

/**
 * Static class with state that tracks changes and whch reaction is responsible for these changes.
 */
class ChangeOriginTracker {
	static List<ChangeSequence> reportedChangeSequences = new ArrayList
	static boolean enabled = false
	static val String REACTION = "Reaction"
	static val String EXECUTE = "execute"
	static val String CORRESPONDENCE = "Correspondence"

	def static report(Iterable<EChange> changes) {
		if (enabled) {
			val stackTrace = new Exception().stackTrace
			val filteredStackTrace = stackTrace.filter[it.toString.contains(REACTION) && it.toString.contains(EXECUTE)]
			reportedChangeSequences += new ChangeSequence(changes.toList, filteredStackTrace.toList)
		}
	}

	def static enableTracking() {
		enabled = true;
	}

	def static disableTracking() {
		enabled = false;
	}

	def static printAll() {
		reportedChangeSequences.forEach[System.err.println(it)]
	}

	def static printNonCorrespondence() {
		reportedChangeSequences.filter[!it.changes.toString.contains(CORRESPONDENCE)].forEach[System.err.println(it)]
	}

	@Data
	static class ChangeSequence {
		List<EChange> changes
		List<StackTraceElement> tracresponsibleReactionse
	}
}
