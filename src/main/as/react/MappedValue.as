//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Plumbing to implement mapped values in such a way that they automatically manage a connection to
 * their underlying value. When the mapped value adds its first connection, it establishes a
 * connection to the underlying value, and when it removes its last connection it clears its
 * connection from the underlying value.
 */
public /*abstract*/ class MappedValue extends AbstractValue
{
    public static function create (source :ValueView, map :Function) :MappedValue {
        return new MappedValueImpl(source, map);
    }

    public static function boolView (source :ValueView, map :Function) :BoolView {
        return new MappedBool(source, map);
    }

    public static function intView (source :ValueView, map :Function) :IntView {
        return new MappedInt(source, map);
    }

    public static function uintView (source :ValueView, map :Function) :UintView {
        return new MappedUint(source, map);
    }

    public static function numberView (source :ValueView, map :Function) :NumberView {
        return new MappedNumber(source, map);
    }

    public static function tryView (source :ValueView, map :Function) :TryView {
        return new MappedTry(source, map);
    }

    /**
     * Establishes a connection to our source value. Called when we go from zero to one listeners.
     * When we go from one to zero listeners, the connection will automatically be cleared.
     *
     * @return the newly established connection.
     */
    protected /*abstract*/ function connectToSource () :Connection {
        throw new IllegalOperationError("abstract");
    }

    override protected function connectionAdded () :void {
        super.connectionAdded();
        if (_conn == null) {
            _conn = connectToSource();
        }
    }

    override protected function connectionRemoved () :void {
        super.connectionRemoved();
        if (!this.hasConnections && _conn != null) {
            _conn.close();
            _conn = null;
        }
    }

    protected var _conn :Connection;
}
}

import react.BoolView;
import react.Connection;
import react.IntView;
import react.MappedValue;
import react.NumberView;
import react.Try;
import react.TryView;
import react.UintView;
import react.ValueView;

class MappedValueImpl extends MappedValue {
    public function MappedValueImpl (source :ValueView, f :Function) {
        _source = source;
        _f = f;
    }

    override public function get () :* {
        return _f(_source.get());
    }

    override protected function connectToSource () :Connection {
        return _source.connect(onSourceChange);
    }

    protected function onSourceChange (value :Object, ovalue :Object) :void {
        notifyChange(_f(value), _f(ovalue));
    }

    protected var _source :ValueView;
    protected var _f :Function;
}

class MappedBool extends MappedValueImpl implements BoolView {
    public function MappedBool (source :ValueView, f :Function) {
        super(source, f);
    }

    public function get value () :Boolean {
        return _f(_source.get());
    }
}

class MappedInt extends MappedValueImpl implements IntView {
    public function MappedInt (source :ValueView, f :Function) {
        super(source, f);
    }

    public function get value () :int {
        return _f(_source.get());
    }
}

class MappedUint extends MappedValueImpl implements UintView {
    public function MappedUint (source :ValueView, f :Function) {
        super(source, f);
    }

    public function get value () :uint {
        return _f(_source.get());
    }
}

class MappedNumber extends MappedValueImpl implements NumberView {
    public function MappedNumber (source :ValueView, f :Function) {
        super(source, f);
    }

    public function get value () :Number {
        return _f(_source.get());
    }
}

class MappedTry extends MappedValueImpl implements TryView {
    public function MappedTry (source :ValueView, f :Function) {
        super(source, f);
    }

    public function get value () :Try {
        return _f(_source.get());
    }
}
