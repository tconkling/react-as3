//
// react-test

package react {

public class Counter
{
    public var notifies :int;

    public function onEmit (event :Object) :void {
        notifies++;
    }
}

}
