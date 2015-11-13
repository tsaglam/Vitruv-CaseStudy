package edu.kit.ipd.sdq.vitruvius.dsls.mapping.helpers

import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.ConstraintBlock
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.ContextVariable
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.FeatureOfContextVariable
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.Mapping
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.MappingFile
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.NamedEClass
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.RequiredMappingPathBase
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.RequiredMappingPathTail
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.Signature
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage

import static extension edu.kit.ipd.sdq.vitruvius.dsls.mapping.helpers.EMFHelper.*
import static extension edu.kit.ipd.sdq.vitruvius.framework.mir.executor.helpers.JavaHelper.*
import static extension java.util.Objects.*
import edu.kit.ipd.sdq.vitruvius.dsls.mapping.mappingLanguage.RequiredMapping
import java.util.List

class MappingLanguageHelper {
	public static def getSignatures(Mapping mapping) {
		return #[mapping.signature0, mapping.signature1].filterNull
	}
	
	public static def getConstraintBlocks(Mapping mapping) {
		return #[mapping.constraints0, mapping.constraints1].filterNull
	}
	
	public static def <T> claimExactlyOneInPackage(Iterable<T> elements, EPackage pkg) {
		elements.filterWithPackage(pkg).claimIdenticalElements
	}
	
	public static def <T> filterWithPackage(Iterable<T> elements, EPackage pkg) {
		elements.filter[getPackage.equals(pkg)]
	} 
	
	public static def dispatch EPackage getPackage(Object obj) {
		throw new UnsupportedOperationException("Unknown type for package resolution: " + obj.class.name)
	}
	
	public static def dispatch EPackage getPackage(NamedEClass namedEClass) {
		namedEClass.type.EPackage
	}
	
	public static def dispatch EPackage getPackage(FeatureOfContextVariable feat) {
		getPackage(feat.context.targetClass)
	}
	
	public static def dispatch EPackage getPackage(Signature signature) {
		signature.elements.map[type.EPackage].claimIdenticalElements
	}
	
	public static def dispatch EPackage getPackage(ConstraintBlock constraintBlock) {
		constraintBlock.eAllContents.filter(ContextVariable).map[targetClass.type.EPackage].claimIdenticalElements
	}
	
	public static def getImport(EObject eObject) {
		val imports = eObject.getContainerOfType(MappingFile).requireNonNull.imports
		val index = imports.map[package].indexOf(eObject.getPackage).claim [
			it != -1
		]
		return imports.get(index)
	}
	
	
	
	public static def RequiredMapping getLastMapping(RequiredMappingPathBase mappingPath) {
		if (mappingPath.tail != null)
			return mappingPath.tail.lastMapping
		else
			return mappingPath.requiredMapping
	}
	
	public static def RequiredMapping getLastMapping(RequiredMappingPathTail mappingPath) {
		if (mappingPath.tail != null)
			return mappingPath.tail.lastMapping
		else
			return mappingPath.requiredMapping
	}
	
	public static def List<RequiredMapping> collectRecursive(RequiredMappingPathBase mappingPath) {
		(#[mappingPath.requiredMapping] + (mappingPath.tail?.collectRecursive ?: #[])).toList
	}
	
	public static def List<RequiredMapping> collectRecursive(RequiredMappingPathTail mappingPath) {
		(#[mappingPath.requiredMapping] + (mappingPath.tail?.collectRecursive ?: #[])).toList
	}
}