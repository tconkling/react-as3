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
     * Causes this signal to emit the supplied event to connected slots.
     */
    public function emit (event :Object) :void {
        notifyEmit(event);
    }

    /**
     * Returns a slot which can be used to wire this signal to the emissons of a {@link Signal} or
     * another value.
     */
    public function slot () :Slot {
        return Slot.create(emit);
    }
}

}
