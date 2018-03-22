package tools.vitruv.extensions.delta.modul

import java.util.ArrayList
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.resource.XtextResourceSet
import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.TypeInferringAtomicEChangeFactory
import tools.vitruv.framework.change.echange.eobject.CreateEObject
import tools.vitruv.framework.change.echange.eobject.DeleteEObject
import tools.vitruv.framework.change.echange.feature.FeatureEChange
import tools.vitruv.framework.change.echange.feature.attribute.InsertEAttributeValue
import tools.vitruv.framework.change.echange.feature.attribute.RemoveEAttributeValue
import tools.vitruv.framework.change.echange.feature.attribute.ReplaceSingleValuedEAttribute
import tools.vitruv.framework.change.echange.feature.list.impl.UpdateSingleListEntryEChangeImpl
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference
import tools.vitruv.framework.change.echange.feature.reference.RemoveEReference
import tools.vitruv.framework.change.echange.root.InsertRootEObject
import tools.vitruv.framework.change.echange.root.RemoveRootEObject
import tools.vitruv.framework.uuid.UuidResolver
import tools.vitruv.framework.change.description.ConcreteChange
import tools.vitruv.framework.change.echange.feature.reference.ReplaceSingleValuedEReference
import tools.vitruv.extensions.delta.dsl.deltaModul.CreateChange
import tools.vitruv.extensions.delta.dsl.deltaModul.DeleteChange
import tools.vitruv.extensions.delta.dsl.deltaModul.SingleAttributeChange
import tools.vitruv.extensions.delta.dsl.deltaModul.InsertAttributeChange
import tools.vitruv.extensions.delta.dsl.deltaModul.RemoveAttributeChange
import tools.vitruv.extensions.delta.dsl.deltaModul.SingleReferenceChange
import tools.vitruv.extensions.delta.dsl.deltaModul.InsertReferenceChange
import tools.vitruv.extensions.delta.dsl.deltaModul.RemoveReferenceChange
import tools.vitruv.extensions.delta.dsl.deltaModul.RemoveRootChange
import tools.vitruv.extensions.delta.dsl.deltaModul.InsertRootChange
import tools.vitruv.extensions.delta.dsl.deltaModul.AtomicChange
import tools.vitruv.extensions.delta.dsl.deltaModul.DeltaModulFactory
import tools.vitruv.extensions.delta.dsl.deltaModul.impl.DeltaModulFactoryImpl
import tools.vitruv.extensions.delta.dsl.DeltaModulStandaloneSetup

class DeltaModul {
	
    private TransactionalChange changes
	private tools.vitruv.extensions.delta.dsl.deltaModul.DeltaModul deltaModul
	private Map<String,EObjectSubstitution> substitutions
	private Map<EObjectSubstitution, String> resubstitutions
	private Set<String> important
	private UuidResolver resolver
	private String name
	private String dirPath
	private Map<EObjectSubstitution, List<EObjectSubstitution>> conflicts
	
	new(List<TransactionalChange> changeDescriptions, UuidResolver resolver, String filePath) {
		important = new HashSet
		this.resolver = resolver
		substitutions = new HashMap
		resubstitutions = new HashMap
		conflicts = new HashMap
		val pathWithoutFileExt = filePath.split("\\.").get(0)
		this.name = null
		for (var i= pathWithoutFileExt.length - 1; i >= 0 && this.name === null;i--) {
			if (pathWithoutFileExt.charAt(i).toString.equals("\\") || pathWithoutFileExt.charAt(i).toString.equals("/")) {

				this.name = pathWithoutFileExt.substring(i+1)
				this.dirPath = pathWithoutFileExt.substring(0,i+1)
			}	
		}
		if (this.name === null) {
			this.name = pathWithoutFileExt
		}
		createDeltaModul(changeDescriptions)
	}
	
