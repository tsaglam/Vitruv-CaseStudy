/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.impl;

import java.io.Serializable;
import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.EObjectImpl;
import org.eclipse.emf.ecore.util.EDataTypeUniqueEList;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.util.InternalEList;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.TUID;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.Correspondence;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.CorrespondencePackage;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.Correspondences;

/**
 * <!-- begin-user-doc --> An implementation of the model object '<em><b>Correspondence</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.impl.CorrespondenceImpl#getParent <em>Parent</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.impl.CorrespondenceImpl#getDependsOn <em>Depends On</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.impl.CorrespondenceImpl#getDependedOnBy <em>Depended On By</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.impl.CorrespondenceImpl#getATUIDs <em>ATUI Ds</em>}</li>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.impl.CorrespondenceImpl#getBTUIDs <em>BTUI Ds</em>}</li>
 * </ul>
 *
 * @generated
 */
// FIXME MK generate implements relation to Serializable from metamodel
public class CorrespondenceImpl extends EObjectImpl implements Correspondence {
    /**
     * @generated NOT
     */
    private static final long serialVersionUID = -1129928608053571384L;

    /**
     * The cached value of the '{@link #getDependsOn() <em>Depends On</em>}' reference list. <!--
     * begin-user-doc --> <!-- end-user-doc -->
     *
     * @see #getDependsOn()
     * @generated
     * @ordered
     */
    protected EList<Correspondence> dependsOn;

    /**
     * The cached value of the '{@link #getDependedOnBy() <em>Depended On By</em>}' reference list.
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @see #getDependedOnBy()
     * @generated
     * @ordered
     */
    protected EList<Correspondence> dependedOnBy;

    /**
     * The cached value of the '{@link #getATUIDs() <em>ATUI Ds</em>}' attribute list. <!--
     * begin-user-doc --> <!-- end-user-doc -->
     *
     * @see #getATUIDs()
     * @generated
     * @ordered
     */
    protected EList<TUID> aTUIDs;

