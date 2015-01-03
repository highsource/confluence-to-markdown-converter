## Properties

Properties define contents of a complex type. From one hand, they configure the structure of a JavaScript object which is mapped by this complex type. From the other hand, they describe, how this object will be presented in an XML form.

Jsonix allows you to map character content, attributes and elements using following property types:

* Character content
	
  * [#Value property](#value-property)


* Attributes
	
  * [#Attribute property](#attribute-property)
  * [#Any attribute property](#any-attribute-property)


* Elements
	
  * [#Element property](#element-property)
  * [#Elements property](#elements-property)
  * [#Element map property](#element-map-property)
  * [#Element reference property](#element-reference-property)
  * [#Element references property](#element-references-property)
  * [#Any element property](#any-element-property)



### Basic property characteristics

Property types enumerated above have different functionality. However, there are some basic characteristics shared by most properties.

#### Property name

Every property must have a name (string). Primary function of this name is to define the name of the matching JavaScript object property.

Consider the following example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'MyType',
        propertyInfos: [{
            type: 'element',
            name: 'data',
            elementName: 'content'
        }]
    }],
    elementInfos: [{ /* ...*/ }]
};
```

The property named `data` is mapped to the element `content`. So if we'll unmarshal the following element:

```
<root>
    <content>one</content>
</root>
```

We'll get the `data` property in the JavaScript object:

```
{
    name: {
        localPart: 'root'
    },
    value: {
        data: 'one',
        TYPE_NAME: 'MyModule.MyType'
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/593Je/).

Name of the property is also used by [attribute](#attribute-property), [element](#element-property) and [element reference](#element-reference-property) properties to default the target XML attribute or element names if they are omitted.

#### Property cardinality

Element properties also have the cardinality characteristic; they can be collection or single properties.

[Value](#value-property), [attribute](#attribute-property) and [any attribute](#any-attribute-property) properties are always single.

Collection properties handle repeatable elements.

Consider the following collection property declaration:

```
{
    type: 'element',
    name: 'data',
    elementName: 'content',
    collection : true
}
```

This will unmarshal the following XML:

```
<root>
    <content>one</content>
    <content>two</content>
    <content>three</content>
</root>
```

Into the following JavaScript object:

```
{  
   data : ['one', 'two', 'three']
}
```

[Fiddle](http://jsfiddle.net/lexi/DT4Ne/).

Note that this is different from [deriving types by list](#deriving-simple-types-by-list):

```
<root>
    <content>one two three</content>
</root>
```

#### Mixed properties

Some of the properties (namely [Element reference](#element-reference-property)/[references](#element-references-property) and [any element](#any-element-property) properties) can be declared as *mixed*. Mixed properties can handle elements together with character content. Consider the following example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'MyType',
        propertyInfos: [{
            type: 'elementRef',
            name: 'data',
            elementName: 'content',
            collection : true,
            mixed: true
        }]
    }],
    elementInfos: [{
        elementName: 'root',
        typeInfo: 'MyModule.MyType'
    }]
};
```

Here's an example of XML:

```
<root>
    <content>one</content>two<content>three</content>
</root> 
```

And the equivalent JavaScript object:

```
{
    name: {
        localPart: 'root'
    },
    value: {
        data: [{
            name: {
                localPart: 'content'
            },
            value: 'one'
        },
            'two', {
            name: {
                localPart: 'content'
            },
            value: 'three'
        }]
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/nrXUu/).

#### Wrapper elements

A common XML Schema design pattern is the usage of wrapper elements to enclose repeated elements, for instance:

```
<root>
    <contents>
        <content>one</content>
        <content>two</content>
        <content>three</content>
    </contents>
</root>
```

The `contents` element on its own has no meaning, it only encloses the `content` subelements. You can model such XML my using the `wrapperElementName` option in element properties:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'MyType',
        propertyInfos: [{
            type: 'element',
            name: 'data',
            wrapperElementName: 'contents',
            elementName: 'content',
            collection: true
        }]
    }],
    elementInfos: [{
        elementName: 'root',
        typeInfo: 'MyModule.MyType'
    }]
};
```

The XML sample above will be marshalled into the following JavaScript object:

```
{
    name: {
        localPart: 'root'
    },
    value: {
        data: [ 'one', 'two', 'three']
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/3S6YZ/).

### Defining properties

#### Value property

Property declaration syntax:

```
{
    type: 'value',

    // Name of the JavaScript object property
    name: 'data',

    // Type of the property
    typeInfo: 'Double'
}
```

Value property maps to the textual content of the XML element:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'MyValueType',
        propertyInfos: [{
            type: 'value',
            typeInfo: 'Double',
            name: 'data'
        }]
    }],
    elementInfos: [{
        elementName: 'root',
        typeInfo: 'MyModule.MyValueType'
    }]
};
```

XML:

```
<root>1.234</root>
```

JavaScript Object:

```
{
    name: {
        localPart: 'root'
    },
    value: {
        data: 1.234,
        TYPE_NAME: 'MyModule.MyValueType'
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/RJN9f/).

Usage constraints:

* Complex type can define at most one value property.
* Value property can be used with [attribute](#attribute-property) or [any attribute](#any-attribute-property) properties. It can not be used with:
	
  * [#Element property](#element-property)
  * [#Elements property](#elements-property)
  * [#Element reference property](#element-reference-property)
  * [#Element references property](#element-references-property)
  * [#Element references property](#element-references-property)
  * [#Mixed properties](#mixed-properties) without wrapper elements



##### Defining complex type with simple content

The [value property](#value-property) can be used to define complex type with simple content. Consider the following XML Schema fragment:

```
<xs:element name="root">
	<xs:complexType>
		<xs:simpleContent>
			<xs:extension base="xs:double"/>
		</xs:simpleContent>
	</xs:complexType>
</xs:element>
```

The anonymous complex type within the `root` element is a complex type with simple content. This is how it can be mapped with Jsonix:

```
{
    type: 'classInfo',
    localName: 'RootType',
    propertyInfos: [{
        type: 'value',
        typeInfo: 'Double',
        name: 'value'
    }]
}
```

[Fiddle](http://jsfiddle.net/lexi/fjrdA/).

#### Attribute property

Property declaration syntax:

```
{
    type: 'attribute',

    // Name of the JavaScript object property
    name: 'data',

    // Attribute name, string or QName, defaults to the name of the property
    attributeName : 'myAttribute',
    // Or as QName
    // attributeName : { localPart: 'myAttribute', namespaceURI : 'urn:mynamespace' }

    // Type of the property
    typeInfo: 'Double'
}
```

Mapping example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'InputType',
        propertyInfos: [{
            type: 'attribute',
            typeInfo: 'Boolean',
            name: 'checked'
        }]
    }],
    elementInfos: [{
        elementName: 'input',
        typeInfo: 'MyModule.InputType'
    }]
};
```

XML:

```
<input checked="false"/>
```

JavaScript object:

```
{
    name: {
        localPart: 'input'
    },
    value: {
        checked: false,
        TYPE_NAME: 'MyModule.InputType'
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/ND8Mr/).

Usage constraints:

* Complex type can define at most one attribute property for the given attribute name.

#### Any attribute property

Property declaration syntax:

```
{
    type: 'anyAttribute',

    // Name of the JavaScript object property
    name: 'attributes'
}
```

"Any attribute" property maps to the attributes of the XML element.

Value of the property is a map of the form:

```
{
	attribute0: value0,
	attribute1: value1,
	attribute2: value2,
	...
}
```

Where `attributeX` is the string representation of the qualified attribute name, `valueX` is the string value of the attribute.

Mapping example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'AnyAttributeType',
        propertyInfos: [{
            type: 'anyAttribute',
            name: 'attributes'
        }]
    }],
    elementInfos: [{
        elementName: 'anyAttribute',
        typeInfo: 'MyModule.AnyAttributeType'
    }]
};
```

XML:

```
<anyAttribute
  a="a"
  b:b="b" xmlns:b="urn:b"
  c:c="c" xmlns:c="urn:c"/>
```

JavaScript Object:

```
{
    name: {
        localPart: 'anyAttribute'
    },
    value: {
        attributes: {
            a: 'a',
                '{urn:b}b': 'b',
                '{urn:c}c': 'c'
        }
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/wPtzw/).

Usage constraints:

* Complex type can define at most one "any attribute" property.

#### Element property

Property declaration syntax:

```
{
    type: 'element',

    // Name of the property, required
    name: 'element',

    // Whether the property is collection or not, defaults to false
    collection: false,

    // Name of the element, optional, defaults to the name of the property
    elementName: 'myElement',
    // Or, as QName
    // elementName : { localPart: 'myElement', namespaceURI: 'urn:mynamespace' }

    // Name of the wrapper element, defaults to null
    wrapperElementName: 'myElements',
    // Or, as QName
    // wrapperElementName : { localPart: 'myElements', namespaceURI: 'urn:mynamespace' }

    // Type of the property (can be simple or complex), required
    typeInfo: 'String'
}
```

Element property maps a JavaScript object property onto the XML element.

See [#Wrapper elements](#wrapper-elements) for an explanation of the `wrapperElementName` option.

Usage constraints:

* Element property can not be used with:
	
  * [Value properties](#value-property)
  * [Mixed properties](#mixed-properties) without wrapper elements



##### Element property example - single element

Mapping example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'ElementType',
        propertyInfos: [{
            type: 'element',
            name: 'element',
            typeInfo: 'String'
        }]
    }],
    elementInfos: [{
        elementName: 'elements',
        typeInfo: 'MyModule.ElementType'
    }]
};
```

XML:

```
<elements>
   <element>fire</element>
</elements>
```

JavaScript object:

```
{
    name: {
        localPart: 'elements'
    },
    value: {
        element: 'fire'
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/TS7M5/).

#### Elements property

Property declaration syntax:

```
{
    type: 'elements',

    // Name of the property, required
    name: 'elements',

    // Whether the property is collection or not, defaults to false
    collection: true,

    // Name of the wrapper element, defaults to null
    wrapperElementName: 'myElements',

    // Element mappings, required
    elementTypeInfos: [{

        // Name of the element, required (can be string or a QName)
        elementName: 'string',

        // Type of the property , required
        typeInfo: 'String'
    }, {
        elementName: 'integer',
        typeInfo: 'Integer'
    }]
}
```

Elements property maps several XML elements onto one JavaScript object property.

Elements property is provided with `elementTypeInfos`, an array of element/type mappings. These mappings are objects carrying `elementName`, string qualified name of the element and `typeInfo`, type of the element.

When unmarshalling an element, this property uses the name of the element to find the corresponding type and then uses this type for actual unmarshalling.

When marshalling a value, this property searches for a matching type for this value and then uses the corresponding element name to create the outgoing XML element.

Mapping example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'ElementsType',
        propertyInfos: [{
            type: 'elements',
            name: 'elements',
            wrapperElementName: 'elements',
            collection: true,
            elementTypeInfos: [{
                elementName: 'string',
                typeInfo: 'String'
            }, {
                elementName: 'integer',
                typeInfo: 'Integer'
            }]
        }]
    }],
    elementInfos: [{
        elementName: 'root',
        typeInfo: 'MyModule.ElementsType'
    }]
};
```

XML:

```
<root>
    <elements>
        <string>one</string>
        <integer>2</integer>
        <string>three</string>
    </elements>
</root>
```

JavaScript object:

```
{
    name: {
        localPart: 'root'
    },
    value: {
        elements: ['one', 2, 'three']
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/CHHnv/).

As you see, we're getting elements of different types (strings, integers) from differently-named elements (`string`, `integer`) in one array property `elements`. The `elementTypeInfos` definition of our elements property allows Jsonix to understand that `string` elements must be unmarshalled as strings, `integer` elements - as integers. During marshalling, Jsonix tries to find a matching type (that is, a type for which this given value would be an instance of) and then use the corresponding element name for marshalling.

The "instance of" operator is implemented differently for simple and complex types.

For simple types the "instance of" operator checks that value has an appropriate JavaScript type (like, `string` for strings, `number` for numeric types, `boolean` for booleans and so on). Simple type also checks that value is actually allowed (ex. integers are round numbers, bytes are in range from -128 to +127 and so on). This can surely be ambiguous, so caution is advised when mixing compatible simple types in one elements property.

Values of complex types are objects so there is no reliable way to determine if a given object is considered as "instance of" a certain complex type. To overcome this difficulty, objects may carry a special-purpose `TYPE_NAME` property, for instance:

```
{
	value : 'two',
	TYPE_NAME : 'MyModule.ValueType'
}
```

Complex type thinks that value is an "instance of" itself if the value is an object and it has a string `TYPE_NAME` property matching the name of the complex type.

#### Element map property

Property declaration syntax:

```
{
    type: 'elementMap',

    // Name of the property, required
    name: 'element',

    // Whether the property is collection or not, defaults to false
    collection: true,

    // Name of the element, optional, defaults to the name of the property (string or a QName)
    elementName: 'myElement',

    // Name of the wrapper element, defaults to null (string or a QName)
    wrapperElementName: 'myElements',

    // Declaration of the key property
    key: {
        type: 'attribute',
        name: 'key',
        typeInfo: 'String'
    },

    // Declaration of the value property
    value: {
        type: 'value',
        name: 'value',
        typeInfo: 'String'
    }
}
```

Element map property allows mapping one or more elements to an object/hashmap-valued property. Element map property is configured with two further properties which describe, what should be taken as a key of the hashmap and what as value.

Since version 1.1 element map properties can be collections. In this case, values in the hashmap will be arrays. This allows modelling multimaps.

Mapping example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'ElementMapType',
        propertyInfos: [{
            type: 'elementMap',
            name: 'element',
            key: {
                type: 'attribute',
                name: 'key',
                typeInfo: 'String'
            },
            value: {
                type: 'value',
                name: 'value',
                typeInfo: 'String'
            }
        }, {
            type: 'elementMap',
            name: 'elements',
            wrapperElementName: 'elements',
            elementName: 'element',
            key: {
                type: 'attribute',
                name: 'key',
                typeInfo: 'String'
            },
            value: {
                type: 'value',
                name: 'value',
                typeInfo: 'String'
            }
        }, {
            type: 'elementMap',
            name: 'elementCollection',
            collection: true,
            key: {
                type: 'attribute',
                name: 'key',
                typeInfo: 'String'
            },
            value: {
                type: 'value',
                name: 'value',
                typeInfo: 'String'
            }
        }, {
            type: 'elementMap',
            name: 'elementsCollection',
            wrapperElementName: 'elementsCollection',
            elementName: 'element',
            collection: true,
            key: {
                type: 'attribute',
                name: 'key',
                typeInfo: 'String'
            },
            value: {
                type: 'value',
                name: 'value',
                typeInfo: 'String'
            }
        }]
    }],
    elementInfos: [{
        elementName: 'elementMap',
        typeInfo: 'MyModule.ElementMapType'
    }]
};
```

XML:

```
<elementMap> 
	<element key="one">earth</element> 
	<element key="two">wind</element> 
	<elements> 
		<element key="three">fire</element> 
		<element key="four">wood</element> 
	</elements> 
	<elementCollection key="one">1</elementCollection> 
	<elementCollection key="one">I</elementCollection> 
	<elementCollection key="two">2</elementCollection> 
	<elementCollection key="two">II</elementCollection> 
	<elementsCollection> 
		<element key="three">3</element> 
		<element key="three">III</element> 
		<element key="four">4</element> 
		<element key="four">IV</element> 
	</elementsCollection> 
</elementMap> 
```

JavaScript object:

```
{
    name: {
        localPart: 'elementMap'
    },
    value: {
        element: {
            'one': 'earth',
                'two': 'wind'
        },
        elements: {
            'three': 'fire',
                'four': 'wood'
        },
        elementCollection: {
            one: ['1', 'I'],
            two: ['2', 'II']
        },
        elementsCollection: {
            three: ['3', 'III'],
            four: ['4', 'IV']
        }
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/8ak6g/).

#### Element reference property

Property declaration syntax:

```
{
    type: 'elementRef',

    // Name of the property, required
    name: 'elementRef',

    // Whether the property is collection or not, defaults to false
    collection: false,

    // Name of the element, optional, defaults to the name of the property, string or QName
    elementName: 'myElementRef',

    // Name of the wrapper element, defaults to null, string or QName
    wrapperElementName: 'myElementRefs',

    // Type of the property (can be simple or complex), required
    typeInfo: 'String'
}
```

Element reference property maps a JavaScript object property onto XML element. This is similar to the [element property](#element-property), however what's different is content representation in the JavaScript object. Consider the following properties:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'ElementRefType',
        propertyInfos: [{
            type: 'element',
            name: 'a',
            typeInfo: 'String'
        }, {
            type: 'elementRef',
            name: 'b',
            typeInfo: 'String'
        }]
    }],
    elementInfos: [{
        elementName: 'data',
        typeInfo: 'MyModule.ElementRefType'
    }, {
        elementName: 'c',
        substitutionHead: 'b',
        typeInfo: 'String'
    }]
};
```

XML elements for both properties is the same:

```
<data>
  <a>1</a>
  <b>2</b>
</data>
```

However, content representation in the JavaScript object is different:

```
{
    name: { localPart: 'data' },
    value: {
        a: '1',
        b: {
            name: { localPart: 'b' },
            value: '2'
        }
    }
}
```

In the example above the element reference property `b` is represented in the JavaScript object by the following construct:

```
{
    name: { localPart: 'b' },
    value: '2'
}
```

The advantage of this representation is that you can choose the name of the XML element dynamically:

```
{
    name: {
        localPart: 'data'
    },
    value: {
        a: '1',
        b: {
            name: {
                localPart: 'c'
            },
            value: '2'
        }
    }
}
```

Despite property name is still `b`, it will be marshalled as the element `c`:

```
<data>
  <a>1</a>
  <c>2</c>
</data>
```

Note that to do this trick we had to declare an element mapping for the element `c`:

```
    elementInfos: [{
        elementName: 'data',
        typeInfo: 'MyModule.ElementRefType'
    }, {
        elementName: 'c',
        typeInfo: 'String'
    }]
```

This lets Jsonix know that the element `c` can substitute the element `b` and it should be processed as `String`.

[Fiddle](http://jsfiddle.net/lexi/Ms63w/).

##### Scoped elements

There is one problem with element declaration above:

```
    {
        elementName: 'c',
        typeInfo: 'String'
    }
```

This makes `c` a global element. So you can now unmarshal the following XML:

```
<c>3</c>
```

This may or may not be the desired effect. To overcome this difficulty, you can define a *scope* for this element declaration.  

Scope is essentially a complex type which will limit the applicability of the given element declaration. In the example above, we can limit the scope of the element `c` to the enclosing type `MyModule.ElementRefType`:

```
    {
        elementName: 'c',
        scope: 'MyModule.ElementRefType',
        typeInfo: 'String'
    }
```

[Fiddle](http://jsfiddle.net/lexi/xwDLp/).

##### Substitution groups

You might have noticed that although marshalling 

```
{
    name: { localPart: 'c' },
    value: '2'
}
```

worked as expected, unmarshalling

```
<data>
    <a>1</a>
    <c>2</c>
</data>
```

did not. The reason is that Jsonix sees the element `c` and can unmarshal it via the global element declaration, *but* it does not know which property it should be mapped to. Our complex type `MyModule.ElementRefType` only declares properties `a` and `b`.

To fix this, we can provide the `substitutionHead` property in the element declaration. The `substitutionHead` name the element (either via string or QName) which can be *substituted* by the given element. For instance, if we can define the element declaration as follows:

```
    {
        elementName: 'c',
        substitutionHead: 'b',
        typeInfo: 'String'
    }
```

This will let Jsonix know that the element `c` substitutes the element `b`. And since our complex type `MyModule.ElementRefType` has an element reference property for the element `b`, Jsonix will know that the unmarshalled `c` should be assigned to the property `b`.

[Fiddle](http://jsfiddle.net/lexi/2eMVD/).

#### Element references property

Property declaration syntax:

```
{
    type: 'elementRefs',

    // Name of the property, required
    name: 'elementRefs',

    // Whether the property is collection or not, defaults to false
    collection: true,

    // Name of the wrapper element, defaults to null, string or QName
    wrapperElementName: 'myElementRefs',

    // Element mappings, required
    elementTypeInfos: [{
        // Name of the element, required, string or QName
        elementName: 'string',

        // Type of the property, required
        typeInfo: 'String'
    }, {
        elementName: 'integer',
        typeInfo: 'Integer'
    }]
}
```

Element references property maps several XML elements onto one JavaScript object property. This is similar to [elements property](#elements-property), but for [references](#element-reference-property).

Example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'ElementRefsType',
        propertyInfos: [{
            type: 'elementRefs',
            name: 'data',
            wrapperElementName: 'numbers',
            collection: true,
            elementTypeInfos: [{
                elementName: 'long',
                typeInfo: 'Long'
            }, {
                elementName: 'integer',
                typeInfo: 'Integer'
            }]
        }]
    }],
    elementInfos: [{
        elementName: 'root',
        typeInfo: 'MyModule.ElementRefsType'
    }]
};
```

XML:

```
<root>
    <numbers>
        <long>1</long>
        <integer>2</integer>
    </numbers>
</root>
```

JavaScript object:

```
{
    name: {
        localPart: 'root'
    },
    value: {
        data: [{
            name: {
                localPart: 'long'
            },
            value: 1
        }, {
            name: {
                localPart: 'integer'
            },
            value: 2
        }]
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/JxuzL/).

#### Any element property

Property declaration syntax:

```
{
    type: 'anyElement',

    // Name of the property
    name: "any",

    // Whether the property is collection or not, defaults to false
    collection: false,

    // Whether the property allows DOM nodes, default to true
    allowDom: true,

    // Whether the property allows typed objects, default to true
    allowTypedObject: true,

    // If the property is a mixed property, default to true
    mixed: true
}
```

Any element property can handle arbitrary XML elements. Depending on the processing types and whether these elements are known within the current Jsonix context, you'll get objects, DOM nodes or strings on the JavaScript side.

Any element property handles unmarshalling as follows:

* When unmarshalling character data:
	
  * If this property is mixed, character data is unmarshalled as string.
  * Otherwise an error is reported.


* When unmarshalling an element:
	
  * If this property allows typed objects, check if this element is know to the context via [element mapping](#element-mappings).
		
    * If it is known, unmarshal as typed object.


  * Otherwise if this property allows DOM, simply return current element as a DOM element.
  * Otherwise report an error.



Below is the correspondence between `xs:any` processing types and `allowTypedObject`/`allowDom` processing settings.

| Processing type |`allowTypedObject`|`allowDom`|
|-----------------|------------------|----------|
| lax              |+|+|
| strict           |+|-|
| skip             |-|+|

Usage constraints:

* Complex type may declare at most one "any element" property.

##### Any element property example - lax processing

Consider the following mapping example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'AnyElementType',
        propertyInfos: [{
            type: 'anyElement',
            name: 'any',
            collection: true
        }]
    }, {
        type: 'classInfo',
        localName: 'ValueType',
        propertyInfos: [{
            type: 'value',
            typeInfo: 'Double',
            name: 'data'
        }]
    }],
    elementInfos: [{
        elementName: 'root',
        typeInfo: 'MyModule.AnyElementType'
    }, {
        elementName: 'string',
        typeInfo: 'String'
    }, {
        elementName: 'value',
        typeInfo: 'MyModule.ValueType'
    }]
};
```

The `allowsDom`, `allowsTypedObject` and `mixed` options are defaulted to `true`, so this property will produce:

* typed objects for elements known in this context;
* DOM nodes for elements which are not known to this context;
* strings for character data.

XML:

```
<root>
    <string>one</string>
    <value>2</value>
    three
    <node>4</node>
</root>
```

Since we have declared global elements `string` and `value` in our module, these elements will be unmarshalled as typed objects. The element `node` is not known in this context - it will be returned as DOM. Character data `three` will be unmarshalled as string.

```
{
    name: {
        localPart: 'root'
    },
    value: {
        any: [{
            name: {
                localPart: 'string'
            },
            value: 'one'
        }, {
            name: {
                localPart: 'value'
            },
            value: {
                data: 2,
                TYPE_NAME: 'MyModule.ValueType'
            }
        },
            'three',
        // <node>4</node> as a DOM element
        Jsonix.DOM.parse('<node>4</node>').documentElement]
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/F2Hj6/).

