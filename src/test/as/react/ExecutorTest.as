//
// react-as3

package react {

public class ExecutorTest {
    public function testSubmitImmediate () :void {
        var exec :Executor = new Executor(1);
        assertExecState(exec, 0, 0, true);

        var successValue :* = null;
        exec.submit(function () :String {
            return "Yay";
        }).onSuccess(function (value :*) :void {
            successValue = value;
        });

        assertExecState(exec, 0, 0, true);
        Assert.equals(successValue, "Yay");

        var failureValue :* = null;
        exec.submit(function () :String {
            throw new TestError("Boo!");
        }).onFailure(function (err :*) :void {
            failureValue = err;
        });

        assertExecState(exec, 0, 0, true);
        Assert.equals(failureValue, new TestError("Boo!"));
    }

    public function testSubmitFuture () :void {
        var exec :Executor = new Executor(1);

        var successValue :* = null;
        var successPromise :Promise = new Promise();
        exec.submit(function () :Future {
            return successPromise;
        }).onSuccess(function (value :*) :void {
            successValue = value;
        });

        assertExecState(exec, 1, 0, false);
        Assert.equals(successValue, null);

        successPromise.succeed("Yay");
        assertExecState(exec, 0, 0, true);
        Assert.equals(successValue, "Yay");

        var failValue :* = null;
        var failPromise :Promise = new Promise();
        exec.submit(function () :Future {
            return failPromise;
        }).onFailure(function (value :*) :void {
            failValue = value;
        });

        assertExecState(exec, 1, 0, false);
        Assert.equals(failValue, null);

        failPromise.fail("Boo!");
        assertExecState(exec, 0, 0, true);
        Assert.equals(failValue, "Boo!");
    }

    public function testSubmitMany () :void {
        var exec :Executor = new Executor(2);
        var p1 :Promise = new Promise();
        var p2 :Promise = new Promise();
        var p3 :Promise = new Promise();
        var p4 :Promise = new Promise();

        exec.submit(wrap(p1));
        exec.submit(wrap(p2));

        var val3 :* = null;
        exec.submit(wrap(p3)).onSuccess(function (value :*) :void {
            val3 = value;
        });

        var val4 :* = null;
        exec.submit(wrap(p4)).onSuccess(function (value :*) :void {
            val4 = value;
        });

        assertExecState(exec, 2, 2, false);
        Assert.equals(val3, null);
        Assert.equals(val4, null);

        p4.succeed("Yay4!");

        // p1, p2 running; p3, p4 pending
        assertExecState(exec, 2, 2, false);
        Assert.equals(val3, null);
        Assert.equals(val4, null);

        // p1, p3 running; p2 complete; p4 pending
        p2.succeed("Yay2!");

        assertExecState(exec, 2, 1, false);
        Assert.equals(val3, null);
        Assert.equals(val4, null);

        // p1 running; p2, p3, p4 complete; nobody pending
        p3.succeed("Yay3!");

        assertExecState(exec, 1, 0, true);
        Assert.equals(val3, "Yay3!");
        Assert.equals(val4, "Yay4!");

        p1.succeed("Yay1!");

        // Everyone is complete
        assertExecState(exec, 0, 0, true);
    }

    private static function wrap (f :Future) :Function {
        return function () :Future {
            return f;
        };
    }

    private static function assertExecState (exec :Executor, numRunning :uint, numPending :uint, hasCapacity :Boolean) :void {
        Assert.equals(exec.numRunning, numRunning);
        Assert.equals(exec.numPending, numPending);
        Assert.equals(exec.hasCapacity, hasCapacity);
    }
}
}
