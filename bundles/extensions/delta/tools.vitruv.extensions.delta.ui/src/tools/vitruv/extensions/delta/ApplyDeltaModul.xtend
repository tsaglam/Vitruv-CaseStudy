package tools.vitruv.extensions.delta

import org.eclipse.emf.common.util.URI
import tools.vitruv.framework.vsum.VirtualModel
import tools.vitruv.framework.vsum.VirtualModelManager
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Shell

class ApplyDeltaModul {
	URI uri;
	VirtualModel vsum
	new() {
		val FileDialog fd = new FileDialog(new Shell, SWT.OPEN)
		fd.filterPath = ResourcesPlugin.workspace.root.location.toPortableString
		fd.filterExtensions = #{"*.delta"}
		
		var String name = fd.open
		if (name !== null && name.endsWith(".delta")) {
			this.uri = URI.createFileURI(name)	
		} else {
			this.uri = null
		}
		val vsumProjectLocation = ResourcesPlugin.workspace.root.getProject("MyVsumProject").location
		if (vsumProjectLocation !== null) {
			vsum = VirtualModelManager.instance.getVirtualModel(vsumProjectLocation.toFile);	
		}
	}
	
	def applyBackwards() {
		if (uri !== null && vsum !== null) {
			vsum.applyDelta(uri,false)
		}
	}
	
	def applyForwards() {
		if (uri !== null && vsum !== null) {
			vsum.applyDelta(uri,true)
		}
	}
	
}