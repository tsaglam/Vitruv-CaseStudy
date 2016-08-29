package edu.kit.ipd.sdq.vitruvius.framework.changes.changedescription.impl

import edu.kit.ipd.sdq.vitruvius.framework.changes.echange.EChange
import java.util.List
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.VURI
import edu.kit.ipd.sdq.vitruvius.framework.changes.changedescription.GeneralChange
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.ChangePreparing

class GeneralChangeImpl extends ConcreteChangeImpl implements GeneralChange {
    public new(List<EChange> eChanges, VURI vuri) {
    	super(vuri);
        this.eChanges.addAll(eChanges);
    }

    public override String toString() {
        return GeneralChangeImpl.getSimpleName() + ": VURI: " + this.URI + " EChanges: " + this.eChanges;
    }
				
	override prepare(ChangePreparing preparer) {
		// Do nothing
	}
	
	override isPrepared() {
		return true;
	}
				
}