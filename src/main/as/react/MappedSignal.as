//
// react

package react {

import flash.errors.IllegalOperationError;

/**
 * Plumbing to implement mapped signals in such a way that they automatically manage a connection
 * to their underlying signal. When the mapped signal adds its first connection, it establishes a
 * connection to the underlying signal, and when it removes its last connection it clears its
 * connection from the underlying signal.
 */
public /*abstract*/ class MappedSignal extends AbstractSignal
{
    public static function create (source :SignalView, f :Function) :MappedSignal {
        return new MappedSignalImpl(source, f);
    }

    /**
     * Establishes a connection to our source signal. Called when we go from zero to one listeners.
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
import react.MappedSignal;
import react.SignalView;

class MappedSignalImpl extends MappedSignal {
    public function MappedSignalImpl (source :SignalView, f :Function) {
        _source = source;
        _f = f;
    }

    override protected function connectToSource () :Connection {
        return _source.connect(onSourceEmit);
    }

    protected function onSourceEmit (value :Object) :void {
        notifyEmit(_f(value));
    }

    protected var _source :SignalView;
    protected var _f :Function;
}
