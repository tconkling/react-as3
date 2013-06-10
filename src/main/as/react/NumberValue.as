//
// react

package react {

public class NumberValue extends AbstractValue
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function NumberValue (value :Number) {
        _value = value;
    }

    public function get value () :Number {
        return _value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value, as determined via {@link Object#equals}.
     * @return the previous value contained by this instance.
     */
    public function update (value :Number) :Number {
        return updateAndNotifyIf(value) as Number;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :Number) :Number {
        return updateAndNotify(value) as Number;
    }

    /**
     * Returns a slot which can be used to wire this value to the emissons of a {@link Signal} or
     * another value.
     */
    public function slot () :Slot {
        return Slot.create(update);
    }

    override public function get () :* {
        return _value;
    }

    override protected function updateLocal (value :Object) :Object {
        var oldValue :Number = _value;
        _value = value as Number;
        return oldValue;
    }

    protected var _value :Number;
}
}
