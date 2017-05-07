//
// react-test

package react {

import flash.display.Sprite;

public class ReactTest extends Sprite
{
    public function ReactTest() {
        registrationGroupTest();
        signalTest();
        valueTest();
        futureTest();

        trace("all tests passed");
    }

    private function registrationGroupTest () :void {
        var group :RegistrationGroup = new RegistrationGroup();
        var sig :UnitSignal = new UnitSignal();
        var counter :Counter = new Counter();
        group.add(sig.connect(counter.slot));
        sig.emit();
        group.close();
        sig.emit();

        counter.assertTriggered(1, "RegistrationGroup close all connections");
    }

    private function signalTest () :void {
        var suite :SignalTest = new SignalTest();
        suite.testSignalToSlot();
        suite.testOneShotSlot();
        suite.testSlotPriority();
        suite.testAddDuringDispatch();
        suite.testRemoveDuringDispatch();
        suite.testAddAndRemoveDuringDispatch();
        suite.testUnitSlot();
        suite.testSingleFailure();
        suite.testMultiFailure();
        suite.testMappedSignal();
    }

    private function valueTest () :void {
        var suite :ValueTest = new ValueTest();
        suite.testSimpleListener();
        suite.testAsSignal();
        suite.testAsOnceSignal();
        suite.testMappedValue();
        suite.testConnectNotify();
        suite.testListenNotify();
        suite.testDisconnect();
        suite.testSlot();
    }

    private function futureTest () :void {
        var suite :FutureTest = new FutureTest();
        suite.testImmediate();
        suite.testDeferred();
        suite.testMappedImmediate();
        suite.testMappedDeferred();
        suite.testFlatMapValues();
        suite.testFlatMappedImmediate();
        suite.testFlatMappedDeferred();
        suite.testFlatMappedDoubleDeferred();
        suite.testSequenceImmediate();
        suite.testSequenceDeferred();
        suite.testCollectEmpty();
        suite.testCollectImmediate();
        suite.testCollectDeferred();
    }
}
}
