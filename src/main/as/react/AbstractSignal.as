//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Handles the machinery of connecting slots to a signal and emitting events to them, without
 * exposing a public interface for emitting events. This can be used by entities which wish to
 * expose a signal-like interface for listening, without allowing external callers to emit signals.
 */
public class AbstractSignal extends Reactor
    implements SignalView
{
    public function map (func :Function) :SignalView {
        return MappedSignal.create(this, func);
    }

    public function connect (slot :Function) :Connection {
        return addConnection(slot);
    }

    public function disconnect (slot :Function) :void {
        removeConnection(slot);
    }

    /**
     * Emits the supplied event to all connected slots.
     */
    protected function notifyEmit (event :Object) :void {
        var lners :Cons = prepareNotify();
        var error :MultiFailureError = null;
        try {
            for (var cons :Cons = lners; cons != null; cons = cons.next) {
                try {
                    cons.listener.onEmit(event);
                } catch (e :Error) {
                    if (error == null) {
                        error = new MultiFailureError();
                    }
                    error.addFailure(e);
                }
                if (cons.oneShot()) {
                    cons.disconnect();
                }
            }
        } finally {
            finishNotify(lners);
        }

        if (error != null) {
            error.trigger();
        }
    }
}
}
