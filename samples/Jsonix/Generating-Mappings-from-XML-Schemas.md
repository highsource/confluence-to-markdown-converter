# Generating mappings from XML Schema

You need a Java environment to generate mappings from XML Schemata.

## Command-line tool

```
java
  -jar jsonix-full-<VERSION>.jar // Run executable Java archieve
  -d src/main/webapp/js // Target directory
  src/main/resources/purchaseorder.xsd // Schema
  -b src/main/resources/bindings.xjb // Bindings
```

## XJC plugin

If you're already using XJC to compile your schemas, you'll just need to use the `jsonix` plugin for XJC. The plugin can be downloaded [[here|Downloads]]. It is activated using the following command-line option:

```
-Xjsonix
```

### Maven usage

* Set `extension=true`
* Add `-Xjsonix` to `args/arg`

```
<plugin>                                                                       
	<groupId>org.jvnet.jaxb2.maven2</groupId>                              
	<artifactId>maven-jaxb2-plugin</artifactId>                            
	<configuration>                                                        
		<extension>true</extension>                                    
		<args>                                                         
			<arg>-Xjsonix</arg>                                    
		</args>                                                        
		<plugins>                                                      
			<plugin>                                               
				<groupId>org.hisrc.jsonix</groupId>            
				<artifactId>jsonix-schema-compiler</artifactId>
				<version><VERSION></version>          
			</plugin>                                              
		</plugins>                                                     
	</configuration>                                                       
</plugin>                                                                      
```

### Ant usage

```
<xjc destdir="${basedir}/target/generated-sources/xjc" extension="true">
	<binding dir="${basedir}/src/main/resources">
	 	<include name="**/*.xjb"/>
	</binding>
	<schema dir="${basedir}/src/main/resources">
	 	<include name="**/*.xsd"/>
	</schema>
	<!-- Plugins -->
	<classpath>
		<fileset dir="${basedir}/lib">
			<include name="jsonix-<VERSION>.jar"/>
		</fileset>
	</classpath>
	<arg line="-Xjsonix"/>
</xjc>
```

## Bindings files

Now you may wonder, what the bindings file does. Bindings customize schema compilation. For instance, you can instruct Jsonix schema compiler to generate the `PO` module (by default written to the `PO.js` file).

Here's how a typical bindings file looks like.

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<jaxb:bindings
	version="2.1"
	xmlns:jaxb="http://java.sun.com/xml/ns/jaxb"
	xmlns:jsonix="http://jsonix.highsource.org/customizations"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	jaxb:extensionBindingPrefixes="jsonix">

	<jaxb:bindings schemaLocation="purchaseorder.xsd" node="/xs:schema">
		<jaxb:schemaBindings>
			<jaxb:package name="org.hisrc.jsonix.demos.po"/>
		</jaxb:schemaBindings>

		<jsonix:packageMapping
			packageName="org.hisrc.jsonix.demos.po"
			spaceName="PO"/>
		
	</jaxb:bindings>

</jaxb:bindings>
```

This bindings file basically says two things:

* The `purchaseorder.xsd` schema will get the package `org.hisrc.jsonix.demos.po`
* The package `org.hisrc.jsonix.demos.po` will have the associated space name (module) `PO`

This might look a bit cumbersome, but this is due to certain limitations in the underlying technologies.

## Using command-line tool in node.js

Add schema generation as a `preinstall` script.

```
{
	...,

	"dependencies": {
		"jsonix": "~<VERSION>"
	},
	"scripts": {
		"preinstall" : "java 
-jar node_modules/jsonix/lib/jsonix-schema-compiler-full.jar 
-d mappings purchaseorder.xsd -b bindings.xjb"
	}
}
```

(Line breaks are added for readablility.)

## Generating compact mappings

Generation of the compact mappings is an experimental feature. While compact naming is stable and ready to use, the way you tell the Jsonix Schema Compiler to generate compact mappings may change in the future. Please be warned that you may need to update your generation scripts then.

Since Jsonix Schema Compiler version 2.2.0.

You can generate compact mappings using the following additional switch:

```
-Xjsonix-compact
```

