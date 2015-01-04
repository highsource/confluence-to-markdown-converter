# Working Example

This chapter demonstrates the usage of Jsonix in a classic "purchase order" example.

Assume you need to develop a JavaScript program which should process an XML in the following XML Schema:

* [Purchase order schema](http://www.w3.org/TR/xmlschema-0/#po.xsd) from the [XML Schema Primer](http://www.w3.org/TR/xmlschema-0/).

Here's an example of XML for this schema:

```
<purchaseOrder orderDate="1999-10-20">
  <shipTo country="US">
    <name>Alice Smith</name>
    <street>123 Maple Street</street>
    <city>Mill Valley</city>
    <state>CA</state>
    <zip>90952</zip>
  </shipTo>
  <billTo country="US">
    <name>Robert Smith</name>
    <street>8 Oak Avenue</street>
    <city>Old Town</city>
    <state>PA</state>
    <zip>95819</zip>
  </billTo>
  <comment>Hurry, my lawn is going wild!</comment>
  <items>
    <item partNum="872-AA">
      <productName>Lawnmower</productName>
      <quantity>1</quantity>
      <USPrice>148.95</USPrice>
      <comment>Confirm this is electric</comment>
    </item>
    <item partNum="926-AA">
      <productName>Baby Monitor</productName>
      <quantity>1</quantity>
      <USPrice>39.98</USPrice>
      <shipDate>1999-05-21</shipDate>
    </item>
  </items>
</purchaseOrder>
```

## Usage example

Here's how you would parse this XML document with Jsonix:

```
// The PO variable provides Jsonix mappings for the purchase order test case
// Its definition will be shown in the next section

var PO = {
    // ... Declaration of Jsonix mappings for the purchase order schema ...
};


// First we construct a Jsonix context - a factory for unmarshaller (parser)
// and marshaller (serializer)
var context = new Jsonix.Context([PO]);

// Then we create a unmarshaller
var unmarshaller = context.createUnmarshaller();

// Unmarshal an object from the XML retrieved from the URL
unmarshaller.unmarshalURL('po.xml',
// This callback function will be provided with the result
// of the unmarshalling
function (unmarshalled) {
    console.log(unmarshalled.value.shipTo.name); // Alice Smith
    console.log(unmarshalled.value.items.item[1].productName); // Baby Monitor
});
```

The callback function will receive the result of the unmarshalling in a form of a JavaScript object. Here's how it would look like in JavaScript:

```
{
    name: {
        localPart: "purchaseOrder"
    },
    value: {
        orderDate: new Date(1999, 10, 20),
        shipTo: {
            country: "US",
            name: "Alice Smith",
            street: "123 Maple Street",
            city: "Mill Valley",
            state: "CA",
            zip: 90952
        },
        billTo: {
            name: "Robert Smith",
            street: "8 Oak Avenue",
            city: "Old Town",
            state: "PA",
            country: "US",
            zip: 95819
        },
        comment: 'Hurry, my lawn is going wild!',
        items: {
            item: [{
                partNum: "872-AA",
                productName: "Lawnmower",
                quantity: 1,
                usPrice: 148.95,
                comment: "Confirm this is electric"
            }, {
                partNum: '926-AA',
                productName: 'Baby Monitor',
                quantity: 1,
                usPrice: 39.98,
                shipDate: new Date(1999, 4, 21)
            }]
        }
    }
}
```

Here's how marshalling of a JavaScript object into XML would look like:

```
// Create a marshaller
var marshaller = context.createMarshaller();
// Marshal a JavaScript Object as XML (DOM Document)
var doc = marshaller.marshalDocument({
    name: {
        localPart: "purchaseOrder"
    },
    value: {
        orderDate: {
            year: 1999,
            month: 10,
            day: 20
        },
        shipTo: {
            country: "US",
            name: "Alice Smith",
            street: "123 Maple Street",
            city: "Mill Valley",
            state: "CA",
            zip: 90952
        },
        billTo: {
            name: "Robert Smith",
            street: "8 Oak Avenue",
            city: "Old Town",
            state: "PA",
            country: "US",
            zip: 95819
        }, // ...
    }
});
```

Try it online in a [fiddle](http://jsfiddle.net/lexi/LP3DC/).

## Defining mappings

Now let us take a look at the XML/object mappings, the part we skipped previously:

```
var PO = {
    name: 'PO',
    typeInfos: [{
        type: 'classInfo',
        localName: 'PurchaseOrderType',
        propertyInfos: [{
            type: 'element',
            name: 'shipTo',
            elementName: 'shipTo',
            typeInfo: 'PO.USAddress'
        }, {
            type: 'element',
            name: 'billTo',
            elementName: 'billTo',
            typeInfo: 'PO.USAddress'
        }, {
            type: 'element',
            name: 'comment',
            elementName: 'comment',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'items',
            elementName: 'items',
            typeInfo: 'PO.Items'
        }, {
            name: 'orderDate',
            typeInfo: 'Calendar',
            attributeName: 'orderDate',
            type: 'attribute'
        }]
    }, {
        type: 'classInfo',
        localName: 'Items',
        propertyInfos: [{
            type: 'element',
            name: 'item',
            collection: true,
            elementName: 'item',
            typeInfo: 'PO.Item'
        }]
    }, {
        type: 'classInfo',
        localName: 'USAddress',
        propertyInfos: [{
            type: 'element',
            name: 'name',
            elementName: 'name',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'street',
            elementName: 'street',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'city',
            elementName: 'city',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'state',
            elementName: 'state',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'zip',
            elementName: 'zip',
            typeInfo: 'Decimal'
        }, {
            name: 'country',
            typeInfo: 'String',
            attributeName: 'country',
            type: 'attribute'
        }]
    }, {
        type: 'classInfo',
        localName: 'Item',
        propertyInfos: [{
            type: 'element',
            name: 'productName',
            elementName: 'productName',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'quantity',
            elementName: 'quantity',
            typeInfo: 'Int'
        }, {
            type: 'element',
            name: 'usPrice',
            elementName: 'USPrice',
            typeInfo: 'Decimal'
        }, {
            type: 'element',
            name: 'comment',
            elementName: 'comment',
            typeInfo: 'String'
        }, {
            type: 'element',
            name: 'shipDate',
            elementName: 'shipDate',
            typeInfo: 'Calendar'
        }, {
            name: 'partNum',
            typeInfo: 'String',
            attributeName: 'partNum',
            type: 'attribute'
        }]
    }],
    elementInfos: [{
        elementName: 'purchaseOrder',
        typeInfo: 'PO.PurchaseOrderType'
    }, {
        elementName: 'comment',
        typeInfo: 'String'
    }]
};
// If we're in node.js environment, export the mappings
if (typeof require === 'function') {
  module.exports.PO = PO;
}
```

Basically, Jsonix mappings is a JavaScript object which describes how XML constructs (simple and complex types, elements, attributes) should be represented in object form. From the other hand, Jsonix mappings define the target object structure: objects, properties, their types and cardinalities. XML/object mappings are required to guarantee strongly-structured and strongly-typed mapping.

## Generating mappings from an XML Schema

As we've seen above, Jsonix needs XML/object mappings to operate. These mappings can be created manually, they are just simple JavaScript programs which use Jsonix API.

There is, however, another possibility for creating Jsonix mappings: you can generate them automatically from an XML Schema. Jsonix provides a *schema compiler* which take an XML Schema as input and generates Jsonix mappings for it. So instead of writing `PO.js` per hand you can generate it from an XML Schema (`po.xsd`) using the Jsonix schema compiler:

```
java
  -jar jsonix-schema-compiler-full-<VERSION>.jar // Run executable Java archieve
  -d mappings // Target directory
  -p PO // Package/Module name
  purchaseorder.xsd // Schema
```

You can [[download|Downloads]] the complete example.

