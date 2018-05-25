package tools.vitruv.domains.emf.monitorededitor.monitor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorPart;

import tools.vitruv.domains.emf.monitorededitor.EditorNotMonitorableException;
import tools.vitruv.domains.emf.monitorededitor.IEditorPartAdapterFactory;
import tools.vitruv.domains.emf.monitorededitor.IEditorPartAdapterFactory.IEditorPartAdapter;
import tools.vitruv.domains.emf.monitorededitor.IMonitoringDecider;
import tools.vitruv.domains.emf.monitorededitor.ISynchronizingMonitoredEmfEditor;
import tools.vitruv.domains.emf.monitorededitor.ISynchronizingMonitoredEmfEditor.IEditorStateListener.EditorStateChange;
import tools.vitruv.domains.emf.monitorededitor.tools.EclipseAdapterProvider;
import tools.vitruv.domains.emf.monitorededitor.tools.EditorManagementListenerMgr;
import tools.vitruv.domains.emf.monitorededitor.tools.IEclipseAdapter;
import tools.vitruv.domains.emf.monitorededitor.tools.IEditorManagementListener;
import tools.vitruv.extensions.delta.modul.DeltaModulGenerator;
import tools.vitruv.framework.change.description.TransactionalChange;
import tools.vitruv.framework.change.description.VitruviusChange;
import tools.vitruv.framework.util.datatypes.VURI;
import tools.vitruv.framework.vsum.VirtualModel;

/**
 * TODO NK Code copy of SynchronizingMonitoredEMFEditorImpl only setupMonitorForEditor(final
 * IEditorPartAdapter editorPart) method is different
 * 
 * @author Nico Kopp
 *
 */
public class DeltaModulSynchronizingMonitoredEmfEditorImpl implements ISynchronizingMonitoredEmfEditor {

    public DeltaModulSynchronizingMonitoredEmfEditorImpl(final VirtualModel virtualModel,
            final ResourceChangeSynchronizing changeSynchronizing,
            final IEditorPartAdapterFactory editorPartAdapterFact, final IMonitoringDecider monitoringDecider) {
        this.virtualModel = virtualModel;
        this.changeSynchronizing = changeSynchronizing;
        this.editorPartAdapterFact = editorPartAdapterFact;
        this.monitoringDecider = monitoringDecider;
        this.editors = new HashMap<>();
        editorCreationListener = new IEditorManagementListener() {
            @Override
            public void onCreated(IEditorPart editorPart) {
                LOGGER.trace("Detected editor open: " + editorPart);
                enableMonitorForEditorIfApplicable(editorPart);
            }

            @Override
            public void onClosed(IEditorPart editorPart) {
                LOGGER.trace("Detected editor close: " + editorPart);
                disableMonitoring(editorPart);
            }
        };
    }

    /** The logger for {@link SynchronizingMonitoredEmfEditorImpl} instances. */
    private static final Logger LOGGER = Logger.getLogger(SynchronizingMonitoredEmfEditorImpl.class);

    /**
     * The editor part adapter factory used to access Eclipse {@link IEditorPart}s. All editors for
     * which such an adapter can be created at editor creation time or during the call to
     * <code>initialize()</code> are automatically monitored after initialization.
     */
    private final IEditorPartAdapterFactory editorPartAdapterFact;

    /** This object determines whether an adaptable IEditorPart is monitored. */
    private final IMonitoringDecider monitoringDecider;

    /**
     * A {@link ResourceChangeSynchronizing} instance whose synchronization method gets called whenever
     * the user saves a monitored EMF/GMF editor.
     */
    private final ResourceChangeSynchronizing changeSynchronizing;

    /**
     * A map associating monitored Eclipse editors with their respective
     * {@link EMFModelChangeRecordingEditorSaveListener} objects.
     */
    private final Map<IEditorPart, EMFModelChangeRecordingEditorSaveListener> editors;

    /**
     * A listener monitoring Eclipse for editor creations and removals.
     */
    private final IEditorManagementListener editorCreationListener;

    private final EditorManagementListenerMgr editorManagementListenerMgr = new EditorManagementListenerMgr();

