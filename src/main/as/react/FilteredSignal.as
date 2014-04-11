//
// react-as3

package react {

public class FilteredSignal extends MappedSignal {
    public function FilteredSignal (source :SignalView, pred :Function) {
        _source = source;
        _pred = pred;
    }

    override protected function connectToSource () :Connection {
        return _source.connect(onSourceEmit);
    }

    protected function onSourceEmit (value :Object) :void {
        if (_pred(value)) {
            notifyEmit(value);
        }
    }

    protected var _source :SignalView;
    protected var _pred :Function;
}
}
