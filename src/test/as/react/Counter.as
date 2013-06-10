//
// react-test

package react {

import react.Slot;

public class Counter extends Slot
{
    public var notifies :int;

    override public function onEmit (event :Object) :void {
        notifies++;
    }
}

}
