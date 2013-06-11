React-as3
=========

React is a low-level library that provides [signal/slot] and [functional
reactive programming]-like primitives. It can serve as the basis for a user
interface toolkit, or any other library that has a model on which clients will
listen and to which they will react.

React-as3 is a port of [React](http://github.com/threerings/react), a Java
library created by Three Rings Design.

Building
--------

The library is built using [Ant] and [Maven], or with [Flash Builder].

From the command line, invoke `ant` to build the library, or 'ant maven-deploy'
to build and deploy it to your local Maven repository.

There's also a Flash Builder project at the root level of the repository.

Artifacts
---------

To add a React-as3 dependency to a Maven project, add the following to your
`pom.xml`:

    <dependencies>
      <dependency>
        <groupId>com.timconkling</groupId>
        <artifactId>react-as3</artifactId>
        <version>1.0-SNAPSHOT</version>
      </dependency>
    </dependencies>

Distribution
------------

React-as3 is released under the New BSD License. The most recent version of the
library is available at http://github.com/tconkling/react-as3

Contact
-------

Feel free to open issues on the project's Github home.

Twitter: [@timconkling](http://twitter.com/timconkling)

[signal/slot]: http://en.wikipedia.org/wiki/Signals_and_slots
[functional reactive programming]: http://en.wikipedia.org/wiki/Functional_reactive_programming
[Maven]: http://maven.apache.org/
[Ant]: http://ant.apache.org/
[Flash Builder]: http://www.adobe.com/products/flash-builder.html