	new(URI deltaModulUri, UuidResolver resolver) {
		this.resolver = resolver
		
		val injector = new DeltaModulStandaloneSetup().createInjectorAndDoEMFRegistration();
		val	rs = injector.getInstance(XtextResourceSet);
		val	r = rs.getResource(deltaModulUri,true);
		deltaModul = r.contents.get(0) as tools.vitruv.extensions.delta.dsl.deltaModul.DeltaModul
		this.name = deltaModul.name
		conflicts = new HashMap
		for (c : deltaModul.conflicts) {
			val List<EObjectSubstitution> confList = new ArrayList
			for(var i = 1; i < c.elementsInConflict.size; i++) {
				confList.add(new EObjectSubstitution(c.elementsInConflict.get(i)))
			}
			if (confList.size > 0) {
				conflicts.put(new EObjectSubstitution(c.elementsInConflict.get(0)),confList)	
			}	
		}
		
		important = new HashSet
		substitutions = new HashMap
		resubstitutions = new HashMap
		for(String imp : deltaModul.requiredObjects) {
			important.add(imp)
		}
		val compositeTransactionalChange =  VitruviusChangeFactory.instance.createCompositeTransactionalChange
		for (c : deltaModul.changes) {
			val EChange echange = transformDeltaModulChangeInEChange(c)
			if (echange !== null) {
				val ConcreteChange change = VitruviusChangeFactory.instance.createConcreteApplicableChange(echange) 
				compositeTransactionalChange.addChange(change)	

			}
		}
		changes = compositeTransactionalChange
		for (c : changes.EChanges) {
			println(c)
		}
	}
	
	
	private def createDeltaModul(List<TransactionalChange> changeDescriptions) {
        val echanges = new ArrayList<EChange>
        
        //Get all EChanges in one List 
        for (TransactionalChange c : changeDescriptions) {
            for (EChange ec : c.getEChanges()) {
                if (ec !== null) {
                    echanges.add(ec)
                }
            }
        }
      
        
        echanges.sort(new EChangeComparator)
        
        removeGhostChanges(echanges)
        
        val changeFactory = VitruviusChangeFactory.instance
		val compositeTransactionalChange =  changeFactory.createCompositeTransactionalChange;
        //Find Objects for substitutions and put EChanges into a CompositeTransactionalChange 
        var int i = 0;
        for (c : echanges) {
            val addChange = canBeAddedToDeltaModul(c);
            if (addChange !== null) {
            	compositeTransactionalChange.addChange(changeFactory.createConcreteApplicableChange(c));         
            } 
            //check if oldValue occurs as newValue of other change	
            //substitution of oldValueID is only possible, if the value also occurs as a newValueID of a ReplaceSingleValuedEReference 
			if (addChange !== null && !addChange.equals("") && echanges.get(i) instanceof ReplaceSingleValuedEReference<?,?>) { 
            	 for (var j = 0; j < echanges.size; j++) {
            	 	if (echanges.get(j) instanceof ReplaceSingleValuedEReference<?,?> 
            	 		&& addChange.equals((echanges.get(j) as ReplaceSingleValuedEReference<?,?>).newValueID)
            	 	) {
            	 		//add substitution
            	 		val change = c as ReplaceSingleValuedEReference<?,?>
			           	var EObjectSubstitution sub
			           	val featureName = change.getAffectedFeature().getName()
			            if (substitutions.containsKey(change.getAffectedEObjectID())) {
			               	 sub = new EObjectSubstitution(substitutions.get(change.getAffectedEObjectID()).toString(), featureName)
			                substitutions.put(addChange, sub)
			                resubstitutions.put(sub, addChange)
			
			            } else {
			                sub = new EObjectSubstitution(change.getAffectedEObjectID(), featureName);
			                substitutions.put(addChange, sub)
			                resubstitutions.put(sub, addChange)
			                if (!substitutions.containsKey(change.getAffectedEObjectID())) {
			                    important.add(change.getAffectedEObjectID())
			                }
			            }
			            //substitution found, break
			            j = echanges.size
            	 	}
            	 } 
            } 
        } 
        changes = compositeTransactionalChange
        
        deltaModul = createDeltaModulFile(echanges)
        
	}
	
	/*finds ghost reference changes in the given list and removes them from it 
	 * a ghost change is for example: (All changes on the same object and the same feature)
	 * Replace "A" to null, Replace null to "B", Replace "B" to null, Replace null to "C"
	 * the changes in the middle are not needed and therefore removed
	 * TODO NK combine Replace "A" to null and null to "B" to new Change "A" to "B"
	 */
	private def removeGhostChanges(List<EChange> changes) {
		val removeChanges = new ArrayList<EChange>
		for (var i = 0; i < changes.size; i++) {
			val c = changes.get(i)
			if (!removeChanges.contains(c)) {
				if (c instanceof ReplaceSingleValuedEReference<?,?>) {
					removeChanges.addAll(removeGhostSingleReferenceChange(changes, i))	
				} else if (c instanceof InsertEReference<?,?>){
					removeChanges.addAll(removeGhostInsertChange(changes, i))
				} else if (c instanceof RemoveEReference<?,?>){
					removeChanges.addAll(removeGhostRemoveChange(changes, i))
				}
			}
		}
		changes.removeAll(removeChanges)
	}
	
	private def List<EChange> removeGhostRemoveChange(List<EChange> changes, int i) {
		val result = new ArrayList<EChange>
		val changeToCompare = changes.get(i) as RemoveEReference<?,?>
		for (var j = i+1; j<changes.size;j++) {
			val c = changes.get(j)
			if (c instanceof InsertEReference<?,?>) {
				if (c.affectedEObjectID.equals(changeToCompare.affectedEObjectID)
					&& c.affectedFeature.equals(changeToCompare.affectedFeature)
					&& c.newValueID.equals(changeToCompare.oldValueID)
					&& c.index == changeToCompare.index
				) {
					result.add(changeToCompare)
					result.add(c)
					return result
				}
			}
		}
		return result
	}
	
	private def List<EChange> removeGhostInsertChange(List<EChange> changes, int i) {
		val result = new ArrayList<EChange>
		val changeToCompare = changes.get(i) as InsertEReference<?,?>
		for (var j = i+1; j<changes.size;j++) {
			val c = changes.get(j)
			if (c instanceof RemoveEReference<?,?>) {
				if (c.affectedEObjectID.equals(changeToCompare.affectedEObjectID)
					&& c.affectedFeature.equals(changeToCompare.affectedFeature)
					&& c.oldValueID.equals(changeToCompare.newValueID)
					&& c.index == changeToCompare.index
				) {
					result.add(changeToCompare)
					result.add(c)
					return result
				}
			}
		}
		return result
	}
	

	
	private def List<EChange> removeGhostSingleReferenceChange(List<EChange> changes, int i) {
		val result = new ArrayList<EChange>
		var lastChangeFound = false
		val changeToCompare = changes.get(i) as ReplaceSingleValuedEReference<?,?>
		for (var j = changes.size-1; j>i;j--) {
			val c = changes.get(j)
			if (c instanceof ReplaceSingleValuedEReference<?,?>) {
				if (c.affectedEObjectID.equals(changeToCompare.affectedEObjectID)
					&& c.affectedFeature.equals(changeToCompare.affectedFeature)
				) {
					if (lastChangeFound) {
						result.add(c)
					} else {
						lastChangeFound = true;
					}
				}
			}
		}
		return result
	}
	
