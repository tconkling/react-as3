//
// react

package react {

public class TryValue extends AbstractValue
    implements TryView
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function TryValue (value :Try = null) {
        _value = value;
    }

    public function get value () :Try {
        return _value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value.
     * @return the previous value contained by this instance.
     */
    public function set value (value :Try) :void {
        updateAndNotifyIf(value);
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :Try) :Try {
        return Try(updateAndNotify(value));
    }

    override public function get () :* {
        return _value;
    }

    override protected function updateLocal (value :Object) :Object {
        var oldValue :Try = _value;
        _value = Try(value);
        return oldValue;
    }

    protected var _value :Try;
}
}
