//
// React

package react {
import flash.utils.Dictionary;

/**
 * Various Function-related utility methods.
 */
public class Functions
{
    /** The identity function */
    public static function IDENT (value :Object) :Object {
        return value;
    }

    /** Implements boolean not. */
    public static function NOT (value :Boolean) :Boolean {
        return !value;
    }

    /** A function that applies {@link String#valueOf} to its argument. */
    public static function TO_STRING (value :Object) :String {
        return value.toString();
    }

    /** A function that returns true for null values and false for non-null values. */
    public static function IS_NULL (value :Object) :Boolean {
        return (value == null);
    }

    /** A function that returns true for non-null values and false for null values. */
    public static function NON_NULL (value :Object) :Boolean {
        return (value != null);
    }

    /**
     * Returns a function that always returns the supplied constant value.
     */
    public static function constant (constant :Object) :Function {
        return function (value :Object) :Object {
            return constant;
        };
    }

    /**
     * Returns a function that computes whether a value is greater than {@code target}.
     */
    public static function greaterThan (target :int) :Function {
        return function (value :int) :Boolean {
            return value > target;
        };
    }

    /**
     * Returns a function that computes whether a value is greater than or equal to {@code value}.
     */
    public static function greaterThanEqual (target :int) :Function {
        return function (value :int) :Boolean {
            return value >= target;
        };
    }

    /**
     * Returns a function that computes whether a value is less than {@code target}.
     */
    public static function lessThan (target :int) :Function {
        return function (value :int) :Boolean {
            return value < target;
        };
    }

    /**
     * Returns a function that computes whether a value is less than or equal to {@code target}.
     */
    public static function lessThanEqual (target :int) :Function {
        return function (value :int) :Boolean {
            return value <= target;
        };
    }

    /**
     * Returns a function which performs a Dictionary lookup with a default value. The function created by
     * this method returns defaultValue for all inputs that do not belong to the dict's key set.
     */
    public static function forDict (dict :Dictionary, defaultValue :Object) :Function {
        return function (key :Object) :Object {
            return (key in dict ? dict[key] : defaultValue);
        };
    }
}

}
