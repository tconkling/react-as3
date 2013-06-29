//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Handles the machinery of connecting listeners to a value and notifying them, without exposing a
 * public interface for updating the value. This can be used by libraries which wish to provide
 * observable values, but must manage the maintenance and distribution of value updates themselves
 * (so that they may send them over the network, for example).
 */
public /*abstract*/ class AbstractValue extends Reactor
    implements ValueView
{
    public /*abstract*/ function get () :* {
        throw new IllegalOperationError("abstract");
    }

    public function map (func :Function) :ValueView {
        return MappedValue.create(this, func);
    }

    public function mapToBool (func :Function) :BoolView {
        return MappedValue.boolView(this, func);
    }

    public function mapToInt (func :Function) :IntView {
        return MappedValue.intView(this, func);
    }

    public function mapToUint (func :Function) :UintView {
        return MappedValue.uintView(this, func);
    }

    public function mapToNumber (func :Function) :NumberView {
        return MappedValue.numberView(this, func);
    }

    public function connect (listener :Function) :Connection {
        return addConnection(listener);
    }

    public function connectNotify (listener :Function) :Connection {
        // connect before calling emit; if the listener changes the value in the body of onEmit, it
        // will expect to be notified of that change; however if onEmit throws a runtime exception,
        // we need to take care of disconnecting the listener because the returned connection
        // instance will never reach the caller
        var cons :Cons = addConnection(listener);
        try {
            cons.listener.onChange(get(), null);
        } catch (e :Error) {
            cons.close();
            throw e;
        }
        return cons;
    }

    public function disconnect (listener :Function) :void {
        removeConnection(listener);
    }

    public function toString () :String {
        var cname :String = getClassName(this);
        return cname.substring(cname.lastIndexOf(".")+1) + "(" + get() + ")";
    }

    /**
     * Updates the value contained in this instance and notifies registered listeners iff said
     * value is not equal to the value already contained in this instance (per {@link #areEqual}).
     */
    protected function updateAndNotifyIf (value :Object) :Object {
        return updateAndNotify(value, false);
    }

    /**
     * Updates the value contained in this instance and notifies registered listeners.
     * @return the previously contained value.
     */
    protected function updateAndNotify (value :Object, force :Boolean = true) :Object {
        checkMutate();
        var ovalue :Object = updateLocal(value);
        if (force || value != ovalue) {
            emitChange(value, ovalue);
        }
        return ovalue;
    }

    /**
     * Emits a change notification. Default implementation immediately notifies listeners.
     */
    protected function emitChange (value :Object, ovalue :Object) :void {
        notifyChange(value, ovalue);
    }

    /**
     * Notifies our listeners of a value change.
     */
    protected function notifyChange (value :Object, ovalue :Object) :void {
        var lners :Cons = prepareNotify();
        var error :MultiFailureError = null;
        try {
            for (var cons :Cons = lners; cons != null; cons = cons.next) {
                try {
                    cons.listener.onChange(value, ovalue);
                } catch (e :Error) {
                    if (error == null) {
                        error = new MultiFailureError();
                    }
                    error.addFailure(e);
                }

                if (cons.oneShot()) {
                    cons.close();
                }
            }
        } finally {
            finishNotify(lners);
        }
        if (error != null) error.trigger();
    }

    /**
     * Updates our locally stored value. Default implementation throws IllegalOperationError.
     * @return the previously stored value.
     */
    protected function updateLocal (value :Object) :Object {
        throw new IllegalOperationError();
    }
}
}
