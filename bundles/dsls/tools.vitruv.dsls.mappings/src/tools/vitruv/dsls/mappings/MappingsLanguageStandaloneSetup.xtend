/*
 * generated by Xtext 2.12.0
 */
package tools.vitruv.dsls.mappings


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MappingsLanguageStandaloneSetup extends MappingsLanguageStandaloneSetupGenerated {

	def static void doSetup() {
		new MappingsLanguageStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
