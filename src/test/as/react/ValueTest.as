//
// React

package react {

/**
 * Tests aspects of the {@link Value} class.
 */
public class ValueTest
{
    public function testSimpleListener () :void {
        var value :IntValue = new IntValue(42);
        var fired :Boolean = false;
        value.connect(function (nvalue :int, ovalue :int) :void {
            assertEquals(42, ovalue);
            assertEquals(15, nvalue);
            fired = true;
        });

        assertEquals(42, value.update(15));
        assertEquals(15, value.get());
        assert(fired);
    }

    public function testAsSignal () :void {
        var value :IntValue = new IntValue(42);
        var fired :Boolean = false;
        value.connect(function (value :int) :void {
            assertEquals(15, value);
            fired = true;
        });
        value.update(15);
        assert(fired);
    }

    public function testAsOnceSignal () :void {
        var value :IntValue = new IntValue(42);
        var counter :Counter = new Counter();
        value.connect(counter.onEmit).once();
        value.update(15);
        value.update(42);
        assertEquals(1, counter.notifies);
    }

    public function testMappedValue () :void {
        var value :IntValue = new IntValue(42);
        var mapped :ValueView = value.map(toString);

        var counter :Counter = new Counter();
        var c1 :Connection = mapped.connect(counter.onEmit);
        var c2 :Connection = mapped.connect(SignalTest.require("15"));

        value.update(15);
        assertEquals(1, counter.notifies);
        value.update(15);
        assertEquals(1, counter.notifies);
        value.updateForce(15);
        assertEquals(2, counter.notifies);

        // disconnect from the mapped value and ensure that it disconnects in turn
        c1.disconnect();
        c2.disconnect();
        assert(!value.hasConnections);
    }

    public function testConnectNotify () :void {
        var value :IntValue = new IntValue(42);
        var fired :Boolean = false;
        value.connectNotify(function (val :int) :void {
            assertEquals(42, val);
            fired = true;
        });
        assert(fired);
    }

    public function testListenNotify () :void {
        var value :IntValue = new IntValue(42);
        var fired :Boolean = false;
        value.connectNotify(function (val :int) :void {
            assertEquals(42, val);
            fired = true;
        });
        assert(fired);
    }

    public function testDisconnect () :void {
        var value :IntValue = new IntValue(42);
        var expectedValue :int = value.get();
        var fired :int = 0;

        var listener :Function = function (newValue :int) :void {
            assertEquals(expectedValue, newValue);
            fired += 1;
            value.disconnect(listener);
        };

        var conn :Connection = value.connectNotify(listener);
        value.update((expectedValue = 12));
        assertEquals(1, fired, "Disconnecting in listenNotify disconnects");
        conn.disconnect();// Just see what happens when calling disconnect while disconnected

        value.connect(listener);
        value.connect(new Counter().onEmit);
        value.connect(listener);
        value.update((expectedValue = 13));
        value.update((expectedValue = 14));
        assertEquals(3, fired, "Disconnecting in listen disconnects");

        value.connect(listener).disconnect();
        value.update((expectedValue = 15));
        assertEquals(3, fired, "Disconnecting before geting an update still disconnects");
    }

    public function testSlot () :void {
        var value :IntValue = new IntValue(42);
        var expectedValue :int = value.get();
        var fired :int = 0;
        var listener :Function = function (newValue :int) :void {
            assertEquals(expectedValue, newValue);
            fired += 1;
            value.disconnect(listener);
        };
        value.connect(listener);
        value.update((expectedValue = 12));
        assertEquals(1, fired, "Calling disconnect with a slot disconnects");

        value.connect(listener).disconnect();
        value.update((expectedValue = 14));
        assertEquals(1, fired);
    }
}


}
