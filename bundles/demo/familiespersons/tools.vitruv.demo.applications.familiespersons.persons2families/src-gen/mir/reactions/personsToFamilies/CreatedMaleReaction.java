package mir.reactions.personsToFamilies;

import edu.kit.ipd.sdq.metamodels.persons.Male;
import edu.kit.ipd.sdq.metamodels.persons.PersonRegister;
import mir.routines.personsToFamilies.RoutinesFacade;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.xbase.lib.Extension;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractReactionRealization;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;
import tools.vitruv.framework.change.echange.EChange;
import tools.vitruv.framework.change.echange.eobject.CreateEObject;
import tools.vitruv.framework.change.echange.feature.reference.InsertEReference;

@SuppressWarnings("all")
public class CreatedMaleReaction extends AbstractReactionRealization {
  private CreateEObject<Male> createChange;
  
  private InsertEReference<PersonRegister, Male> insertChange;
  
  private int currentlyMatchedChange;
  
  public CreatedMaleReaction(final RoutinesFacade routinesFacade) {
    super(routinesFacade);
  }
  
  public void executeReaction(final EChange change) {
    if (!checkPrecondition(change)) {
    	return;
    }
    edu.kit.ipd.sdq.metamodels.persons.PersonRegister affectedEObject = insertChange.getAffectedEObject();
    EReference affectedFeature = insertChange.getAffectedFeature();
    edu.kit.ipd.sdq.metamodels.persons.Male newValue = insertChange.getNewValue();
    int index = insertChange.getIndex();
    				
    getLogger().trace("Passed complete precondition check of Reaction " + this.getClass().getName());
    				
    mir.reactions.personsToFamilies.CreatedMaleReaction.ActionUserExecution userExecution = new mir.reactions.personsToFamilies.CreatedMaleReaction.ActionUserExecution(this.executionState, this);
    userExecution.callRoutine1(insertChange, affectedEObject, affectedFeature, newValue, index, this.getRoutinesFacade());
    
    resetChanges();
  }
  
  private void resetChanges() {
    createChange = null;
    insertChange = null;
    currentlyMatchedChange = 0;
  }
  
  private boolean matchCreateChange(final EChange change) {
    if (change instanceof CreateEObject<?>) {
    	CreateEObject<edu.kit.ipd.sdq.metamodels.persons.Male> _localTypedChange = (CreateEObject<edu.kit.ipd.sdq.metamodels.persons.Male>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof edu.kit.ipd.sdq.metamodels.persons.Male)) {
    		return false;
    	}
    	this.createChange = (CreateEObject<edu.kit.ipd.sdq.metamodels.persons.Male>) change;
    	return true;
    }
    
    return false;
  }
  
  public boolean checkPrecondition(final EChange change) {
    if (currentlyMatchedChange == 0) {
    	if (!matchCreateChange(change)) {
    		resetChanges();
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    	return false; // Only proceed on the last of the expected changes
    }
    if (currentlyMatchedChange == 1) {
    	if (!matchInsertChange(change)) {
    		resetChanges();
    		checkPrecondition(change); // Reexecute to potentially register this as first change
    		return false;
    	} else {
    		currentlyMatchedChange++;
    	}
    }
    
    return true;
  }
  
  private boolean matchInsertChange(final EChange change) {
    if (change instanceof InsertEReference<?, ?>) {
    	InsertEReference<edu.kit.ipd.sdq.metamodels.persons.PersonRegister, edu.kit.ipd.sdq.metamodels.persons.Male> _localTypedChange = (InsertEReference<edu.kit.ipd.sdq.metamodels.persons.PersonRegister, edu.kit.ipd.sdq.metamodels.persons.Male>) change;
    	if (!(_localTypedChange.getAffectedEObject() instanceof edu.kit.ipd.sdq.metamodels.persons.PersonRegister)) {
    		return false;
    	}
    	if (!_localTypedChange.getAffectedFeature().getName().equals("persons")) {
    		return false;
    	}
    	if (!(_localTypedChange.getNewValue() instanceof edu.kit.ipd.sdq.metamodels.persons.Male)) {
    		return false;
    	}
    	this.insertChange = (InsertEReference<edu.kit.ipd.sdq.metamodels.persons.PersonRegister, edu.kit.ipd.sdq.metamodels.persons.Male>) change;
    	return true;
    }
    
    return false;
  }
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(final InsertEReference insertChange, final PersonRegister affectedEObject, final EReference affectedFeature, final Male newValue, final int index, @Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.createMaleMemberOfFamily(newValue);
    }
  }
}
