//
// react

package react {

/**
 * A signal that emits Objects. {@link Slot}s may be connected to a signal to be
 * notified upon event emission.
 */
public class Signal extends AbstractSignal
{
    /**
     * Constructs a new Signal.
     * The optional eventType parameter exists purely for documentation purposes.
     */
    public function Signal (eventType :Class = null) {
    }

    /**
     * Causes this signal to emit the supplied event to connected slots.
     */
    public function emit (event :Object) :void {
        notifyEmit(event);
    }
}

}
