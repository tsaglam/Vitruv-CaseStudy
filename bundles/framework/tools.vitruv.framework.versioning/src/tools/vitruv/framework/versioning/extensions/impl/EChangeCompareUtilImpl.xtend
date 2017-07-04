package tools.vitruv.framework.versioning.extensions.impl

import java.util.Set
import org.eclipse.emf.ecore.InternalEObject
import org.eclipse.emf.ecore.util.EcoreUtil
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.compound.impl.CreateAndInsertNonRootImpl
import tools.vitruv.framework.change.echange.compound.impl.CreateAndReplaceNonRootImpl
import tools.vitruv.framework.change.echange.feature.attribute.impl.ReplaceSingleValuedEAttributeImpl
import tools.vitruv.framework.versioning.extensions.EChangeCompareUtil

class EChangeCompareUtilImpl implements EChangeCompareUtil {

	static val Set<Pair<String, String>> rootToRootMap = newHashSet

	static def EChangeCompareUtil init() {
		new EChangeCompareUtilImpl
	}

	private new() {
	}

	override addPair(Pair<String, String> pair) {
		rootToRootMap += pair
	}

	override isEChangeEqual(EChange e1, EChange e2) {
		compareEchange(e1, e2)
	}

	private dispatch def boolean compareEchange(EChange e1, EChange e2) {
		false
	}

	private static def Boolean containerIsRootAndMapped(String containerString, InternalEObject affectedContainer2) {
		rootToRootMap.filter [
			val x = containerString.contains(key) || containerString.contains(value)
			return x
		].map[
			val x = if (containerString.contains(key)) it else new Pair(value, key)
			return x
		].map [
			val affectedContainerPlatformString2 = affectedContainer2.eProxyURI.toPlatformString(false)
			if (!affectedContainerPlatformString2.contains(value))
				throw new IllegalStateException('''No lying under root''')
			val s = affectedContainerPlatformString2.replace(value, key)
			val x = containerString == s
			return x
		].fold(false, [current, next|(current || next)])
	}

	private dispatch def boolean compareEchange(ReplaceSingleValuedEAttributeImpl<?, ?> e1,
		ReplaceSingleValuedEAttributeImpl<?, ?> e2) {
		val affectedObjectIsEqual = EcoreUtil::equals(e1.affectedEObject, e2.affectedEObject)
		val affectedFeatureIsEqual = EcoreUtil::equals(e1.affectedFeature, e2.affectedFeature)
		val newValueIsEqual = e1.newValue == e2.newValue
		val affectedContainer1 = e1.affectedEObject as InternalEObject
		val affectedContainerPlatformString1 = affectedContainer1.eProxyURI.toPlatformString(false)
		val containerIsRootAndMapped = containerIsRootAndMapped(affectedContainerPlatformString1,
			e2.affectedEObject as InternalEObject)
		return (affectedObjectIsEqual || containerIsRootAndMapped) && affectedFeatureIsEqual && newValueIsEqual
	}

	private dispatch def boolean compareEchange(CreateAndReplaceNonRootImpl<?, ?> e1,
		CreateAndReplaceNonRootImpl<?, ?> e2) {
		val createdObjectIsEqual = EcoreUtil::equals(e1.createChange.affectedEObject, e2.createChange.affectedEObject)
		val containerIsEqual = EcoreUtil::equals(e1.insertChange.affectedEObject, e2.insertChange.affectedEObject)
		val affectedContainer1 = e1.insertChange.affectedEObject as InternalEObject
		val affectedContainerPlatformString1 = affectedContainer1.eProxyURI.toPlatformString(false)
		var containerIsRootAndMapped = containerIsRootAndMapped(affectedContainerPlatformString1,
			e2.insertChange.affectedEObject as InternalEObject)
		val newValueIsEqual = EcoreUtil::equals(e1.insertChange.newValue, e2.insertChange.newValue)
		return createdObjectIsEqual && (containerIsEqual || containerIsRootAndMapped) && newValueIsEqual
	}

	private dispatch def boolean compareEchange(CreateAndInsertNonRootImpl<?, ?> e1,
		CreateAndInsertNonRootImpl<?, ?> e2) {
		val createdObjectIsEqual = EcoreUtil::equals(e1.createChange.affectedEObject, e2.createChange.affectedEObject)
		val containerIsEqual = EcoreUtil::equals(e1.insertChange.affectedEObject, e2.insertChange.affectedEObject)
		val affectedContainer1 = e1.insertChange.affectedEObject as InternalEObject
		val affectedContainerPlatformString1 = affectedContainer1.eProxyURI.toPlatformString(false)
		var containerIsRootAndMapped = containerIsRootAndMapped(affectedContainerPlatformString1,
			e2.insertChange.affectedEObject as InternalEObject)
		val newValueIsEqual = EcoreUtil::equals(e1.insertChange.newValue, e2.insertChange.newValue)
		return createdObjectIsEqual && (containerIsEqual || containerIsRootAndMapped) && newValueIsEqual
	}

}
