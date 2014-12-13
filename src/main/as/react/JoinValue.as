//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Plumbing to implement "join" values -- values that are dependent on multiple underlying
 * source values -- in such a way that they automatically manage a connection
 * to their underlying values. When the JoinValue adds its first connection, it establishes a
 * connection to each underlying value, and when it removes its last connection it clears its
 * connection from each underlying value.
 */
public class JoinValue extends AbstractValue
{
    /** Mapping function that computes the 'and' of its boolean sources */
    public static const AND :Function = function (sources :Array) :Boolean {
        for each (var source :ValueView in sources) {
            if (!Boolean(source.get())) {
                return false;
            }
        }
        return true;
    };

    /** Mapping function that computes the 'or' of its boolean sources */
    public static const OR :Function = function (sources :Array) :Boolean {
        for each (var source :ValueView in sources) {
            if (Boolean(source.get())) {
                return true;
            }
        }
        return false;
    };

    /** Mapping function that computes the sum of its numeric sources */
    public static const SUM :Function = function (sources :Array) :Number {
        var sum :Number = 0;
        for each (var source :ValueView in sources) {
            sum += source.get();
        }
        return sum;
    };

    public static function create (sources :Array, map :Function) :ValueView {
        return new JoinValueImpl(sources, map);
    }

    public static function boolView (sources :Array, map :Function) :BoolView {
        return new JoinBool(sources, map);
    }

    public static function intView (sources :Array, map :Function) :IntView {
        return new JoinInt(sources, map);
    }

    public static function uintView (sources :Array, map :Function) :UintView {
        return new JoinUint(sources, map);
    }

    public static function numberView (sources :Array, map :Function) :NumberView {
        return new JoinNumber(sources, map);
    }

    public static function objectView (sources :Array, map :Function) :ObjectView {
        return new JoinObject(sources, map);
    }

    /**
     * Establishes a connection to our source value. Called when we go from zero to one listeners.
     * When we go from one to zero listeners, the connection will automatically be cleared.
     *
     * @return a vector of the newly established connections.
     */
    protected /*abstract*/ function connectToSources () :Vector.<Connection> {
        throw new IllegalOperationError("abstract");
    }

    override protected function connectionAdded () :void {
        super.connectionAdded();
        if (_conns == null) {
            _conns = connectToSources();
        }
    }

    override protected function connectionRemoved () :void {
        super.connectionRemoved();
        if (!this.hasConnections && _conns != null) {
            for each (var conn :Connection in _conns) {
                conn.close();
            }
            _conns = null;
        }
    }

    protected var _conns :Vector.<Connection>;
}
}

import react.BoolView;
import react.Connection;
import react.IntView;
import react.JoinValue;
import react.NumberView;
import react.ObjectView;
import react.UintView;
import react.ValueView;

class JoinValueImpl extends JoinValue {
    public function JoinValueImpl (sources :Array, f :Function) {
        _sources = sources;
        _f = f;
    }

    override public function get () :* {
        // If we don't have connections, we need to update every time we're called,
        // since we're not being notified when underlying values change.
        return (this.hasConnections ? _curValue : update());
    }

    protected function update () :* {
        return (_f.length == 0 ? _f() : _f(_sources));
    }

    override protected function connectToSources () :Vector.<Connection> {
        var out :Vector.<Connection> = new Vector.<Connection>(_sources.length, true);
        for (var ii :int = 0; ii < _sources.length; ++ii) {
            out[ii] = ValueView(_sources[ii]).connect(onSourceChange);
        }
        _curValue = update();
        return out;
    }

    protected function onSourceChange (value :Object, ovalue :Object) :void {
        var newVal :* = update();
        if (newVal != _curValue) {
            var oldVal :* = _curValue;
            _curValue = newVal;
            notifyChange(_curValue, oldVal);
        }
    }

    protected static function GET (view :ValueView, _ :int, __ :Array) :* {
        return view.get();
    }

    protected var _sources :Array;
    protected var _curValue :* = undefined;
    protected var _f :Function;
}

class JoinBool extends JoinValueImpl implements BoolView {
    public function JoinBool (sources :Array, f :Function) {
        super(sources, f);
    }

    public function get value () :Boolean {
        return get();
    }
}

class JoinInt extends JoinValueImpl implements IntView {
    public function JoinInt (sources :Array, f :Function) {
        super(sources, f);
    }

    public function get value () :int {
        return get();
    }
}

class JoinUint extends JoinValueImpl implements UintView {
    public function JoinUint (sources :Array, f :Function) {
        super(sources, f);
    }

    public function get value () :uint {
        return get();
    }
}

class JoinNumber extends JoinValueImpl implements NumberView {
    public function JoinNumber (sources :Array, f :Function) {
        super(sources, f);
    }

    public function get value () :Number {
        return get();
    }
}

class JoinObject extends JoinValueImpl implements ObjectView {
    public function JoinObject (sources :Array, f :Function) {
        super(sources, f);
    }

    public function get value () :* {
        return get();
    }
}
