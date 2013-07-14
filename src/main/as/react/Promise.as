//
// react

package react {

/**
 * Provides a concrete implementation {@link Future} that can be updated with a success or failure
 * result when it becomes available.
 *
 * <p>This implementation also guarantees a useful behavior, which is that all listeners added
 * prior to the completion of the promise will be cleared when the promise is completed, and no
 * further listeners will be retained. This allows the promise to be retained after is has been
 * completed as a useful "box" for its underlying value, without concern that references to long
 * satisfied listeners will be inadvertently retained.</p>
 */
public class Promise extends Future {

    /** Creates a new, uncompleted, promise. */
    public static function create () :Promise {
        return new Promise();
    }

    /** Causes this promise to be completed successfully with {@code value}. */
    public function succeed (value :Object = null) :void {
        _value.value = Try.success(value);
    }

    /**
     * Causes this promise to be completed with failure caused by {@code cause}.
     * 'cause' can be an Error, ErrorEvent, or String, and will be converted to an Error.
     */
    public function fail (cause :Object) :void {
        _value.value = Try.failure(cause);
    }

    /** Returns a function that can be used to complete this promise. */
    public function get completer () :Function {
        return _value.slot;

    }

    /** Returns true if there are listeners awaiting the completion of this promise. */
    public function get hasConnections () :Boolean {
        return _value.hasConnections;
    }

    public function Promise () {
        super(_value = new PromiseValue());
    }

    protected var _value :PromiseValue;
}

}

import react.TryValue;

class PromiseValue extends TryValue {
    override protected function updateAndNotify (value :Object, force :Boolean = true) :Object {
        if (_value != null) {
            throw new Error("Already completed");
        }
        try {
            return super.updateAndNotify(value, force);
        } finally {
            _listeners = null; // clear out our listeners now that they have been notified
        }
        return null; // compiler too dumb to realize we'll never get here
    }
}
