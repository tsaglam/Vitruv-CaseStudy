package edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.VitruviusConstants;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.util.datatypes.ForwardHashedBackwardLinkedTree;

/**
 * Implements the multiton design pattern.
 * 
 * @author kramerm
 * 
 */
public class TUID {
    private static final ForwardHashedBackwardLinkedTree<String> SEGMENTS = new ForwardHashedBackwardLinkedTree<String>();
    private static final Map<ForwardHashedBackwardLinkedTree<String>.Segment, TUID> LAST_SEGMENT_2_TUID_INSTANCES_MAP = new HashMap<ForwardHashedBackwardLinkedTree<String>.Segment, TUID>();

    private ForwardHashedBackwardLinkedTree<String>.Segment lastSegment;

    /** Multiton classes should not have a public or default constructor. */
    private TUID(final List<String> splitTUIDString) {
        this.lastSegment = SEGMENTS.addNewSegmentsWhereNecessary(splitTUIDString);
    }

    public static synchronized TUID getInstance(final String tuidString) {
        return getInstance(tuidString, false);
    }

    private static TUID getInstance(final String tuidString, final boolean recursively) {
        if (tuidString == null) {
            throw new RuntimeException("The null string is no TUID!");
        } else {
            List<String> splitTUIDString = split(tuidString);
            ForwardHashedBackwardLinkedTree<String>.Segment lastSegmentOrPrefix = SEGMENTS
                    .getMaximalPrefix(splitTUIDString);
            TUID instance;
            if (lastSegmentOrPrefix != null
                    && lastSegmentOrPrefix.toString(VitruviusConstants.getTUIDSegmentSeperator()).equals(tuidString)) {
                // the complete specified tuidString was already mapped
                instance = LAST_SEGMENT_2_TUID_INSTANCES_MAP.get(lastSegmentOrPrefix);
                if (instance == null) {
                    if (!recursively) {
                        throw new RuntimeException("A TUID instance for the last segment '" + lastSegmentOrPrefix
                                + "' should already have been mapped for the tuidString '" + tuidString + "'!");
                    }
                } else {
                    return instance;
                }
            } // a real prefix of the specified tuidString or nothing was already mapped (but not
              // the complete tuidString)
            instance = new TUID(splitTUIDString);
            lastSegmentOrPrefix = instance.getLastSegment();
            LAST_SEGMENT_2_TUID_INSTANCES_MAP.put(lastSegmentOrPrefix, instance);
            // also create TUIDs for all prefixes of the specified tuidString and register them
            Iterator<ForwardHashedBackwardLinkedTree<String>.Segment> segmentIterator = lastSegmentOrPrefix.iterator();
            ForwardHashedBackwardLinkedTree<String>.Segment pivot;
            while (segmentIterator.hasNext()) {
                pivot = segmentIterator.next();
                TUID subInstance = getInstance(pivot.toString(VitruviusConstants.getTUIDSegmentSeperator()), true);
                LAST_SEGMENT_2_TUID_INSTANCES_MAP.put(subInstance.getLastSegment(), subInstance);
            }
            return instance;
        }
    }

    private static List<String> split(final String tuidString) {
        String seperator = VitruviusConstants.getTUIDSegmentSeperator();
        // TODO replace this possibly ArrayList with a LinkList if performance is not sufficient
        return Arrays.asList(tuidString.split(seperator));
    }

    protected ForwardHashedBackwardLinkedTree<String>.Segment getLastSegment() {
        return this.lastSegment;
    }

    // If a package is renamed in Java, then only the paths of all contained classifiers are
    // affected. The paths of subpackages are not affected but they are no longer subpackages.
    // If a package is renamed in Java, then the depth of its path may change arbitrarily.
    //
    // If a folder is renamed, then the paths of all contained elements are affected but the depth
    // may not change.
    //
    // If a package is moved in Java, then it may only be completely moved to another folder and
    // subpackages are not affected. It is not possible to move subpackages to another package. It
    // is however possible to move a package to a folder in which the package or a subpackage is
    // already existing, then the packages are merged.
    //
    // If a folder is moved, then the paths of all contained elements are affected and the depth may
    // change. If the destination folder already exists the containing elements of both folders are
    // merged.

    public void renameLastSegment(final String newLastSegmentString) {
        SEGMENTS.changeSegmentValue(this.lastSegment, newLastSegmentString);
    }

    @Override
    public String toString() {
        return this.lastSegment.toString(VitruviusConstants.getTUIDSegmentSeperator());
    }
}