	private def dispatch EChange transformDeltaModulChangeInEChange(AtomicChange change) {
		throw new IllegalStateException("Unknown EChange type: " + change.getClass())
	}
	
	private def dispatch CreateEObject<?> transformDeltaModulChangeInEChange(CreateChange change) {
		//check if EObject was already created
		if (resolver.hasEObject(change.affectedEObjectID)) {
			return null
		}
		//TODO NK creating a new EObject, if it dosn't exist
		//needs access to factory of metamodel
		//solution 1 (ugly): via VitruviusDomainProviderRegistry and the file extension of deltaModul.uri
		return null
	}

	private def dispatch DeleteEObject<?> transformDeltaModulChangeInEChange(DeleteChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val object = TypeInferringAtomicEChangeFactory.instance.createDeleteEObjectChange(aff)
		object.affectedEObjectID = uuid
		return object
	}
	
	private def dispatch FeatureEChange<?,?> transformDeltaModulChangeInEChange(SingleAttributeChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val att = aff.eClass.getEStructuralFeature(change.attribute) as EAttribute
		val oldValue = if (change.oldValue.equals("")) {att.defaultValue} else {change.oldValue}
		var FeatureEChange<?,?> object
		if (change.newValue.equals("")) {
			object = TypeInferringAtomicEChangeFactory.instance.createUnsetFeatureChange(aff,att)
		} else {
			object = TypeInferringAtomicEChangeFactory.instance.createReplaceSingleAttributeChange(aff,att,oldValue, change.newValue)
		}
		object.affectedEObjectID = uuid
		return object
	}
	
	private def dispatch InsertEAttributeValue<?, ?> transformDeltaModulChangeInEChange(InsertAttributeChange change) {
        val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val att = aff.eClass.getEStructuralFeature(change.attribute) as EAttribute
		val index = change.index
		val newValue = if (change.newValue.equals("")) {att.defaultValue} else {change.newValue}
		val object = TypeInferringAtomicEChangeFactory.instance.createInsertAttributeChange(aff,att,index,newValue)
		object.affectedEObjectID = uuid
		return object
	}
	private def dispatch RemoveEAttributeValue<?, ?> transformDeltaModulChangeInEChange(RemoveAttributeChange change) {
        val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val att = aff.eClass.getEStructuralFeature(change.attribute) as EAttribute
		val oldValue = if (change.oldValue.equals("")) {att.defaultValue} else {change.oldValue}
		val EList<?> elist = aff.eGet(att) as EList<?>
		val index = change.index
		if (index >= elist.size || oldValue === null || !oldValue.equals(elist.get(index))) {
			//element to remove not found (already removed through Opposite Reference
			return null
		} 
		val object = TypeInferringAtomicEChangeFactory.instance.createRemoveAttributeChange(aff,att,index,oldValue)
		object.affectedEObjectID = uuid
		return object
	}
	
	private def dispatch FeatureEChange<?,?> transformDeltaModulChangeInEChange(SingleReferenceChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val ref = aff.eClass.getEStructuralFeature(change.feature) as EReference
		var String oldValueID
		var EObject oldValue
		if (change.oldValueID.equals("")) {
			oldValueID = ref.defaultValueLiteral
			oldValue = ref.defaultValue as EObject
		} else {
			oldValueID = resolveSubstitution(change.oldValueID)
			oldValue = resolver.getEObject(oldValueID) 
		}
		var String newValueID
		var EObject newValue
		if (change.newValueID.equals("")) {
			val object = TypeInferringAtomicEChangeFactory.instance.createUnsetFeatureChange(aff,ref)
			object.affectedEObjectID = uuid
			return object
		} else {
			newValueID = resolveSubstitution(change.newValueID)
			newValue = resolver.getEObject(newValueID) 
			val object = TypeInferringAtomicEChangeFactory.instance.createReplaceSingleReferenceChange(aff,ref,oldValue,newValue)
			object.affectedEObjectID = uuid
			object.newValueID = newValueID
			object.oldValueID = oldValueID
			return object
		}
//		val object = TypeInferringAtomicEChangeFactory.instance.createReplaceSingleReferenceChange(aff,ref,oldValue,newValue)
//		object.affectedEObjectID = uuid
//		object.newValueID = newValueID
//		object.oldValueID = oldValueID
//		return object
	}
	
