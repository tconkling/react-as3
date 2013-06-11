//
// react

package react {

public class ObjectValue extends AbstractValue
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function ObjectValue (value :Object) {
        _value = value;
    }

    public function get value () :* {
        return _value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value, as determined via {@link Object#equals}.
     * @return the previous value contained by this instance.
     */
    public function update (value :Object) :* {
        return updateAndNotifyIf(value);
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :Object) :* {
        return updateAndNotify(value);
    }

    override public function get () :* {
        return _value;
    }

    override protected function updateLocal (value :Object) :Object {
        var oldValue :* = _value;
        _value = value;
        return oldValue;
    }

    protected var _value :Object;
}
}
