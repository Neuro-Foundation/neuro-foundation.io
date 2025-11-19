Title: Sensor Data
Description: Sensor Data page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Sensor Data
==================

This document outlines the XML representation of sensor data. The XML representation is modelled using an annotated XML Schema:

| Sensor Data                                           ||
| ------------|------------------------------------------|
| Namespace:  | `urn:nfi:iot:sd:1.0`                      |
| Schema:     | [SensorData.xsd](Schemas/SensorData.xsd) |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The representation of sensor data described in this document, is designed with the following goals in mind:

* The representation must be **loosely coupled** with the type of device and the data being represented. Loose coupling guarantees that
infrastructure and software components do not need to be updated, by the introduction of new types of devices into the network.

* Sufficient **meta-data** must be available, to be able to process the data in a generic sense and create both Machine-to-Machine (M2M) and 
Human-to-Machine (H2M) interfaces automatically.


Requirements
---------------

![Sensor Data Requirements](SensorDataRequirements.md)

Conceptual model
------------------------

The XML representation of Sensor Data used by the Neuro-Foundation IoT interfaces is based on a three or four level abstraction:

```uml:Conceptual model
@startuml
Device "1" *-- "0..*" Node
Node o-- "*" Timestamp
Device "1" o-- "*" Timestamp
Timestamp "1  " o-- "*" Field
Timestamp "1" o-- "*" Error

Device : JID

Node : Node ID
Node : Source ID
Node : Partition

Timestamp : Date & Time

Field : Name
Field : Field Type
Field : Quality of Service
Field : Localization
Field : Custom Annotation

Error : Message
@enduml
```

Either the **device** is a simple device, with one identity, or it consists of a set of **nodes**. The latter is also sometimes referred 
to as a **concentrator**, as it *concentrates* several nodes, or virtual devices, into one entity. Each device then reports a set of **fields** (or **errors**), 
each stamped with a **timestamp** to which they correspond. In XMPP, devices are addressed using an **XMPP Address**, also referred to as a **Jabber ID** or 
a **JID**.

The nodes are identified using one to three identifiers, depending on the size and needs of the concentrator. The required attribute, is the 
**Node ID**. The **Source ID** allows a concentrator to divide the set of nodes into different data sources. If data sources are not used, this
attribute can be omitted. **Partitions** allow the concentrator to divide a data source into multiple pieces. This attribute can also be omitted,
if not used. It is the triple (Node ID, Source ID, Partition) that must be unique inside the device.

### XML representation

| Entity    | Element   | Use      | Attributes | Type          | Use      | Description     |
|-----------|-----------|----------|------------|---------------|----------|-----------------|
| Node      | `nd`      | Optional | `id`       | `xs:string`   | Required | Node identity   |
|           |           |          | `src`      | `xs:string`   | Optional | Source identity |
|           |           |          | `pt`       | `xs:string`   | Optional | Partition       |
| Timestamp | `ts`      | Required | `v`        | `xs:dateTime` | Required | Timestamp value |
		  

Fields
---------------------

The sensor data model defines different types of fields, depending on the data type required to represent its value.

```uml:Conceptual model
@startuml
Field <|-- PhysicalQuantity
Field <|-- String
Field <|-- Boolean
Field <|-- Date
Field <|-- DateTime
Field <|-- Duration
Field <|-- Enumeration
Field <|-- Int32
Field <|-- Int64
Field <|-- Time

Field : Name
Field : Field Type
Field : Quality of Service
Field : Localization
Field : Custom Annotation

PhysicalQuantity : Value : xs:double
PhysicalQuantity : Unit : xs:string

String : Value : xs:string

Boolean : Value : xs:boolean

Date : Value : xs:date

DateTime : Value : xs:dateTime

Duration : Value : xs:duration

Enumeration : Value : xs:string
Enumeration : Type : xs:string

Int32 : Value : xs:int

Int64 : Value : xs:long

Time : Value : xs:time
@enduml
```

### XML representation

