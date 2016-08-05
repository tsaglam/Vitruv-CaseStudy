package edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.user.TransformationAbortCause;

/**
 * Listener for the synchronisation status.
 */
public interface SynchronisationListener {

    /**
     * Called before the synchronisation is started.
     */
    void syncStarted();

    /**
     * Called after the synchronisation is finished.
     */
    void syncFinished();

    /**
     * Called if the synchronisation has been aborted.
     *
     * @param cause
     *            The cause for the abortion.
     */
    void syncAborted(TransformationAbortCause cause);

}
