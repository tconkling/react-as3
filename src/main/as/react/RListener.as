//
// React

package react {

import flash.errors.IllegalOperationError;

public /*abstract*/ class RListener
{
    public static function create (f :Function) :RListener {
        switch (f.length) {
        case 2: return new RListener2(f);
        case 1: return new RListener1(f);
        default: return new RListener0(f);
        }
    }

    public function onEmit (val :Object) :void {
        throw new IllegalOperationError("abstract");
    }

    public function onChange (val1 :Object, val2 :Object) :void {
        throw new IllegalOperationError("abstract");
    }

    public function RListener (f :Function) {
        _f = f;
    }

    internal function get f () :Function {
        return _f;
    }

    protected var _f :Function;
}

}

import react.RListener;

class RListener0 extends RListener {
    public function RListener0 (f :Function) {
        super(f);
    }

    override public function onEmit (val :Object) :void {
        _f();
    }

    override public function onChange (val1 :Object, val2 :Object) :void {
        _f();
    }
}

class RListener1 extends RListener {
    public function RListener1 (f :Function) {
        super(f);
    }

    override public function onEmit (val :Object) :void {
        _f(val);
    }

    override public function onChange (val1 :Object, val2 :Object) :void {
        _f(val1);
    }
}

class RListener2 extends RListener {
    public function RListener2 (f :Function) {
        super(f);
    }

    override public function onEmit (val :Object) :void {
        _f(val, undefined);
    }

    override public function onChange (val1 :Object, val2 :Object) :void {
        _f(val1, val2);
    }
}