| Entity                  | Element | Use      | Attributes | Type          | Use      | Description                |
|-------------------------|---------|----------|------------|---------------|----------|----------------------------|
| Boolean Field           | `b`     | Optional | `v`        | `xs:boolean`  | Required | Boolean field value        |
| Date Field              | `d`     | Optional | `v`        | `xs:date`     | Required | Date field value           |
| Date & Time Field       | `dt`    | Optional | `v`        | `xs:dateTime` | Required | Date & Time field value    |
| Duration Field          | `dr`    | Optional | `v`        | `xs:duration` | Required | Duration field value       |
| Enumeration Field       | `e`     | Optional | `v`        | `xs:string`   | Required | Enumeration field value    |
|                         |         |          | `t`        | `xs:string`   | Required | Enumeration Type used      |
| 32-bit Integer Field    | `i`     | Optional | `v`        | `xs:int`      | Required | 32-bit Integer field value |
| 64-bit Integer Field    | `l`     | Optional | `v`        | `xs:long`     | Required | 64-bit Integer field value |
| Physical Quantity Field | `q`     | Optional | `v`        | `xs:double`   | Required | Floating-point field value |
|                         |         |          | `u`        | `xs:string`   | Optional | Unit used                  |
| String Field            | `s`     | Optional | `v`        | `xs:string`   | Required | String field value         |
| Time Field              | `t`     | Optional | `v`        | `xs:time`     | Required | Time field value           |

Common field attributes
--------------------------

