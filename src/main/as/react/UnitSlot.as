//
// react

package react {

/**
 * A signal that emits an event with no associated data.
 */
public class UnitSlot extends Slot
{
    public static function create (onEmit :Function) :UnitSlot {
        return new UnitSlot(onEmit);
    }

    public function UnitSlot (onEmit :Function) {
        _onEmit = onEmit;
    }

    override public function onEmit (event :Object) :void {
        // if you're using unit slot, you're not allow to see the event
        _onEmit();
    }

    protected var _onEmit :Function;
}
}
