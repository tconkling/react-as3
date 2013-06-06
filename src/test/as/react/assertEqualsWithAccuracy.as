//
// react-test

package react {

public function assertEqualsWithAccuracy (a :Number, b :Number, epsilon :Number, failureMessage :String="") :void {
    if (Math.abs(b - a) > epsilon) {
        throw new Error(failureMessage);
    }
}

}
