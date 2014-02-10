/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.impl;

import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.ChangePackage;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.CreateNonRootEObject;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.EFeatureChange;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.EReferenceChange;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.UpdateEContainmentReference;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.UpdateEFeature;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.UpdateEReference;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Create Non Root EObject</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.impl.CreateNonRootEObjectImpl#getNewValue <em>New Value</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.impl.CreateNonRootEObjectImpl#getAffectedFeature <em>Affected Feature</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.change.impl.CreateNonRootEObjectImpl#getAffectedEObject <em>Affected EObject</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class CreateNonRootEObjectImpl<T extends EObject, U extends EReference> extends CreateEObjectImpl implements CreateNonRootEObject<T, U> {
    /**
     * The cached value of the '{@link #getNewValue() <em>New Value</em>}' reference.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see #getNewValue()
     * @generated
     * @ordered
     */
    protected T newValue;

    /**
     * The cached value of the '{@link #getAffectedFeature() <em>Affected Feature</em>}' reference.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see #getAffectedFeature()
     * @generated
     * @ordered
     */
    protected U affectedFeature;

    /**
     * The cached value of the '{@link #getAffectedEObject() <em>Affected EObject</em>}' reference.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see #getAffectedEObject()
     * @generated
     * @ordered
     */
    protected EObject affectedEObject;

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    protected CreateNonRootEObjectImpl() {
        super();
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    protected EClass eStaticClass() {
        return ChangePackage.Literals.CREATE_NON_ROOT_EOBJECT;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @SuppressWarnings("unchecked")
    public T getNewValue() {
        if (newValue != null && ((EObject)newValue).eIsProxy()) {
            InternalEObject oldNewValue = (InternalEObject)newValue;
            newValue = (T)eResolveProxy(oldNewValue);
            if (newValue != oldNewValue) {
                if (eNotificationRequired())
                    eNotify(new ENotificationImpl(this, Notification.RESOLVE, ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE, oldNewValue, newValue));
            }
        }
        return newValue;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public T basicGetNewValue() {
        return newValue;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public void setNewValue(T newNewValue) {
        T oldNewValue = newValue;
        newValue = newNewValue;
        if (eNotificationRequired())
            eNotify(new ENotificationImpl(this, Notification.SET, ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE, oldNewValue, newValue));
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @SuppressWarnings("unchecked")
    public U getAffectedFeature() {
        if (affectedFeature != null && affectedFeature.eIsProxy()) {
            InternalEObject oldAffectedFeature = (InternalEObject)affectedFeature;
            affectedFeature = (U)eResolveProxy(oldAffectedFeature);
            if (affectedFeature != oldAffectedFeature) {
                if (eNotificationRequired())
                    eNotify(new ENotificationImpl(this, Notification.RESOLVE, ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE, oldAffectedFeature, affectedFeature));
            }
        }
        return affectedFeature;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public U basicGetAffectedFeature() {
        return affectedFeature;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public void setAffectedFeature(U newAffectedFeature) {
        U oldAffectedFeature = affectedFeature;
        affectedFeature = newAffectedFeature;
        if (eNotificationRequired())
            eNotify(new ENotificationImpl(this, Notification.SET, ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE, oldAffectedFeature, affectedFeature));
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public EObject getAffectedEObject() {
        if (affectedEObject != null && affectedEObject.eIsProxy()) {
            InternalEObject oldAffectedEObject = (InternalEObject)affectedEObject;
            affectedEObject = eResolveProxy(oldAffectedEObject);
            if (affectedEObject != oldAffectedEObject) {
                if (eNotificationRequired())
                    eNotify(new ENotificationImpl(this, Notification.RESOLVE, ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT, oldAffectedEObject, affectedEObject));
            }
        }
        return affectedEObject;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public EObject basicGetAffectedEObject() {
        return affectedEObject;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public void setAffectedEObject(EObject newAffectedEObject) {
        EObject oldAffectedEObject = affectedEObject;
        affectedEObject = newAffectedEObject;
        if (eNotificationRequired())
            eNotify(new ENotificationImpl(this, Notification.SET, ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT, oldAffectedEObject, affectedEObject));
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public Object eGet(int featureID, boolean resolve, boolean coreType) {
        switch (featureID) {
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE:
                if (resolve) return getNewValue();
                return basicGetNewValue();
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE:
                if (resolve) return getAffectedFeature();
                return basicGetAffectedFeature();
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT:
                if (resolve) return getAffectedEObject();
                return basicGetAffectedEObject();
        }
        return super.eGet(featureID, resolve, coreType);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @SuppressWarnings("unchecked")
    @Override
    public void eSet(int featureID, Object newValue) {
        switch (featureID) {
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE:
                setNewValue((T)newValue);
                return;
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE:
                setAffectedFeature((U)newValue);
                return;
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT:
                setAffectedEObject((EObject)newValue);
                return;
        }
        super.eSet(featureID, newValue);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public void eUnset(int featureID) {
        switch (featureID) {
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE:
                setNewValue((T)null);
                return;
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE:
                setAffectedFeature((U)null);
                return;
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT:
                setAffectedEObject((EObject)null);
                return;
        }
        super.eUnset(featureID);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public boolean eIsSet(int featureID) {
        switch (featureID) {
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE:
                return newValue != null;
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE:
                return affectedFeature != null;
            case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT:
                return affectedEObject != null;
        }
        return super.eIsSet(featureID);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public int eBaseStructuralFeatureID(int derivedFeatureID, Class<?> baseClass) {
        if (baseClass == UpdateEFeature.class) {
            switch (derivedFeatureID) {
                case ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE: return ChangePackage.UPDATE_EFEATURE__NEW_VALUE;
                default: return -1;
            }
        }
        if (baseClass == EFeatureChange.class) {
            switch (derivedFeatureID) {
                case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE: return ChangePackage.EFEATURE_CHANGE__AFFECTED_FEATURE;
                case ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT: return ChangePackage.EFEATURE_CHANGE__AFFECTED_EOBJECT;
                default: return -1;
            }
        }
        if (baseClass == EReferenceChange.class) {
            switch (derivedFeatureID) {
                default: return -1;
            }
        }
        if (baseClass == UpdateEReference.class) {
            switch (derivedFeatureID) {
                default: return -1;
            }
        }
        if (baseClass == UpdateEContainmentReference.class) {
            switch (derivedFeatureID) {
                default: return -1;
            }
        }
        return super.eBaseStructuralFeatureID(derivedFeatureID, baseClass);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public int eDerivedStructuralFeatureID(int baseFeatureID, Class<?> baseClass) {
        if (baseClass == UpdateEFeature.class) {
            switch (baseFeatureID) {
                case ChangePackage.UPDATE_EFEATURE__NEW_VALUE: return ChangePackage.CREATE_NON_ROOT_EOBJECT__NEW_VALUE;
                default: return -1;
            }
        }
        if (baseClass == EFeatureChange.class) {
            switch (baseFeatureID) {
                case ChangePackage.EFEATURE_CHANGE__AFFECTED_FEATURE: return ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_FEATURE;
                case ChangePackage.EFEATURE_CHANGE__AFFECTED_EOBJECT: return ChangePackage.CREATE_NON_ROOT_EOBJECT__AFFECTED_EOBJECT;
                default: return -1;
            }
        }
        if (baseClass == EReferenceChange.class) {
            switch (baseFeatureID) {
                default: return -1;
            }
        }
        if (baseClass == UpdateEReference.class) {
            switch (baseFeatureID) {
                default: return -1;
            }
        }
        if (baseClass == UpdateEContainmentReference.class) {
            switch (baseFeatureID) {
                default: return -1;
            }
        }
        return super.eDerivedStructuralFeatureID(baseFeatureID, baseClass);
    }

} //CreateNonRootEObjectImpl