	private def dispatch InsertEReference<?, ?> transformDeltaModulChangeInEChange(InsertReferenceChange change) {
        val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val ref = aff.eClass.getEStructuralFeature(change.feature) as EReference
		var String newValueID
		var EObject newValue
		if (change.newValueID.equals("")) {
			newValueID = ref.defaultValueLiteral
			newValue = ref.defaultValue as EObject
		} else {
			newValueID = resolveSubstitution(change.newValueID)
			newValue = resolver.getEObject(newValueID) 
		}
		val index = change.index
		val object = TypeInferringAtomicEChangeFactory.instance.createInsertReferenceChange(aff,ref,newValue, index)
		object.affectedEObjectID = uuid
		object.newValueID = newValueID
		return object
	}
	
	private def dispatch EChange transformDeltaModulChangeInEChange(RemoveReferenceChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val ref = aff.eClass.getEStructuralFeature(change.feature) as EReference
		var String oldValueID
		var EObject oldValue
		if (change.oldValueID.equals("")) {
			oldValueID = ref.defaultValueLiteral
			oldValue = ref.defaultValue as EObject
		} else {
			oldValueID = resolveSubstitution(change.oldValueID)
			oldValue = resolver.getEObject(oldValueID) 
		}
//		val EList<?> elist = aff.eGet(ref) as EList<?>
		var index = change.index
//		if (elist.size == 0) {
//			val result = TypeInferringAtomicEChangeFactory.instance.createUnsetFeatureChange(aff,ref)
//			result.affectedEObjectID = uuid
//			return result
//		}
//		for (var i = 0; i < elist.size && index < 0; i++) {
//			if(oldValueID.equals(resolver.getUuid(elist.get(i) as EObject))) {
//				index = i;	
//			}
//		} 
//		if (index < 0) {
//			//Element to remove not found, probably removed from EOpposite
//			return null
//		}
		val object = TypeInferringAtomicEChangeFactory.instance.createRemoveReferenceChange(aff,ref,oldValue, index)
		object.affectedEObjectID = uuid
		object.oldValueID = oldValueID
		
		return object
	}
	

	
	private def dispatch InsertRootEObject<?> transformDeltaModulChangeInEChange(InsertRootChange change) {
		throw new UnsupportedOperationException("Not implemented")
	}
	
	private def dispatch RemoveRootEObject<?> transformDeltaModulChangeInEChange(RemoveRootChange change) {
		throw new UnsupportedOperationException("Not implemented")
	}
	
	private def String resolveSubstitution(String substitution) {
		if (!isSubstitution(substitution)) {
			return substitution
		}
		val array = substitution.split("\\.")
		var element = array.get(0)
		for (var i = 1; i< array.length;i++) {
			val temp = new EObjectSubstitution(element, array.get(i))
			if (resubstitutions.containsKey(temp)) {
				element = resubstitutions.get(temp)
			} else {
				val obj = resolver.getEObject(element)
				val featureName = array.get(i)
				val feature = obj.eClass.getEStructuralFeature(featureName)
				element = resolver.getUuid(obj.eGet(feature) as EObject)
				val subKey = if (substitutions.containsKey(obj)) {substitutions.get(obj).toString} else {resolver.getUuid(obj)}
				val sub = new EObjectSubstitution(subKey, featureName)
				resubstitutions.put(sub, element)
				substitutions.put(element, sub)
			}
		}
		 
		
		return element
		
	}
	
	
	private def dispatch String canBeAddedToDeltaModul(EChange change) {
		throw new IllegalStateException("Unknown EChange type: " + change.getClass())
	}
	
	private def dispatch String canBeAddedToDeltaModul(CreateEObject<?> change) {
		//checks if object already exists and isn't just "recreated"
		//should always be true
		if (resolver.hasEObject(change.affectedEObjectID)) {
			return null
		} else {
			important.add(change.affectedEObjectID);		
			return ""
		}
	}

	private def dispatch String canBeAddedToDeltaModul(DeleteEObject<?> change) {
//		if (!substitutions.containsKey(change.getAffectedEObjectID())) {
        	important.add(change.getAffectedEObjectID());
//        }
        return ""
	}
	
