//
// React

package react {

/**
 * Tests basic signals and slots behavior.
 */
public class SignalTest
{
    public static function require (reqValue :Object) :Slot {
        return Slot.create(function (value :Object) :void {
            assertEquals(reqValue, value);
        });
    }

    public function testSignalToSlot () :void {
        var signal :Signal = new Signal();
        var slot :AccSlot = new AccSlot();
        signal.connect(slot);
        signal.emit(1);
        signal.emit(2);
        signal.emit(3);
        assertEquals(new <Object>[1, 2, 3], slot.events);
    }

    public function testOneShotSlot () :void {
        var signal :Signal = new Signal();
        var slot :AccSlot = new AccSlot();
        signal.connect(slot).once();
        signal.emit(1); // slot should be removed after this emit
        signal.emit(2);
        signal.emit(3);
        assertEquals(new <Object>[1], slot.events);
    }

    public function testSlotPriority () :void {
        var counter :Object = { val: 0 };
        var slot1 :PriorityTestSlot = new PriorityTestSlot(counter);
        var slot2 :PriorityTestSlot = new PriorityTestSlot(counter);
        var slot3 :PriorityTestSlot = new PriorityTestSlot(counter);
        var slot4 :PriorityTestSlot = new PriorityTestSlot(counter);

        var signal :UnitSignal = new UnitSignal();
        signal.connect(slot3).atPriority(3);
        signal.connect(slot1).atPriority(1);
        signal.connect(slot2).atPriority(2);
        signal.connect(slot4).atPriority(4);
        signal.emit();
        assertEquals(1, slot1.order);
        assertEquals(2, slot2.order);
        assertEquals(3, slot3.order);
        assertEquals(4, slot4.order);
    }

    public function testAddDuringDispatch () :void {
        var signal :Signal = new Signal();
        var toAdd :AccSlot = new AccSlot();

        signal.connect(UnitSlot.create(function () :void {
            signal.connect(toAdd);
        })).once();

        // this will connect our new signal but not dispatch to it
        signal.emit(5);
        assertEquals(0, toAdd.events.length)

        // now dispatch an event that should go to the added signal
        signal.emit(42);
        assertEquals(new <Object>[42], toAdd.events);
    }

    public function testRemoveDuringDispatch () :void {
        var signal :Signal = new Signal();
        var toRemove :AccSlot = new AccSlot();
        var rconn :Connection = signal.connect(toRemove);

        // dispatch one event and make sure it's received
        signal.emit(5);
        assertEquals(new <Object>[5], toRemove.events);

        // now add our removing signal, and dispatch again
        signal.connect(UnitSlot.create(function () :void {
            rconn.disconnect();
        })).atPriority(1); // ensure that we're before toRemove
        signal.emit(42);

        // since toRemove will have been removed during this dispatch, it will receive the signal
        // in question, even though the higher priority signal triggered first
        assertEquals(new <Object>[5, 42], toRemove.events);
        // finally dispatch one more event and make sure toRemove didn't get it
        signal.emit(9);
        assertEquals(new <Object>[5, 42], toRemove.events);
    }

    public function testAddAndRemoveDuringDispatch () :void {
        var signal :Signal = new Signal();
        var toAdd :AccSlot = new AccSlot();
        var toRemove :AccSlot = new AccSlot();
        var rconn :Connection = signal.connect(toRemove);

        // dispatch one event and make sure it's received by toRemove
        signal.emit(5);
        assertEquals(new <Object>[5], toRemove.events);

        // now add our adder/remover signal, and dispatch again
        signal.connect(UnitSlot.create(function () :void {
            rconn.disconnect();
            signal.connect(toAdd);
        }));
        signal.emit(42);
        // make sure toRemove got this event and toAdd didn't
        assertEquals(new <Object>[5, 42], toRemove.events);
        assertEquals(0, toAdd.events.length);

        // finally emit one more and ensure that toAdd got it and toRemove didn't
        signal.emit(9);
        assertEquals(new <Object>[9], toAdd.events);
        assertEquals(new <Object>[5, 42], toRemove.events);
    }

    public function testUnitSlot () :void {
        var signal :Signal = new Signal();
        var fired :Boolean = false;
        signal.connect(UnitSlot.create(function () :void {
            fired = true;
        }));
        signal.emit(42);
        assert(fired);
    }

    public function testSingleFailure () :void {
        assertThrows(function () :void {
            var signal :UnitSignal = new UnitSignal();
            signal.connect(UnitSlot.create(function () :void {
                throw new Error("Bang!");
            }));
            signal.emit();
        });
    }

    public function testMultiFailure () :void {
        assertThrows(function () :void {
            var signal :UnitSignal = new UnitSignal();
            signal.connect(UnitSlot.create(function () :void {
                throw new Error("Bing!");
            }));
            signal.connect(UnitSlot.create(function () :void {
                throw new Error("Bang!");
            }));
            signal.emit();
        }, MultiFailureError);
    }

    public function testMappedSignal () :void {
        var signal :Signal = new Signal();
        var mapped :SignalView = signal.map(toString);

        var counter :Counter = new Counter();
        var c1 :Connection = mapped.connect(counter);
        var c2 :Connection = mapped.connect(SignalTest.require("15"));

        signal.emit(15);
        assertEquals(1, counter.notifies);
        signal.emit(15);
        assertEquals(2, counter.notifies);

        // disconnect from the mapped signal and ensure that it clears its connection
        c1.disconnect();
        c2.disconnect();
        assert(!signal.hasConnections);
    }
}

}

import react.Slot;
import react.UnitSlot;

class AccSlot extends Slot {
    public var events :Vector.<Object> = new Vector.<Object>();
    override public function onEmit (event :Object) :void {
        events.push(event);
    }
}

class PriorityTestSlot extends UnitSlot {
    public var order :int;
    public var counter :Object;

    public function PriorityTestSlot (counter :Object) {
        super(function () :void {});
        this.counter = counter;
    }

    override public function onEmit (event :Object) :void {
        order = ++(counter.val);
    }
}
