Title: Harmonized Interfaces
Description: Page describing harmonized interfaces
Date: 2025-08-25
Author: Peter Waher
Master: Master.md
JavaScript: /Controls/SimpleTree.js
JavaScript: /Events.js
CSS: /Controls/SimpleTree.cssx

=============================================

Harmonized Interfaces
========================

While it for many purposes is sufficient to know how to communicate sensor data and control
actions in order to generate human interfaces and allow humans to program and configure 
IoT-systems, it is not sufficient in many cases for machine-to-machine interoperation without
human operators. For this purpose, *harmonized interfaces* are defined. These can be used as
templates or agreements on how to interpret exchange information for different use cases. 
Developers are free to create their own interoperability interfaces, if a suitable is lacking.
Neuro-Foundation publishes a set of harmonized interfaces to simplify interoperability across 
domains. This document shows available interfaces.

| Harmonized Interfaces                                                      ||
| -------------|--------------------------------------------------------------|
| Namespace:   | `urn:nfi:iot:hi:1.0`                                         |
| Schema:      | [HarmonizedInterfaces.xsd](Schemas/HarmonizedInterfaces.xsd) |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The following design goals have been used when defining the architecture publishing and
promoting the use of harmonized interfaces for interoperability between devices:

* The concept of an interface

* Any actor with control of a domain is allowed to publish harmonized interfaces for
interoperability, and share and publish the definition with others.

* Any device, be it a standalone device, or embedded in a [concentrator](/Concentrator.md), can 
implement any number of harmionized interfaces.

* Any other device, be it a standalone device, or embedded in a [concentrator](/Concentrator.md), 
with  permission to the first device, can retrieve the list of supported harmonized interfaces, 
in order to learn how it can interoperate with the device.