The different field types share a set of common attributes. All fields include the required **name**, then optional **localization** information for languages, and if the field corresponds to 
a **control parameter** with the same name. More on [localization](#localization) below. The field can also be annotated with **category** and
**quality of service** information.

| Attributes | Type          | Use      | Description                                                            |
|------------|---------------|----------|------------------------------------------------------------------------|
| `n`        | `xs:string`   | Required | Field name                                                            |
| `lns`      | `xs:string`   | Optional | Localization namespace                                                |
| `loc`      | `xs:string`   | Optional | Localization steps                                                    |
| `ctr`      | `xs:boolean`  | Optional | If the field has a corresponding control parameter with the same name |


### Field categories

Apart from the field type, each field can also be categorized using a set of category attributes. These can be used in requests, to limit responses
to certain categories. The categories can also be combined.

| Attributes | Type         |  Use     | Description       |
|------------|--------------|----------|-------------------|
| `m`        | `xs:boolean` | Optional | Momentary value  |
| `p`        | `xs:boolean` | Optional | Peak value       |
| `s`        | `xs:boolean` | Optional | Status value     |
| `c`        | `xs:boolean` | Optional | Computed value   |
| `i`        | `xs:boolean` | Optional | Identity value   |
| `h`        | `xs:boolean` | Optional | Historical value |

### Quality of service

Individual fields can also be annotated with Quality of Service information, using a set of predefined attributes:

| Attributes | Type         |  Use     | Description                                                        |
|------------|--------------|----------|--------------------------------------------------------------------|
| `ms`       | `xs:boolean` | Optional | Value is missing                                                  |
| `pr`       | `xs:boolean` | Optional | Value is in the progress of being calculated                      |
| `ae`       | `xs:boolean` | Optional | Value is an automated estimate                                    |
| `me`       | `xs:boolean` | Optional | Value is a manual estimate                                        |
| `mr`       | `xs:boolean` | Optional | Value is the result of a manual readout                           |
| `ar`       | `xs:boolean` | Optional | Value is the result of an automatic readout                       |
| `of`       | `xs:boolean` | Optional | The internal clock is offset more than an allowed value           |
| `w`        | `xs:boolean` | Optional | A warning has been logged, related to the value                   |
| `er`       | `xs:boolean` | Optional | An error has been logged, related to the value                    |
| `so`       | `xs:boolean` | Optional | The value has been signed by an operator                          |
| `iv`       | `xs:boolean` | Optional | The value has been used for the creation of an invoice            |
| `eos`      | `xs:boolean` | Optional | The value represents the last of a series of values               |
| `pf`       | `xs:boolean` | Optional | Power failure has been registered, concerning the value           |
| `ic`       | `xs:boolean` | Optional | The invoice created on the basis of the value, has been confirmed |

Some of the Quality of Service levels are mutually exclusive, others can be combined. Some introduce a natural order of "quality", that can be used to
decide if a reported value is has a higher quality, and thus can overwrite an existing value of lesser quality:

`ms` < `ms+so` < `pr` < `pr+so` < `ae` < `ae+so` < `me` < `me+so` < `mr` < `mr+so` < `ar` < `ar+so` < `so` < `iv` < `iv+so` < `ic` < `ic+so`

The significance of the `so` attribute is to tell the system the value has been signed by an authorized human operator and can thus be used to override
existing values.

### Custom extensions

Each field can be extended using custom elements and custom attributes. This is done by including an `<x/>` element as a child node to the corresponding
field node. The `<x/>` element can take any number of attributes and child elements of any type. Note however, that only fully qualified elements and attributes,
that have been approved by a standards group can be used for interoperable features.


Errors
--------------

Errors can be reported at the same level as fields in the sensor data model. It is done using the `<err/>` element. It is a simple type of type `xs:string`.

Localization
---------------

The sensor data model allows for localization of field names. The required name attribute `n` defines the field, while the optional `lns` and `loc` attributes
can be used to localize the name. The possibility to localize field names, however, should not discourage the use of human readable names on fields. Instead,
the localization parameters should be seen as a way to represent the field name in multiple languages in human interfaces.

The principle behind localization, is the use of namespaces, and then identifying each translatable element of a string, with a positive integer in that
corresponding namespace. The translation of a string can then be made using a sequence of translation steps, each one consisting of a **String ID**, an optional 
**Namespace** and an optional **Seed** value. The localized string in each step, can include the values `%0%`, corresponding to the result of the previous step,
and `%1%`, corresponding to the seed value. If no namespace is provided, the default namespace is used, which is provided in the `lns` attribute. The `loc` 
attribute is then formed of the individual translation steps delimited by commas (`,`). The different parts of each step are delimited using pipe characters
(`|`).

In the following examples, assume `lns="NS"`:

| `loc`            | Result                |
|------------------|-----------------------|
| 1                | Temperature           |
| 2&#124;&#124;5   | Input 5               |
| 1,3              | Temperature, Max      |
| 2&#124;&#124;5,3 | Input 5, Max          |
| 1,1&#124;Stat    | Avg(Temperature)      |
| 1,1&#124;Stat,3  | Avg(Temperature), Max |


| ID    | `NS`        |
|-------|-------------|
| 1     | Temperature |
| 2     | Input %1%   |
| 3     | %0%, Max    |

| ID    | `Stat`      |
|-------|-------------|
| 1     | Avg(\%0\%)  |

**Note**: Providing localized strings, ordered by namespace and language, would be the only components required to be updated in software supporting
the architecture described in this document. But such strings constitute data, and not code, so no actual software updates are required. Furthermore,
interfaces will still work without the actual localized versions of the strings, if human readable strings are chosen as default field names when
reporting fields. Preferable, all field names are chosen in a globally understood language, such as English.


Control parameters
-------------------------

If reporting sensor data from an actuator, you can highlight the correlation of sensor data fields with the corresponding control parameters having the 
same name, by using the `ctr` attribute on the corresponding field. If the field name appears multiple times in the sensor data readout, only the
momentary value should be flagged with the `ctr`attribute.

Legacy
-------------

The following data model is based on work done in the [XMPP Standards Foundation (XSF)](https://xmpp.org/about/xmpp-standards-foundation.html),
[XEP-0323: Internet of Things - Sensor Data](https://xmpp.org/extensions/xep-0323.html). Following is a list of notable differences:

* A Neuro-Foundation namespace is used.
* Names of elements and attributes have been shortened.
* A separation of XML representation and communication pattern has been done.
* The schema is now annotated.
* Historical periods have been removed and replaced with a single historical field category.
* It is possible to customize the annotation of fields.
* Sensor data spanning multiple messages are correlated using a string-valued `id` attribute, instead of a sequence number.
* The node element is now optional.
* Localization is somewhat simplified.
* Errors can now be embedded with the sensor data and is not related to the communication pattern.
* Documentation has been simplified.
* It has been made easier for small/quick devices to respond.
* A `more` attribute is used instead of a `done` attribute.

Examples
---------------

A simple example containing sensor data from a temperature sensor.

```xml
<ts v="2017-09-22T15:22:33Z" xmlns="urn:nfi:iot:sd:1.0">
  <q n="Temperature" v="12.3" u="°C" m="true" ar="true"/>
  <s n="SN" v="12345678" i="true" ar="true"/>
</ts>
```

If this temperature sensor would be a node inside a concentrator, the same data would be represented as:

```xml
<nd id="Node1" xmlns="urn:nfi:iot:sd:1.0">
  <ts v="2017-09-22T15:22:33Z">
    <q n="Temperature" v="12.3" u="°C" m="true" ar="true"/>
    <s n="SN" v="12345678" i="true" ar="true"/>
  </ts>
</nd>
```