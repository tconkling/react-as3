//
// React

package react {

/**
 * Represents an asynchronous result. Unlike standard Java futures, you cannot block on this
 * result. You can {@link #map} or {@link #flatMap} it, and listen for success or failure via the
 * {@link #success} and {@link #failure} signals.
 *
 * <p> The benefit over just using {@link Callback} is that results can be composed. You can
 * subscribe to an object, flatmap the result into a service call on that object which returns the
 * address of another object, flat map that into a request to subscribe to that object, and finally
 * pass the resulting object to some other code via a slot. Failure can be handled once for all of
 * these operations and you avoid nesting yourself three callbacks deep. </p>
 */
public class RFuture {

    /** Returns a future with a pre-existing success value. */
    public static function success (value :Object = null) :RFuture {
        return result(Try.success(value));
    }

    /** Returns a future with a pre-existing failure value. */
    public static function failure (cause :Error) :RFuture {
        return result(Try.failure(cause));
    }

    /** Returns a future with an already-computed result. */
    public static function result (result :Try) :RFuture {
        return new RFuture(new ObjectValue(result));
    }

    /** Returns a future containing an Array of all success results from {@code futures} if all of
     * the futures complete successfully, or an aggregate of all failures (where multiple
     * exceptions are combined via {@link MultiFailureException}), if any of the futures fails. */
    public static function sequence (futures :Array) :RFuture {
        const pseq :RPromise = RPromise.create();
        const seq :Sequencer = new Sequencer(pseq, futures.length);
        for (var ii :int = 0, len :int = futures.length; ii < len; ++ii) {
            var future :RFuture = futures[ii];
            future.onComplete(addToSequenceCallback(seq, ii));
        }
        return pseq;
    }

    /** Returns a future containing a list of all success results from {@code futures}. Any failure
     * results are simply omitted from the list. The success results are also in no particular
     * order. If all of {@code futures} fail, the resulting list will be empty. */
    public static function collect (futures :Array) :RFuture { // RFuture<Array<T>>
        const pseq :RPromise = RPromise.create();
        const results :Array = [];
        var remain :int = futures.length;
        for each (var future :RFuture in futures) {
            future.onComplete(function (result :Try) :void {
                if (result.isSuccess) {
                    results.push(result.value);
                }
                if (--remain == 0) {
                    pseq.succeed(results);
                }
            });
        }
        return pseq;
    }

    /** Causes {@code slot} to be notified if/when this future is completed with success. If it has
     * already suceeded, the slot will be notified immediately.
     * @return this future for chaining. */
    public function onSuccess (slot :Function) :RFuture {
        var result :Try = _result.get();
        if (result == null) {
            _result.connect(function (result :Try) :void {
                if (result.isSuccess) {
                    slot(result.value);
                }
            });
        } else if (result.isSuccess) {
            slot(result.value);
        }
        return this;
    }

    /** Causes {@code slot} to be notified if/when this future is completed with failure. If it has
     * already failed, the slot will be notified immediately.
     * @return this future for chaining. */
    public function onFailure (slot :Function) :RFuture {
        var result :Try = _result.get();
        if (result == null) {
            _result.connect(function (result :Try) :void {
                if (result.isFailure) {
                    slot(result.failure);
                }
            });
        } else if (result.isFailure) {
            slot(result.failure);
        }
        return this;
    };

    /** Causes {@code slot} to be notified when this future is completed. If it has already
     * completed, the slot will be notified immediately.
     * @return this future for chaining. */
    public function onComplete (slot :Function) :RFuture {
        var result :Try = _result.get();
        if (result == null) {
            _result.connect(slot);
        } else {
            slot(result);
        }
        return this;
    };

    /** Returns a value that indicates whether this future has completed. */
    public function get isComplete () :BoolView {
        if (_isComplete == null) {
            _isComplete = _result.mapToBool(Functions.NON_NULL);
        }
        return _isComplete;
    }

    /** Convenience method to {@link ValueView#connectNotify} {@code slot} to {@link #isComplete}.
     * This is useful for binding the disabled state of UI elements to this future's completeness
     * (i.e. disabled while the future is incomplete, then reenabled when it is completed).
     * @return this future for chaining. */
    public function bindComplete (slot :Function) :RFuture {
        this.isComplete.connectNotify(slot);
        return this;
    }

    /** Maps the value of a successful result using {@link #func} upon arrival. */
    public function map (func :Function) :RFuture {
        // we'd use Try.lift here but we have to handle the special case where our try is null,
        // meaning we haven't completed yet; it would be weird if Try.lift did that
        return new RFuture(_result.map(function (result :Try) :Try {
            return (result == null ? null : result.map(func));
        }));
    };

    /** Maps a successful result to a new result using {@link #func} when it arrives. Failure on
     * the original result or the mapped result are both dispatched to the mapped result. This is
     * useful for chaining asynchronous actions. It's also known as monadic bind. */
    public function flatMap (func :Function) :RFuture {
        const mapped :ObjectValue = new ObjectValue(null);
        _result.connectNotify(function (result :Try) :void {
            if (result == null) {
                return; // source future not yet complete; nothing to do
            } else if (result.isFailure) {
                mapped.value = Try.failure(result.failure);
            } else {
                RFuture(func(result.value)).onComplete(mapped.slot);
            }
        });
        return new RFuture(mapped);
    };

    public function RFuture (result :ValueView) {
        _result = result;
    }

    protected static function addToSequenceCallback (seq :Sequencer, idx :int) :Function {
        return function (result :Try) :void {
            seq.onResult(idx, result);
        }
    }

    protected var _result :ValueView; // ValueView<Try>
    protected var _isComplete :BoolView;
}

}

import react.MultiFailureError;
import react.RPromise;
import react.Try;

class Sequencer {
    public function Sequencer (pseq :RPromise, count :int) {
        _pseq = pseq;
        _results = [];
        _results.length = count;
        _remain = count;
    }

    public function onResult (idx :int, result :Try) :void {
        if (result.isSuccess) {
            _results[idx] = result.value;
        } else {
            if (_error == null) {
                _error = new MultiFailureError();
            }
            _error.addFailure(result.failure);
        }

        if (--_remain == 0) {
            if (_error != null) {
                _pseq.fail(_error.consolidate());
            } else {
                _pseq.succeed(_results);
            }
        }
    }

    protected var _pseq :RPromise; // RPromise<Array>
    protected var _results :Array
    protected var _remain :int;
    protected var _error :MultiFailureError;
}
