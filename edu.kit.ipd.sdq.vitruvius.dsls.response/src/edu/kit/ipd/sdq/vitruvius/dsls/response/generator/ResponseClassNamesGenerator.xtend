package edu.kit.ipd.sdq.vitruvius.dsls.response.generator

import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI
import edu.kit.ipd.sdq.vitruvius.framework.util.datatypes.Pair
import org.eclipse.emf.common.util.URI
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.Response
import static extension edu.kit.ipd.sdq.vitruvius.dsls.response.helper.ResponseLanguageHelper.*;
import edu.kit.ipd.sdq.vitruvius.dsls.response.helper.XtendImportHelper
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.Effect
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ExplicitEffect
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ImplicitEffect
import edu.kit.ipd.sdq.vitruvius.dsls.response.responseLanguage.ResponsesSegment

final class ResponseClassNamesGenerator {
	private static String BASIC_PACKAGE = "mir";
	private static val FSA_SEPARATOR = "/";
	private static val XTEND_FILE_EXTENSION = ".java";
	private static val RESPONSES_PACKAGE = "responses";
	private static String EFFECTS_PACKAGE = "effects";
	private static String EFFECTS_FACADE_CLASS_NAME = "EffectsFacade";
	
	private new() {}
	
	static def generateClass(String packageName, XtendImportHelper importHelper, CharSequence classImplementation) '''
		package «packageName»;
		
		«importHelper.generateImportCode»
		
		«classImplementation»
		'''

	public static def String getFilePath(String qualifiedClassName) '''
		«qualifiedClassName.replace('.', FSA_SEPARATOR)»«XTEND_FILE_EXTENSION»'''
		
	public static def String getBasicMirPackageQualifiedName() '''
		«BASIC_PACKAGE»'''
		
	public static def String getBasicResponsesPackageQualifiedName() '''
		«basicMirPackageQualifiedName».«RESPONSES_PACKAGE»'''
	
	public static def String getBasicEffectsPackageQualifiedName() '''
		«basicMirPackageQualifiedName».«EFFECTS_PACKAGE»'''	
	
	private static def String getMetamodelIdentifier(URI uri) {
		if (uri.lastSegment.nullOrEmpty) {
			return uri.toString.split("\\.").last.toFirstUpper;
		} else {
			return uri.lastSegment.replace(".", "_").toFirstUpper;
		}
	}
	
	private static def String getMetamodelIdentifier(VURI uri) {
		return uri.EMFUri.metamodelIdentifier;
	}
	
	private static def String getMetamodelPairName(Pair<VURI, VURI> metamodelPair) {
		return '''«metamodelPair.first.metamodelIdentifier»To«metamodelPair.second.metamodelIdentifier»'''	
	}
	
	private static def String getMetamodelPairName(ResponsesSegment responsesSegment) {
		return responsesSegment.sourceTargetPair.metamodelPairName;
	}
	
	private static def String getPackageName(ResponsesSegment responsesSegment) '''
		responses«responsesSegment.metamodelPairName»'''
		
	private static def String getQualifiedPackageName(ResponsesSegment responsesSegment) '''
		«basicResponsesPackageQualifiedName».«responsesSegment.packageName»'''
	
	public static def ClassNameGenerator getChange2CommandTransformingClassNameGenerator(Pair<VURI, VURI> metamodelPair) {
		return new Change2CommandTransformingClassNameGenerator(metamodelPair);
	}
	
	public static def ClassNameGenerator getExecutorClassNameGenerator(ResponsesSegment responsesSegment) {
		return new ExecutorClassNameGenerator(responsesSegment);
	}
	
	public static def ClassNameGenerator getEffectsFacadeClassNameGenerator(ResponsesSegment responsesSegment) {
		return new EffectsFacadeClassNameGenerator(responsesSegment);
	}
	
	public static def ClassNameGenerator getResponseClassNameGenerator(Response response) {
		return new ResponseClassNameGenerator(response);
	}
	
	public static def ClassNameGenerator getEffectClassNameGenerator(Effect effect) {
		return new EffectClassNameGenerator(effect);
	}
	
	public static abstract class ClassNameGenerator {
		public def String getQualifiedName() '''
			«packageName».«simpleName»'''
			
		public def String getSimpleName();
		public def String getPackageName();
	}
	
	private static class Change2CommandTransformingClassNameGenerator extends ClassNameGenerator {
		private val String metamodelPairName;
		
		public new(Pair<VURI, VURI> metamodelPair) {
			this.metamodelPairName = metamodelPair.metamodelPairName;
		}
		
		public override getSimpleName() '''
			AbstractChange2CommandTransforming«metamodelPairName»'''
		
		public override getPackageName() '''
			«basicResponsesPackageQualifiedName»'''	
	}	
	
	private static class ExecutorClassNameGenerator extends ClassNameGenerator {
		private val ResponsesSegment responsesSegment;
		
		public new(ResponsesSegment responsesSegment) {
			this.responsesSegment = responsesSegment;
		}
		
		public override getSimpleName() '''
			Executor«responsesSegment.metamodelPairName»'''
	
		public override getPackageName() '''
			«responsesSegment.qualifiedPackageName».«responsesSegment.name.toFirstLower»'''		
	}
	
	private static class ResponseClassNameGenerator extends ClassNameGenerator {
		private val Response response;
		public new(Response response) {
			this.response = response;
		}
		
		public override String getSimpleName() '''
			«response.name»Response'''
		
		public override String getPackageName() '''
			«response.responsesSegment.qualifiedPackageName».«response.responsesSegment.name.toFirstLower»'''		
	}
	
	private static class EffectClassNameGenerator extends ClassNameGenerator {
		private val Effect effect;
		public new(Effect effect) {
			this.effect = effect;
		}
		
		public override String getSimpleName() '''
			«effect.effectName»Effect'''
		
		private static def dispatch String getEffectName(ImplicitEffect effect) {
			return effect.containingResponse.name
		}
		
		private static def dispatch String getEffectName(ExplicitEffect effect) {
			return effect.name
		}
		
		public override String getPackageName() '''
			«basicEffectsPackageQualifiedName».«effect.responsesSegment.name.toFirstLower»'''
		
	}
	
	private static class EffectsFacadeClassNameGenerator extends ClassNameGenerator {
		private val ResponsesSegment responsesSegment;
		public new(ResponsesSegment responsesSegment) {
			this.responsesSegment = responsesSegment;
		}
		
		public override String getSimpleName() '''
			«EFFECTS_FACADE_CLASS_NAME»'''
		
		public override String getPackageName() '''
			«basicEffectsPackageQualifiedName».«responsesSegment.name.toFirstLower»'''		
	}
}