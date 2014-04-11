//
// react

package react {

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

    public function filter (pred :Function) :SignalView {
        return new FilteredSignal(this, pred);
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
        notify(EMIT, event, null, null);
    }

    protected static function EMIT (slot :RListener, event :Object, _1 :Object, _2 :Object) :void {
        slot.onEmit(event);
    }
}
}
