//
// react-test

package react {

import react.UnitSlot;

public class Counter extends UnitSlot
{
    public var notifies :int;

    public function Counter () :void {
        super(function () :void {});
    }

    override public function onEmit (event :Object) :void {
        notifies++;
    }
}

}
