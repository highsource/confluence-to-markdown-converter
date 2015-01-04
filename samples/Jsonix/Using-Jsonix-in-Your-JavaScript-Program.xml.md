# Using Jsonix in your JavaScript program

* [[Download|Downloads]] Jsonix or [install](https://npmjs.org/package/xmldom) it with npm in node.js
* Add/import/include/require Jsonix scripts into your program/page.
* [[Write|Mapping XML to JavaScript Objects]] or [[generate|Generating mappings from XML Schema]] Jsonix mappings.
* Create Jsonix context from these mappings.
  * To marshal (serialize JavaScript objects as XML):
    * Create marshaller.
    * Use `marshalString`, `marshalDocument` etc. methods of marshaller.


  * To unmarshal (parse JavaScript objects from XML):
    * Create unmarshaller.
    * Use `unmarshalString`, `unmarshalDocument`, `unmarshalURL` etc. methods of unmarshaller.





## Including Jsonix scripts in a web page

In production you'll normally want to use the minified version of Jsonix:

```
<html>
	<head>
		<script type="text/javascript" src="../js/Jsonix/Jsonix-min.js"></script>
		<!-- ... --> 
	</head> 
	<!-- ... --> 
</html>
```

Available versions:

* `Jsonix-min.js` - aggregated, minified version.
* `Jsonix-all.js` - aggregated, not minified version.
* `lib/Jsonix.js` - not aggregated, not minified development version.

### Using Jsonix with RequireJS

Since 2.0.11.

Jsonix is compatible with [AMD](https://github.com/amdjs/amdjs-api/wiki/AMD)/[RequireJS](http://requirejs.org/).

Include `require.js` in your page, point `data-main` to your main script file:

```
<script type="text/javascript" src="js/require.js" data-main="js/main.js"></script> 
```

In your scripts, define Jsonix and mappings as dependencies of your module. The code below assumes `Jsonix-all.js` and `PO.js` are placed next to `main.js` and `require.js` in the `js` folder.

```
define([ "Jsonix-all", "PO" ], function(JsonixModule, POModule) {
	var Jsonix = JsonixModule.Jsonix;
	var PO = POModule.PO;


	// Create Jsonix context
	var context = new Jsonix.Context([ PO ]);
	// Create unmarshaller
	var unmarshaller = context.createUnmarshaller();
	// ...
});
```

Note that Jsonix still works in node.js and in browser without RequireJS.

## Installing Jsonix in node.js

Install:

```
npm install jsonix
```

Or add to dependencies of your package:

```
{
	"name": "mypackage",
	// ...
	"dependencies": {
		"jsonix": "~<VERSION>",
		// ...
	}
}
```

## Using Jsonix

### Creating Jsonix Context

In order to marshal or unmarshal you'll first need to create Jsonix context:

```
var context = new Jsonix.Context(
	// Array of mapping modules
	[ MyMappings1, MyMappings2 ],
	// Optional properties
	{
		// Default namespace/prefix mappings (optional)
		namespacePrefixes : {
			'http://acme.com/foo' : 'foo',
			'http://acme.com/bar' : 'bar'
		}
	}
);
```

Jsonix context is a factory which produces marshallers or unmarshallers. Jsonix context is thread-safe and reusable.

Once Jsonix context is created you can use it to produce marshallers or unmarshallers:

```
var marshaller = context.createMarshaller();
var unmarshaller = context.createUnmarshaller();
```

Unlike the context itself, marshaller and unmarshallers *neither* thread-safe *nor* reusable.

#### Additional context options

##### Namespace prefixes

`namespacePrefixes` is a map of namespace/prefix pairs. During marshalling they will be eagerly declared on the root element and then used to determine prefix for qualified element names (if the name itself does not provide one).

### Marshalling

Once you have a marshaller, you can marshal your object as XML:

```
// Marshal as string
var objectAsXMLString = marshaller.marshalString(myObject);
// Marshal as document
var objectAsXMLDocument = marshaller.marshalDocument(myObject);
```

### Unmarshalling

Unmarshaller can parse your object from XML:

```
// Unmarshal from string
var objectFromXMLString = unmarshaller.unmarshalString(myString);
// Unmarshal from document
var objectFromXMLDocument = unmarshaller.unmarshalDocument(myDocument);
// Unmarshal from URL via AJAX
unmarshaller.unmarshalURL(myURL,
	function (data)	{
		var objectFromURL = data;
	});
```

#### Unmarshalling a file with node.js

Since 2.0

If you're running Jsonix in a [node.js](http://nodejs.org/) environment, you can also unmarshal from a file:

```
// Unmarshal from file via node.js file system API
unmarshaller.unmarshalFile(fileName,
	function (data)	{
		var objectFromFile = data;
	},
        options);
```

At the moment, the file will be loaded as a string, then parsed into DOM document and finally unmarshalled from the parsed document.

The optional argument `options` is passed directly to the `fs.readFile(...)` call. See [node.js FileSystem API](http://nodejs.org/api/fs.html).

