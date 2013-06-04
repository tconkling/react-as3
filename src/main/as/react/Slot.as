//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Reacts to signal emissions.
 */
public /*abstract*/ class Slot extends ValueListener
{
    public static function create (onEmit :Function) :Slot {
        return new SlotImpl(onEmit);
    }

    /**
     * Called when a signal to which this slot is connected has emitted an event.
     * @param event the event emitted by the signal.
     */
    public /*abstract*/ function onEmit (event :Object) :void {
        throw new IllegalOperationError("abstract");
    }

    /**
     * Returns a slot that maps values via {@code f} and then passes them to this slot.
     * This is essentially function composition in that {@code slot.compose(f)} means
     * {@code slot(f(value)))} where this slot is treated as a side effecting void function.
     */
    public function compose (f :Function) :Slot {
        const outer :Slot = this;
        return Slot.create(function (value :Object) :void {
            outer.onEmit(f.apply(null, value));
        });
    }

    /**
     * Returns a new slot that invokes this slot and then evokes {@code after}.
     */
    public function andThen (after :Slot) :Slot {
        const before :Slot = this;
        return new SlotImpl(function (event :Object) :void {
            before.onEmit(event);
            after.onEmit(event);
        });
    }

    /**
     * Allows a slot to be used as a {@link ValueView.Listener} by passing just the new value
     * through to {@link #onEmit}.
     */
    override public final function onChange (value :Object, oldValue :Object) :void {
        onEmit(value);
    }
}

}

import react.Slot;

class SlotImpl extends Slot {
    public function SlotImpl (onEmit :Function) {
        _onEmit = onEmit;
    }

    override public function onEmit (event :Object) :void {
        _onEmit(event);
    }

    protected var _onEmit :Function;
}
