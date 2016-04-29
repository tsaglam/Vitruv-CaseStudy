package edu.kit.ipd.sdq.vitruvius.codeintegration.scmchanges.extractors

import com.github.gumtreediff.actions.RootsClassifier
import com.github.gumtreediff.gen.jdt.JdtTreeGenerator
import com.github.gumtreediff.matchers.MappingStore
import com.github.gumtreediff.matchers.Matchers
import com.github.gumtreediff.tree.ITree
import com.github.gumtreediff.tree.TreeUtils
import edu.kit.ipd.sdq.vitruvius.codeintegration.scmchanges.converters.GumTree2JdtAstConverterImpl
import java.util.ArrayList
import java.util.Comparator
import java.util.HashSet
import java.util.List
import java.util.Random
import java.util.Set
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI

class GumTreeChangeExtractor implements IAtomicChangeExtractor {
	
	private Set<ITree> alreadyAdded;
	
	private MappingStore workingTreeMappings;

	private static final Logger logger = Logger.getLogger(typeof(GumTreeChangeExtractor))

	private String oldContent

	private String newContent

	private IContentValidator validator

	private URI fileUri

	private int validExtractions

	private int totalExtractions

	new(String oldContent, String newContent, URI fileUri) {
		this.oldContent = oldContent
		this.newContent = newContent
		this.fileUri = fileUri
		this.validator = null
		this.validExtractions = 0
		this.totalExtractions = 0
		logger.setLevel(Level.ALL)
	}

	override extract() {
		workingTreeMappings = new MappingStore
		alreadyAdded = new HashSet;
		val generator = new JdtTreeGenerator()
		val srcTreeContext = generator.generateFromString(oldContent)
		val dstTreeContext = generator.generateFromString(newContent)
		logger.info(" --- SOURCE TREE --- ")
		logger.info(srcTreeContext.root.toPrettyString(srcTreeContext))
		logger.info(" --- DESTINATION TREE --- ")
		logger.info(dstTreeContext.root.toPrettyString(dstTreeContext))

		val contentList = new ArrayList()
		val converter = new GumTree2JdtAstConverterImpl()

		contentList.add(converter.convertTree(srcTreeContext.root).toString)

		val m = Matchers.getInstance().getMatcher(srcTreeContext.root, dstTreeContext.root);
		m.match();
		val mappings = m.getMappings();

		val classifier = new RootsClassifier(srcTreeContext, dstTreeContext, m)

		processDels(classifier, srcTreeContext.root, mappings, contentList, converter)
		processAdds(classifier, srcTreeContext.root, mappings, contentList, converter, dstTreeContext.root)
		processUpds(classifier, srcTreeContext.root, mappings, contentList, converter)
		processMvs(classifier, srcTreeContext.root, mappings, contentList, converter)

		contentList.add(converter.convertTree(dstTreeContext.root).toString)

		totalExtractions = totalExtractions + contentList.size

		if (validator != null) {
			val toRemove = new HashSet<String>();
			for (contentString : contentList) {
				if (!validator.isValid(contentString, fileUri)) {
					toRemove.add(contentString)
				}
			}
			contentList.removeAll(toRemove)
		}

		validExtractions = validExtractions + contentList.size

		return contentList

	}

	private def processUpds(RootsClassifier classifier, ITree workingTree, MappingStore mappings,
		ArrayList<String> contentList, GumTree2JdtAstConverterImpl converter) {
		val rootUpds = getRootChanges(classifier.srcUpdTrees)
		for (updTree : rootUpds) {
			val nodeInDstTree = mappings.getDst(updTree)
			logger.info("Found UPD")
			val removed = removeNodeFromWorkingTree(updTree, mappings)
			val added = addNodeToWorkingTree(nodeInDstTree, mappings)
			if (added || removed) {
				contentList.add(converter.convertTree(workingTree).toString)
			} else {
				logger.info("Couldn't add or remove for UPD. Happens if changes were already covered by ADDs and DELs")
			}
		}
	}

	private def processMvs(RootsClassifier classifier, ITree workingTree, MappingStore mappings,
		ArrayList<String> contentList, GumTree2JdtAstConverterImpl converter) {
		val rootMvs = getRootChanges(classifier.srcMvTrees)
		for (mvTree : rootMvs) {
			val nodeInDstTree = mappings.getDst(mvTree)
			logger.info("Found MV")
			val removed = removeNodeFromWorkingTree(mvTree, mappings)
			val added = addNodeToWorkingTree(nodeInDstTree, mappings)
			if (removed || added) {
				contentList.add(converter.convertTree(workingTree).toString)
			} else {
				logger.info("Couldn't add or remove for MV. Happens if changes were already covered by ADDs and DELs")
			}
		}
	}

	private def processAdds(RootsClassifier classifier, ITree workingTree, MappingStore mappings,
		ArrayList<String> contentList, GumTree2JdtAstConverterImpl converter, ITree completeDst) {
		val rootAdds = getRootChanges(classifier.dstAddTrees)
		rootAdds.sort(new OrderbyBreadthFirstOrderingOfCompleteTree(completeDst))
		for (addTree : rootAdds) {
			logger.info("Found ADD")
			if (addNodeToWorkingTree(addTree, mappings)) {
				contentList.add(converter.convertTree(workingTree).toString)
			} else {
				logger.warn("Couldn't add node. How can this happen? FIXME")
			}
		}
	}

