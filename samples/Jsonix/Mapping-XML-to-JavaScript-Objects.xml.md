# Mapping XML to JavaScript Objects

Jsonix needs XML/object mappings to operate. These mappings can be created manually or generated from an XML Schema. Either way, they are just simple JavaScript objects which define how XML should be mapped to properties of objects and vice versa.  
 This sections explains concepts of these mappings and describes how to create them.

## Basic concepts

Jsonix mappings are defined in a *module object* which provides information about declared types and XML elements which they are mapped to. Below is a very simple module `One` which declares a complex type `One.ValueType` (containing a single property `value`) and maps this type to the global XML element `value`:

```
var One = {
    name: 'One',
    typeInfos: [{
        type: 'classInfo',
        localName: 'ValueType',
        propertyInfos: [{
            name: 'data',
            type: 'value',
            typeInfo: 'String'
        }]
    }],
    elementInfos: [{
        elementName: 'value',
        typeInfo: 'One.ValueType'
    }]
};
```

Provided this module object, we can create a Jsonix context and use it for marshalling or unmarshalling:

```
var context = new Jsonix.Context([One]);
var unmarshaller = context.createUnmarshaller();
var data = unmarshaller.unmarshalString('<value>Some text.</value>');
console.log(data);
```

See the [Fiddle](http://jsfiddle.net/lexi/9yG7b/) for this example.

Now we can enumerate basic components of Jsonix mappings:

* [Modules](#modules)
* [Types](#types) and [Properties](#properties)
* [Element declarations](#element-declarations)

These components will be described in the following sections.



