//
// React

package react {

import flash.errors.IllegalOperationError;

/**
 * Represents a computation that either provided a result, or failed with an exception. Monadic
 * methods are provided that allow one to map and compose tries in ways that propagate failure.
 * This class is not itself "reactive", but it facilitates a more straightforward interface and
 * implementation for {@link Future} and {@link Promise}.
 */
public /*abstract*/ class Try
{
    /** Creates a successful try. */
    public static function success (value :Object) :Try { return new Success(value); }

    /**
     * Creates a failed try.
     * 'cause' can be an Error, ErrorEvent, or String, and will be converted to an Error.
     */
    public static function failure (cause :Object) :Try { return new Failure(cause); }

    /** Lifts {@code func}, a function on values, to a function on tries. */
    public static function lift (func :Function) :Function {
        return function (result :Try) :Object {
            return result.map(func);
        };
    }

    /** Returns the value associated with a successful try, or rethrows the exception if the try
     * failed. */
    public function get value () :* { return abstract(); }

    /** Returns the cause of failure for a failed try. Throws {@link IllegalOperationError} if
     * called on a successful try. */
    public /*abstract*/ function get failure () :Error { return abstract(); }

    /** Returns true if this is a successful try, false if it is a failed try. */
    public /*abstract*/ function get isSuccess () :Boolean { return abstract(); }

    /** Returns true if this is a failed try, false if it is a successful try. */
    public final function get isFailure () :Boolean { return !this.isSuccess; }

    /** Maps successful tries through {@code func}, passees failure through as is. */
    public /*abstract*/ function map (func :Function) :Try { return abstract(); }

    /** Maps successful tries through {@code func}, passes failure through as is. */
    public /*abstract*/ function flatMap (func :Function) :Try { return abstract(); }

    private static function abstract () :* {
        throw new IllegalOperationError("abstract");
    }
}

}

import flash.errors.IllegalOperationError;
import flash.events.ErrorEvent;
import flash.utils.getQualifiedClassName;

import react.Try;

/** Represents a successful try. Contains the successful result. */
class Success extends Try {
    public function Success (value :Object) {
        _value = value;
    }

    override public function get value () :* {
        return _value;
    }

    override public function get failure () :Error {
        throw new IllegalOperationError();
    }

    override public function get isSuccess () :Boolean {
        return true;
    }

    override public function map (func :Function) :Try {
        return Try.success(func(_value));
    }

    override public function flatMap (func :Function) :Try {
        return func(_value);
    }

    public function toString () :String {
        return "Success(" + value + ")";
    }

    protected var _value :Object;
}

/** Represents a failed try. Contains the cause of failure. */
class Failure extends Try {

    public function Failure (cause :Object) {
        _cause = resultToError(cause);
    }

    override public function get value ():* {
        throw _cause;
    }

    override public function get failure () :Error {
        return _cause;
    }

    override public function get isSuccess () :Boolean {
        return false;
    }

    override public function map (func :Function) :Try {
        return this;
    }

    override public function flatMap (func :Function) :Try {
        return this;
    }

    public function toString () :String {
        return "Failure(" + value + ")";
    }

    protected static function resultToError (result :*) :Error {
        if (result is Error) {
            return result;
        } else if (result is ErrorEvent) {
            var ee :ErrorEvent = result as ErrorEvent;
            return new Error("An ErrorEvent occurred [type=" +
                getClassName(result) + ", message=" + ee.text + "]");
        } else if (result is String) {
            return new Error(result);
        } else {
            return new Error("An unknown failure occurred" +
                (result != null ? " (" + result + ")" : ""));
        }
    }

    protected static function getClassName (obj :Object) :String {
        var name :String = getQualifiedClassName(obj);
        var dex :int = name.lastIndexOf(".");
        return name.substring(dex + 1); // works even if dex is -1
    }

    protected var _cause :Error;
}
