package tools.vitruv.framework.vsum.modelsynchronization;

import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import tools.vitruv.framework.change.processing.ChangePropagationSpecification
import java.util.Collections

/**
 * Static class with state that tracks the order in which the change propagation specifications are applied.
 */
class ChangePropagationTracker {
	@Accessors
	static val List<Collection<String>> trackedSpecifications = new ArrayList
	@Accessors
	static boolean trackingEnabled = true

	/**
	 * Reports a change sequence, if tracking is enabled. The change sequence is matched with the correlating reactions stack.
	 */
	def static report(Collection<? extends ChangePropagationSpecification> specifications) {
		if (trackingEnabled) {
			trackedSpecifications.addAll(specifications.map[toReadableString].toList)
		}
	}

	/**
	 * Clears the tracked change sequences. This means all previously tracked data is lost.
	 */
	def static clear() {
		trackedSpecifications.clear
	}

	/** 
	 * Prints all change sequences.
	 */
	def static printAll() {
		trackedSpecifications.forEach[System.err.println(it)]
	}

	def static toReadableString(ChangePropagationSpecification specification) {
		val text = specification.toString
		if (text.startsWith("tools.vitruv.applications.umljava.java2uml")) {
			return "Java --> UML"
		} else if (text.startsWith("tools.vitruv.applications.umljava.uml2java")) {
			return "UML --> Java"
		} else if (text.startsWith("tools.vitruv.applications.pcmjava.pojotransformations.pcm2java")) {
			return "PCM --> Java"
		} else if (text.startsWith("tools.vitruv.applications.pcmjava.pojotransformations.java2pcm")) {
			return "Java --> PCM"
		} else if (text.startsWith("tools.vitruv.applications.pcmumlclass.CombinedPcmToUml")) {
			return "PCM --> UML"
		} else if (text.startsWith("tools.vitruv.applications.pcmumlclass.CombinedUmlClassToPcm")) {
			return "UML --> PCM"
		}
		return text
	}
}
