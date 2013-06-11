//
// react

package react {

/**
 * Provides a mechanism to cancel a slot or listener registration, or to perform post-registration
 * adjustment like making the registration single-shot.
 */
public interface Connection extends Registration
{
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
