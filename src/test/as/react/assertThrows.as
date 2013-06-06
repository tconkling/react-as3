//
// react-test

package react {

public function assertThrows (f :Function, clazz :Class = null, failureMessage :String="") :void {
    try {
        f();
    } catch (e :Error) {
        if (clazz != null && !(e is clazz)) {
            throw new Error(failureMessage);
        }
        return;
    }
    throw new Error(failureMessage);
}

}
