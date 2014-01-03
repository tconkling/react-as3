//
// react

package react {

public class StringValue extends AbstractValue
    implements StringView
{
    /**
     * Creates an instance with the supplied starting value.
     */
    public function StringValue (value :String = null) {
        _value = value;
    }

    public function get value () :String {
        return _value;
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified only if the
     * value differs from the current value.
     * @return the previous value contained by this instance.
     */
    public function set value (value :String) :void {
        updateAndNotifyIf(value);
    }

    /**
     * Updates this instance with the supplied value. Registered listeners are notified regardless
     * of whether the new value is equal to the old value.
     * @return the previous value contained by this instance.
     */
    public function updateForce (value :String) :* {
        return updateAndNotify(value);
    }

    override public function get () :* {
        return _value;
    }

    override protected function updateLocal (value :Object) :Object {
        var oldValue :String = _value;
        _value = value as String;
        return oldValue;
    }

    protected var _value :String;
}
}
