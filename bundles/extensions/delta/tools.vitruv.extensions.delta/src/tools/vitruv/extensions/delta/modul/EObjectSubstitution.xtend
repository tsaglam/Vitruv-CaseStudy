package tools.vitruv.extensions.delta.modul

import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@Data 
@FinalFieldsConstructor
class EObjectSubstitution {
	
	private final String objectID;
    private final String featureName;
	
	new(String substitution) {
		if (!substitution.contains(".")) {
			throw new IllegalArgumentException("substitition must contain objectID + featureName seperated by a dot")
		}
		this.featureName = substitution.split("\\.").last
		this.objectID = substitution.substring(0, substitution.length - featureName.length-1)		
	}
   
    override toString() {
    	return objectID + "." + featureName
    }
}