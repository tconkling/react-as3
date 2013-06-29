//
// react

package react {

/**
 * An exception thrown to communicate multiple listener failures.
 */
public class MultiFailureError extends Error
{
    public function get failures () :Vector.<Error> {
        return _failures;
    }

    public function addFailure (e :Error) :void {
        _failures.push(e);
    }

    public function trigger () :void {
        if (_failures.length != 1) {
            throw this;
        }

        var e :Error = _failures[0];
        throw e;
    }

    /**
     * Returns this exception if it contains more than one underlying exception. Returns the
     * underyling exception if only one exception has been added. Returns null if no exceptions
     * have been added.
     */
    public function consolidate () :Error {
        switch (_failures.length) {
        case 0: return null;
        case 1: return _failures[0];
        default: return this;
        }
    }

    public function getMessage () :String {
        var buf :String = "";
        for each (var failure :Error in _failures) {
            if (buf.length > 0) {
                buf += ", ";
            }
            buf += getClassName(failure) + ": " + failure.message;
        }
        return "" + _failures.length + (_failures.length != 1 ? " failures: " : "failure: ") + buf;
    }

    protected var _failures :Vector.<Error> = new Vector.<Error>();
}

}
