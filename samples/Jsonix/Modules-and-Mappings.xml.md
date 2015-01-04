## Modules

Jsonix module is essentially just a simple JavaScript object which declares a set of XML/object mappings.

```
// Module declaration syntax
var MyModule = {
    // Name of the module, required
    name: 'MyModule',
    // Array of types declared by the module, optional 
    typeInfos: [ /*...*/ ],
    // Array of element mappings declared by the module, optional
    elementInfos: [ /*...*/ ],
    // Default namespace URI for elements, optional
    defaultElementNamespaceURI: 'http://www.mymodule.org/elements',
    // Default namespace URI for attributes, optional
    defaultElementNamespaceURI: 'http://www.mymodule.org/attributes'
};
```

[Fiddle](http://jsfiddle.net/lexi/zFZW6/).

### Name

Each module must have a string `name` property which names a module. The name is useful for locally-named declarations. For instance, in the code below the full name of the `PurchaseOrderType` type info will be `PO.PurchaseOrderType`.

```
var PO = {
  name: 'PO',
  typeInfos: [
    // Full name of the class info ist PO.PurchaseOrderType
    {
      type: 'classInfo',
      localName: 'PurchaseOrderType',
      // ...
    }, // ...
  ], // ...
};
```

[Fiddle](http://jsfiddle.net/lexi/F79g5/).

For backwards-compatibility, `name` property the module is technically not required (you'll get no error if you pass a module without a name). However it is highly recommended to declare this property. We may implement in strict check for name in future versions.

### Type infos

Each module may declare zero or more [types](#types) using the `typeInfos` property.  

Types are roughly equivalent to the global simple and complex types of the XML Schema.

```
var PO = {
    name: 'PO',
    typeInfos: [{
        type: 'classInfo',
        localName: 'PurchaseOrderType',
        // ...
    }, {
        type: 'classInfo',
        localName: 'Items',
        // ...
    }, {
        type: 'classInfo',
        localName: 'USAddress',
        // ...
    }, {
        type: 'classInfo',
        localName: 'Item',
        // ...
    }],
    elementInfos: [ /* ... */ ]
};
```

[Fiddle](http://jsfiddle.net/lexi/nZmRf/).

If type info is declared with a local name, it will get a "full" name based on the pattern `<ModuleName>.<LocalName>`, ex. `PO.PurchaseOrderType`.  

See the [types](#types) section for more information.

### Element infos

Each module may declare zero or more [element declarations](#element-declarations).  

Element declarations are roughly equivalent to global elements of the XML Schema.

```
var PO = {
    name: 'PO',
    typeInfos: [ /* ... */ ],
    elementInfos: [{
        elementName: 'purchaseOrder',
        typeInfo: 'PO.PurchaseOrderType'
    }, {
        elementName: 'comment',
        typeInfo: 'String'
    }]
};
```

[Fiddle](http://jsfiddle.net/lexi/Fq5cD/).

The mapping above basicaly says that `<purchaseOrder .../>` element should be processed using the `PO.PurchaseOrderType` type and `<comment.../>` using the (built-in) string type.

See the [element declarations](#element-declarations) section for more information.

### Default element and attribute namespaces

Element an attribute names can be declared using simple strings, for instance `elementName: 'comment'`. If you use namespaces (I hope you do), you can the use the `defaultElementNamespaceURI` or `defaultAttributeNamespaceURI` to declare the namespace for such names. Consider the following example of the mapping.

```
var Qualified = {
    name: 'Qualified ',
    defaultElementNamespaceURI: 'urn:qualified',
    elementInfos: [{
        elementName: 'comment',
        typeInfo: 'String'
    }]
};
```

This will suit XML like:

```
<q:comment xmlns:q="urn:qualified">Some text.</q:comment>
```

[Fiddle](http://jsfiddle.net/lexi/UPeww/).

An alternative would have to declare the `elementName` like this:

```
var Qualified = {
    name: 'Qualified ',
    elementInfos: [{
        elementName: {
            namespaceURI: 'urn:qualified',
            localPart: 'comment'
        },
        typeInfo: 'String'
    }]
};
```

[Fiddle](http://jsfiddle.net/lexi/Dgv9p/).  

Which is a little bit more cumbersome.

