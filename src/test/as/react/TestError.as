//
// aciv

package react {

public class TestError extends Error {
    public function TestError (message :String) {
        super(message);
    }

    public function equals (other :Object) :Boolean {
        var o :TestError = (other as TestError);
        return (o != null && o.message == this.message);
    }

    public function toString () :String {
        return "TestError: '" + this.message + "'";
    }
}
}
