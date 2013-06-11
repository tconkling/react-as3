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
    public static function create (source :ValueView, f :Function) :MappedValue {
        return new MappedValueImpl(source, f);
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
            _conn.disconnect();
            _conn = null;
        }
    }

    protected var _conn :Connection
}
}

import react.Connection;
import react.MappedValue;
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
