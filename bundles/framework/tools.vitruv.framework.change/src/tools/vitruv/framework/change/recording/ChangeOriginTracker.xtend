package tools.vitruv.framework.change.recording

import tools.vitruv.framework.change.echange.EChange
import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Data
import tools.vitruv.framework.change.recording.ChangeOriginTracker.ChangeSequence
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Static class with state that tracks changes and whch reaction is responsible for these changes.
 */
class ChangeOriginTracker {
	static val String CORRESPONDENCE = "Correspondence"
	static val String MIR = "mir.r" // mir reaction or routine
	static val String DOLLAR = "$" // generated generic methods
	static val String FACADE = ".RoutinesFacade." // unwanted facade lines

	@Accessors
	static val List<ChangeSequence> trackedChangeSequences = new ArrayList
	@Accessors
	static boolean trackingEnabled = false

	/**
	 * Reports a change sequence, if tracking is enabled. The change sequence is matched with the correlating reactions stack.
	 */
	def static report(Iterable<EChange> changes) {
		if (trackingEnabled) {
			val filteredStackTrace = new Exception().stackTrace.filter[it.toString.contains(MIR) && !it.toString.contains(DOLLAR) && !it.toString.contains(FACADE)]
			trackedChangeSequences += new ChangeSequence(changes.toList, filteredStackTrace.toList)
		}
	}

	/**
	 * Clears the tracked change sequences. This means all previously tracked data is lost.
	 */
	def static clear() {
		trackedChangeSequences.clear
	}

	/** 
	 * Prints all change sequences.
	 */
	def static printAll() {
		trackedChangeSequences.forEach[System.err.println(it)]
	}

	def static printLatest() {
		if (!trackedChangeSequences.empty) {
			System.err.println(trackedChangeSequences.last)
		}
	}

	/** 
	 * Prints all change sequences that do not mention correspondence model changes.
	 */
	def static printNonCorrespondence() {
		trackedChangeSequences.filter[!it.changes.toString.contains(CORRESPONDENCE)].forEach[System.err.println(it)]
	}
	
	/** 
	 * Prints only the change sequences that mention correspondence model changes.
	 */
	def static printOnlyCorrespondence() {
		trackedChangeSequences.filter[it.changes.toString.contains(CORRESPONDENCE)].forEach[System.err.println(it)]
	}

	@Data
	static class ChangeSequence {
		List<EChange> changes
		List<StackTraceElement> reactionStackTrace
	}
}