    private final Set<IEditorStateListener> editorStateListeners = new HashSet<>();

    /**
     * The {@link IEclipseAdapter} used to access Eclipse.
     */
    private final IEclipseAdapter eclipseAdapter = EclipseAdapterProvider.getInstance().getEclipseAdapter();

    private final VirtualModel virtualModel;

    @Override
    public void initialize() {
        LOGGER.trace("Installing myself in all accessible currently active editors");
        for (IEditorPart editor : eclipseAdapter.getCurrentlyActiveEditors()) {
            enableMonitorForEditorIfApplicable(editor);
        }

        LOGGER.trace("Initializing the editor creation monitor");
        editorManagementListenerMgr.initialize();
        editorManagementListenerMgr.addEditorManagementListener(editorCreationListener);
    }

    private void enableMonitorForEditorIfApplicable(final IEditorPart editorPart) {
        try {
            enableMonitoring(editorPart);
        } catch (EditorNotMonitorableException e) {
            LOGGER.trace(
                    "Not installing a listener for an editor of class " + editorPart.getClass().getCanonicalName());
        }
    }

    @Override
    public void enableMonitoring(final IEditorPart editorPart) {
        // If no such adapter can be created, a runtime exception is thrown by
        // createAdapter(), so no further checking needs to be done here.
        IEditorPartAdapter editorPartAdapter = editorPartAdapterFact.createAdapter(editorPart);
        if (monitoringDecider.isMonitoringEnabled(editorPartAdapter)) {
            LOGGER.debug(
                    "Installing an EMF monitor for an editor of class " + editorPart.getClass().getCanonicalName());
            setupMonitorForEditor(editorPartAdapter);
        } else {
            throw new EditorNotMonitorableException();
        }
    }

    private void addEditor(IEditorPart editorPart, EMFModelChangeRecordingEditorSaveListener listener) {
        LOGGER.debug("Adding editor part " + editorPart + " to set of monitored editors.");
        editors.put(editorPart, listener);
    }

