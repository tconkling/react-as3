//
// react

package react {

import flash.utils.Dictionary;

/**
 * Collects Registrations to allow mass operations on them.
 */
public class RegistrationGroup
    implements Registration
{
    /**
     * Adds a Registration to the manager.
     * @return the Registration passed to the function.
     */
    public function add (r :Registration) :Registration {
        if (_regs == null) {
            _regs = new Dictionary();
        }
        _regs[r] = true;
        return r;
    }

    /** Removes a Registration from the group without disconnecting it. */
    public function remove (r :Registration) :void {
        if (_regs != null) {
            delete _regs[r];
        }
    }

    /** Closes all Registrations that have been added to the manager. */
    public function close () :void {
        if (_regs != null) {
            var regs :Dictionary = _regs;
            _regs = null;

            var err :MultiFailureError = null;
            for (var r :Registration in regs) {
                try {
                    r.close();
                } catch (e :Error) {
                    if (err == null) {
                        err = new MultiFailureError();
                    }
                    err.addFailure(e);
                }
            }

            if (err != null) {
                throw err;
            }
        }
    }

    private var _regs :Dictionary; // lazily instantiated
}
}

