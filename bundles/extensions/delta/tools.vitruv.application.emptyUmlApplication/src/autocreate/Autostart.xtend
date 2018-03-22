package autocreate;

import application.UMLProjectGeneration
import org.eclipse.ui.IStartup

class Autostart implements IStartup {

	override earlyStartup() {
		//create caex demo project
		new UMLProjectGeneration().createProjectAndVsum
	}

		

}
