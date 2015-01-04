## Element declarations

Every valid XML document has a single root element which is called the *document element*. When unmarshalling an XML document, Jsonix runtime needs to know onto which type does the root element of this document map. For instance that the element `value` maps onto the type `One.ValueType` in the module `One`.

This mapping is defined by the `elementInfos` property of the module object. The `elementInfos` property is an array of element declarations. Each element declaration is an object with the following structure:

```
var MyModule = {
    // ...
    elementInfos: [
    // Element declaration syntax
    {
        // Qualified name of the element
        name: {
            namespaceURI: 'urn:myNamespaceURI',
            localPart: 'element'
        },
        // Target type of the element
        typeInfo: 'MyModule.MyType',
        // Element scope (optional)
        scope: 'MyModule.AnotherType',
        // Substitution group (optional)
        substitutionGroup: {
            namespaceURI: 'urn:myNamespaceURI',
            localPart: 'substitutableElement'
        }
    }]
};
```

[Fiddle](http://jsfiddle.net/lexi/jhz25/).

The `name` property provides the name of the element to be mapped. This can be a qualified name defined by an object with properties `namespaceURI`, `localPart` (and maybe `prefix`) or a string. If name is given as a string, it will be resolved to the qualified name using the `defaultNamespaceURI` of the module.  

See [defining element and attribute names](#defining-element-and-attribute-names) for details about name resolution. (TODO)

The `typeInfo` property defines the type which is associated with the given element. It can be a string (name of the type) or an object (full mapping of the type).  

See [referencing types](#referencing-types) for more information about type resolution. (TODO)

Element declaration has two more options, [`scope`](#scoped-elements) and [`substitutionHead`](#substitution-groups) which will be explained later on.

For example, consider the following element declaration:

```
{
    name: {
        namespaceURI: 'urn:myNamespaceURI',
        localPart: 'element'
    },
    typeInfo: 'MyModule.MyType',
}
```

This declaration maps the following element:

```
<my:element xmlns:my="urn:myNamespaceURI" ...>
    ...
</my:element>
```

Onto the type `MyModule.MyType`. So when Jsonix unmarshals such an element it will produce a result like:

```
{
    name: {
        namespaceURI: 'urn:myNamespaceURI',
        localPart: 'myLocalPart'
    },
    value: {
        // Contents according to the MyModule.MyType  
    },
    TYPE_NAME : 'MyModule.MyType
}
```

You mostly need to declare only your global elements in `MyModule.elementInfos`. All other elements, attributes etc. mappings are done via properties.

However, you may also need to use `MyModule.elementInfos` to declare [scoped elements](#scoped-elements).

