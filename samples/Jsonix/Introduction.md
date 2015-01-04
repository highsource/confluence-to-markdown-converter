# Introduction

Take a look at [this question](http://stackoverflow.com/questions/3819192/is-there-a-javascript-api-for-xml-binding-analog-to-jaxb-for-java) on Stackoverflow which incepted the development of Jsonix.

Jsonix (JSON interfaces for XML) is a JavaScript library which allows you to convert between XML and JSON structures.

With Jsonix you can parse XML into JavaScript objects (this process is called *unmarshalling*) or serialize JavaScript objects in XML form (this is called *marshalling*). 

These conversions are based on simple XML/JSON mappings which can be written manually or generated from an XML Schema.

Strictly speaking, Jsonix works with JavaScript objects, which are not limited to JSON. But for the sake of simplicity we'll use *JSON* to denote these "plain old simple JavaScript objects".

In short, with Jsonix you can:

* parse XML into JSON;
* serialize JSON into XML;
* define mappings between XML and JSON declaratively;
* generate these mappings from XML Schemas.

## Related projects

### JAXB

Jsonix is inspired by and based on [JAXB](https://jaxb.dev.java.net/) which is a great tool to convert between XML and Java objects. Jsonix is literally a JAXB analog for JavaScript.

Jsonix mappings are heavily influenced by [JAXB annotations](http://download.oracle.com/javaee/5/api/javax/xml/bind/annotation/package-summary.html). 

Jsonix schema compiler is based on XJC, schema compiler from the [JAXB Reference Implementation](https://jaxb.dev.java.net/).

