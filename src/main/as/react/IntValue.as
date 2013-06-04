//
// react

package react {

public class IntValue extends AbstractValue
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function IntValue (value :int) {
        _value = value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value, as determined via {@link Object#equals}.
     * @return the previous value contained by this instance.
     */
    public function update (value :int) :int {
        return updateAndNotifyIf(value) as int;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :int) :int {
        return updateAndNotify(value) as int;
    }

    /**
     * Returns a slot which can be used to wire this value to the emissons of a {@link Signal} or
     * another value.
     */
    public function slot () :Slot {
        return Slot.create(update);
    }

    override public function get () :Object {
        return _value;
    }

    override protected function updateLocal (value :Object) :Object {
        var oldValue :int = _value;
        _value = value as int;
        return oldValue;
    }

    protected var _value :int;
}
}
