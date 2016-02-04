/**
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package edu.kit.ipd.sdq.vitruvius.dsls.mirbase.ui.quickfix;

import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.mirBase.MetamodelImport;
import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.validation.EclipsePluginHelper;
import edu.kit.ipd.sdq.vitruvius.dsls.mirbase.validation.MirBaseValidator;
import edu.kit.ipd.sdq.vitruvius.framework.util.bridges.EclipseBridge;
import org.eclipse.core.resources.IProject;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.ui.editor.model.edit.IModificationContext;
import org.eclipse.xtext.ui.editor.model.edit.ISemanticModification;
import org.eclipse.xtext.ui.editor.quickfix.Fix;
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.ui.quickfix.XbaseQuickfixProvider;

/**
 * Custom quickfixes.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#quick-fixes
 */
@SuppressWarnings("all")
public class MirBaseQuickfixProvider extends XbaseQuickfixProvider {
  @Fix(MirBaseValidator.METAMODEL_IMPORT_DEPENDENCY_MISSING)
  public void addDependencyToManifest(final Issue issue, final IssueResolutionAcceptor acceptor) {
    final ISemanticModification _function = (EObject element, IModificationContext context) -> {
      final MetamodelImport metamodelImport = ((MetamodelImport) element);
      EPackage _package = metamodelImport.getPackage();
      String _nsURI = _package.getNsURI();
      final String contributorName = EclipseBridge.getNameOfContributorOfExtension(
        "org.eclipse.emf.ecore.generated_package", "uri", _nsURI);
      Resource _eResource = metamodelImport.eResource();
      final IProject project = EclipsePluginHelper.getProject(_eResource);
      boolean _hasDependency = EclipsePluginHelper.hasDependency(project, contributorName);
      boolean _not = (!_hasDependency);
      if (_not) {
        EclipsePluginHelper.addDependency(project, contributorName);
      }
    };
    acceptor.accept(issue, "Add dependency.", "Add the dependency.", null, _function);
  }
  
  @Fix(MirBaseValidator.VITRUVIUS_DEPENDENCY_MISSING)
  public void addVitruviusDependenciesToManifest(final Issue issue, final IssueResolutionAcceptor acceptor) {
    final ISemanticModification _function = (EObject element, IModificationContext context) -> {
      Resource _eResource = element.eResource();
      final IProject project = EclipsePluginHelper.getProject(_eResource);
      for (final String dependency : MirBaseValidator.VITRUVIUS_DEPENDENCIES) {
        {
          InputOutput.<String>println(dependency);
          boolean _hasDependency = EclipsePluginHelper.hasDependency(project, dependency);
          boolean _not = (!_hasDependency);
          if (_not) {
            EclipsePluginHelper.addDependency(project, dependency);
          }
        }
      }
    };
    acceptor.accept(issue, "Add all Vitruvius depdendencies.", "Add all Vitruvius depdendencies.", null, _function);
  }
}