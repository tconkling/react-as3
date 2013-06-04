//
// react

package react {

/**
 * A signal that emits an event with no associated data.
 */
public class UnitSignal extends AbstractSignal
{
    /**
     * Causes this signal to emit an event to its connected slots.
     */
    public function emit () :void {
        notifyEmit(null);
    }

    /**
     * Returns a slot which can be used to wire this signal to the emissons of a {@link Signal} or
     * another value.
     */
    public function slot () :UnitSlot {
        return UnitSlot.create(emit);
    }
}
}
