package mir.routines.adXre_R2L;

import java.io.IOException;
import mir.routines.adXre_R2L.RoutinesFacade;
import org.eclipse.xtext.xbase.lib.Extension;
import tools.vitruv.extensions.dslsruntime.reactions.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.reactions.ReactionExecutionState;
import tools.vitruv.extensions.dslsruntime.reactions.structure.CallHierarchyHaving;

/**
 * *****************************************************
 * ********** BEGIN AdRootXReRoot MAPPING **********
 * ******************************************************
 */
@SuppressWarnings("all")
public class EnsureAdRootXReRootMappingRoutine extends AbstractRepairRoutineRealization {
  private EnsureAdRootXReRootMappingRoutine.ActionUserExecution userExecution;
  
  private static class ActionUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public ActionUserExecution(final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
      super(reactionExecutionState);
    }
    
    public void callRoutine1(@Extension final RoutinesFacade _routinesFacade) {
      _routinesFacade.deleteAdRootXReRootMappingInstances();
      _routinesFacade.createAdRootXReRootMappingInstances();
      _routinesFacade.updateAdRootXReRootMappingInstances();
    }
  }
  
  public EnsureAdRootXReRootMappingRoutine(final RoutinesFacade routinesFacade, final ReactionExecutionState reactionExecutionState, final CallHierarchyHaving calledBy) {
    super(routinesFacade, reactionExecutionState, calledBy);
    this.userExecution = new mir.routines.adXre_R2L.EnsureAdRootXReRootMappingRoutine.ActionUserExecution(getExecutionState(), this);
  }
  
  protected boolean executeRoutine() throws IOException {
    getLogger().debug("Called routine EnsureAdRootXReRootMappingRoutine with input:");
    
    userExecution.callRoutine1(this.getRoutinesFacade());
    
    postprocessElements();
    
    return true;
  }
}
