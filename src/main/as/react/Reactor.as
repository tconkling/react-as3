//
// React

package react {

/**
 * A base class for all reactive classes. This is an implementation detail, but is public so that
 * third parties may use it to create their own reactive classes, if desired.
 */
public /*abstract*/ class Reactor
{
    /**
     * Returns true if this reactor has at least one connection.
     */
    public function get hasConnections () :Boolean {
        return _listeners != null;
    }

    public function addConnection (listener :RListener) :Cons {
        if (listener == null) {
            throw new ArgumentError("Null listener");
        }
        return addCons(new Cons(this, listener));
    }

    public function addCons (cons :Cons) :Cons {
        if (this.isDispatching) {
            _pendingRuns = insert(_pendingRuns, new Runs(function () :void {
                _listeners = Cons.insert(_listeners, cons);
                connectionAdded();
            }));
        } else {
            _listeners = Cons.insert(_listeners, cons);
            connectionAdded();
        }
        return cons;
    }

    public function removeCons (cons :Cons) :void {
        if (this.isDispatching) {
            _pendingRuns = insert(_pendingRuns, new Runs(function () :void {
                _listeners = Cons.remove(_listeners, cons);
                connectionRemoved();
            }));
        } else {
            _listeners = Cons.remove(_listeners, cons);
            connectionRemoved();
        }
    }

    protected function prepareNotify () :Cons {
        if (_listeners == DISPATCHING) {
            throw new Error("Initiated notify while notifying");
        }
        var lners :Cons = _listeners;
        _listeners = DISPATCHING;
        return lners;
    }

    protected function finishNotify (lners :Cons) :void {
        // note that we're no longer dispatching
        _listeners = lners;

        // now remove listeners any queued for removing and add any queued for adding
        for (; _pendingRuns != null; _pendingRuns = _pendingRuns.next) {
            _pendingRuns.action();
        }
    }

    protected function removeConnection (listener :RListener) :void {
        if (this.isDispatching) {
            _pendingRuns = insert(_pendingRuns, new Runs(function () :void {
                _listeners = Cons.removeAll(_listeners, listener);
                connectionRemoved();
            }));
        } else {
            _listeners = Cons.removeAll(_listeners, listener);
            connectionRemoved();
        }
    }

    /**
     * Called prior to mutating any underlying model; allows subclasses to reject mutation.
     */
    protected function checkMutate () :void {
        // noop
    }

    /**
     * Called when a connection has been added to this reactor.
     */
    protected function connectionAdded () :void {
        // noop
    }

    /**
     * Called when a connection may have been removed from this reactor.
     */
    protected function connectionRemoved () :void {
        // noop
    }

    protected static function insert (head :Runs, action :Runs) :Runs {
        if (head == null) {
            return action;
        } else {
            head.next = insert(head.next, action);
            return head;
        }
    }

    // always called while lock is held on this reactor
    private function get isDispatching () :Boolean {
        return _listeners == DISPATCHING;
    }

    protected var _listeners :Cons;
    protected var _pendingRuns :Runs;

    protected static const DISPATCHING :Cons = new Cons(null, null);
}

}

class Runs {
    public var next :Runs;
    public var action :Function;

    public function Runs (action :Function) {
        this.action = action;
    }
}
