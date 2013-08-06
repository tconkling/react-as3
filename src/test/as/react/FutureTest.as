//
// React-Test

package react {

public class FutureTest
{
    public function testImmediate () :void {
        const counter :FutureCounter = new FutureCounter();

        const success :Future = Future.success("Yay!");
        counter.bind(success);
        counter.check("immediate succeed", 1, 0, 1);

        const failure :Future = Future.failure(new Error("Boo!"));
        counter.bind(failure);
        counter.check("immediate failure", 0, 1, 1);
    }

    public function testDeferred () :void {
        const counter :FutureCounter = new FutureCounter();

        const success :Promise = new Promise();
        counter.bind(success);
        counter.check("before succeed", 0, 0, 0);
        success.succeed("Yay!");
        counter.check("after succeed", 1, 0, 1);

        const failure :Promise = new Promise();
        counter.bind(failure);
        counter.check("before fail", 0, 0, 0);
        failure.fail(new Error("Boo!"));
        counter.check("after fail", 0, 1, 1);

        assertFalse(success.hasConnections);
        assertFalse(failure.hasConnections);
    }

    public function testMappedImmediate () :void {
        const counter :FutureCounter = new FutureCounter();

        const success :Future = Future.success("Yay!");
        counter.bind(success.map(Functions.NON_NULL));
        counter.check("immediate succeed", 1, 0, 1);

        const failure :Future = Future.failure(new Error("Boo!"));
        counter.bind(failure.map(Functions.NON_NULL));
        counter.check("immediate failure", 0, 1, 1);
    }

    public function testMappedDeferred () :void {
        const counter :FutureCounter = new FutureCounter();

        const success :Promise = new Promise();
        counter.bind(success.map(Functions.NON_NULL));
        counter.check("before succeed", 0, 0, 0);
        success.succeed("Yay!");
        counter.check("after succeed", 1, 0, 1);

        const failure :Promise = new Promise();
        counter.bind(failure.map(Functions.NON_NULL));
        counter.check("before fail", 0, 0, 0);
        failure.fail(new Error("Boo!"));
        counter.check("after fail", 0, 1, 1);

        assertFalse(success.hasConnections);
        assertFalse(failure.hasConnections);
    }

    public function testFlatMappedImmediate () :void {
        const scounter :FutureCounter = new FutureCounter();
        const fcounter :FutureCounter = new FutureCounter();

        const success :Future = Future.success("Yay!");
        scounter.bind(success.flatMap(SUCCESS_MAP));
        fcounter.bind(success.flatMap(FAIL_MAP));
        scounter.check("immediate success/success", 1, 0, 1);
        fcounter.check("immediate success/failure", 0, 1, 1);

        const failure :Future = Future.failure(new Error("Boo!"));
        scounter.bind(failure.flatMap(SUCCESS_MAP));
        fcounter.bind(failure.flatMap(FAIL_MAP));
        scounter.check("immediate failure/success", 0, 1, 1);
        scounter.check("immediate failure/failure", 0, 1, 1);
    }

    public function testFlatMappedDeferred () :void {
        const scounter :FutureCounter = new FutureCounter();
        const fcounter :FutureCounter = new FutureCounter();

        const success :Promise = new Promise();
        scounter.bind(success.flatMap(SUCCESS_MAP));
        scounter.check("before succeed/succeed", 0, 0, 0);
        fcounter.bind(success.flatMap(FAIL_MAP));
        fcounter.check("before succeed/fail", 0, 0, 0);
        success.succeed("Yay!");
        scounter.check("after succeed/succeed", 1, 0, 1);
        fcounter.check("after succeed/fail", 0, 1, 1);

        const failure :Promise = new Promise();
        scounter.bind(failure.flatMap(SUCCESS_MAP));
        fcounter.bind(failure.flatMap(FAIL_MAP));
        scounter.check("before fail/success", 0, 0, 0);
        fcounter.check("before fail/failure", 0, 0, 0);
        failure.fail(new Error("Boo!"));
        scounter.check("after fail/success", 0, 1, 1);
        fcounter.check("after fail/failure", 0, 1, 1);

        assertFalse(success.hasConnections);
        assertFalse(failure.hasConnections);
    }

    public function testFlatMappedDoubleDeferred () :void {
        const scounter :FutureCounter = new FutureCounter();
        const fcounter :FutureCounter = new FutureCounter();

        {   const success :Promise = new Promise();
            const innerSuccessSuccess :Promise = new Promise();
            scounter.bind(success.flatMap(function (value :String) :Future {
                return innerSuccessSuccess;
            }));
            scounter.check("before succeed/succeed", 0, 0, 0);
            const innerSuccessFailure :Promise = new Promise();
            fcounter.bind(success.flatMap(function (value :String) :Future {
                return innerSuccessFailure;
            }));
            fcounter.check("before succeed/fail", 0, 0, 0);

            success.succeed("Yay!");
            scounter.check("after first succeed/succeed", 0, 0, 0);
            fcounter.check("after first succeed/fail", 0, 0, 0);
            innerSuccessSuccess.succeed(true);
            scounter.check("after second succeed/succeed", 1, 0, 1);
            innerSuccessFailure.fail(new Error("Boo hoo!"));
            fcounter.check("after second succeed/fail", 0, 1, 1);

            assertFalse(success.hasConnections);
            assertFalse(innerSuccessSuccess.hasConnections);
            assertFalse(innerSuccessFailure.hasConnections);
        }

        {
            const failure :Promise = new Promise();
            const innerFailureSuccess :Promise = new Promise();
            scounter.bind(failure.flatMap(function (value :String) :Future {
                return innerFailureSuccess;
            }));
            scounter.check("before fail/succeed", 0, 0, 0);
            const innerFailureFailure :Promise = new Promise();
            fcounter.bind(failure.flatMap(function (value :String) :Future {
                return innerFailureFailure;
            }));
            fcounter.check("before fail/fail", 0, 0, 0);

            failure.fail(new Error("Boo!"));
            scounter.check("after first fail/succeed", 0, 1, 1);
            fcounter.check("after first fail/fail", 0, 1, 1);
            innerFailureSuccess.succeed(true);
            scounter.check("after second fail/succeed", 0, 1, 1);
            innerFailureFailure.fail(new Error("Is this thing on?"));
            fcounter.check("after second fail/fail", 0, 1, 1);

            assertFalse(failure.hasConnections);
            assertFalse(innerFailureSuccess.hasConnections);
            assertFalse(innerFailureFailure.hasConnections);
        }
    }

    public function testSequenceImmediate () :void {
        const counter :FutureCounter = new FutureCounter();

        const success1 :Future = Future.success("Yay 1!");
        const success2 :Future = Future.success("Yay 2!");

        const failure1 :Future = Future.failure(new Error("Boo 1!"));
        const failure2 :Future = Future.failure(new Error("Boo 2!"));

        const sucseq :Future = Future.sequence([success1, success2]);
        counter.bind(sucseq);
        sucseq.onSuccess(function (results :Array) :void {
            assertEquals(results.length, 2);
            assertEquals(results[0], "Yay 1!");
            assertEquals(results[1], "Yay 2!");
        });
        counter.check("immediate seq success/success", 1, 0, 1);

        counter.bind(Future.sequence([success1, failure1]));
        counter.check("immediate seq success/failure", 0, 1, 1);

        counter.bind(Future.sequence([failure1, success2]));
        counter.check("immediate seq failure/success", 0, 1, 1);

        counter.bind(Future.sequence([failure1, failure2]));
        counter.check("immediate seq failure/failure", 0, 1, 1);
    }

    public function testSequenceDeferred () :void {
        const counter :FutureCounter = new FutureCounter();

        const success1 :Promise = new Promise(), success2 :Promise = new Promise();
        const failure1 :Promise = new Promise(), failure2 :Promise = new Promise();

        const suc2seq :Future = Future.sequence([success1, success2]);
        counter.bind(suc2seq);
        suc2seq.onSuccess(function (results :Array) :void {
            assertEquals(results.length, 2);
            assertEquals(results[0], "Yay 1!");
            assertEquals(results[1], "Yay 2!");
        });
        counter.check("before seq succeed/succeed", 0, 0, 0);
        success1.succeed("Yay 1!");
        success2.succeed("Yay 2!");
        counter.check("after seq succeed/succeed", 1, 0, 1);

        const sucfailseq :Future = Future.sequence([success1, failure1]);
        sucfailseq.onFailure(function (cause :Error) :void {
            assert(cause is MultiFailureError);
            assertEquals("1 failure: Error: Boo 1!", cause.message);
        });
        counter.bind(sucfailseq);
        counter.check("before seq succeed/fail", 0, 0, 0);
        failure1.fail(new Error("Boo 1!"));
        counter.check("after seq succeed/fail", 0, 1, 1);

        const failsucseq :Future = Future.sequence([failure1, success2]);
        failsucseq.onFailure(function (cause :Error) :void {
            assert(cause is MultiFailureError);
            assertEquals("1 failure: Error: Boo 1!", cause.message);
        });
        counter.bind(failsucseq);
        counter.check("after seq fail/succeed", 0, 1, 1);

        const fail2seq :Future = Future.sequence([failure1, failure2]);
        fail2seq.onFailure(function (cause :Error) :void {
            assert(cause is MultiFailureError);
            assertEquals("2 failures: Error: Boo 1!, Error: Boo 2!", MultiFailureError(cause).getMessage());
        });
        counter.bind(fail2seq);
        counter.check("before seq fail/fail", 0, 0, 0);
        failure2.fail(new Error("Boo 2!"));
        counter.check("after seq fail/fail", 0, 1, 1);
    }

    protected static function SUCCESS_MAP (value :String) :Future {
        return Future.success(value != null);
    }
    protected static function FAIL_MAP (value :String) :Future {
        return Future.failure(new Error("Barzle!"));
    }
}

}

import react.Counter;
import react.Future;

class FutureCounter {
    public const successes :Counter = new Counter();
    public const failures :Counter = new Counter();
    public const completes :Counter = new Counter();

    public function bind (future :Future) :void {
        reset();
        future.onSuccess(successes.slot);
        future.onFailure(failures.slot);
        future.onComplete(completes.slot);
    }

    public function check (state :String, scount :int, fcount :int, ccount :int) :void {
        successes.assertTriggered(scount, "Successes " + state);
        failures.assertTriggered(fcount, "Failures " + state);
        completes.assertTriggered(ccount, "Completes " + state);
    }

    public function reset () :void {
        successes.reset();
        failures.reset();
        completes.reset();
    }
}
