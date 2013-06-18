//
// react

package react {

public class IntValue extends AbstractValue
    implements IntView
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function IntValue (value :int = 0) {
        _value = value;
    }

    public function get value () :int {
        return _value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value, as determined via {@link Object#equals}.
     * @return the previous value contained by this instance.
     */
    public function set value (value :int) :void {
        updateAndNotifyIf(value);
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :int) :int {
        return updateAndNotify(value) as int;
    }

    override public function get () :* {
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
