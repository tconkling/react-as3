//
// react

package react {

public class Registrations
{
    /** Returns a Registration that will call the given function when disconnected */
    public static function createWithFunction (f :Function) :Registration {
        return new FunctionRegistration(f);
    }

    /** Returns a Registration that does nothing. */
    public static function Null () :Registration {
        if (_null == null) {
            _null = new NullRegistration();
        }
        return _null;
    }

    protected static var _null :NullRegistration;
}
}

import react.Registration;

class NullRegistration implements Registration {
    public function close () :void {}
}

class FunctionRegistration implements Registration {
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
