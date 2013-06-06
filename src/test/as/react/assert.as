//
// react-test

package react {

public function assert (condition :Boolean, failureMessage :String="") :void {
    if (!condition) {
        throw new Error(failureMessage);
    }
}

}
