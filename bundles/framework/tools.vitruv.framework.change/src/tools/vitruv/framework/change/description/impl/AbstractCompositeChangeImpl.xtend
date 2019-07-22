package tools.vitruv.framework.change.description.impl

import java.util.ArrayList
import java.util.LinkedList
import java.util.List
import tools.vitruv.framework.change.description.CompositeChange
import tools.vitruv.framework.change.description.VitruviusChange
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.uuid.UuidResolver
import tools.vitruv.framework.change.echange.feature.FeatureEChange
import tools.vitruv.framework.change.echange.AdditiveEChange
import tools.vitruv.framework.change.echange.SubtractiveEChange
import tools.vitruv.framework.change.echange.root.RootEChange
import tools.vitruv.framework.change.echange.eobject.EObjectExistenceEChange

abstract class AbstractCompositeChangeImpl<C extends VitruviusChange> implements CompositeChange<C> {
	List<C> changes;

	new() {
		this.changes = new LinkedList<C>();
	}

	new(List<? extends C> changes) {
		this.changes = new LinkedList<C>(changes);
	}

	override List<C> getChanges() {
		return this.changes;
	}

	override addChange(C change) {
		if (change !== null) this.changes.add(change);
	}

	override removeChange(C change) {
		if (change !== null) this.changes.remove(change);
	}

	override containsConcreteChange() {
		for (change : changes) {
			if (change.containsConcreteChange) {
				return true
			}
		}
		return false
	}

	override getURI() {
		val uris = this.changes.map[URI].filterNull
		if (!uris.empty) {
			return uris.get(0);
		} else {
			return null;
		}
	}

	override validate() {
		if (!this.containsConcreteChange()) {
			return false;
		}

		var lastURI = changes.get(0).URI;
		for (change : changes) {
			if (lastURI !== null && change.URI !== null && change.URI != lastURI) {
				return false;
			}
			lastURI = change.URI;
		}
		return true;
	}

	override getEChanges() {
		return changes.fold(
			new ArrayList<EChange>(),
			[ eChangeList, change |
				eChangeList.addAll(change.EChanges);
				return eChangeList;
			]
		);
	}

	override resolveBeforeAndApplyForward(UuidResolver uuidResolver) {
		for (c : changes) {
			c.resolveBeforeAndApplyForward(uuidResolver)
		}
	}

	override resolveAfterAndApplyBackward(UuidResolver uuidResolver) {
		for (c : changes.reverseView) {
			c.resolveAfterAndApplyBackward(uuidResolver)
		}
	}

	override getAffectedEObjects() {
		return changes.fold(newArrayList, [list, element|list += element.affectedEObjects; return list]).filterNull;
	}

	override getAffectedEObjectIds() {
		return changes.fold(newArrayList, [list, element|list += element.affectedEObjectIds; return list]).filterNull;
	}

	override unresolveIfApplicable() {
		changes.forEach[unresolveIfApplicable]
	}

	override getUserInteractions() {
		return changes.map[userInteractions].flatten
	}

	// TODO TS (TOSTRING) original method:
	def String toStringOriginal() '''
		«this.class.simpleName», VURI: «URI»
			«FOR change : changes»
				«change»
			«ENDFOR»
	'''

	override toString() {
		return toStringNew() // TODO TS (TOSTRING) use custom toStringNew instead of toStringOriginal
	}
	
	// TODO TS (TOSTRING) kills anything related to Correspondence
	def String toStringNew() {
		val string = toStringNew2
		if (string.contains("Correspondence")) {
			return ""
		}
		return string
	}

	// TODO TS (TOSTRING) no URI, but changes size and readable subchanges
	def String toStringNew2() '''
		«this.class.simpleName» with «changes.size» changes:
			«FOR change : changes»
				«change.readable»
			«ENDFOR»
	'''

	// TODO TS (TOSTRING) filters paths, file names, etc.
	private def String readable(C change) {
		var representation = change.toString
		val list = change.EChanges.map[e|e.obj]
		var String eChanges
		if (list.size == 1) {
			eChanges = list.get(0).toString
		} else {
			eChanges = "many: " + list.toString
		}
		//representation = representation.replaceFirst("affectedEObjectID: (.)+\\)", '''«eChanges»)''')
		
		// TODO TS (TOSTRING) use custom path here to make things more reable (see line above)
		//representation = representation.replace("/Users/Timur/Dropbox/Studium/Eclipse%20Workspace/vitruv%20workspace/Vitruv-Applications-ComponentBasedSystems/tests/pcmumlclassjava/tools.vitruv.applications.transitivechange.tests/out", "")
		representation = representation.replace("/Vitruv-Applications-ComponentBasedSystems/tests/pcmumlclassjava/tools.vitruv.applications.transitivechange.tests/out", "")
		
		representation = representation.replaceAll("file:(.)+src", "file:src")
		return representation.replace("tools.vitruv.dsls.reactions.meta.correspondence.reactions.impl.","")
	}

	private def dispatch String getObj(FeatureEChange<?, ?> change) {
		return "affectedEObject: " + change.affectedEObject.toString

	}

	private def dispatch String getObj(AdditiveEChange<?> change) {
		return "new value: " + change.newValue
	}

	private def dispatch String getObj(SubtractiveEChange<?> change) {
		return "old value: " + change.oldValue
	}

	private def dispatch String getObj(RootEChange change) {
		return "root change: " + change
	}

	private def dispatch String getObj(EObjectExistenceEChange<?> change) {
		return "affectedEObject: " + change.affectedEObject
	}

	/**
	 * Indicates whether some other object is "equal to" this composite change.
	 * This means it is a composite change which contains the same changes as this one in no particular order.
	 * @param other is the object to compare with.
	 * @return true, if the object is a composite change and has the same changes in any order.
	 */
	override equals(Object other) {
		return other.isEqual // delegates to dynamic dispatch
	}

	private def dispatch boolean isEqual(Object object) { super.equals(object) }

	private def dispatch boolean isEqual(CompositeChange<C> compositeChange) {
		if (changes.size != compositeChange.changes.size) {
			return false
		}
		val remainingChanges = new LinkedList(compositeChange.changes)
		remainingChanges.removeIf([it|changes.contains(it)])
		return remainingChanges.empty
	}

	override boolean changedEObjectEquals(VitruviusChange change) {
		return change.isChangedEObjectEqual
	}

	private def dispatch boolean isChangedEObjectEqual(VitruviusChange change) { super.equals(change) } // use super implementation if anything else than ConcreteApplicableChangeImpl

	private def dispatch boolean isChangedEObjectEqual(CompositeChange<C> compositeChange) {
		if (changes.size != compositeChange.changes.size) {
			return false
		}
		val remainingChanges = new LinkedList(compositeChange.changes)
		remainingChanges.removeIf[change|changes.exists[otherChange|change.changedEObjectEquals(otherChange)]]
		return remainingChanges.empty
	}
}
