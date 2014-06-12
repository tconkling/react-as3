//
// React

package react {

/**
 * Implements {@link Connection} and a linked-list style listener list for {@link Reactor}s.
 */
internal class Cons implements Connection
{
    /** The next connection in our chain. */
    public var next :Cons;

    public function Cons (owner :Reactor, listener :RListener) {
        _owner = owner;
        _listener = listener;
    }

    /** Indicates whether this connection is one-shot or persistent. */
    public final function oneShot () :Boolean {
        return _oneShot;
    }

    /** Returns the listener for this cons cell. */
    public function get listener () :RListener {
        return _listener;
    }

    public function close () :void {
        // multiple disconnects are OK, we just NOOP after the first one
        if (_owner != null) {
            _owner.removeCons(this);
            _owner = null;
            _listener = null;
        }
    }

    public function once () :Connection {
        _oneShot = true;
        return this;
    }

    public function atPriority (priority :int) :Connection {
        if (_owner == null) {
            throw new Error("Cannot change priority of disconnected connection.");
        }
        _owner.removeCons(this);
        next = null;
        _priority = priority;
        _owner.addCons(this);
        return this;
    }

    internal static function insert (head :Cons, cons :Cons) :Cons {
        if (head == null) {
            return cons;
        } else if (cons._priority > head._priority) {
            cons.next = head;
            return cons;
        } else {
            head.next = insert(head.next, cons);
            return head;
        }
    }

    internal static function remove (head :Cons, cons :Cons) :Cons {
        if (head == null) {
            return head;
        } else if (head == cons) {
            return head.next;
        } else {
            head.next = remove(head.next, cons);
            return head;
        }
    }

    internal static function removeAll (head :Cons, listener :Function) :Cons {
        if (head == null) {
            return null;
        } else if (head.listener.f == listener) {
            return removeAll(head.next, listener);
        } else {
            head.next = removeAll(head.next, listener);
            return head;
        }
    }

    private var _owner :Reactor;
    private var _listener :RListener;
    private var _oneShot :Boolean;
    private var _priority :int;
}
}
