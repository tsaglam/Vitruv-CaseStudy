package tools.vitruv.extensions.delta.modul

import java.util.Comparator
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference
import tools.vitruv.framework.change.echange.feature.attribute.ReplaceSingleValuedEAttribute
import tools.vitruv.framework.change.echange.eobject.DeleteEObject
import tools.vitruv.framework.change.echange.feature.attribute.RemoveEAttributeValue
import tools.vitruv.framework.change.echange.root.RootEChange
import tools.vitruv.framework.change.echange.feature.reference.RemoveEReference
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.feature.attribute.InsertEAttributeValue
import tools.vitruv.framework.change.echange.eobject.CreateEObject
import tools.vitruv.framework.change.echange.feature.reference.ReplaceSingleValuedEReference
import tools.vitruv.framework.change.echange.feature.UnsetFeature
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EReference


class EChangeTypeComparator implements Comparator<EChange> {

	/**
     * Default: Highest Priority. May be used by other EChanges.
     */
    private final int CREATE_EOBJECT_VALUE;

    /**
     * Default: Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
    private final int REPLACE_SINGLE_VALUED_EREFERENCE_VALUE;

	 /**
     * Default: Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
	private final int UNSET_EREFERENCE_VALUE;
	
    /**
     * Default: Same Priority as Single Reference Changes. An Root Changes is the "same" as an Set or an Unset
     * Change
     */
    private final int ROOT_ECHANGE_VALUE;

    /**
     * Default: Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
    private final int INSERT_EREFERENCE_VALUE;

    /**
     * Default: Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
    private final int REMOVE_EREFERENCE_VALUE;

    /**
     * Default: Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
    private final int REPLACE_SINGLE_VALUED_EATTRIBUTE_VALUE;

    /**
     * Default: Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
    private final int INSERT_EATTRIBUTE_VALUE;

    /**
     * Default: Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
    private final int REMOVE_EATTRIBUTE_VALUE;

    /**
     * Default: Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
	private final int UNSET_EATTRIBUTE_VALUE;
    
    /**
     * Default: Lowest Priority. Element maybe still needed.
     */
    private final int DELETE_EOBJECT_VALUE;
	
	/**
	 * Default compare strategy: 
	 * createChanges < SingleValuedReferenceChanges = rootChanges < ManyValuedReferenceChanges < AttributeChanges < DeleteChanges 
	 */
	new () {
		CREATE_EOBJECT_VALUE = 0;
		REPLACE_SINGLE_VALUED_EREFERENCE_VALUE = 10;
		UNSET_EREFERENCE_VALUE = 10;
		ROOT_ECHANGE_VALUE = 10;
		INSERT_EREFERENCE_VALUE = 100;
		REMOVE_EREFERENCE_VALUE = 100;
		REPLACE_SINGLE_VALUED_EATTRIBUTE_VALUE = 1000;
		INSERT_EATTRIBUTE_VALUE = 1000;
		REMOVE_EATTRIBUTE_VALUE = 1000;
		UNSET_EATTRIBUTE_VALUE = 1000;
		DELETE_EOBJECT_VALUE = 10000;
	}
	/**
	 * Constructur for defining individual compare strategies
	 * TODO NK find better way to initialize the compare constants, maybe with Map<EClass, Integer>
	 */
	new (int[] compareValues) {
		if (compareValues === null || compareValues.size < 11) {
			throw new IllegalArgumentException("not enough compareValues")
		}
		CREATE_EOBJECT_VALUE = compareValues.get(0);
		REPLACE_SINGLE_VALUED_EREFERENCE_VALUE = compareValues.get(1);
		UNSET_EREFERENCE_VALUE = compareValues.get(2);
		ROOT_ECHANGE_VALUE = compareValues.get(3);
		INSERT_EREFERENCE_VALUE = compareValues.get(4);
		REMOVE_EREFERENCE_VALUE = compareValues.get(5);
		REPLACE_SINGLE_VALUED_EATTRIBUTE_VALUE = compareValues.get(6);
		INSERT_EATTRIBUTE_VALUE = compareValues.get(7);
		REMOVE_EATTRIBUTE_VALUE = compareValues.get(8);
		UNSET_EATTRIBUTE_VALUE = compareValues.get(9);
		DELETE_EOBJECT_VALUE = compareValues.get(10);
	}

    override compare(EChange arg0, EChange arg1) {
        if (arg0 === null || arg1 === null) {
            throw new NullPointerException();
        }
        val int arg0Value = getValue(arg0);
        val int arg1Value = getValue(arg1);
        return arg0Value.compareTo(arg1Value);
    }

    private def dispatch int getValue(EChange arg0) {
    	throw new IllegalStateException("Unknown EChange type: " + arg0.getClass());
    }	
    
    private def dispatch int getValue(CreateEObject<?> arg0) {
    	return CREATE_EOBJECT_VALUE;
    }	
    
    private def dispatch int getValue(DeleteEObject<?> arg0) {
        return DELETE_EOBJECT_VALUE;
    }	
    
    private def dispatch int getValue(ReplaceSingleValuedEAttribute<?, ?> arg0) {
        return REPLACE_SINGLE_VALUED_EATTRIBUTE_VALUE;
    }
    private def dispatch int getValue(InsertEAttributeValue<?, ?> arg0) {
        return INSERT_EATTRIBUTE_VALUE;
    }
    private def dispatch int getValue(RemoveEAttributeValue<?, ?> arg0) {
        return REMOVE_EATTRIBUTE_VALUE;
    }
    private def dispatch int getValue(UnsetFeature<?,?> arg0) {
    	if (arg0.affectedFeature instanceof EAttribute) {
    		return UNSET_EATTRIBUTE_VALUE;	
    	} else if (arg0.affectedFeature instanceof EReference) {
    		return UNSET_EREFERENCE_VALUE;
    	} else {
    		throw new IllegalStateException("Unknown EStructuralFeature type: " + arg0.affectedFeature.class.name)
    	}
    }
    private def dispatch int getValue(ReplaceSingleValuedEReference<?, ?> arg0) {
        return REPLACE_SINGLE_VALUED_EREFERENCE_VALUE;
    }
    private def dispatch int getValue(InsertEReference<?, ?> arg0) {
        return INSERT_EREFERENCE_VALUE;
    }
    private def dispatch int getValue(RemoveEReference<?, ?> arg0) {
        return REMOVE_EREFERENCE_VALUE;
    }
    private def dispatch int getValue(RootEChange arg0) {
        return ROOT_ECHANGE_VALUE;
    }
    
}