    /**
     * The cached value of the '{@link #getBTUIDs() <em>BTUI Ds</em>}' attribute list. <!--
     * begin-user-doc --> <!-- end-user-doc -->
     *
     * @see #getBTUIDs()
     * @generated
     * @ordered
     */
    protected EList<TUID> bTUIDs;

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    protected CorrespondenceImpl() {
        super();
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    protected EClass eStaticClass() {
        return CorrespondencePackage.Literals.CORRESPONDENCE;
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public Correspondences getParent() {
        if (eContainerFeatureID() != CorrespondencePackage.CORRESPONDENCE__PARENT) return null;
        return (Correspondences)eInternalContainer();
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    public NotificationChain basicSetParent(Correspondences newParent, NotificationChain msgs) {
        msgs = eBasicSetContainer((InternalEObject)newParent, CorrespondencePackage.CORRESPONDENCE__PARENT, msgs);
        return msgs;
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public void setParent(Correspondences newParent) {
        if (newParent != eInternalContainer() || (eContainerFeatureID() != CorrespondencePackage.CORRESPONDENCE__PARENT && newParent != null)) {
            if (EcoreUtil.isAncestor(this, newParent))
                throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
            NotificationChain msgs = null;
            if (eInternalContainer() != null)
                msgs = eBasicRemoveFromContainer(msgs);
            if (newParent != null)
                msgs = ((InternalEObject)newParent).eInverseAdd(this, CorrespondencePackage.CORRESPONDENCES__CORRESPONDENCES, Correspondences.class, msgs);
            msgs = basicSetParent(newParent, msgs);
            if (msgs != null) msgs.dispatch();
        }
        else if (eNotificationRequired())
            eNotify(new ENotificationImpl(this, Notification.SET, CorrespondencePackage.CORRESPONDENCE__PARENT, newParent, newParent));
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public EList<Correspondence> getDependsOn() {
        if (dependsOn == null) {
            dependsOn = new EObjectWithInverseResolvingEList.ManyInverse<Correspondence>(Correspondence.class, this, CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON, CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY);
        }
        return dependsOn;
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public EList<Correspondence> getDependedOnBy() {
        if (dependedOnBy == null) {
            dependedOnBy = new EObjectWithInverseResolvingEList.ManyInverse<Correspondence>(Correspondence.class, this, CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY, CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON);
        }
        return dependedOnBy;
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public EList<TUID> getATUIDs() {
        if (aTUIDs == null) {
            aTUIDs = new EDataTypeUniqueEList<TUID>(TUID.class, this, CorrespondencePackage.CORRESPONDENCE__ATUI_DS);
        }
        return aTUIDs;
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public EList<TUID> getBTUIDs() {
        if (bTUIDs == null) {
            bTUIDs = new EDataTypeUniqueEList<TUID>(TUID.class, this, CorrespondencePackage.CORRESPONDENCE__BTUI_DS);
        }
        return bTUIDs;
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public EList<EObject> getAs() {
        // TODO: implement this method
        // Ensure that you remove @generated or mark it @generated NOT
        throw new UnsupportedOperationException();
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public EList<EObject> getBs() {
        // TODO: implement this method
        // Ensure that you remove @generated or mark it @generated NOT
        throw new UnsupportedOperationException();
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public TUID getElementATUID() {
        // TODO: implement this method
        // Ensure that you remove @generated or mark it @generated NOT
        throw new UnsupportedOperationException();
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public TUID getElementBTUID() {
        // TODO: implement this method
        // Ensure that you remove @generated or mark it @generated NOT
        throw new UnsupportedOperationException();
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @SuppressWarnings("unchecked")
    @Override
    public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
        switch (featureID) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                if (eInternalContainer() != null)
                    msgs = eBasicRemoveFromContainer(msgs);
                return basicSetParent((Correspondences)otherEnd, msgs);
            case CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON:
                return ((InternalEList<InternalEObject>)(InternalEList<?>)getDependsOn()).basicAdd(otherEnd, msgs);
            case CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY:
                return ((InternalEList<InternalEObject>)(InternalEList<?>)getDependedOnBy()).basicAdd(otherEnd, msgs);
        }
        return super.eInverseAdd(otherEnd, featureID, msgs);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
        switch (featureID) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                return basicSetParent(null, msgs);
            case CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON:
                return ((InternalEList<?>)getDependsOn()).basicRemove(otherEnd, msgs);
            case CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY:
                return ((InternalEList<?>)getDependedOnBy()).basicRemove(otherEnd, msgs);
        }
        return super.eInverseRemove(otherEnd, featureID, msgs);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
        switch (eContainerFeatureID()) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                return eInternalContainer().eInverseRemove(this, CorrespondencePackage.CORRESPONDENCES__CORRESPONDENCES, Correspondences.class, msgs);
        }
        return super.eBasicRemoveFromContainerFeature(msgs);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public Object eGet(int featureID, boolean resolve, boolean coreType) {
        switch (featureID) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                return getParent();
            case CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON:
                return getDependsOn();
            case CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY:
                return getDependedOnBy();
            case CorrespondencePackage.CORRESPONDENCE__ATUI_DS:
                return getATUIDs();
            case CorrespondencePackage.CORRESPONDENCE__BTUI_DS:
                return getBTUIDs();
        }
        return super.eGet(featureID, resolve, coreType);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @SuppressWarnings("unchecked")
    @Override
    public void eSet(int featureID, Object newValue) {
        switch (featureID) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                setParent((Correspondences)newValue);
                return;
            case CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON:
                getDependsOn().clear();
                getDependsOn().addAll((Collection<? extends Correspondence>)newValue);
                return;
            case CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY:
                getDependedOnBy().clear();
                getDependedOnBy().addAll((Collection<? extends Correspondence>)newValue);
                return;
            case CorrespondencePackage.CORRESPONDENCE__ATUI_DS:
                getATUIDs().clear();
                getATUIDs().addAll((Collection<? extends TUID>)newValue);
                return;
            case CorrespondencePackage.CORRESPONDENCE__BTUI_DS:
                getBTUIDs().clear();
                getBTUIDs().addAll((Collection<? extends TUID>)newValue);
                return;
        }
        super.eSet(featureID, newValue);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public void eUnset(int featureID) {
        switch (featureID) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                setParent((Correspondences)null);
                return;
            case CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON:
                getDependsOn().clear();
                return;
            case CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY:
                getDependedOnBy().clear();
                return;
            case CorrespondencePackage.CORRESPONDENCE__ATUI_DS:
                getATUIDs().clear();
                return;
            case CorrespondencePackage.CORRESPONDENCE__BTUI_DS:
                getBTUIDs().clear();
                return;
        }
        super.eUnset(featureID);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public boolean eIsSet(int featureID) {
        switch (featureID) {
            case CorrespondencePackage.CORRESPONDENCE__PARENT:
                return getParent() != null;
            case CorrespondencePackage.CORRESPONDENCE__DEPENDS_ON:
                return dependsOn != null && !dependsOn.isEmpty();
            case CorrespondencePackage.CORRESPONDENCE__DEPENDED_ON_BY:
                return dependedOnBy != null && !dependedOnBy.isEmpty();
            case CorrespondencePackage.CORRESPONDENCE__ATUI_DS:
                return aTUIDs != null && !aTUIDs.isEmpty();
            case CorrespondencePackage.CORRESPONDENCE__BTUI_DS:
                return bTUIDs != null && !bTUIDs.isEmpty();
        }
        return super.eIsSet(featureID);
    }

    /**
     * <!-- begin-user-doc --> <!-- end-user-doc -->
     * @generated
     */
    @Override
    public String toString() {
        if (eIsProxy()) return super.toString();

        StringBuffer result = new StringBuffer(super.toString());
        result.append(" (aTUIDs: ");
        result.append(aTUIDs);
        result.append(", bTUIDs: ");
        result.append(bTUIDs);
        result.append(')');
        return result.toString();
    }

} // CorrespondenceImpl