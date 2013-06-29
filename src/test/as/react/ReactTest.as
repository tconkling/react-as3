//
// react-test

package react {

import flash.display.Sprite;

public class ReactTest extends Sprite
{
    public function ReactTest() {
        signalTest();
        valueTest();
        futureTest();
    }

    protected function signalTest () :void {
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

    protected function valueTest () :void {
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

    protected function futureTest () :void {
        var suite :RFutureTest = new RFutureTest();
        suite.testImmediate();
        suite.testDeferred();
        suite.testMappedImmediate();
        suite.testMappedDeferred();
        suite.testFlatMappedImmediate();
        suite.testFlatMappedDeferred();
        suite.testFlatMappedDoubleDeferred();
        suite.testSequenceImmediate();
        suite.testSequenceDeferred();
    }
}
}
