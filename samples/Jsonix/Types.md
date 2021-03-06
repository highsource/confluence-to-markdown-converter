## Types

A concept of *type* is a central concept in Jsonix mappings. Element declarations map XML elements onto types; most of the properties have a target type and so on.

Jsonix distinguished two categories of types: [simple](#simple-types) and [complex](#complex-types) types. The difference between them is that complex types contain [properties](#properties) whereas simple types don't.

Either way, types can convert between XML structures (elements, attributes, character data) and JavaScript structures (objects, arrays, strings, numbers etc.).

Each type *may* have a name which can be used to reference this type in mappings.

### Simple types

Simple types convert between character data on XML side and primitive or basic types on the JavaScript side. For instance, Jsonix boolean type converts between `"true"` or `"false"` text on XML side and `true` or `false` boolean values on JavaScript.

Jsonix provides supports most simple types defined in the XML Schema [out of the box](#build-in-simple-types). You can also define your own simple types using [derivation by list](#deriving-simple-types-by-list), [by union](#deriving-simple-types-by-union), defining [enumerations](#enum-types) or writing a [custom simple type](#defining-custom-simple-types).

#### Built-in simple types

Jsonix supports most simple types defined in the XML Schema. These types are called *built-in* simple types and are based on the following hierarchy of types:

[![](type-hierarchy.gif)](http://www.w3.org/TR/xmlschema-2/#built-in-datatypes)

To support this hierarchy, Jsonix declares an individual JavaScript class for each of these types. Each of the classes also has a pre-instantiated instance (ex. `Jsonix.Schema.XSD.String.INSTANCE`) which can be reference by name (ex. `String`). Below is the type mapping table:

|XML Schema Type|Jsonix JavaScript Class|Jsonix Type Name|
|---------------|-----------------------|----------------|
|`anySimpleType`|`Jsonix.Schema.XSD.AnySimpleType`|`AnySimpleType`|
|`string`|`Jsonix.Schema.XSD.String`|`String`|
|`normalizedString`|`Jsonix.Schema.XSD.NormalizedString`|`NormalizedString`|
|`token`|`Jsonix.Schema.XSD.Token`|`Token`|
|`language`|`Jsonix.Schema.XSD.Language`|`Language`|
|`Name`|`Jsonix.Schema.XSD.Name`|`Name`|
|`NCName`|`Jsonix.Schema.XSD.NCName`|`NCName`|
|`boolean`|`Jsonix.Schema.XSD.Boolean`|`Boolean`|
|`base64Binary`|`Jsonix.Schema.XSD.Base64Binary`|`Base64Binary`|
|`hexBinary`|`Jsonix.Schema.XSD.HexBinary`|`HexBinary`|
|`float`|`Jsonix.Schema.XSD.Float`|`Float`|
|`decimal`|`Jsonix.Schema.XSD.Decimal`|`Decimal`|
|`integer`|`Jsonix.Schema.XSD.Integer`|`Integer`|
|`nonPositiveInteger`|`Jsonix.Schema.XSD.NonPositiveInteger`|`NonPositiveInteger`|
|`negativeInteger`|`Jsonix.Schema.XSD.NegativeInteger`|`NegativeInteger`|
|`long`|`Jsonix.Schema.XSD.Long`|`Long`|
|`int`|`Jsonix.Schema.XSD.Int`|`Int`|
|`short`|`Jsonix.Schema.XSD.Short`|`Short`|
|`byte`|`Jsonix.Schema.XSD.Byte`|`Byte`|
|`nonNegativeInteger`|`Jsonix.Schema.XSD.NonNegativeInteger`|`NonNegativeInteger`|
|`unsignedLong`|`Jsonix.Schema.XSD.UnsignedLong`|`UnsignedLong`|
|`unsignedInt`|`Jsonix.Schema.XSD.UnsignedInt`|`UnsignedInt`|
|`unsignedShort`|`Jsonix.Schema.XSD.UnsignedShort`|`UnsignedShort`|
|`unsignedByte`|`Jsonix.Schema.XSD.UnsignedByte`|`UnsignedByte`|
|`positiveInteger`|`Jsonix.Schema.XSD.PositiveInteger`|`PositiveInteger`|
|`double`|`Jsonix.Schema.XSD.Double`|`Double`|
|`anyURI`|`Jsonix.Schema.XSD.AnyURI`|`AnyURI`|
|`QName`|`Jsonix.Schema.XSD.QName`|`QName`|
|`duration`|`Jsonix.Schema.XSD.Duration`|`Duration`|
|`dateTime`|`Jsonix.Schema.XSD.DateTime`|`DateTime`|
|`time`|`Jsonix.Schema.XSD.Time`|`Time`|
|`date`|`Jsonix.Schema.XSD.Date`|`Date`|
|`gYearMonth`|`Jsonix.Schema.XSD.GYearMonth`|`GYearMonth`|
|`gYear`|`Jsonix.Schema.XSD.GYear`|`GYear`|
|`gMonthDay`|`Jsonix.Schema.XSD.GMonthDay`|`GMonthDay`|
|`gDay`|`Jsonix.Schema.XSD.GDay`|`GDay`|
|`gMonth`|`Jsonix.Schema.XSD.GMonth`|`GMonth`|

`QName` is supported by Jsonix since version 2.1.0 and generated by Jsonix Schema Compiler since version 2.2.0.

Consider the following declaration of the global element:

```
var MyModule = {
    elementInfos: [{
        elementName: 'comment',
        typeInfo: 'String'
    }]
};
```

This maps the following element:

```
<comment>Some text</comment>
```

Onto the following data:

```
{
    name: {
        localPart: 'comment'
    }
    value: 'Some text'
}
```

[Fiddle](http://jsfiddle.net/lexi/vbXCy/).

Although all classes are defined, not all the types are already implemented. See [JSNX-1](http://jira.highsource.org/browse/JSNX-1) and [JSNX-2](http://jira.highsource.org/browse/JSNX-2) issues.

Since 2.0.11, Jsonix simple types always accept string when marshalling. Under the hood, they'll check if the provided value is a string. if it is, it will be parsed and then printen. So you can use `'1234'` as well as 1234 as an integer value. Note that the string value is not output directly, but parsed/printed to ensure the correct type and valid value.

#### Deriving simple types by list

In addition to atomic simple types Jsonix supports list simple types. Such list types map an *array* of values to string (delimiter-separated items of the array).  
 Derived type is defined as follows:

```
// List type declaration syntax
{
    // Indicates this is a "list" type info
    type: 'list',
    // Type of the list elements, required
    typeInfo: 'String',
    // Name of the type, optional. Defaults to typeInfo.name + '*', ex. 'String*'
    name: 'Strings',
    // Separator characters, optional. Defaults to ' '
    separator: ' '
}
```

Example:

```
var MyModule = {
    elementInfos: [{
        elementName: 'comment',
        typeInfo: {
            type: 'list',
            typeInfo: 'String'
        }
    }]
};
```

XML element:

```
<comment>Some text</comment>
```

Data:

```
{
    name: {
        localPart: 'comment'
    }
    value: ['Some', text']
}
```

[Fiddle](http://jsfiddle.net/lexi/hxqXh/).

Here's XML Schema analog:

```
<xsd:simpleType>
	<xsd:list itemType="xsd:string"/>
</xsd:simpleType>
```

Unlike XML Schema, Jsonix allows deriving list types from non-atomic types (ex. other list types). Below is an example of a list of lists of doubles:

```
{
    type: 'list',
    typeInfo: {
        type: 'list',
        typeInfo: 'Double'
    },
    separator: ','
}
```

You can use this type to convert between the string `0 0, 0 1, 1 1, 1 0, 0 0` and JavaScript array structure `[ [ 0, 0 ], [ 0, 1 ], [ 1, 1 ], [ 1, 0 ], [ 0, 0 ] ]`.

[Fiddle](http://jsfiddle.net/lexi/vQPSJ/).

#### Deriving simple types by union

This feature is planned but not supported, see [JSNX-9](http://jira.highsource.org/browse/JSNX-9).

#### Deriving simple types by restriction

Definition of complex types by restriction is not supported at the moment.

#### Defining enums

Since 2.0.12 Jsonix supports enum types.

You can define enum types by listing individual values. You can list them either as an array, or as an object.

Enum types have a base type info (string by default).

Example of an array definition:

```
{
	localName: 'IntegerEnums',
	type: 'enumInfo',
	baseTypeInfo: 'Integer',
	values: {
		'one' : 1,
		'two' : '2',
		'three' : 3
	}
}
```

[Fiddle](http://jsfiddle.net/lexi/ksyehopx/).

In case on an array definition you list individual values. If you provide a string as a value, this value will first get parsed with the enum's base type info. In the example above, `'2'` will be parsed to the integer `2`.

Example of an object definition:

```
 {
	localName: 'IntegerEnums',
	type: 'enumInfo',
	baseTypeInfo: 'Integer',
	values: {
		'one' : 1,
		'two' : '2',
		'three' : 3
	}
} 
```

[Fiddle](http://jsfiddle.net/lexi/phmxp7eu/).

In case of an object definition you define key/value pairs. When unmarshalling, you'll get your key (string) as the result. For instance, if you unmarshal `2` with the type above, you'll get `two` (string) as value. As with arrays, if you provide a string value, it will first get parsed with enum's base type.

#### Defining custom simple types

Type system in Jsonix is extensible, so if your requirements are not covered by the built-in simple types, you can write custom simple types to match your needs.

Jsonix requires an *instance* of a simple types to provide the following properties and functions:

* `name` - Logical name of the type to be used in mappings.
* `typeName` - Qualified name of the type (as if you'd define it in an XML Schema). Optional.
* `CLASS_NAME` - String property which provides the name of the class. Required.
* `unmarshal` - Function which accepts `Jsonix.Context` and `Jsonix.XML.Input` and returns unmarshalled value.
* `marshal` - Function which accepts `Jsonix.Context`, value and `Jsonix.XML.Output` and marshalls the given value into the output.

In most cases you can just inherit from `Jsonix.Schema.XSD.AnySimpleType` and implement `print` and `parse` methods. See the following custom yes/no boolean typefor example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [new(Jsonix.Class(Jsonix.Schema.XSD.AnySimpleType, {
        name: 'MyModule.YesNo',
        typeName: new Jsonix.XML.QName('urn:my', 'YesNo'),
        print: function (value) {
            Jsonix.Util.Ensure.ensureBoolean(value);
            return value ? 'yes' : 'no';
        },
        parse: function (text) {
            Jsonix.Util.Ensure.ensureString(text);
            if (text.toLowerCase() === 'yes') {
                return true;
            } else if (text.toLowerCase() === 'no') {
                return false;
            } else {
                throw "Either [yes] or [no] expected as boolean value.";
            }
        },
        CLASS_NAME: 'MyModule.YesNo'
    }))()],
    elementInfos: [{
        elementName: 'data',
        typeInfo: 'MyModule.YesNo'
    }]
};
```

[Fiddle](http://jsfiddle.net/lexi/hDLKF).

### Complex types

Complex type has a name and contains a number of properties.

```
// Complex type declaration syntax
{
    // Local name of the type, required
    localName: 'ExtendedType',
    // Array of properties of this complex type, required
    propertyInfos: [ /* ... */ ],
    // Base type info, optional
    baseTypeInfo: 'MyModule.BaseType'
}
```

The name is defined using the `localName` property. The full name of the type will be composed of the name of the module and the local name of the complex type, with `.` as delimiter (`MyModule.DataType` in the example above. Name of the type can be used to reference this type in mappings (note the declaration of the `data` element above).

Properties are provided using the `propertyInfos` property. In the example above, we define two properties, `key` (mapped onto the `key` attribute) and `value` (mapped onto the textual contents of the element.

Complex types can be defined using the `typeInfos` property of the module:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'DataType',
        propertyInfos: [{
            type: 'value',
            name: 'value',
            typeInfo: 'Integer'
        }, {
            type: 'attribute',
            name: 'key',
            attributeName: 'key',
            typeInfo: 'String'
        }]
    }],
    elementInfos: [{
        elementName: 'data',
        typeInfo: 'MyModule.DataType'
    }]
};
```

[Fiddle](http://jsfiddle.net/lexi/c6EsM/).

The mapping above converts between the following XML:

```
<data key="one">1</data>
```

And the following JavaScript object:

```
{
    name: {
        localPart: 'data'
    },
    value: {
        key: 'one',
        value: 1
    }
}
```

[Fiddle](http://jsfiddle.net/lexi/c6EsM/).

See [#Properties](#properties) for more information on defining properties.

Properties declared in a complex type define both the structure of the JavaScript object as well as structure of the XML it will be mapped onto.

#### Defining complex types by extension

Complex types can be defined as extensions for other content types. This is achieved by setting the `baseTypeInfo` property of the extending type to point to the base type. Consider the following example:

```
var MyModule = {
    name: 'MyModule',
    typeInfos: [{
        type: 'classInfo',
        localName: 'BaseType',
        propertyInfos: [{
            type: 'element',
            name: 'alpha',
            elementName: 'Alpha',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'beta',
            elementName: 'Beta',
            collection: true,
            typeInfo: 'Integer'
        }]
    }, {
        type: 'classInfo',
        localName: 'ExtendedType',
        baseTypeInfo: 'MyModule.BaseType',
        propertyInfos: [{
            type: 'element',
            name: 'gamma',
            elementName: 'Gamma',
            typeInfo: 'AnyURI'
        }, {
            type: 'element',
            name: 'delta',
            elementName: 'Delta',
            collection: true,
            typeInfo: 'Date'
        }]
    }],
    elementInfos: [{
        elementName: 'Base',
        typeInfo: 'MyModule.BaseType'
    }, {
        elementName: 'Extended',
        typeInfo: 'MyModule.ExtendedType'
    }]
};
```

In this example the base type has the properties `alpha` and `beta` whereas the extended type has four properties `alpha`, `beta`, `gamma` and `delta`. This corresponds to the following XML Schema:

```
<xs:complexType name="BaseType">
	<xs:sequence>
		<xs:element name="Alpha" type="xs:string" minOccurs="0"/>
		<xs:element name="Beta" type="xs:integer" minOccurs="0" maxOccurs="unbounded"/>
	</xs:sequence>
</xs:complexType>

<xs:complexType name="ExtendedType">
	<xs:complexContent>
		<xs:extension base="BaseType">
			<xs:sequence>
				<xs:element name="Gamma" type="xs:anyURI" minOccurs="0"/>
				<xs:element name="Delta" type="xs:date" minOccurs="0" maxOccurs="unbounded"/>
			</xs:sequence>
		</xs:extension>
	</xs:complexContent>
</xs:complexType>
```

Here's a couple of examples of XML and equivalent JavaScript objects.

```
<Base>
	<Alpha>one</Alpha>
	<Beta>2</Beta>
	<Beta>3</Beta>
</Base>
```

Turns into:

```
{
	name : { localPart: 'Base' },
	value : {
		alpha : 'one',
		beta : [ 2, 3 ]
	},
	TYPE_NAME: 'MyModule.BaseType'
}
```

Next,

```
<Extended>
	<Alpha>one</Alpha>
	<Beta>2</Beta>
	<Beta>3</Beta>
	<Gamma>urn:four</Gamma>
	<Delta>2005-06-07</Delta>
	<Delta>2008-09-10</Delta>
</Extended>
```

turns into:

```
{
	name : { localPart : 'extended' },
	value : {
		alpha : 'one',
		beta : [ 2, 3 ],
		gamma : 'urn:four',
		delta : [ new Date(2005, 5, 7), new Date(2008, 8, 9) ]
	}
}
```

[Fiddle](http://jsfiddle.net/lexi/UjL6j).

#### Defining complex types by restriction

Definition of complex types by restriction is not supported.

