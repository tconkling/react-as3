//
// react

package react {

public class Registrations
{
    /** Returns a Registration that will call the given function when disconnected */
    public static function createWithFunction (f :Function) :Registration {
        return new FunctionRegistration(f);
    }
}
}

import react.Registration;

class FunctionRegistration
    implements react.Registration
{
    public function FunctionRegistration (f :Function) {
        _f = f;
    }

    public function close () :void {
        if (_f != null) {
            var f :Function = _f;
            _f = null;
            f();
        }
    }

    protected var _f :Function;
}
