package tools.vitruv.framework.change.echange.util

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.ENamedElement

class StringRepresentationUtil {
	static final String[] MODELS = #["java", "uml", "pcm"]
	static final String BRACKET = ")"
	static final String DOT = "."
	static final String NOTHING = ""
	static final String NULL = "null"

	/**
	 * Returns more readable toString() representation.
	 * Adds a model prefix (uml, pcm, java).
	 * Replaces fully qualified name by simple name.
	 * Cuts off everything after first closed bracket (e.g. after "(name: aName)").
	 */
	def static readable(EObject object) {
		if (object === null) {
			return NULL;
		}
		var text = object.modelPrefix + object.toString.replace(object.class.name, object.class.simpleName)
		return text.cutAfterFirstClosingBracket
	}

	/**
	 * Returns only the name if the EObject is a named element. Returns readable(object) if not.
	 */
	def static nameOf(EObject object) {
		if (object instanceof ENamedElement) {
			return '''"«object.name»"'''
		}
		return object.readable
	}

	def private static cutAfterFirstClosingBracket(String text) {
		if (text.contains(BRACKET)) {
			return text.substring(0, text.indexOf(BRACKET) + 1)
		}
		return text
	}

	def private static getModelPrefix(EObject object) {
		for (model : MODELS) {
			if (object.class.name.contains(DOT + model + DOT)) {
				return model + DOT
			}
		}
		return NOTHING
	}
}
