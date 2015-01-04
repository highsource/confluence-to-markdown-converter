## Compact Naming

Supported by Jsonix since version 2.1.0 and Jsonix Schema Compiler from version 2.2.0.

This feature is not backwards compatible - older Jsonix versions will not be able to read mappings with compact naming. However, newer version of Jsonix (2.1.0 and up) will stil read your "normal" (i.e. not compact) mappings. There are no plans to drop normal mappings.

Jsonix Schema Compiler 2.2.0 and up generate normal mappings by default but have a switch to generate compact mappings instead.

In order to reduce the size of mapping scripts, Jsonix offers compact naming. You can just replace long property names in mappings with their short versions.

Compact naming drastically reduces the size of the mapping files, you can expect 25-50% reduction in size.

The following sections list compact names corresponding to the full names as well as their default values.

### Module

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`name`|`n`|`null`|Name of the module|
|`defaultElementNamespaceURI`|`dens`|`''`|Default namespace URI for elements|
|`defaultAttributeNamespaceURI`|`dans`|`''`|Default namespace URI for attributes|
|`typeInfos`|`tis`|`[]`|Type infos declared in the module|
|`elementInfos`|`eis`|`[]`|Element infos declared in the module|

### Element infos

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`defaultElementNamespaceURI`|`dens`|`defaultElementNamespaceURI`of the module|Default namespace URI for elements|
|`defaultAttributeNamespaceURI`|`dans`|`defaultAttributeNamespaceURI`of the module|Default namespace URI for attributes|
|`elementName`|`en`||Name of the element, may be string or a qualified name. If it is a string, the qualified name will be formed using the `defaultElementNamespaceURI`|
|`typeInfo`|`ti`|`'String'`|Type of the element|
|`substitutionHead`|`sh`|`null`|Substitution head of the element|
|`scope`|`sc`|`null`|Scope of the element|

### Type infos

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`type`|`t`|`'classInfo'`|Type of the type info (ex. class, enum or list)|
|`classInfo`|`c`||Denotes a class type info|
|`enumInfo`|`enum`||Denotes a enum type info|
|`list`|`l`||Denotes a list type|
|`localName`|`ln`|`null`|Local name of the type within the module|
|`name`|`n`|`moduleName + '.' + localName`|Full name of the type|

#### List

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`baseTypeInfo`|`bti`|`'String'`|Type of the list items|
|`separator`|`s`|`' '`|Separator of the list items|

#### Enum

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`baseTypeInfo`|`bti`|`'String'`|Base type info of the enum|
|`values`|`vs`||Values of the enum|

#### Class

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`defaultElementNamespaceURI`|`dens`|`defaultElementNamespaceURI` of the module|Default namespace URI for elements|
|`defaultAttributeNamespaceURI`|`dans`|`defaultAttributeNamespaceURI` of the module|Default namespace URI for attributes|
|`baseTypeInfo`|`bti`|`null`|Base type info (super-class)|
|`instanceFactory`|`inF`|`null`|Instance factory - constructor function for instances of this class|
|`properties`|`ps`|`[]`|Properties|

#### Properties

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`name`|`n`||Name of the property|
|`defaultElementNamespaceURI`|`dens`|`defaultElementNamespaceURI` of the class|Default namespace URI for elements|
|`defaultAttributeNamespaceURI`|`dans`|`defaultAttributeNamespaceURI` of the class|Default namespace URI for attributes|
|`collection`|`col`|`false`|Whether this is a collection property|
|`type`|`t`|`'element'`|Property type|

Mapping properties above apply to all properties.

##### Property types

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`anyAttribute`|`aa`||Any attribute property|
|`anyElement`|`ae`||Any element property|
|`attribute`|`a`||Attribute property|
|`elementMap`|`em`||Element map property|
|`element`|`e`||Element property|
|`elements`|`es`||Elements property|
|`elementRef`|`er`||Element reference property|
|`elementRefs`|`ers`||Element references property|
|`value`|`v`||Value property|

##### Any attribute property

Any attribute property does not have any additional mapping parameters.

##### Any element property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`allowDom`|`dom`|`true`|Whether DOM elements are allowed as-is in case they are not known in this context and can't be unmarshalled|
|`allowTypedObject`|`typed`|`true`|Whether typed objects are allowed (not just DOM elements)|
|`mixed`|`mx`|`true`|If mixed content allowed (strings together with DOM elements or typed objects)|

##### Attribute property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`attributeName`|`an`|`name` of the property|Name of the attribute - qualified name or just string. Strings will be qualified using the `defaultAttributeNamespaceURI`|
|`typeInfo`|`ti`|`'String'`|Attribute's type|

##### Element map property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`elementName`|`en`|`name` of the property|Name of the element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`wrapperElementName`|`wen`|null|Name of the wraper element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`key`|`k`||Key property|
|`value`|`v`||Value property|

##### Element property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`elementName`|`en`|`name` of the property|Name of the element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`wrapperElementName`|`wen`|null|Name of the wraper element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`typeInfo`|`ti`|`'String'`|Element's type|

##### Elements property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`wrapperElementName`|`wen`|`null`|Name of the wraper element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`elementTypeInfos`|`etis`|`[]`|Element type infos of this property|

###### Elements property - element type infos

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`elementName`|`en`||Name of the element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`typeInfo`|`ti`|`'String'`|Type info of the element|

##### Element reference property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`elementName`|`en`|`name` of the property|Name of the element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`wrapperElementName`|`wen`|`null`|Name of the wrapper element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|mixed|mx|true|If this property allows mixed content|

##### Element references property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`wrapperElementName`|`wen`|`null`|Name of the wrapper element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`mixed`|`mx`|`true`|If this property allows mixed content|
|`elementTypeInfos`|`etis`|`[]`|Element type infos of this property|

###### Element references property - element type infos

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`elementName`|`en`||Name of the element - qualified name or just string. Strings will be qualified using the `defaultElementNamespaceURI`|
|`typeInfo`|`ti`|`'String'`|Type info of the element|

##### Value property

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`typeInfo`|`ti`|`'String'`|Type info of the value|

### Qualified names

|Name|Compact name|Default value|Description|
|----|------------|-------------|-----------|
|`localPart`|`lp`||Local part|
|`namespaceURI`|`ns`|`''`|Namespace URI|
|`prefix`|`p`|`''`|Prefix|

### Type names

Since Jsonix version 2.1.0.

When referencing types within the same module, you can use the compact syntax `.MyType` instead of the full name `MyModule.MyType`.

Example:

```
Five = {
	n : 'Five',
	tis : [ {
		ln : 'ValueType',
		ps : [ {
			t : 'v',
			n : 'value'
		} ]
	}, {
		ln : 'ElementsType',
		ps : [ {
			t : 'es',
			n : 'ab',
			etis : [ {
				en : 'a',
				// We can use .ValueType instead of Five.ValueType
				ti : '.ValueType'
			}, {
				en : 'b',
				ti : 'Integer'
			} ]
		} /*...*/ ],
	} ],
	eis : [ /* ... */ ]
};
```

