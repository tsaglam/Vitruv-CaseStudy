/**
 */
package tools.vitruv.framework.change.echange.feature.attribute.impl;

import tools.vitruv.framework.change.echange.AdditiveEChange;
import tools.vitruv.framework.change.echange.SubtractiveEChange;
import tools.vitruv.framework.change.echange.feature.attribute.AdditiveAttributeEChange;
import tools.vitruv.framework.change.echange.feature.attribute.AttributePackage;
import tools.vitruv.framework.change.echange.feature.attribute.ReplaceSingleValuedEAttribute;
import tools.vitruv.framework.change.echange.feature.attribute.SubtractiveAttributeEChange;
import tools.vitruv.framework.change.echange.feature.attribute.UpdateAttributeEChange;
import tools.vitruv.framework.change.echange.feature.impl.UpdateSingleValuedFeatureEChangeImpl;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Replace Single Valued EAttribute</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link tools.vitruv.framework.change.echange.feature.attribute.impl.ReplaceSingleValuedEAttributeImpl#getOldValue <em>Old Value</em>}</li>
 *   <li>{@link tools.vitruv.framework.change.echange.feature.attribute.impl.ReplaceSingleValuedEAttributeImpl#getNewValue <em>New Value</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ReplaceSingleValuedEAttributeImpl<A extends EObject, T extends Object> extends UpdateSingleValuedFeatureEChangeImpl<A, EAttribute> implements ReplaceSingleValuedEAttribute<A, T> {
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
    protected ReplaceSingleValuedEAttributeImpl() {
		super();
	}

    /**
	 * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
	 * @generated
	 */
    @Override
    protected EClass eStaticClass() {
		return AttributePackage.Literals.REPLACE_SINGLE_VALUED_EATTRIBUTE;
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
			eNotify(new ENotificationImpl(this, Notification.SET, AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE, oldOldValue, oldValue));
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
			eNotify(new ENotificationImpl(this, Notification.SET, AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE, oldNewValue, newValue));
	}

    /**
	 * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
	 * @generated
	 */
    @Override
    public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE:
				return getOldValue();
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE:
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
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE:
				setOldValue((T)newValue);
				return;
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE:
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
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE:
				setOldValue((T)null);
				return;
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE:
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
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE:
				return oldValue != null;
			case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE:
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
		if (baseClass == SubtractiveEChange.class) {
			switch (derivedFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == UpdateAttributeEChange.class) {
			switch (derivedFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == SubtractiveAttributeEChange.class) {
			switch (derivedFeatureID) {
				case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE: return AttributePackage.SUBTRACTIVE_ATTRIBUTE_ECHANGE__OLD_VALUE;
				default: return -1;
			}
		}
		if (baseClass == AdditiveEChange.class) {
			switch (derivedFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == AdditiveAttributeEChange.class) {
			switch (derivedFeatureID) {
				case AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE: return AttributePackage.ADDITIVE_ATTRIBUTE_ECHANGE__NEW_VALUE;
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
		if (baseClass == SubtractiveEChange.class) {
			switch (baseFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == UpdateAttributeEChange.class) {
			switch (baseFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == SubtractiveAttributeEChange.class) {
			switch (baseFeatureID) {
				case AttributePackage.SUBTRACTIVE_ATTRIBUTE_ECHANGE__OLD_VALUE: return AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__OLD_VALUE;
				default: return -1;
			}
		}
		if (baseClass == AdditiveEChange.class) {
			switch (baseFeatureID) {
				default: return -1;
			}
		}
		if (baseClass == AdditiveAttributeEChange.class) {
			switch (baseFeatureID) {
				case AttributePackage.ADDITIVE_ATTRIBUTE_ECHANGE__NEW_VALUE: return AttributePackage.REPLACE_SINGLE_VALUED_EATTRIBUTE__NEW_VALUE;
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

} //ReplaceSingleValuedEAttributeImpl