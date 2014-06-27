//
// react

package react {

/**
 * An exception thrown to communicate multiple listener failures.
 */
public class MultiFailureError extends Error
{
    public function get failures () :Vector.<Object> {
        return _failures;
    }

    public function addFailure (e :Object) :void {
        _failures.push(e);
        this.message = getMessage();
    }

    public function getMessage () :String {
        var buf :String = "";
        for each (var failure :Object in _failures) {
            if (buf.length > 0) {
                buf += ", ";
            }
            buf += getClassName(failure) + ": " + failure.message;
        }
        return "" + _failures.length + (_failures.length != 1 ? " failures: " : " failure: ") + buf;
    }

    protected var _failures :Vector.<Object> = new Vector.<Object>();
}

}