    private void setupMonitorForEditor(final IEditorPartAdapter editorPart) {
        EMFModelChangeRecordingEditorSaveListener listener = new EMFModelChangeRecordingEditorSaveListener(editorPart) {
            @Override
            protected void onSavedResource(final List<TransactionalChange> changeDescriptions) {
                FileDialog fd = new FileDialog(new Shell(), SWT.SAVE);
                fd.setFilterExtensions(new String[] { "*.delta" });
                fd.setFilterPath(ResourcesPlugin.getWorkspace().getRoot().getLocation().toPortableString());
                String name = fd.open();
                if (name != null) {
                    LOGGER.trace("Received change descriptions " + changeDescriptions);
                    if (null == changeDescriptions || changeDescriptions.isEmpty()) {
                        LOGGER.trace("changeDescription is null. Change can not be synchronized: " + this);
                        return;
                    }
                    new DeltaModulGenerator(changeDescriptions, virtualModel.getUuidGeneratorAndResolver(), name);
                    // use recorded changeDescription because create+insert and remove+delete changes are applied
                    // together
                    triggerSynchronization(new ArrayList<VitruviusChange>(changeDescriptions),
                            editorPart.getEditedModelResource());
                } else {
                    LOGGER.trace("Received change descriptions " + changeDescriptions);
                    if (null == changeDescriptions || changeDescriptions.isEmpty()) {
                        LOGGER.trace("changeDescription is null. Change can not be synchronized: " + this);
                        return;
                    }
                    triggerSynchronization(new ArrayList<VitruviusChange>(changeDescriptions),
                            editorPart.getEditedModelResource());
                }
            }

            // private List<TransactionalChange> createDeltaModul(List<TransactionalChange> changeDescriptions)
            // {
            // List<EChange> echanges = new ArrayList<EChange>();
            // for (TransactionalChange c : changeDescriptions) {
            // for (EChange ec : c.getEChanges()) {
            // if (ec != null) {
            // echanges.add(ec);
            // }
            // }
            // }
            // Collections.sort(echanges, new EChangeComparator());
            // List<TransactionalChange> result = new ArrayList<TransactionalChange>();
            // final VitruviusChangeFactory changeFactory = VitruviusChangeFactory.getInstance();
            // CompositeTransactionalChange compositeTransactionalChange = changeFactory
            // .createCompositeTransactionalChange();
            // Map<String, EObjectSubstitution> substitutions = new HashMap<String, EObjectSubstitution>();
            // Set<String> important = new HashSet<String>();
            // for (EChange c : echanges) {
            // placeholderSwitch(c, substitutions, important); // Method needs a Name
            // compositeTransactionalChange.addChange(changeFactory.createConcreteApplicableChange(c));
            // }
            // result.add(compositeTransactionalChange);
            // String lines = testString(echanges, substitutions, important);
            // File file = new
            // File("C:\\Users\\nkopp\\runtime-EclipseApplication\\MyProject\\deltas\\d1.delta");
            // try {
            // // Whatever the file path is.
            // new File("C:\\Users\\nkopp\\runtime-EclipseApplication\\MyProject\\deltas").mkdirs();
            // if (!file.exists()) {
            // file.createNewFile();
            // }
            // FileOutputStream is = new FileOutputStream(file);
            // OutputStreamWriter osw = new OutputStreamWriter(is);
            // Writer w = new BufferedWriter(osw);
            // w.write(lines);
            // w.close();
            // } catch (IOException e) {
            // System.err.println("Problem writing to the file statsTest.txt");
            // }
            //
            // System.out.println(lines);
            // System.out.println(file.getAbsolutePath());
            // return result;
            // }
            //
            // private String testString(List<EChange> echanges, Map<String, EObjectSubstitution> substitutions,
            // Set<String> important) {
            // StringBuilder result = new StringBuilder();
            // result.append("DELTAMODUL d1 \n");
            // Iterator<String> iter = important.iterator();
            // if (iter.hasNext()) {
            // result.append("REQUIRED OBJECTS:\n ");
            // }
            // while (iter.hasNext()) {
            // result.append(iter.next());
            // if (iter.hasNext()) {
            // result.append(", ");
            // } else {
            // result.append(";\n");
            // }
            // }
            // result.append("CHANGES:\n");
            // for (EChange change : echanges) {
            // result.append(" ");
            // if (change instanceof CreateEObject<?>) {
            // result.append("CREATE " + ((CreateEObject<?>) change).getAffectedEObjectID() + " OF TYPE "
            // + ((CreateEObject<?>) change).getAffectedEObjectType().getName() + ";\n");
            // } else if (change instanceof DeleteEObject<?>) {
            // result.append("DELETE " + ((DeleteEObject<?>) change).getAffectedEObjectID() + ";\n");
            // } else if (change instanceof ReplaceSingleValuedEAttribute<?, ?>) {
            // ReplaceSingleValuedEAttribute<?, ?> c = (ReplaceSingleValuedEAttribute<?, ?>) change;
            // result.append("REPLACE ");
            // result.append("OLD_VALUE ");
            // result.append(c.getOldValue());
            // result.append(" OF ATTRIBUT ");
            // result.append(c.getAffectedFeature().getName() + " OF OBJECT ");
            // if (substitutions.containsKey(c.getAffectedEObjectID())) {
            // result.append(substitutions.get(c.getAffectedEObjectID()).toString());
            // } else {
            // result.append(c.getAffectedEObjectID());
            // }
            // result.append(" WITH VALUE ");
            // result.append(c.getNewValue());
            //
            // result.append(";\n");
            // } else if (change instanceof InsertEAttributeValue<?, ?>) {
            // InsertEAttributeValue<?, ?> c = (InsertEAttributeValue<?, ?>) change;
            // result.append("INSERT VALUE ");
            // result.append(c.getNewValue());
            // result.append(" IN ATTRIBUT " + c.getAffectedFeature().getName() + " OF OBJECT ");
            // if (substitutions.containsKey(c.getAffectedEObjectID())) {
            // result.append(substitutions.get(c.getAffectedEObjectID()).toString());
            // } else {
            // result.append(c.getAffectedEObjectID());
            // }
            // result.append(";\n");
            // } else if (change instanceof RemoveEAttributeValue<?, ?>) {
            // RemoveEAttributeValue<?, ?> c = (RemoveEAttributeValue<?, ?>) change;
            // result.append("REMOVE VALUE ");
            // result.append(c.getOldValue());
            // result.append(" FROM Attribut " + c.getAffectedFeature().getName() + " OF OBJECT ");
            // if (substitutions.containsKey(c.getAffectedEObjectID())) {
            // result.append(substitutions.get(c.getAffectedEObjectID()).toString());
            // } else {
            // result.append(c.getAffectedEObjectID());
            // }
            // result.append(";\n");
            // } else if (change instanceof ReplaceSingleValuedEReference<?, ?>) {
            // ReplaceSingleValuedEReference<?, ?> c = (ReplaceSingleValuedEReference<?, ?>) change;
            // result.append("REPLACE ");
            // result.append("OLD_REFERENCE ");
            // if (substitutions.containsKey(c.getOldValueID())) {
            // result.append(substitutions.get(c.getOldValueID()).toString());
            // } else {
            // result.append(c.getOldValueID());
            // }
            // result.append(" FROM FEATURE " + c.getAffectedFeature().getName() + " OF OBJECT ");
            // if (substitutions.containsKey(c.getAffectedEObjectID())) {
            // result.append(substitutions.get(c.getAffectedEObjectID()).toString());
            // } else {
            // result.append(c.getAffectedEObjectID());
            // }
            // result.append(" WITH REFERENCE ");
            // if (substitutions.containsKey(c.getNewValueID())) {
            // result.append(substitutions.get(c.getNewValueID()).toString());
            // } else {
            // result.append(c.getNewValueID());
            // }
            //
            // result.append(";\n");
            // } else if (change instanceof InsertEReference<?, ?>) {
            // InsertEReference<?, ?> c = (InsertEReference<?, ?>) change;
            // result.append("INSERT REFERENCE ");
            // if (substitutions.containsKey(c.getNewValueID())) {
            // result.append(substitutions.get(c.getNewValueID()).toString());
            // } else {
            // result.append(c.getNewValueID());
            // }
            // result.append(" IN FEATURE " + c.getAffectedFeature().getName() + " OF OBJECT ");
            // if (substitutions.containsKey(c.getAffectedEObjectID())) {
            // result.append(substitutions.get(c.getAffectedEObjectID()).toString());
            // } else {
            // result.append(c.getAffectedEObjectID());
            // }
            // result.append(";\n");
            // } else if (change instanceof RemoveEReference<?, ?>) {
            // RemoveEReference<?, ?> c = (RemoveEReference<?, ?>) change;
            // result.append("REMOVE REFERENCE ");
            // if (substitutions.containsKey(c.getOldValueID())) {
            // result.append(substitutions.get(c.getOldValueID()).toString());
            // } else {
            // result.append(c.getOldValueID());
            // }
            // result.append(" FROM FEATURE " + c.getAffectedFeature().getName() + " OF OBJECT ");
            // if (substitutions.containsKey(c.getAffectedEObjectID())) {
            // result.append(substitutions.get(c.getAffectedEObjectID()).toString());
            // } else {
            // result.append(c.getAffectedEObjectID());
            // }
            // result.append(";\n");
            // } else if (change instanceof RootEChange) {
            // result.append("ROOTCHANGE;\n");
            // } else {
            // throw new IllegalStateException("Unknown EChange type: " + change.getClass());
            // }
            //
            // }
            // return result.toString();
            // }
            //
            // private void placeholderSwitch(EChange change, Map<String, EObjectSubstitution> substitutions,
            // Set<String> important) {
            // if (change instanceof CreateEObject<?>) {
            // placeholder((CreateEObject<?>) change, substitutions, important);
            // } else if (change instanceof DeleteEObject<?>) {
            // placeholder((DeleteEObject<?>) change, substitutions, important);
            // } else if (change instanceof ReplaceSingleValuedEAttribute<?, ?>) {
            // placeholder((ReplaceSingleValuedEAttribute<?, ?>) change, substitutions, important);
            // } else if (change instanceof InsertEAttributeValue<?, ?>) {
            // placeholder((InsertEAttributeValue<?, ?>) change, substitutions, important);
            // } else if (change instanceof RemoveEAttributeValue<?, ?>) {
            // placeholder((RemoveEAttributeValue<?, ?>) change, substitutions, important);
            // } else if (change instanceof ReplaceSingleValuedEReference<?, ?>) {
            // placeholder((ReplaceSingleValuedEReference<?, ?>) change, substitutions, important);
            // } else if (change instanceof InsertEReference<?, ?>) {
            // placeholder((InsertEReference<?, ?>) change, substitutions, important);
            // } else if (change instanceof RemoveEReference<?, ?>) {
            // placeholder((RemoveEReference<?, ?>) change, substitutions, important);
            // } else if (change instanceof RootEChange) {
            // placeholder((RootEChange) change, substitutions, important);
            // } else {
            // throw new IllegalStateException("Unknown EChange type: " + change.getClass());
            // }
            //
            // }
            //
            // private void placeholder(CreateEObject<?> change, Map<String, EObjectSubstitution> substitutions,
            // Set<String> important) {
            // important.add(change.getAffectedEObjectID());
            //
            // }
            //
            // private void placeholder(DeleteEObject<?> change, Map<String, EObjectSubstitution> substitutions,
            // Set<String> important) {
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            // }
            //
            // private void placeholder(ReplaceSingleValuedEAttribute<?, ?> change,
            // Map<String, EObjectSubstitution> substitutions, Set<String> important) {
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            //
            // }
            //
            // private void placeholder(InsertEAttributeValue<?, ?> change, Map<String, EObjectSubstitution>
            // substitutions,
            // Set<String> important) {
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            // }
            //
            // private void placeholder(RemoveEAttributeValue<?, ?> change, Map<String, EObjectSubstitution>
            // substitutions,
            // Set<String> important) {
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            // }
            //
            // private void placeholder(ReplaceSingleValuedEReference<?, ?> change,
            // Map<String, EObjectSubstitution> substitutions, Set<String> important) {
            // String oldValue = change.getOldValueID();
            // if (oldValue != null && !important.contains(oldValue) && !substitutions.containsKey(oldValue)) {
            // EObjectSubstitution sub;
            // String featureName = change.getAffectedFeature().getName();
            // if (substitutions.containsKey(change.getAffectedEObjectID())) {
            // sub = new EObjectSubstitution(substitutions.get(change.getAffectedEObjectID()).toString(),
            // featureName);
            // substitutions.put(oldValue, sub);
            //
            // } else {
            // sub = new EObjectSubstitution(change.getAffectedEObjectID(), featureName);
            // substitutions.put(oldValue, sub);
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            // }
            // // tempImportant.remove(oldValue);
            // }
            //
            // // String newValue = change.getNewValueID();
            // // if (newValue != null && !substitutions.containsKey(newValue)) {
            // // tempImportant.add(change.getAffectedEObjectID());
            // // String featureName = change.getAffectedFeature().getName();
            // // EObjectSubstitution sub = new EObjectSubstitution(change.getAffectedEObjectID(), featureName);
            // // substitutions.put(newValue, sub);
            // // }
            //
            // }
            //
            // private void placeholder(InsertEReference<?, ?> change, Map<String, EObjectSubstitution>
            // substitutions,
            // Set<String> important) {
            // // String newValue = change.getNewValueID();
            // // if (newValue != null && !substitutions.containsKey(newValue)) {
            // // tempImportant.add(change.getAffectedEObjectID());
            // // String featureName = change.getAffectedFeature().getName();
            // // EObjectSubstitution sub = new EObjectSubstitution(change.getAffectedEObjectID(), featureName);
            // // substitutions.put(newValue, sub);
            // // }
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            // if (!substitutions.containsKey(change.getNewValueID())) {
            // important.add(change.getNewValueID());
            // }
            //
            // }
            //
            // private void placeholder(RemoveEReference<?, ?> change, Map<String, EObjectSubstitution>
            // substitutions,
            // Set<String> important) {
            // // String oldValue = change.getOldValueID();
            // // if (oldValue != null && !important.contains(oldValue) && !substitutions.containsKey(oldValue))
            // {
            // // EObjectSubstitution sub;
            // // String featureName = change.getAffectedFeature().getName();
            // // if (substitutions.containsKey(change.getAffectedEObjectID())) {
            // // sub = new EObjectSubstitution(substitutions.get(change.getAffectedEObjectID()).toString(),
            // // featureName);
            // // substitutions.put(oldValue, sub);
            // // } else {
            // // sub = new EObjectSubstitution(change.getAffectedEObjectID(), featureName);
            // // substitutions.put(oldValue, sub);
            // // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // // important.add(change.getAffectedEObjectID());
            // // }
            // // }
            // // }
            // if (!substitutions.containsKey(change.getAffectedEObjectID())) {
            // important.add(change.getAffectedEObjectID());
            // }
            // if (!substitutions.containsKey(change.getOldValueID())) {
            // important.add(change.getOldValueID());
            // }
            // }
            //
            // private void placeholder(RootEChange change, Map<String, EObjectSubstitution> substitutions,
            // Set<String> important) {
            // // TODO Auto-generated method stub
            //
            // }
            //
        };

        addEditor(editorPart.getEditorPart(), listener);

        LOGGER.trace("Initializing resource change listener.");
        listener.initialize(virtualModel);
        fireEditorStateListeners(editorPart.getEditorPart(), EditorStateChange.MONITORING_STARTED);
    }

