//
// react-test

package react {

public class Counter  {
    public function get slot () :Function {
        return onEmit;
    }

    public function trigger () :void {
        _count++;
    }

    public function assertTriggered (count :int, message :String = "") :void {
        AssertX.equals(count, _count, message);
    }

    public function reset () :void {
        _count = 0;
    }

    public function onEmit (value :Object) :void {
        trigger();
    }

    protected var _count :int;
}

}
