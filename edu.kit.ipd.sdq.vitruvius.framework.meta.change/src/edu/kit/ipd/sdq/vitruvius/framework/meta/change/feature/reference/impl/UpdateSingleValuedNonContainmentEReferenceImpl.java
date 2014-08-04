/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.impl;

import edu.kit.ipd.sdq.vitruvius.framework.meta.change.EChange;

import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.EFeatureChange;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.FeaturePackage;

import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.impl.UpdateSingleValuedEFeatureImpl;

import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.ReferencePackage;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.UpdateEReference;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.UpdateNonContainmentEReference;
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.UpdateSingleValuedNonContainmentEReference;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Update Single Valued Non Containment EReference</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.impl.UpdateSingleValuedNonContainmentEReferenceImpl#getAffectedFeature <em>Affected Feature</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.impl.UpdateSingleValuedNonContainmentEReferenceImpl#getAffectedEObject <em>Affected EObject</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.impl.UpdateSingleValuedNonContainmentEReferenceImpl#getOldValue <em>Old Value</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.meta.change.feature.reference.impl.UpdateSingleValuedNonContainmentEReferenceImpl#getNewValue <em>New Value</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class UpdateSingleValuedNonContainmentEReferenceImpl<T extends EObject> extends UpdateSingleValuedEFeatureImpl<T> implements UpdateSingleValuedNonContainmentEReference<T> {
	/**
	 * The cached value of the '{@link #getAffectedFeature() <em>Affected Feature</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAffectedFeature()
	 * @generated
	 * @ordered
	 */
	protected EReference affectedFeature;

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
	 * The cached value of the '{@link #getOldValue() <em>Old Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getOldValue()
	 * @generated
	 * @ordered
	 */
	protected T oldValue;

	/**
	 * The cached value of the '{@link #getNewValue() <em>New Value</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNewValue()
	 * @generated
	 * @ordered
	 */
	protected T newValue;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected UpdateSingleValuedNonContainmentEReferenceImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return ReferencePackage.Literals.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference getAffectedFeature() {
		if (affectedFeature != null && affectedFeature.eIsProxy()) {
			InternalEObject oldAffectedFeature = (InternalEObject)affectedFeature;
			affectedFeature = (EReference)eResolveProxy(oldAffectedFeature);
			if (affectedFeature != oldAffectedFeature) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE, oldAffectedFeature, affectedFeature));
			}
		}
		return affectedFeature;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EReference basicGetAffectedFeature() {
		return affectedFeature;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setAffectedFeature(EReference newAffectedFeature) {
		EReference oldAffectedFeature = affectedFeature;
		affectedFeature = newAffectedFeature;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE, oldAffectedFeature, affectedFeature));
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
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT, oldAffectedEObject, affectedEObject));
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
			eNotify(new ENotificationImpl(this, Notification.SET, ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT, oldAffectedEObject, affectedEObject));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public T getOldValue() {
		return oldValue;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setOldValue(T newOldValue) {
		T oldOldValue = oldValue;
		oldValue = newOldValue;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__OLD_VALUE, oldOldValue, oldValue));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public T getNewValue() {
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
			eNotify(new ENotificationImpl(this, Notification.SET, ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__NEW_VALUE, oldNewValue, newValue));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE:
				if (resolve) return getAffectedFeature();
				return basicGetAffectedFeature();
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT:
				if (resolve) return getAffectedEObject();
				return basicGetAffectedEObject();
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__OLD_VALUE:
				return getOldValue();
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__NEW_VALUE:
				return getNewValue();
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
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE:
				setAffectedFeature((EReference)newValue);
				return;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT:
				setAffectedEObject((EObject)newValue);
				return;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__OLD_VALUE:
				setOldValue((T)newValue);
				return;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__NEW_VALUE:
				setNewValue((T)newValue);
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
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE:
				setAffectedFeature((EReference)null);
				return;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT:
				setAffectedEObject((EObject)null);
				return;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__OLD_VALUE:
				setOldValue((T)null);
				return;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__NEW_VALUE:
				setNewValue((T)null);
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
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE:
				return affectedFeature != null;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT:
				return affectedEObject != null;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__OLD_VALUE:
				return oldValue != null;
			case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__NEW_VALUE:
				return newValue != null;
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
		if (baseClass == EChange.class) {
			switch (derivedFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == EFeatureChange.class) {
			switch (derivedFeatureID) {
				case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE: return FeaturePackage.EFEATURE_CHANGE__AFFECTED_FEATURE;
				case ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT: return FeaturePackage.EFEATURE_CHANGE__AFFECTED_EOBJECT;
				default: return -1;
			}
		}
		if (baseClass == UpdateEReference.class) {
			switch (derivedFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == UpdateNonContainmentEReference.class) {
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
		if (baseClass == EChange.class) {
			switch (baseFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == EFeatureChange.class) {
			switch (baseFeatureID) {
				case FeaturePackage.EFEATURE_CHANGE__AFFECTED_FEATURE: return ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_FEATURE;
				case FeaturePackage.EFEATURE_CHANGE__AFFECTED_EOBJECT: return ReferencePackage.UPDATE_SINGLE_VALUED_NON_CONTAINMENT_EREFERENCE__AFFECTED_EOBJECT;
				default: return -1;
			}
		}
		if (baseClass == UpdateEReference.class) {
			switch (baseFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == UpdateNonContainmentEReference.class) {
			switch (baseFeatureID) {
				default: return -1;
			}
		}
		return super.eDerivedStructuralFeatureID(baseFeatureID, baseClass);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuffer result = new StringBuffer(super.toString());
		result.append(" (oldValue: ");
		result.append(oldValue);
		result.append(", newValue: ");
		result.append(newValue);
		result.append(')');
		return result.toString();
	}

} //UpdateSingleValuedNonContainmentEReferenceImpl
