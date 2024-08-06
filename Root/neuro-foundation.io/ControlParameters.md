Control Parameters
========================

This document outlines the XML representation of control parameters, as defined by the IEEE XMPP IoT Working Group. The XML representation is modelled using
an annotated XML Schema:

| Control                                         ||
| ------------|------------------------------------|
| Namespace:  | urn:ieee:iot:ctr:1.0               |
| Schema:     | [Control.xsd](Schemas/Control.xsd) |

Motivation and design goal
----------------------------

The representation of control parameters in this document, is designed with the following goals in mind:

* The representation must be **loosely coupled** with the type of device and the data being represented. Loose coupling guarantees that
infrastructure and software components do not need to be updated, by the introduction of new types of devices into the network.

* Sufficient **meta-data** must be available, to be able to process the data in a generic sense and create both Machine-to-Machine (M2M) and 
Human-to-Machine (H2M) interfaces automatically.

* Quick atomic control actions should be possible.

* Intelligible and intuitive human interfaces should be possible to define.


Conceptual model
------------------------

A device publishing a control interface, publishes a set of **control parameters**. A device can also consist of a set of **nodes**, each publishing
an individual set of **control parameters**. Each control parameter is a **simple type**. More complex control operations must be defined by **grouping** simple control parameters together. 
The basic types defined in this interface are:

```uml:Conceptual model
@startuml
Device "1" *-- "0..*" Node
Node o-- "*" Parameter
Device "1" o-- "*" Parameter

Parameter <|-- Boolean
Parameter <|-- Color
Parameter <|-- Date
Parameter <|-- DateTime
Parameter <|-- Double
Parameter <|-- Duration
Parameter <|-- Enum
Parameter <|-- Int32
Parameter <|-- Int64
Parameter <|-- String
Parameter <|-- Time

Node : ID
Node : [Source]
Node : [Partition]

Parameter : Name

String : Value : xs:string

Boolean : Value : xs:boolean

Color : Value : Color

Date : Value : xs:date

DateTime : Value : xs:dateTime

Double : Value : xs:double

Duration : Value : xs:duration

Enum : Value : xs:string
Enum : Type : xs:string

Int32 : Value : xs:int

Int64 : Value : xs:long

Time : Value : xs:time
@enduml
```

A device containing multiple nodes is also called a **concentrator**, as it concentrates a set of nodes into one entity. The nodes are identified using 
one to three identifiers, depending on the size and needs of the concentrator. The required attribute, is the 
**Node ID**. The **Source ID** allows a concentrator to divide the set of nodes into different data sources. If data sources are not used, this
attribute can be omitted. **Partitions** allow the concentrator to divide a data source into multiple pieces. This attribute can also be omitted,
if not used. It is the triple (Node ID, Source ID, Partition) that must be unique inside the device.

XML representation
--------------------

Control parameters can be represented in two different ways. One, for quick control options, and another for human interfaces. Quick control commands
only concern themselves with parameter names and their corresponding parameter values. Human interfaces for control options require more information,
including possible layout information. For this reason, XMPP data forms are used to represent the control parameters. Both of these representations
are made inside a node element.

| Entity    | Element   | Use      | Attributes | Type          | Use      | Description     |
|-----------|-----------|----------|------------|---------------|----------|-----------------|
| Node      | `nd`      | Optional | `id`       | `xs:string`   | Required | Node identity   |
|           |           |          | `src`      | `xs:string`   | Optional | Source identity |
|           |           |          | `pt`       | `xs:string`   | Optional | Partition       |

### Control representation of parameters

The model defines different types of parameters, depending on the underlying simple data type of the parameter. Regardless of type of parameter,
they all share one common attribute:

| Entity                      | Attributes | Type        | Use      | Description     |
|-----------------------------|------------|-------------|----------|-----------------|
| Parameter                   | `n`        | `xs:string`  | Required | Parameter name |

The value on the other hand, is encoded using the corresponding type of the parameter:

| Entity                      | Element | Use      | Attributes | Type          | Use      | Description                                           |
|-----------------------------|---------|----------|------------|---------------|----------|-------------------------------------------------------|
| Boolean Parameter           | `b`     | Optional | `v`        | `xs:boolean`  | Required | Boolean parameter value                               |
| Color Parameter             | `cl`    | Optional | `v`        | `Color`[^1]   | Required | Color parameter value                                 |
| Date Parameter              | `d`     | Optional | `v`        | `xs:date`     | Required | Date parameter value                                  |
| Date & Time Parameter       | `dt`    | Optional | `v`        | `xs:dateTime` | Required | Date & Time parameter value                           |
| Double Parameter            | `db`    | Optional | `v`        | `xs:double`   | Required | Double-precision floating point parameter value       |
| Duration Parameter          | `dr`    | Optional | `v`        | `xs:duration` | Required | Duration parameter value                              |
| Enumeration Parameter       | `e`     | Optional | `v`        | `xs:string`   | Required | String parameter value                                |
|                             |         |          | `t`        | `xs:string`   | Required | Type name of enumeration                              |
| 32-bit Integer Parameter    | `i`     | Optional | `v`        | `xs:int`      | Required | 32-bit Integer parameter value                        |
| 64-bit Integer Parameter    | `l`     | Optional | `v`        | `xs:long`     | Required | 64-bit Integer parameter value                        |
| String Parameter            | `s`     | Optional | `v`        | `xs:string`   | Required | String parameter value                                |
| Time Parameter              | `t`     | Optional | `v`        | `xs:time`     | Required | Time parameter value                                  |

