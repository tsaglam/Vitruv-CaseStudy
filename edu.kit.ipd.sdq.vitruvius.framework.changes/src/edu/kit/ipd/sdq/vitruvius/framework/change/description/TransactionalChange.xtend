package edu.kit.ipd.sdq.vitruvius.framework.change.description

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VitruviusChange

interface TransactionalChange extends ConcreteChange, GenericCompositeChange<VitruviusChange> {
	
}