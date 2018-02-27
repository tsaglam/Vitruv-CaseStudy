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

class EChangeComparator implements Comparator<EChange> {

	/**
     * Highest Priority. May be used by other EChanges.
     */
    private static final int CREATE_EOBJECT_VALUE = 0;

    /**
     * Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
    private static final int REPLACE_SINGLE_VALUED_EREFERENCE_VALUE = 10;

	 /**
     * Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
	private static final int UNSET_EREFERENCE_VALUE = 10;
	
    /**
     * Same Priority as Single Reference Changes. An Root Changes is the "same" as an Set or an Unset
     * Change
     */
    private static final int ROOT_ECHANGE_VALUE = 10;

    /**
     * Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
    private static final int INSERT_EREFERENCE_VALUE = 100;

    /**
     * Higher Priority then Attribute. Single Reference Changes has Higher Priority than Multi-Reference
     * Changes
     */
    private static final int REMOVE_EREFERENCE_VALUE = 100;

    /**
     * Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
    private static final int REPLACE_SINGLE_VALUED_EATTRIBUTE_VALUE = 1000;

    /**
     * Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
    private static final int INSERT_EATTRIBUTE_VALUE = 1000;

    /**
     * Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
    private static final int REMOVE_EATTRIBUTE_VALUE = 1000;

    /**
     * Lower Priority then Reference. Order of Attribute Changes should be the same as the recorded one
     */
	private static final int UNSET_EATTRIBUTE_VALUE = 1000;
    
    /**
     * Lowest Priority. Element maybe still needed.
     */
    private static final int DELETE_EOBJECT_VALUE = 10000;
	

	

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