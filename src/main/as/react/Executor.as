//
// react-as3

package react {

/**
 * An object that executes "tasks" which take time to complete. Allows controlling the number of
 * concurrently-executing tasks.
 */
public class Executor {
    /**
     * Number of tasks that can run concurrently on this Executor.
     * If maxSimultaneous <= 0, there is no concurrency limit.
     */
    public var maxSimultaneous :int;

    public function Executor (maxSimultaneous :int = 0) {
        this.maxSimultaneous = maxSimultaneous;
    }

    /** Number of tasks currently running on the Exector. */
    public function get numRunning () :uint {
        return _numRunning;
    }

    /** Number of tasks currently pending on the Executor. */
    public function get numPending () :uint {
        return _pending.length;
    }

    /** True if the Executor will immediately run a new task passed to it. */
    public function get hasCapacity () :Boolean {
        return this.maxSimultaneous <= 0 || _numRunning < this.maxSimultaneous;
    }

    /**
     * Submit a Function to the Executor. The Function will be run on the Executor at
     * some point in the future. If the submitted Function returns a Future, that Future's
     * result will be flat-mapped onto the returned Future. Otherwise, the returned Future
     * will succeed with the output of the function, or fail with any Error thrown by the Function.
     */
    public function submit (f :Function) :Future {
        var task :ExecutorTask = new ExecutorTask(f);
        _pending.unshift(task);
        runNextIfAvailable();
        return task.promise;
    }

    private function runNextIfAvailable () :void {
        if (_pending.length > 0 && this.hasCapacity) {
            runTask(_pending.pop());
        }
    }

    private function runTask (task :ExecutorTask) :void {
        _numRunning++;
        var val :*;
        try {
            val = task.func();
        } catch (e :Error) {
            task.promise.fail(e);
            _numRunning--;
            runNextIfAvailable();
            return;
        }

        var futureVal :Future = (val as Future);
        if (futureVal != null) {
            futureVal.onComplete(function (result :Try) :void {
                if (result.isSuccess) {
                    task.promise.succeed(result.value);
                } else {
                    task.promise.fail(result.failure);
                }
                _numRunning--;
                runNextIfAvailable();
            });

        } else {
            task.promise.succeed(val);
            _numRunning--;
            runNextIfAvailable();
        }
    }

    private var _numRunning :uint;
    private var _pending :Vector.<ExecutorTask> = new <ExecutorTask>[];
}
}

import react.Promise;

class ExecutorTask {
    public const promise :Promise = new Promise();
    public var func :Function;

    public function ExecutorTask (func :Function) {
        this.func = func;
    }
}
