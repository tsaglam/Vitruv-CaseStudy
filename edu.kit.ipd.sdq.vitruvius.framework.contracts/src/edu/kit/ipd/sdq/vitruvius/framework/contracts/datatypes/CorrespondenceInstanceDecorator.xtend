package edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes

import java.util.Map
import java.util.Set
import edu.kit.ipd.sdq.vitruvius.framework.contracts.internal.InternalCorrespondenceInstance

interface CorrespondenceInstanceDecorator extends InternalCorrespondenceInstance {
	/** 
	 * Returns a mutable map from prefixes for the file extension to objects that should be saved in
	 * a file with this extension and the original name of the decorated correspondence instance in
	 * order to persist decorator information.
	 * @return
	 */
	def // TODO MK (deco): Serializable instead of Object?
	Map<String, Object> getFileExtPrefix2ObjectMapForSave()

	/** 
	 * Returns a mutable set of prefixes for file names for which a file should be loaded to obtain
	 * objects that persist decorator information.
	 * @return
	 */
	def Set<String> getFileExtPrefixesForObjectsToLoad()

	/** 
	 * Initializes the decorator using the decorator information in the given objects that pertain
	 * to a file with the given file extension prefix.
	 * @param fileExtPrefix2ObjectMap
	 */
	def void initialize(Map<String, Object> fileExtPrefix2ObjectMap)

	def <T extends CorrespondenceInstanceDecorator> T getFirstCorrespondenceInstanceDecoratorOfTypeInChain(
		Class<T> type)

}