    @Override
    public boolean isMonitoringEditor(IEditorPart editorPart) {
        return editors.containsKey(editorPart);
    }

    private void removeEditor(IEditorPart editorPart) {
        editors.remove(editorPart);
    }

    @Override
    public void disableMonitoring(IEditorPart editorPart) {
        if (isMonitoringEditor(editorPart)) {
            LOGGER.debug("Dismissing monitor for " + editorPart);
            EMFModelChangeRecordingEditorSaveListener listener = editors.get(editorPart);
            if (null != listener) {
                listener.dispose();
            }
            fireEditorStateListeners(editorPart, EditorStateChange.MONITORING_ENDED);
            removeEditor(editorPart);
        }
    }

    @Override
    public void dispose() {
        for (IEditorPart editor : new ArrayList<>(editors.keySet())) { // TODO: refactor, use
                                                                       // ConcurrentHashMap
            disableMonitoring(editor);
        }
        editorManagementListenerMgr.dispose();
    }

    // private List<VitruviusChange> getChangeList(List<EMFModelChange> changeDescriptions, Resource
    // resource) {
    // LOGGER.debug("Triggering synchronization for change description " + changeDescriptions + " on
    // resource "
    // + resource.getURI());
    // /*
    // * ChangeDescription2ChangeTransformation converter = new
    // * ChangeDescription2ChangeTransformation( changeDescriptions, VURI.getInstance(resource));
    // */
    // return converter.getChanges();
    // }

    private void triggerSynchronization(List<VitruviusChange> changes, Resource resource) {
        if (changes.isEmpty()) {
            LOGGER.debug("Not triggering synchronization for " + resource.getURI() + ": No changes detected.");
        } else {
            VURI uri = VURI.getInstance(resource);
            LOGGER.trace("Triggering synchronization for VURI " + uri.toString());
            changeSynchronizing.synchronizeChanges(changes, uri, resource);
        }
    }

    @Override
    public void addEditorStateListener(IEditorStateListener listener) {
        this.editorStateListeners.add(listener);
    }

    private void fireEditorStateListeners(IEditorPart modifiedEditor, EditorStateChange stateChange) {
        for (IEditorStateListener listener : editorStateListeners) {
            listener.monitoringStateChanged(modifiedEditor, editors.get(modifiedEditor).getMonitoredResource(),
                    stateChange);
        }
    }
}
