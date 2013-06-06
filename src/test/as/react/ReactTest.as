//
// react-test

package react {

import flash.display.Sprite;

public class ReactTest extends Sprite
{
    public function ReactTest() {
        signalTest();
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
}
}