[^1]: Colors are either 6 or 8 character hexadecimal strings (RRGGBB, or RRGGBBAA), where each two characters correspond to one component of the (R, G, B) or (R, G, B, A) color definition.

### Data Form representation of parameters

To create human interfaces for control parameters, XMPP data forms are used. Such forms integrate into existing XMPP client software implementations
and allow devices to provide basic information about how the user is supposed to interact with the control parameters in a meaningful way. XMPP data forms
are defined in a set of XMPP extensions:

* [XEP-0004: Data Forms](https://xmpp.org/extensions/xep-0004.html)
* [XEP-0122: Data Forms Validation](https://xmpp.org/extensions/xep-0122.html)
* [XEP-0141: Data Forms Layout](https://xmpp.org/extensions/xep-0141.html)
* [XEP-0221: Data Forms Media Element](https://xmpp.org/extensions/xep-0221.html)
* [XEP-0331: Data Forms - Color Field Types](https://xmpp.org/extensions/xep-0331.html)
* [XEP-0336: Data Forms - Dynamic Forms](https://xmpp.org/extensions/xep-0336.html)

The basic layout of data forms XML is defined in [XEP-0004: Data Forms](https://xmpp.org/extensions/xep-0004.html). It defines forms as a set of
fields. More detailed rules for the validation of field content is defined in [XEP-0122: Data Forms Validation](https://xmpp.org/extensions/xep-0122.html).
The ability to put fields into sections and tabs (pages) is then introduced in [XEP-0141: Data Forms Layout](https://xmpp.org/extensions/xep-0141.html).
Multimedia elements can also be inserted through the use of [XEP-0221: Data Forms Media Element](https://xmpp.org/extensions/xep-0221.html). Color-valued
field parameters are defined in [XEP-0331: Data Forms - Color Field Types](https://xmpp.org/extensions/xep-0331.html). Creating dynamic forms, including
the management of server post-backs, contextual content, visual feedback, asynchronous server updates (push), etc., is defined in 
[XEP-0336: Data Forms - Dynamic Forms](https://xmpp.org/extensions/xep-0336.html).

Each control parameter is modelled as a field in a data form. Form validation is used to provide validation rules for input. Layout should be used to
give the user viewing the form an intuitive understanding of how the form operates. Dynamic forms can further be used to provide enhanced feedback. The
control extension further provides an extension to data forms: The ability to group parameters into one unit. By creating **parameter groups**, the client
can be made to understand that certain parameters belong together and should be treated as a unit. This means that if a user changes the value of one parameter,
all parameters in that group should be configured together. This is done by inserting a `pGroup` element in the field definition.

Legacy
-------------

The following data model is based on work done in the [XMPP Standards Foundation (XSF)](https://xmpp.org/about/xmpp-standards-foundation.html),
[XEP-0325: Internet of Things - Control](https://xmpp.org/extensions/xep-0325.html). Following is a list of notable differences:

* An IEEE namespace is used.
* Names of elements and attributes have been shortened.
* A separation of XML representation and communication pattern has been done.
* The schema is now annotated.
* Documentation has been simplified.

Examples
---------------

Simple set of parameters for a spotlight:

```xml
<b n="MainSwitch" v="true"/>
<db n="HorizontalAngle" v="0"/>
<db n="ElevationAngle" v="0"/>
```

Same set of parameters, represented in a Data Form, using the validation, layout and dynamic form extensions:

```xml
<x type='form'
    xmlns='jabber:x:data'
    xmlns:xdv='http://jabber.org/protocol/xdata-validate'
    xmlns:xdl='http://jabber.org/protocol/xdata-layout'
    xmlns:xdd='urn:xmpp:xdata:dynamic'>
  <title>Spotlight</title>
  <xdl:page label='Output'>
    <xdl:fieldref var='MainSwitch'/>
  </xdl:page>
  <xdl:page label='Direction'>
    <xdl:fieldref var='HorizontalAngle'/>
    <xdl:fieldref var='ElevationAngle'/>
  </xdl:page>
  <field var='xdd session' type='hidden'>
    <value>83CAA4BC-6D3A-40E6-90DC-5C3CAA030AE1</value>
  </field>
  <field var='MainSwitch' type='boolean' label='Main switch'>
    <desc>If the spotlight is turned on or off.</desc>
    <value>true</value>
    <xdd:notSame/>
  </field>
  <field var='HorizontalAngle' type='text-single' label='Horizontal angle:'>
    <desc>Horizontal angle of the spotlight.</desc>
    <value>0</value>
    <xdv:validate datatype='xs:double'>
      <xdv:range min='-180' max='180'/>
    </xdv:validate>
    <xdd:notSame/>
    <pGroup xmlns='urn:ieee:iot:ctr:1.0' name='direction'/>
  </field>
  <field var='ElevationAngle' type='text-single' label='Elevation angle:'>
   <desc>Elevation angle of the spotlight.</desc>
   <value>0</value>
   <xdv:validate datatype='xs:double'>
     <xdv:range min='-90' max='90'/>
   </xdv:validate>
   <xdd:notSame/>
   <pGroup xmlns='urn:ieee:iot:ctr:1.0' name='direction'/>
  </field>
</x>
```