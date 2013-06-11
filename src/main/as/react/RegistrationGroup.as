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
        _regs[r] = true;
        return r;
    }

    /**
     * Removes a Registration from the group without disconnecting it.
     */
    public function remove (r :Registration) :void {
        delete _regs[r];
    }

    /**
     * Cancels all Registrations that have been added to the manager.
     */
    public function cancel () :void {
        var regs :Dictionary = _regs;
        _regs = new Dictionary();

        for (var r :Object in regs) {
            Registration(r).cancel();
        }
    }

    protected var _regs :Dictionary = new Dictionary();
}
}

