//
// React

package react {

/**
 * A view of a {@link AbstractValue} subclass, to which listeners may be added, but which one
 * cannot update. Value consumers should require only a view on a value, rather than a
 * concrete value.
 */
public interface ValueView
{
    /**
     * Returns the current value.
     */
    function get () :*;

    /**
     * Creates a value that maps this value via a function. When this value changes, the mapped
     * listeners will be notified, regardless of whether the new and old mapped values differ. The
     * mapped value will retain a connection to this value for as long as it has connections of its
     * own.
     */
    function map (func :Function) :ValueView;

    /**
     * Creates a BoolView that maps this value via a function.
     */
    function mapToBool (func :Function) :BoolView;

    /**
     * Creates an IntView that maps this value via a function.
     */
    function mapToInt (func :Function) :IntView;

    /**
     * Creates a UintView that maps this value via a function.
     */
    function mapToUint (func :Function) :UintView;

    /**
     * Creates a NumberView that maps this value via a function.
     */
    function mapToNumber (func :Function) :NumberView;

    /**
     * Creates a TryView that maps this value via a function.
     */
    function mapToTry (func :Function) :TryView;

    /**
     * Connects the supplied Function to this value, such that it will be notified when this value
     * changes.
     * @return a connection instance which can be used to cancel the connection.
     */
    function connect (listener :Function) :Connection;

    /**
     * Connects the supplied listener to this value, such that it will be notified when this value
     * changes. Also immediately notifies the listener of the current value. Note that the previous
     * value supplied with this notification will be null. If the notification triggers an
     * unchecked exception, the slot will automatically be disconnected and the caller need not
     * worry about cleaning up after itself.
     * @return a connection instance which can be used to cancel the connection.
     */
    function connectNotify (listener :Function) :Connection;

    /**
     * Disconnects the supplied listener from this value if it's connected. If the listener has been
     * connected multiple times, all connections are cancelled.
     */
    function disconnect (listener :Function) :void;
}

}
