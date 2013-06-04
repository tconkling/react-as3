//
// react

package react {

import flash.utils.getQualifiedClassName;

/**
 * Get the full class name, e.g. "com.threerings.util.ClassUtil".
 * Calling getClassName with a Class object will return the same value as calling it with an
 * instance of that class. That is, getClassName(Foo) == getClassName(new Foo()).
 */
internal function getClassName (obj :Object) :String {
    return getQualifiedClassName(obj).replace("::", ".");
}

}
