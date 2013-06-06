//
// react

package react {

public interface Connection
{
    /**
     * Disconnects this registration. Subsequent events will not be dispatched to the associated
     * slot or listener.
     */
    function disconnect () :void;

    /**
     * Converts this connection into a one-shot connection. After the first time the slot or
     * listener is notified, it will automatically be disconnected.
     * @return this connection instance for convenient chaining.
     */
    function once () :Connection;

    /**
     * Changes the priority of this connection to the specified value. This should generally be
     * done simultaneously with creating a connection.
     * @return this connection instance for convenient chaining.
     */
    function atPriority (priority :int) :Connection;
}

}
