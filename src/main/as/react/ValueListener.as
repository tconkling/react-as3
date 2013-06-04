//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Used to observe changes to a value.
 */
internal /*abstract*/ class ValueListener extends RListener
{
    /**
     * Called when the value to which this listener is bound has changed.
     */
    public function onChange (value :Object, oldValue :Object) :void {
        throw new IllegalOperationError("abstract");
    }
}
}
