//
// react

package react {

public class UintValue extends AbstractValue
    implements UintView
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function UintValue (value :uint = 0) {
        _value = value;
    }

    public function get value () :uint {
        return _value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value, as determined via {@link Object#equals}.
     * @return the previous value contained by this instance.
     */
    public function update (value :uint) :uint {
        return updateAndNotifyIf(value) as uint;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :uint) :uint {
        return updateAndNotify(value) as uint;
    }

    override public function get () :* {
        return _value;
    }

    override protected function updateLocal (value :Object) :Object {
        var oldValue :uint = _value;
        _value = value as uint;
        return oldValue;
    }

    protected var _value :uint;
}
}
