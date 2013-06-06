//
// react-test

package react {

public function assertEquals (a :*, b :*, failureMessage :String="") :void {
    if (a is Vector.<Object> && b is Vector.<Object>) {
        return assertVectorEquals(a, b, failureMessage);
    } else if (a != b) {
        throw new Error(failureMessage);
    }
}

}

function assertVectorEquals (a :Vector.<Object>, b :Vector.<Object>, failureMessage :String="") :void {
    if (a.length != b.length) {
        throw new Error(failureMessage);
    }

    for (var ii :int = 0; ii < a.length; ++ii) {
        if (a[ii] != b[ii]) {
            throw new Error(failureMessage);
        }
    }
}