	private def processDels(RootsClassifier classifier, ITree workingTree, MappingStore mappings,
		ArrayList<String> contentList, GumTree2JdtAstConverterImpl converter) {
		val rootDels = getRootChanges(classifier.srcDelTrees)
		rootDels.sort(new OrderbyBreadthFirstOrderingOfCompleteTree(workingTree, true))
		for (delTree : rootDels) {
			logger.info("Found DEL")
			if (removeNodeFromWorkingTree(delTree, mappings)) {
				contentList.add(converter.convertTree(workingTree).toString)
			} else {
				logger.warn("Couldn't delete node. How can this happen? FIXME")
			}
		}
	}

	private def getRootChanges(Set<ITree> allChanges) {
		val rootChanges = new ArrayList<ITree>()
		// Make sure that only root changes are executed
		for (tree : allChanges) {
			if (!allChanges.contains(tree.parent)) {
				rootChanges.add(tree)
			}
		}
		return rootChanges
	}

	private def addNodeToWorkingTree(ITree addTree, MappingStore mappings) {
		if (alreadyAdded.contains(addTree)) {
			return false
		}
		val addCopy = addTree.deepCopy
		var dstParent = addTree.parent
		val srcParent = mappings.getSrc(dstParent)

		if (srcParent != null) {
			val children = srcParent.children
			var pos = addTree.positionInParent
			if (pos > children.size) {
				// Avoid out of bounds exception
				pos = children.size
			}
			children.add(pos, addCopy)
			// we'll try to figure out correct order by looking at dst order
			children.sort(new OrderByDstOrderComparator(dstParent, mappings, workingTreeMappings))
			srcParent.children = children
			alreadyAdded.add(addTree)
			
			// Link new working tree subtree to dst. Needed for correct ordering of children
			addWorkingTreeMapping(addCopy, addTree)
			return true

		} else {
			return false
		}

	}
	
	private def addWorkingTreeMapping(ITree addCopy, ITree addTree) {
		val newSrcSubTreeIterator = addCopy.breadthFirst.iterator;
		val dstTreeIterator = addTree.breadthFirst.iterator;
		while (newSrcSubTreeIterator.hasNext) {
			val nextNew = newSrcSubTreeIterator.next
			val nextDst = dstTreeIterator.next
			workingTreeMappings.link(nextNew, nextDst)
		}
	}

	private def removeNodeFromWorkingTree(ITree delTree, MappingStore mappings) {
		var srcParent = delTree.parent
		if (srcParent != null) {
			val children = srcParent.children
			if (children.contains(delTree)) {
				children.remove(delTree)
				srcParent.children = children
				return true
			}
		}
		return false
	}

	override setValidator(IContentValidator validator) {
		this.validator = validator
	}

	override getNumberOfTotalExtractions() {
		return totalExtractions;
	}

	override getNumberOfValidExtractions() {
		return validExtractions;
	}

}

class OrderbyBreadthFirstOrderingOfCompleteTree implements Comparator<ITree> {

	List<ITree> completeTreeOrderedByBreadthFirst;

	int factor

	new(ITree completeTree, boolean invert) {
		this.completeTreeOrderedByBreadthFirst = TreeUtils.breadthFirst(completeTree)
		this.factor = if(!invert) 1 else -1
	}

	new(ITree completeTree) {
		this.completeTreeOrderedByBreadthFirst = TreeUtils.breadthFirst(completeTree)
		this.factor = 1
	}

	override compare(ITree o1, ITree o2) {
		if (completeTreeOrderedByBreadthFirst.indexOf(o1) < completeTreeOrderedByBreadthFirst.indexOf(o2)) {
			return -1 * factor
		} else {
			return 1 * factor
		}
	}

}

/**
 * Used to sort children of a node by what the order looks like in the dst tree
 */
class OrderByDstOrderComparator implements Comparator<ITree> {

	private ITree dstParent
	private MappingStore mappings
	private MappingStore workingTreeMappings

	new(ITree dstParent, MappingStore mappings, MappingStore workingTreeMappings) {
		this.dstParent = dstParent
		this.mappings = mappings
		this.workingTreeMappings = workingTreeMappings
	}

	override compare(ITree o1, ITree o2) {
		var dst1 = null as ITree;
		var dst2 = null as ITree;
		if (dstParent.children.contains(o1)) {
			dst1 = o1
		} else {
			dst1 = mappings.getDst(o1)
			if (dst1 == null) {
				dst1 = workingTreeMappings.getDst(o1)
			}
		}
		if (dstParent.children.contains(o2)) {
			dst2 = o2
		} else {
			dst2 = mappings.getDst(o2)
			if (dst2 == null) {
				dst2 = workingTreeMappings.getDst(o2)
			}
		}
		if (dst1 == null || dst2 == null || dst1.parent != dst2.parent) {
			return 1
		}
		val pos1 = dst1.positionInParent
		val pos2 = dst2.positionInParent
		if (pos1 < pos2) {
			-1
		} else {
			1
		}
	}

}