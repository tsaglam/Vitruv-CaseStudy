package tools.vitruv.framework.change.description.impl

import tools.vitruv.framework.change.echange.EChange

class ConcreteChangeImpl extends AbstractConcreteChange {
    new(EChange eChange) {
		super(eChange);
    }

// TODO TS (TOSTRING) original method:
//    override String toString() {
//        return this.class.getSimpleName() + ", VURI: " + this.URI + "\n	EChange: " + this.EChange;
//    }

	// TODO TS (TOSTRING) prints ONLY EChanges and no simple name or VURI:
	override String toString() {
		return this.EChange.toString;
	}

}