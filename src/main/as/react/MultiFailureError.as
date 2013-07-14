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
        this.message = getMessage();
    }

    public function getMessage () :String {
        var buf :String = "";
        for each (var failure :Error in _failures) {
            if (buf.length > 0) {
                buf += ", ";
            }
            buf += getClassName(failure) + ": " + failure.message;
        }
        return "" + _failures.length + (_failures.length != 1 ? " failures: " : " failure: ") + buf;
    }

    protected var _failures :Vector.<Error> = new Vector.<Error>();
}

}
