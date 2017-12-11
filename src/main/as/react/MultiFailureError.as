//
// react

package react {

import flash.events.ErrorEvent;
import flash.events.UncaughtErrorEvent;

/**
 * An exception thrown to communicate multiple listener failures.
 */
public class MultiFailureError extends Error
{
    public function get failures () :Vector.<Object> {
        return _failures;
    }

    public function addFailure (e :Object) :void {
        if (e is MultiFailureError) {
            _failures = _failures.concat(MultiFailureError(e).failures);
        } else {
            _failures[_failures.length] = e;
        }
        this.message = getMessage();
    }

    public function getMessage () :String {
        var buf :String = "";
        for each (var failure :Object in _failures) {
            if (buf.length > 0) {
                buf += ", ";
            }
            buf += getMessageInternal(failure, false);
        }
        return "" + _failures.length + (_failures.length != 1 ? " failures: " : " failure: ") + buf;
    }

    private static function getMessageInternal (error :*, wantStackTrace :Boolean) :String {
        // NB: do NOT use the class-cast operator for converting to typed error objects.
        // Error() is a top-level function that creates a new error object, rather than performing
        // a class-cast, as expected.

        if (error is Error) {
            var e :Error = (error as Error);
            return (wantStackTrace ? e.getStackTrace() : e.message || "");
        } else if (error is UncaughtErrorEvent) {
            return getMessageInternal(error.error, wantStackTrace);
        } else if (error is ErrorEvent) {
            var ee :ErrorEvent = (error as ErrorEvent);
            return getClassName(ee) +
                " [errorID=" + ee.errorID +
                ", type='" + ee.type + "'" +
                ", text='" + ee.text + "']";
        }

        return "An error occurred: " + error;
    }

    private var _failures :Vector.<Object> = new Vector.<Object>();
}

}
