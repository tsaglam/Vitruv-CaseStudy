/**
 * generated by Xtext 2.9.1
 */
package edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Metamodel Reference</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MetamodelReference#getModel <em>Model</em>}</li>
 * </ul>
 *
 * @see edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MirBasePackage#getMetamodelReference()
 * @model
 * @generated
 */
public interface MetamodelReference extends EObject
{
  /**
   * Returns the value of the '<em><b>Model</b></em>' reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Model</em>' reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Model</em>' reference.
   * @see #setModel(MetamodelImport)
   * @see edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MirBasePackage#getMetamodelReference_Model()
   * @model
   * @generated
   */
  MetamodelImport getModel();

  /**
   * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MetamodelReference#getModel <em>Model</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Model</em>' reference.
   * @see #getModel()
   * @generated
   */
  void setModel(MetamodelImport value);

} // MetamodelReference