	private def dispatch String canBeAddedToDeltaModul(ReplaceSingleValuedEAttribute<?, ?> change) {
		if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            important.add(change.getAffectedEObjectID());
        }
        return ""
	}
	
	private def dispatch String canBeAddedToDeltaModul(InsertEAttributeValue<?, ?> change) {
        if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            important.add(change.getAffectedEObjectID());
        }
        return ""
	}
	private def dispatch String canBeAddedToDeltaModul(RemoveEAttributeValue<?, ?> change) {
        if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            important.add(change.getAffectedEObjectID());
        }
        return ""
	}
	
	private def dispatch String canBeAddedToDeltaModul(ReplaceSingleValuedEReference<?, ?> change) {
		val oldValue = change.getOldValueID()
		//check for substitution candidate
		//candidate can't be null, 
		//candidate can't be an object, that's created in the same modul
        if (oldValue !== null && !important.contains(oldValue)) {
        	if (substitutions.containsKey(oldValue)) {
        		val conflict = substitutions.get(oldValue);
        		println("Warning: " + oldValue + " already substituted by "+ conflict.toString + "!")
        		println("Deltamodul maybe needs manual optimization")
        		var List<EObjectSubstitution> confList = conflicts.get(conflict)
        		if (confList === null) {
        			confList = new ArrayList
        			conflicts.put(conflict, confList)
        		}
        		confList.add(new EObjectSubstitution(change.affectedEObjectID, change.affectedFeature.name))
        	}
            return oldValue
        }
        return ""
	}
	
	private def dispatch String canBeAddedToDeltaModul(InsertEReference<?, ?> change) {
        if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            important.add(change.getAffectedEObjectID());
        }
        if (!substitutions.containsKey(change.getNewValueID())) {
            important.add(change.getNewValueID());
        }
        return ""
	}
	
	private def dispatch String canBeAddedToDeltaModul(RemoveEReference<?, ?> change) {
		if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            important.add(change.getAffectedEObjectID());
        }
        if (!substitutions.containsKey(change.getOldValueID())) {
            important.add(change.getOldValueID());
        }
        return ""
	}
	
	private def dispatch String canBeAddedToDeltaModul(InsertRootEObject<?> change) {
		throw new UnsupportedOperationException("Not implemented");
	}
	
	private def dispatch String canBeAddedToDeltaModul(RemoveRootEObject<?> change) {
		throw new UnsupportedOperationException("Not implemented");
	}

	private def tools.vitruv.extensions.delta.dsl.deltaModul.DeltaModul createDeltaModulFile(List<EChange> echanges) {

	

	val deltaModul = DeltaModulFactory.eINSTANCE.createDeltaModul;
	deltaModul.name = this.name;
	
	//TODO NK resource uri chosen by user
	deltaModul.uri = "C:/Users/nkopp/runtime-EclipseXtext/MyProject/src/My.uml"
	
	
//	//TODO NK features chosen by user
//	val reqFeature = DeltaModulFactoryImpl.eINSTANCE.createRequiredFeatureRule
//	reqFeature.feature = "f1"
//	reqFeature.isSet = "true"
//	deltaModul.requiredFeatures.add(reqFeature)
//	val setsFeature = DeltaModulFactoryImpl.eINSTANCE.createSetsFeatureRule
//	setsFeature.feature = "f2"
//	setsFeature.isSet = "true"
//	deltaModul.setsFeatures.add(setsFeature)
	
	
	for (EChange c : changes.EChanges) {		
		deltaModul.changes.addAll(getDeltaModulChange(c))
	}	
	
   	for (String imp : important) {
    	deltaModul.requiredObjects.add(imp)
    }
 	for (con : conflicts.keySet) {
 		val deltaModulConflict = DeltaModulFactory.eINSTANCE.createConflict
 		deltaModulConflict.elementsInConflict.add(con.toString)
 		for (con2 : conflicts.get(con)) {
 			deltaModulConflict.elementsInConflict.add(con2.toString)
 		}
 		deltaModul.conflicts.add(deltaModulConflict)
 	}
    
	val injector = new DeltaModulStandaloneSetup().createInjectorAndDoEMFRegistration();
	val	rs = injector.getInstance(XtextResourceSet);
	val	r = rs.createResource(URI.createFileURI(dirPath + name + ".delta"));
	
	r.contents.add(deltaModul)
	r.save(null)
	return deltaModul
	}
	
	
	private def dispatch List<CreateChange> getDeltaModulChange(CreateEObject<?> change) {
		important.remove(change.getAffectedEObjectID)
		val object = DeltaModulFactoryImpl.eINSTANCE.createCreateChange
		object.affectedEObjectID = change.getAffectedEObjectID
		object.class = change.affectedEObjectType.instanceClassName
		return #[object].toList
	}

	private def dispatch List<AtomicChange> getDeltaModulChange(DeleteEObject<?> change) {
		val result = new ArrayList<AtomicChange>
//		//assumption: Reference Features are already removed or unset through EOpposite
//		for (EStructuralFeature a : change.affectedEObjectType.EAllAttributes) {
//			if (a.changeable && change.affectedEObject.eIsSet(a)) {
//				val attValue = change.affectedEObject.eGet(a)
//				if (attValue instanceof EList<?>) {
//					for (var int i = 0; i < attValue.size;i++) {
//						val object = DeltaModulFactoryImpl.eINSTANCE.createSingleAttributeChange
//						object.affectedEObjectID = change.affectedEObjectID
//						object.attribute = a.name
//						object.oldValue = attValue.get(i).toString
//						object.index = i
//						result.add(object)
//					}
//				} else {
//					val object = DeltaModulFactoryImpl.eINSTANCE.createSingleAttributeChange
//					object.affectedEObjectID = change.affectedEObjectID
//					object.attribute = a.name
//					object.oldValue = attValue.toString
//					object.newValue = ""
//					result.add(object)
//				}
//				
//			}
//		}
//		//Remove Element from container if container exists
//		val EStructuralFeature containingFeature = change.affectedEObject.eContainingFeature
//		if (containingFeature !== null && change.affectedEObject.eContainer !== null) {
//			if (containingFeature.many) {
//				val object = DeltaModulFactoryImpl.eINSTANCE.createRemoveReferenceChange
//				object.affectedEObjectID = resolver.getUuid(change.affectedEObject.eContainer)
//				if (object.affectedEObjectID !== null) {
//					object.feature = containingFeature.name
//					object.oldValueID = change.affectedEObjectID
//					var index = -1
//					var i = 0;
//					for (EObject eobject : change.affectedEObject.eContainer.eGet(containingFeature) as EList<EObject>) {
//						if (resolver.hasUuid(eobject) && change.affectedEObjectID.equals(resolver.getUuid(eobject))) {
//							index = i; 
//						}
//						i++;
//					} 
//					if (index > 0) {
//						result.add(object)
//					}
//				}
//			} else {
//				val object = DeltaModulFactoryImpl.eINSTANCE.createSingleReferenceChange
//				object.affectedEObjectID = resolver.getUuid(change.affectedEObject.eContainer)
//				object.feature = containingFeature.name
//				object.oldValueID = change.affectedEObjectID
//				object.newValueID = containingFeature.defaultValueLiteral
//				if (object.affectedEObjectID !== null) {
//					result.add(object)	
//				}
//			}
//		}
		val object = DeltaModulFactoryImpl.eINSTANCE.createDeleteChange
		object.affectedEObjectID =  
//			if (substitutions.containsKey(change.affectedEObjectID)) {
//				substitutions.get(change.affectedEObjectID).toString
//			} else {
				change.affectedEObjectID
//			}
		result.add(object)
		return result
	}
	
	private def dispatch List<SingleAttributeChange> getDeltaModulChange(ReplaceSingleValuedEAttribute<?, ?> change) {
		val object = DeltaModulFactoryImpl.eINSTANCE.createSingleAttributeChange
		object.affectedEObjectID = 
			if (substitutions.containsKey(change.affectedEObjectID)) {
				substitutions.get(change.affectedEObjectID).toString
			} else {
				change.affectedEObjectID
			}
		object.attribute = change.affectedFeature.name
		object.newValue = 
			if(change.newValue === null) { 
				"" 
			} else {
				change.newValue.toString
			}
		object.oldValue = if(change.oldValue === null){ "" } else {change.oldValue.toString}
        return #[object].toList
	}
	
	private def dispatch List<InsertAttributeChange> getDeltaModulChange(InsertEAttributeValue<?, ?> change) {
		val object = DeltaModulFactoryImpl.eINSTANCE.createInsertAttributeChange
		object.affectedEObjectID = 
			if (substitutions.containsKey(change.affectedEObjectID)) {
				substitutions.get(change.affectedEObjectID).toString
			} else {
				change.affectedEObjectID
			}
		object.attribute = change.affectedFeature.name
		object.index = change.index
		object.newValue = 
			if(change.newValue === null){ 
				"" 
			} else {
				change.newValue.toString
			}
        return #[object].toList
	}
	private def dispatch List<RemoveAttributeChange> getDeltaModulChange(RemoveEAttributeValue<?, ?> change) {
		val object = DeltaModulFactoryImpl.eINSTANCE.createRemoveAttributeChange
		object.affectedEObjectID = 
			if (substitutions.containsKey(change.affectedEObjectID)) {
				substitutions.get(change.affectedEObjectID).toString
			} else {
				change.affectedEObjectID
			}
		object.attribute = change.affectedFeature.name
		object.index = change.index
		object.oldValue =  if(change.oldValue === null){ "" } else {change.oldValue.toString}
        return #[object].toList
	}
	
	private def dispatch List<SingleReferenceChange> getDeltaModulChange(ReplaceSingleValuedEReference<?, ?> change) {
		val object = DeltaModulFactoryImpl.eINSTANCE.createSingleReferenceChange
		object.affectedEObjectID = 
			if (substitutions.containsKey(change.affectedEObjectID)) {
				substitutions.get(change.affectedEObjectID).toString
			} else {
				change.affectedEObjectID
			}
		object.feature = change.affectedFeature.name
		object.newValueID =
			if(change.newValueID === null){
				 ""
			} else if (substitutions.containsKey(change.newValueID)) {
				substitutions.get(change.newValueID).toString
			} else {
				change.newValueID
			}
		object.oldValueID =
			if(change.oldValueID === null){
				 ""
			} else if (substitutions.containsKey(change.oldValueID)) {
				substitutions.get(change.oldValueID).toString
			} else {
				change.oldValueID
			}	
        return #[object].toList
	}
	
	private def dispatch List<InsertReferenceChange> getDeltaModulChange(InsertEReference<?, ?> change) {
		val object = DeltaModulFactoryImpl.eINSTANCE.createInsertReferenceChange
		object.affectedEObjectID = 
			if (substitutions.containsKey(change.affectedEObjectID)) {
				substitutions.get(change.affectedEObjectID).toString
			} else {
				change.affectedEObjectID
			}
		object.feature = change.affectedFeature.name
		object.newValueID =
			if(change.newValueID === null){
				 ""
			} else if (substitutions.containsKey(change.newValueID)) {
				substitutions.get(change.newValueID).toString
			} else {
				change.newValueID
			}
		object.index = (change as UpdateSingleListEntryEChangeImpl<?,?>).index
        return #[object].toList
	}
	
	private def dispatch List<RemoveReferenceChange> getDeltaModulChange(RemoveEReference<?, ?> change) {
		val object = DeltaModulFactoryImpl.eINSTANCE.createRemoveReferenceChange
		object.affectedEObjectID = 
			if (substitutions.containsKey(change.affectedEObjectID)) {
				substitutions.get(change.affectedEObjectID).toString
			} else {
				change.affectedEObjectID
			}
		object.feature = change.affectedFeature.name
		object.oldValueID =
			if(change.oldValueID === null){
				 ""
			} else if (substitutions.containsKey(change.oldValueID)) {
				substitutions.get(change.oldValueID).toString
			} else {
				change.oldValueID
			}
		object.index = (change as UpdateSingleListEntryEChangeImpl<?,?>).index
        return #[object].toList
	}
	
	private def dispatch List<InsertRootChange> getDeltaModulChange(InsertRootEObject<?> change) {
        val object = DeltaModulFactoryImpl.eINSTANCE.createInsertRootChange
		object.affectedEObjectID =
			if(change.newValueID === null){
				 ""
			} else if (substitutions.containsKey(change.newValueID)) {
				substitutions.get(change.newValueID).toString
			} else {
				change.newValueID
			}
        return #[object].toList
	}
	
	private def dispatch List<RemoveRootChange> getDeltaModulChange(RemoveRootEObject<?> change) {
        val object = DeltaModulFactoryImpl.eINSTANCE.createRemoveRootChange
		object.affectedEObjectID =
			if(change.oldValueID === null){
				 ""
			} else if (substitutions.containsKey(change.oldValueID)) {
				substitutions.get(change.oldValueID).toString
			} else {
				change.oldValueID
			}
        return #[object].toList
	}
	
	
	public def TransactionalChange getChanges() {
		return changes;
	}
	
	public def tools.vitruv.extensions.delta.dsl.deltaModul.DeltaModul getDeltaModul() {
		return deltaModul;
	}
	
	public def TransactionalChange getInverseChanges() {
		substitutions = new HashMap
		resubstitutions = new HashMap
		val factory = VitruviusChangeFactory.instance
		val result = factory.createCompositeTransactionalChange
		val List<EChange> echanges = new ArrayList
		findResubstitutions()
//		for (c : this.deltaModul.changes) {
//			//put the substitutions in the substitution map
//			var isSub =false;
//			if (c instanceof SingleReferenceChange) {
//				isSub = isSubstitution(c.newValueID)
//				if (isSub) {
//					//val temp = findResubstitution(c.oldValueID)
//					//if (temp !== null) {
//						val sub = new EObjectSubstitution(c.newValueID)
//						val EObject o = resolver.getEObject(c.affectedEObjectID);
//						val temp = resolver.getUuid(o.eGet(o.eClass.getEStructuralFeature(c.feature)) as EObject)
//						substitutions.put(temp, sub)
//						resubstitutions.put(sub, temp)
//					//}
//				}
//			}
////			resolveSubstitutionForInverseChange(c)
//		}
		for (AtomicChange c: this.deltaModul.changes.reverseView) {	
			val EChange echange = invertDeltaModulChange(c)
			if (echange !== null) {
				echanges.add(echange)
			}		
		}
		echanges.sort(new EChangeComparator)
		for (EChange c: echanges) {
			val con = factory.createConcreteApplicableChange(c)
			
			result.addChange(con)		
		}
		return result
	}
	
	private def void findResubstitutions() {
		this.deltaModul.changes.filter(SingleReferenceChange).filter[isSubstitution(it.newValueID)].forEach(c |
			{
				val EObject o = resolver.getEObject(c.affectedEObjectID);
				val sub = new EObjectSubstitution(c.newValueID)
				val temp = resolver.getUuid(o.eGet(o.eClass.getEStructuralFeature(c.feature)) as EObject)
				substitutions.put(temp, sub)
				resubstitutions.put(sub, temp)
			})
	}
	
	private def boolean isSubstitution(String value) {
		return value.contains(".")
	}
	
