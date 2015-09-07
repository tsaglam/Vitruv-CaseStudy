package edu.kit.ipd.sdq.vitruvius.integration.traversal.composite;

import org.eclipse.emf.common.util.BasicEList;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;

import de.uka.ipd.sdq.pcm.core.composition.AssemblyContext;
import de.uka.ipd.sdq.pcm.core.entity.ComposedProvidingRequiringEntity;
import de.uka.ipd.sdq.pcm.repository.CompositeComponent;
import de.uka.ipd.sdq.pcm.repository.Repository;
import de.uka.ipd.sdq.pcm.repository.RepositoryComponent;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Change;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.VURI;
import edu.kit.ipd.sdq.vitruvius.integration.traversal.ITraversalStrategy;

 
/**
 * This class traverses all composed PCM entities that derive from ComposedProvidingRequiringEntity
 * and are part of the repository package. (CompositeComponent, Subsystem)
 *
 * @author Sven Leonhardt
 *
 */

public class CompositeTraversalStrategy extends ComposedEntitiesTraversalStrategy implements
        ITraversalStrategy<Repository> {

    /*
     * (non-Javadoc)
     * 
     * @see
     * edu.kit.ipd.sdq.vitruvius.integration.traversal.ITraversalStrategy#traverse(org.eclipse.emf
     * .ecore.EObject, org.eclipse.emf.common.util.URI, org.eclipse.emf.common.util.EList)
     */
    @Override
    public EList<Change> traverse(final Repository entity, final URI uri, final EList<Change> existingChanges)
            throws UnsupportedOperationException {

        final Repository repository = entity;
        this.vuri = VURI.getInstance(uri);
        this.changeList = existingChanges;

        if (this.changeList == null || this.changeList.isEmpty()) {
            throw new UnsupportedOperationException(
                    "Changes for Composite Components must be placed upon changes for Repository Components");
        }

        final EList<ComposedProvidingRequiringEntity> compositeEntities = this.getComposedEntities(repository);

        // 1. find root-nodes
        final EList<ComposedProvidingRequiringEntity> rootEntities = this.getRootEntities(compositeEntities);

        // 2. recursively traverse root-nodes
        for (final ComposedProvidingRequiringEntity composedEntity : rootEntities) {
            this.traverseComposedEntity(composedEntity);
        }

        return this.changeList;

    }

    /**
     * Finds the top-level entities. Note that there can be more than one (multiple
     * CompositeComponents in a repository) We assume for system models there is only one top-level
     * system.
     *
     * @param compositeEntities
     *            : List of all composed entities
     * @return : root level entities
     */
    private EList<ComposedProvidingRequiringEntity> getRootEntities(
            final EList<ComposedProvidingRequiringEntity> compositeEntities) {

        final EList<ComposedProvidingRequiringEntity> rootEntities = compositeEntities;

        for (final ComposedProvidingRequiringEntity comp : compositeEntities) {
            final EList<AssemblyContext> contexts = comp.getAssemblyContexts__ComposedStructure();

            for (final AssemblyContext context : contexts) {

                final RepositoryComponent child = context.getEncapsulatedComponent__AssemblyContext();

                // if the child of a composed entity is itself a composed entity it cannot be a root
                // entity
                if (child instanceof ComposedProvidingRequiringEntity) {
                    rootEntities.remove(child);
                }
            }
        }

        return rootEntities;
    }

    /**
     * Finds all composed entities in a repository.
     *
     * @param repository
     *            : repository
     * @return : all composed entities
     */
    private EList<ComposedProvidingRequiringEntity> getComposedEntities(final Repository repository) {

        final EList<ComposedProvidingRequiringEntity> list = new BasicEList<ComposedProvidingRequiringEntity>();

        for (final RepositoryComponent comp : repository.getComponents__Repository()) {
            if (comp instanceof ComposedProvidingRequiringEntity) {
                list.add((CompositeComponent) comp);
            }
        }

        return list;
    }

}
