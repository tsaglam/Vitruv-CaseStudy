/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.impl;

import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.ChangePackage;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.UnsetEFeature;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EStructuralFeature;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Unset EFeature</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * </p>
 *
 * @generated
 */
public class UnsetEFeatureImpl<T extends EStructuralFeature> extends EFeatureChangeImpl<T> implements UnsetEFeature<T> {
    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    protected UnsetEFeatureImpl() {
        super();
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    protected EClass eStaticClass() {
        return ChangePackage.Literals.UNSET_EFEATURE;
    }

} //UnsetEFeatureImpl