* Sensor data readout, and actuator control operations are performed using the operations
defined for [Communication Patterns](/Index.md#communicationPatterns) using formats as defined
in the [Representation](https://neuro-foundation.io/Index.md#representation) section.


Requirements
---------------

![Harmonized Interface Requirements](HarmonizedInterfacesRequirements.md)

Interfaces
-------------

The basic tool for creating interoperability in large networks where many different devices from 
many different manufacturers needs to interoperate, is to create recognized interfaces with well 
defined attributes. Each interface represents a contract that the device promises to uphold. It 
consists of mandatory and optional parts. If the device implements any optional funcionality, it 
must implement them as defined by the corresponding interface.

Harmonized Interfaces are identified by its namespace. Anyone with control of a domain can 
therefore create, share and publish interoperability interfaces. The Neuro-Foundation publishes
a set of harmonized interfaces for IoT devices, as published in this document. These interfaces
are categorized, grouped and named using a sequence of parts separated using colon (`:`) 
characters, and they all include a version number. The interfaces in this document all begin 
with `urn:nfi:iot:hi:`. Any manufacturer is free to create their own interfaces, however these 
cannot use a `urn:nfi:` unless their interface gets published by the Neuro-Foundation.

Note that devices are free to report any number of fields, control parameters, units, etc., as 
they desire or requirements dictate. The interfaces listed here only define a minimum set for
the purpose to facilitate interopability. They also list optional extensions that must be 
adhered to, if used, for the same reasons.

Important: Active participation is encouraged in defining new interfaces or enhancing existing 
interfaces within the Neuro-Foundation namespaces, all in an effort to create as large a 
communicty as possible that can agree on a set of interoperable interfaces that can be used to 
exchange information in harmonized networks.

Aggregate Interfaces
-----------------------

In addition to the basic interfaces, *aggregate interfaces* are defined. These are interfaces
that extend existing interfaces with additional generic functionality. Instead of having to
define a new interface for each new aggregate extension, a generic aggregate interface is defined.
This aggregate interface can then be used to extend any existing interface.

Example: The `urn:nfi:iot:hi:sensor.temperature:1.0` interface defines a minimum interface for
a temperature sensor. The `urn:nfi:iot:hia:statistics:average:1.0` aggregate interface defines how 
a sensor can report an average value (regardless of sensor type). If a temperature sensor would
like to inform that it can report average values, it would then implement both the
`urn:nfi:iot:hi:sensor.temperature:1.0` interface and the 
`urn:nfi:iot:hi:sensor.temperature:statistics:average:1.0` interface. Note that the only the version of
the aggregate interface is specified. The version of the aggregated interface is inferred from
the version as reported for the base interface.

Enumerations
---------------

Some interfaces declare fields or control parameters that use enumeration values. For this reason,
a set of *harmonized enuemrations* are also defined, each one given its own URI. When reporting
sensor data fields or control parameters of such enumeration types, the harmonized enumeration URI
is used to identify the type of enumeration used.

Getting supported interfaces
-------------------------------

To get the list of supported harmonized interfaces from a device, an `iq get` request is sent
to the device using the `<getInterfaces>` element, with optional `id`, `src` and/or `pt` 
attributes if the device is embedded in a [concentrator](/Concentrator.md). The device response 
with an `iq result` stanza containing an `<interfaces>` element containing a list of supported 
harmonized interfaces.

Request example to a standalone device:

```xml
<iq type='get'
    from='master@example.com/1234'
    to='weatherstation@example.com/5678'
    id='1'>
  <getInterfaces xmlns='urn:nfi:iot:hi:1.0'/>
</iq>
```

Request example to a device beind a concentrator:

```xml
<iq type='get'
    from='master@example.com/1234'
    to='weatherstation@example.com/5678'
    id='1'>
  <getInterfaces xmlns='urn:nfi:iot:hi:1.0' id='Station01' src='MeteringTopology'/>
</iq>
```

Response example:

```xml
<iq type='result'
    from='weatherstation@example.com/5678'
    to='master@example.com/1234'
    id='1'>
  <interfaces xmlns='urn:nfi:iot:hi:1.0'>
    <interface ref='urn:nfi:iot:hi:sensor:dewPoint:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:rainRate:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:windDirection:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:windSpeed:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:humidity:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:solarRadiation:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:temperature:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:dewPoint:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:rainRate:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:windDirection:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:windSpeed:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:humidity:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:solarRadiation:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:sensor:temperature:statistics:history:1.0'/>
    <interface ref='urn:nfi:iot:hi:identity:clock:1.0'/>
    <interface ref='urn:nfi:iot:hi:identity:location:1.0'/>
    <interface ref='urn:nfi:iot:hi:identity:manufacturer:1.0'/>
    <interface ref='urn:nfi:iot:hi:identity:name:1.0'/>
    <interface ref='urn:nfi:iot:hi:identity:version:1.0'/>
    <interface ref='urn:nfi:iot:hi:media:camera:1.0'/>
  </interfaces>
</iq>
```

Published Harmonized Interfaces
----------------------------------

Following is a tree structure of published harmonized interfaces. Browse available interfaces
by expanding the tree and clicking on the interface you want to learn more about.

<ul class="SimpleTree">
{{
FolderName:=null;
Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedInterfaces",false,FolderName);
InterfaceFolders:=System.IO.Directory.GetDirectories(FolderName);

foreach InterfaceFolder in Sort(InterfaceFolders) do
(
    RelFolderName:=InterfaceFolder.Substring(len(FolderName));
    InterfaceUri:="urn:nfi:iot:hi" + RelFolderName.Replace("\\",":");
	
    ]]<li class="Expandable" onclick="ExpandNode(event,this)"[[;
    ]] data-id="((RelFolderName))"[[;
    ]] data-expand="Api/ExpandInterfaceFolder.ws"[[;
    ]] data-collapsedimg="((HtmlAttributeEncode(MarkdownToHtml(":file_folder:") ) ))"[[;
    ]] data-expandedimg="((HtmlAttributeEncode(MarkdownToHtml(":open_file_folder:") ) ))">[[;
    ]]<span class="ItemImage">:file_folder:</span>[[;
    ]]`((InterfaceUri))`[[;
    ]]</li>
[[
)
}}
</ul>

Published Harmonized Aggregate Interfaces
--------------------------------------------

Following is a tree structure of published harmonized aggregate interfaces. Browse available 
aggregate interfaces by expanding the tree and clicking on the interface you want to learn more about.

<ul class="SimpleTree">
{{
FolderName:=null;
Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedAggregateInterfaces",false,FolderName);
InterfaceFolders:=System.IO.Directory.GetDirectories(FolderName);

foreach InterfaceFolder in Sort(InterfaceFolders) do
(
    RelFolderName:=InterfaceFolder.Substring(len(FolderName));
    InterfaceUri:="urn:nfi:iot:hia" + RelFolderName.Replace("\\",":");
	
    ]]<li class="Expandable" onclick="ExpandNode(event,this)"[[;
    ]] data-id="((RelFolderName))"[[;
    ]] data-expand="Api/ExpandAggregateInterfaceFolder.ws"[[;
    ]] data-collapsedimg="((HtmlAttributeEncode(MarkdownToHtml(":file_folder:") ) ))"[[;
    ]] data-expandedimg="((HtmlAttributeEncode(MarkdownToHtml(":open_file_folder:") ) ))">[[;
    ]]<span class="ItemImage">:file_folder:</span>[[;
    ]]`((InterfaceUri))`[[;
    ]]</li>
[[
)
}}
</ul>

Published Harmonized Enumerations
------------------------------------

Following is a tree structure of published harmonized enumerations. Browse available 
enumerations by expanding the tree and clicking on the enumeration you want to learn more about.

<ul class="SimpleTree">
{{
FolderName:=null;
Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedEnumerations",false,FolderName);
EnumerationFolders:=System.IO.Directory.GetDirectories(FolderName);

foreach EnumerationFolder in Sort(EnumerationFolders) do
(
    RelFolderName:=EnumerationFolder.Substring(len(FolderName));
    EnumerationUri:="urn:nfi:iot:hie" + RelFolderName.Replace("\\",":");
	
    ]]<li class="Expandable" onclick="ExpandNode(event,this)"[[;
    ]] data-id="((RelFolderName))"[[;
    ]] data-expand="Api/ExpandEnumerationFolder.ws"[[;
    ]] data-collapsedimg="((HtmlAttributeEncode(MarkdownToHtml(":file_folder:") ) ))"[[;
    ]] data-expandedimg="((HtmlAttributeEncode(MarkdownToHtml(":open_file_folder:") ) ))">[[;
    ]]<span class="ItemImage">:file_folder:</span>[[;
    ]]`((EnumerationUri))`[[;
    ]]</li>
[[
)
}}
</ul>
