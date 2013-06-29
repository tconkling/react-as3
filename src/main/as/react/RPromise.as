//
// react

package react {

/**
 * Provides a concrete implementation {@link RFuture} that can be updated with a success or failure
 * result when it becomes available.
 *
 * <p>This implementation also guarantees a useful behavior, which is that all listeners added
 * prior to the completion of the promise will be cleared when the promise is completed, and no
 * further listeners will be retained. This allows the promise to be retained after is has been
 * completed as a useful "box" for its underlying value, without concern that references to long
 * satisfied listeners will be inadvertently retained.</p>
 */
public class RPromise extends RFuture {

    /** Creates a new, uncompleted, promise. */
    public static function create () :RPromise {
        return new RPromise();
    }

    /** Causes this promise to be completed successfully with {@code value}. */
    public function succeed (value :Object) :void {
        _value.value = Try.success(value);
    }

    /** Causes this promise to be completed with failure caused by {@code cause}. */
    public function fail (cause :Error) :void {
        _value.value = Try.failure(cause);
    }

    /** Returns a function that can be used to complete this promise. */
    public function completer () :Function {
        return _value.slot;

    }

    /** Returns true if there are listeners awaiting the completion of this promise. */
    public function get hasConnections () :Boolean {
        return _value.hasConnections;
    }

    public function RPromise () {
        super(_value = new TryValue());
    }

    protected var _value :TryValue;
}

}

import react.ObjectValue;

class TryValue extends ObjectValue {
    public function TryValue () {
        super(null);
    }

    override protected function updateAndNotify (value :Object, force :Boolean = true) :Object {
        if (_value != null) {
            throw new Error("Already completed");
        }
        try {
            return super.updateAndNotify(value, force);
        } finally {
            _listeners = null;
        }
        return null; // we'll never get here, but the stupid compiler doesn't know that
    }
}
