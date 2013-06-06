//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Used to observe changes to a value.
 */
public /*abstract*/ class ValueListener extends RListener
{
    public static function create (onChange :Function) :ValueListener {
        return new ValueListenerImpl(onChange);
    }

    /**
     * Called when the value to which this listener is bound has changed.
     */
    public function onChange (value :Object, oldValue :Object) :void {
        throw new IllegalOperationError("abstract");
    }
}
}

import react.ValueListener;

class ValueListenerImpl extends ValueListener {
    public function ValueListenerImpl (onChange :Function) {
        _onChange = onChange;
    }

    override public function onChange (value :Object, oldValue :Object) :void {
        _onChange(value, oldValue);
    }

    protected var _onChange :Function;
}