//	private def dispatch resolveSubstitutionForInverseChange(AtomicChange change) {
//		throw new UnsupportedOperationException("TODO: auto-generated method stub")
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(CreateChange change) {
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(DeleteChange change) {
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(SingleAttributeChange change) {
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(InsertAttributeChange change) {
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(RemoveAttributeChange change) {
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(ReplaceSingleValuedEReference change) {
//		resolveSubstitution(change.oldValueID)
//		resolveSubstitution(change.newValueID)		
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(InsertReferenceChange change) {
//		resolveSubstitution(change.newValueID)
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(RemoveReferenceChange change) {
//		resolveSubstitution(change.oldValueID)
//		resolveSubstitution(change.affectedEObjectID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(InsertRootChange change) {
//		resolveSubstitution(change.newValueID)
//	}
//	
//	private def dispatch resolveSubstitutionForInverseChange(RemoveRootChange change) {
//		resolveSubstitution(change.oldValueID)
//	}
	
	private def dispatch EChange invertDeltaModulChange(AtomicChange change) {
		throw new IllegalStateException("unknown type: " + change.class)
	}
	private def dispatch EChange invertDeltaModulChange(CreateChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val result = TypeInferringAtomicEChangeFactory.instance.createDeleteEObjectChange(aff)
		result.affectedEObjectID = uuid
		return result
	}
	private def dispatch EChange invertDeltaModulChange(DeleteChange change) {
		//check if Object was already created
		if (resolver.hasEObject(change.affectedEObjectID)) {
			return null
		}
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val result = TypeInferringAtomicEChangeFactory.instance.createCreateEObjectChange(aff)
		result.affectedEObjectID = uuid
		return result
	}
	private def dispatch EChange invertDeltaModulChange(SingleAttributeChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val att = aff.eClass.getEStructuralFeature(change.attribute) as EAttribute
		val newValue = if (change.newValue.equals("")) {att.defaultValue} else {change.newValue}
		if (change.oldValue.equals("")) {
			val result = TypeInferringAtomicEChangeFactory.instance.createUnsetFeatureChange(aff,att)
			result.affectedEObjectID = uuid
			return result
		} else {
			val result = TypeInferringAtomicEChangeFactory.instance.createReplaceSingleAttributeChange(aff,att,newValue,change.oldValue)
			result.affectedEObjectID = uuid
			return result
		}
	}
	private def dispatch EChange invertDeltaModulChange(InsertAttributeChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val att = aff.eClass.getEStructuralFeature(change.attribute) as EAttribute
		val index = change.index
		val newValue = if (change.newValue.equals("")) {att.defaultValue} else {change.newValue}
		val result = TypeInferringAtomicEChangeFactory.instance.createRemoveAttributeChange(aff, att, index, newValue)
		result.affectedEObjectID = uuid
		return result
	}
	private def dispatch EChange invertDeltaModulChange(RemoveAttributeChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val att = aff.eClass.getEStructuralFeature(change.attribute) as EAttribute
		val index = change.index
		val oldValue = if (change.oldValue.equals("")) {att.defaultValue} else {change.oldValue}
		val result = TypeInferringAtomicEChangeFactory.instance.createInsertAttributeChange(aff, att, index, oldValue)
		result.affectedEObjectID = uuid
		return result
	}
	private def dispatch EChange invertDeltaModulChange(SingleReferenceChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val ref = aff.eClass.getEStructuralFeature(change.feature) as EReference
		var String newValueID
		var EObject newValue
		if (change.newValueID.equals("")) {
			newValueID = ref.defaultValueLiteral
			newValue = ref.defaultValue as EObject
		} else {
			newValueID = resolveSubstitution(change.newValueID)
			newValue = resolver.getEObject(newValueID) 
		}
		var String oldValueID
		var EObject oldValue

		if (change.oldValueID.equals("")) {
			val result = TypeInferringAtomicEChangeFactory.instance.createUnsetFeatureChange(aff,ref)
			result.affectedEObjectID = uuid
			return result
		} else {
			oldValueID = resolveSubstitution(change.oldValueID)
			oldValue = resolver.getEObject(oldValueID) 
			val result = TypeInferringAtomicEChangeFactory.instance.createReplaceSingleReferenceChange(aff,ref,newValue,oldValue)
			result.affectedEObjectID = uuid
			result.newValueID = oldValueID
			result.oldValueID = newValueID
			return result
		}
//		val result = TypeInferringAtomicEChangeFactory.instance.createReplaceSingleReferenceChange(aff,ref,newValue,oldValue)
//		result.affectedEObjectID = uuid
//		result.newValueID = oldValueID
//		result.oldValueID = newValueID
//		return result
	}
	private def dispatch EChange invertDeltaModulChange(InsertReferenceChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val ref = aff.eClass.getEStructuralFeature(change.feature) as EReference
		var String newValueID
		var EObject newValue
		if (change.newValueID.equals("")) {
			newValueID = ref.defaultValueLiteral
			newValue = ref.defaultValue as EObject
		} else {
			newValueID = resolveSubstitution(change.newValueID)
			newValue = resolver.getEObject(newValueID) 
		}
//		val EList<?> elist = aff.eGet(ref) as EList<?>
		var index = change.index
//		if (elist.size == 0) {
//			val result = TypeInferringAtomicEChangeFactory.instance.createUnsetFeatureChange(aff,ref)
//			result.affectedEObjectID = uuid
//			return result
//		}
//		for (var i = 0; i < elist.size && index < 0; i++) {
//			if(newValueID.equals(resolver.getUuid(elist.get(i) as EObject))) {
//				index = i;	
//			}
//		} 
//		if (index < 0) {
//			//Element to remove not found, probably removed from EOpposite
//			return null
//		}
		val result = TypeInferringAtomicEChangeFactory.instance.createRemoveReferenceChange(aff,ref,newValue, index)
		result.affectedEObjectID = uuid
		result.oldValueID = newValueID
		return result
	}
	private def dispatch EChange invertDeltaModulChange(RemoveReferenceChange change) {
		val uuid = resolveSubstitution(change.affectedEObjectID)
		val aff = resolver.getEObject(uuid)
		val ref = aff.eClass.getEStructuralFeature(change.feature) as EReference
		var String oldValueID
		var EObject oldValue
		if (change.oldValueID.equals("")) {
			oldValueID = ref.defaultValueLiteral
			oldValue = ref.defaultValue as EObject
		} else {
			oldValueID = resolveSubstitution(change.oldValueID)
			oldValue = resolver.getEObject(oldValueID) 
		}
		val index = change.index
		val result = TypeInferringAtomicEChangeFactory.instance.createInsertReferenceChange(aff, ref, oldValue, index)
		result.affectedEObjectID = uuid
		result.newValueID = oldValueID
		return result
	}
	private def dispatch EChange invertDeltaModulChange(RemoveRootChange change) {
		throw new UnsupportedOperationException("Not implemented")
	}
	
	private def dispatch EChange invertDeltaModulChange(InsertRootChange change) {
		throw new UnsupportedOperationException("Not implemented")
	}
	
}