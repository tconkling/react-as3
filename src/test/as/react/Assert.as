//
// aciv

package react {

public class Assert {
    public static function isTrue (condition :Boolean, failureMessage :String = "") :void {
        if (!condition) {
            throw new Error(failureMessage);
        }
    }

    public static function isFalse (condition :Boolean, failureMessage :String = "") :void {
        isTrue(!condition, failureMessage);
    }

    public static function equals (a :*, b :*, failureMessage :String = null) :void {
        if (!testEquals(a, b)) {
            if (failureMessage == null) {
                try {
                    failureMessage = "" + a + " != " + b;
                } catch (e :Error) {
                    failureMessage = "";
                }
            }
            throw new Error(failureMessage);
        }
    }

    public static function epsilonEquals (a :Number, b :Number, epsilon :Number, failureMessage :String="") :void {
        if (Math.abs(b - a) > epsilon) {
            throw new Error(failureMessage);
        }
    }

    public static function throws (f :Function, errorClass :Class = null, failureMessage :String="") :void {
        try {
            f();
        } catch (e :Error) {
            if (errorClass != null && !(e is errorClass)) {
                throw new Error(failureMessage);
            }
            return;
        }
        throw new Error(failureMessage);
    }

    private static function testEquals (a :*, b :*) :Boolean {
        if (a === b) {
            return true;
        } else if (a is TestError) {
            return TestError(a).equals(b);
        } else {
            var aVec :Vector.<Object> = (a as Vector.<Object>);
            var bVec :Vector.<Object> = (b as Vector.<Object>);
            if (aVec != null && bVec != null) {
                if (aVec.length != bVec.length) {
                    return false;
                }

                for (var ii :int = 0; ii < aVec.length; ++ii) {
                    if (!testEquals(aVec[ii], bVec[ii])) {
                        return false;
                    }
                }

                return true;
            }

            return false;
        }
    }
}
}
