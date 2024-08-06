Title: Concentrator
Description: Concentrator page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Concentrator ("Thing of Things")
==================================

This document outlines the XML representation of interacting with concentrators and their underlying nodes. A concentrator "concentrates" a set 
of underlying physical or virtual devices, called *nodes*, into one unit using one XMPP address (network identity). The XML representation is 
modelled using an annotated XML Schema:

| Concentrator                                              ||
| ------------|----------------------------------------------|
| Namespace:  | `urn:nf:iot:concentrator:1.0`                |
| Schema:     | [Concentrator.xsd](Schemas/Concentrator.xsd) |


Motivation and design goal
----------------------------

The method of managing concentrators, and their nodes, as described here, is designed with the following goals in mind:

* The interfaces should support both machine and human interfaces.

* It should be possible to interact with a node, just as with any other device on the network.

* The design should support small/simple concentrators, such as PLCs or devices with a small number of embedded devices.

* The design should support protocol bridging, allowing devices communicating using one protocol to be bridged to XMPP by a bridge working as a concentrator.

* The design should support complex concentrators interfacing huge networks or back-end systems with huge sets of physical or logical devices, as if they 
were connected to the XMPP network via a concentrator.

* It should be possible to manage a concentrator that chooses to allow this, allowing administrators to manage nodes and their lifecycles.

* A concentrator is free to implement a security architecture providing access to nodes to authorized clients only.

* It should be possible to discover available nodes in a concentrator, given sufficient privileges.


Extended addressing
-------------------------

Since all nodes behind a concentrator reside behind the same XMPP address, an additional addressing mechanism is required. For all interfaces relating to
IoT Harmonization, whether it be related to sensor data, control operations, decision support or provisioning, the following set of attributes are available
to address nodes in a concentrator. If the request does not include these attributes, it is assumed the receiver is not a concentrator.

| Attribute  | Type          | Description       | 
|:-----------|:--------------|:------------------| 
| `id`       | `xs:string`   | Node identity     |
| `src`      | `xs:string`   | Source identity   |
| `pt`       | `xs:string`   | Partition         |

Each node in a concentrator is at least identified by its *node identity*, provided in the `id` attribute. A concentrator might choose to group nodes
with similar properties in data/node *sources*. If so, the *source identity* is provided using the `src` attribute. Large concentrators might need to
sub-divide sources in *partitions*. If so, the partition is identified using the `pt` attribute. If an attribute is not provided, it is assumed to have 
the value of the empty string. The quadruple (JID, `id`, `src`, `pt`) should always be unique. Nodes and Data Sources can be ordered into tree structures.
This means there are root data sources and root nodes, as well as child and leaf sources and nodes.

```uml:Concentrator model
@startuml
class Concentrator
Concentrator : xs:string JID

class "Data Source" as DataSource
DataSource : xs:string src
Concentrator "1" *-- "*" DataSource
DataSource "1" *-- "*" DataSource

class Partition
Partition : xs:string pt
Concentrator "1" *-- "*" Partition
DataSource "1" *-- "*" Partition

class Node
Node : xs:string id
Concentrator "1" *-- "*" Node
DataSource "1" *-- "*" Node
Partition "1" *-- "*" Node
Node "1" *-- "*" Node
@enduml
```

**Note**: The same attributes can be used in sensor-data and control operations, with the same meaning.


Identities
--------------

The concentrator is free to authorize requests based on the identities provided by the caller. It can also restrict or limit the responses to elements
the client is authorized to interact with. Apart from the JID the caller uses, and the implicit domain on which the caller has an account, each call 
can also be annotated using tokens. There are three different types of tokens that can be used:

| Attribute  | Type          | Description       | 
|:-----------|:--------------|:------------------| 
| `dt`       | `xs:string`   | Device token(s)   |
| `st`       | `xs:string`   | Service token(s)  |
| `ut`       | `xs:string`   | User token(s)     |

If multiple tokens of the same type are used, they are simply separated using the space character.

**Note**: The same attributes can be used in sensor-data and control operations, with the same meaning.


Capabilities
-----------------

The concentrator interface consists of one mandatory operation (`<getCapabilities/>`), and a set of optional operations. It is up to the 
concentrator to define which optional operations are supported. Clients can ask what operations are supported by sending the 
`<getCapabilities/>` element in an `<iq type="get"/>` to the concentrator. The response will contain a `<strings/>` element containing a 
set of `<value/>` child elements, each one containing a name of an operation it supports.

| Element           | Attribute  | Type          | Use      | Default  | Description               | 
|:------------------|:-----------|:--------------|:---------|:---------|:--------------------------| 
| `getCapabilities` | `dt`       | `xs:string`   | optional |          | Device token(s).          |
|                   | `st`       | `xs:string`   | optional |          | Service token(s).         |
|                   | `ut`       | `xs:string`   | optional |          | User token(s).            |
| `strings`         |            |               |          |          | Array of strings.         |
| `value`           | (value)    | `xs:string`   |          |          | Represents a capability.  |

The following table lists defined operations. It also suggests what types of concentrators would implement each one.

| Operation                          | Small/static (PLC) | Bridge/Gateway | Subsystem |
|:-----------------------------------|:------------------:|:--------------:|:---------:|
| `getCapabilities`                  |         x          |        x       |     x     |
| `getAllDataSources`                |         x          |        x       |     x     |
| `getRootDataSources`               |                    |        x       |     x     |
| `getChildDataSources`              |                    |        x       |     x     |
| `containsNode`                     |         x          |        x       |     x     |
| `containsNodes`                    |                    |                |     x     |
| `getNode`                          |         x          |        x       |     x     |
| `getNodes`                         |                    |                |     x     |
| `getAllNodes`                      |         x          |        x       |     x     |
| `getNodeInheritance`               |                    |        x       |     x     |
| `getRootNodes`                     |         x          |        x       |     x     |
| `getChildNodes`                    |         x          |        x       |     x     |
| `getAncestors`                     |                    |        x       |     x     |
| `getNodeParametersForEdit`         |                    |        x       |     x     |
| `setNodeParametersAfterEdit`       |                    |        x       |     x     |
| `getCommonNodeParametersForEdit`   |                    |                |     x     |
| `setCommonNodeParametersAfterEdit` |                    |                |     x     | 
| `getAddableNodeTypes`              |                    |        x       |     x     | 
| `getParametersForNewNode`          |                    |        x       |     x     | 
| `createNewNode`                    |                    |        x       |     x     | 
| `destroyNode`                      |                    |        x       |     x     | 
| `moveNodeUp`                       |                    |        x       |     x     | 
| `moveNodeDown`                     |                    |        x       |     x     | 
| `moveNodesUp`                      |                    |        x       |     x     | 
| `moveNodesDown`                    |                    |        x       |     x     | 
| `subscribe`                        |                    |        x       |     x     | 
| `unsubscribe`                      |                    |        x       |     x     | 
| `getNodeCommands`                  |         x          |        x       |     x     | 
| `getCommandParameters`             |        (x)         |        x       |     x     | 
| `executeNodeCommand`               |         x          |        x       |     x     | 
| `executeNodeQuery`                 |        (x)         |        x       |     x     | 
| `getCommonNodeCommands`            |                    |                |     x     | 
| `getCommonCommandParameters`       |                    |                |     x     | 
| `executeCommonNodeCommand`         |                    |                |     x     | 
| `executeCommonNodeQuery`           |                    |                |     x     | 
| `abortNodeQuery`                   |        (x)         |        x       |     x     | 
| `abortCommonNodeQuery`             |                    |        x       |     x     | 
| `registerSniffer`                  |                    |        x       |     x     | 
| `unregisterSniffer`                |                    |        x       |     x     | 

**Note**: Some operations exist in both in singular and plural forms. When managing large systems, sets of nodes must be possible to administer. Such
operations might be unnecessary to implement for smaller concentrators. Clients supporting both large and small concentrators can iterate the singular
operation over the set of nodes, for concentrators not supporting the plural versions.

Errors
----------------

Error management in all IoT Harmonization requests, are handled by the XMPP layer. If an operation fails, a corresponding XMPP error is returned in an
`<iq type="error"/>` stanza, using the error elements defined in [RFC 6120](https://tools.ietf.org/html/rfc6120). Common errors:

* An item (node, source, etc.) was not found. This results in an `<item-not-found/>` error.
* Access rights are lacking, results in a `<forbidden/>` error.
* Badly formed requests result in `<bad-request/>` errors.
* Trying to create something that already exists, results in a `<conflict/>` error.
* Unsupported actions result in `<feature-not-implemented/>` errors.

Localization
------------------

It's optional to support localization. Concentrators supporting localization return localized content based on the value of the `xml:lang` attribute available
in the stanza element, as defined in [RFC 6121](https://tools.ietf.org/html/rfc6121).

Sources
----------------

Manageable concentrators order their nodes in data sources. The following sets of operations allow the client to discover what data sources are available
in a concentrator.

### getAllDataSources

A client can request a list of all data sources available on a concentrator server by sending a `<getAllDataSources/>` element in an 
`<iq type="get"/>` to the concentrator. The concentrator returns a `<dataSources/>` element in the response, consisting of a set of 
`<dataSource/>` elements, each describing a single data source. Each `<dataSource/>` contains the following attributes:

| Element             | Attribute     | Type          | Use      | Default  | Description        | 
|:--------------------|:--------------|:--------------|:---------|:---------|:-------------------| 
| `getAllDataSources` | `dt`          | `xs:string`   | optional |          | Device token(s).   |
|                     | `st`          | `xs:string`   | optional |          | Service token(s).  |
|                     | `ut`          | `xs:string`   | optional |          | User token(s).     |
| `dataSources`       |               |               |          |          | List of data sources available (to the caller).                                                                                          |
| `dataSource`        | `src`         | `xs:string`   | required |          | Machine-readable identity of the data source. This identity is used in all references to the data source.                                |
|                     | `name`        | `xs:string`   | required |          | Human-readable, localized name of the data source.                                                                                       |
|                     | `hasChildren` | `xs:boolean`  | optional | `false`  | Data sources can be organized in tree structures. This attribute lets the caller know if the data source has child data sources or not. |
|                     | `lastChanged` | `xs:dateTime` | optional |          | Variable data sources use this attribute to report when the last change in the source took place. Used for synchronization.              |

### getRootDataSources

A client can request a list of all root data sources available on a concentrator server by sending a `<getRootDataSources/>` element in 
an `<iq type="get"/>` to the concentrator. The concentrator returns a `<dataSources/>` element in the response, consisting of a set of 
`<dataSource/>` elements, each describing a single root data source.

| Element              | Attribute     | Type          | Use      | Default  | Description        | 
|:---------------------|:--------------|:--------------|:---------|:---------|:-------------------| 
| `getRootDataSources` | `dt`          | `xs:string`   | optional |          | Device token(s).   |
|                      | `st`          | `xs:string`   | optional |          | Service token(s).  |
|                      | `ut`          | `xs:string`   | optional |          | User token(s).     |
| `dataSources`        |               |               |          |          | List of data sources available (to the caller).                                                                                          |
| `dataSource`         | `src`         | `xs:string`   | required |          | Machine-readable identity of the data source. This identity is used in all references to the data source.                                |
|                      | `name`        | `xs:string`   | required |          | Human-readable, localized name of the data source.                                                                                       |
|                      | `hasChildren` | `xs:boolean`  | optional | `false`  | Data sources can be organized in tree structueres. This attribute lets the caller know if the data source has child data sources or not. |
|                      | `lastChanged` | `xs:dateTime` | optional |          | Variable data sources use this attribute to report when the last change in the source took place. Used for synchornization.              |

### getChildDataSources

A client can request a list of all child data sources available on a concentrator server by sending a `<getChildDataSources/>` element in 
an `<iq type="get"/>` to the concentrator. The source is specified in the `src` attribute. The concentrator returns a `<dataSources/>` 
element in the response, consisting of a set of `<dataSource/>` elements, each describing a single child data source.

| Element               | Attribute     | Type          | Use      | Default  | Description        | 
|:----------------------|:--------------|:--------------|:---------|:---------|:-------------------| 
| `getChildDataSources` | `src`         | `xs:string`   | required |          | Machine-readable identity of the data source. |
|                       | `dt`          | `xs:string`   | optional |          | Device token(s).                              |
|                       | `st`          | `xs:string`   | optional |          | Service token(s).                             |
|                       | `ut`          | `xs:string`   | optional |          | User token(s).                                |
| `dataSources`         |               |               |          |          | List of data sources available (to the caller).                                                                                          |
| `dataSource`          | `src`         | `xs:string`   | required |          | Machine-readable identity of the data source. This identity is used in all references to the data source.                                |
|                       | `name`        | `xs:string`   | required |          | Human-readable, localized name of the data source.                                                                                       |
|                       | `hasChildren` | `xs:boolean`  | optional | `false`  | Data sources can be organized in tree structueres. This attribute lets the caller know if the data source has child data sources or not. |
|                       | `lastChanged` | `xs:dateTime` | optional |          | Variable data sources use this attribute to report when the last change in the source took place. Used for synchornization.              |


Nodes
----------

All concentrators consist of nodes. These might be static, or dynamic, and manageable by clients with sufficient access rights. The following sets of operations
allow clients to discover (given access rights), what nodes are available in the concentrator.

### containsNode

Checks if a node exists (and visible to the caller). It is sent in an `<iq type="get"/>` to the concentrator, which responds with a 
`<bool/>` element containing the response to the question.

| Element        | Attribute  | Type          | Use      | Default  | Description              | 
|:---------------|:-----------|:--------------|:---------|:---------|:-------------------------| 
| `containsNode` | `id`       | `xs:string`   | required |          | Node identity.           |
|                | `src`      | `xs:string`   | optional |          | Source identity.         |
|                | `pt`       | `xs:string`   | optional |          | Partition.               |
|                | `dt`       | `xs:string`   | optional |          | Device token(s).         |
|                | `st`       | `xs:string`   | optional |          | Service token(s).        |
|                | `ut`       | `xs:string`   | optional |          | User token(s).           |
| `bool`         | (value)    | `xs:boolean`  |          |          | Boolean-valued response. |

### containsNodes

Allows a client to check the existence of multiple nodes in one request. The client sends a `<containsNodes/>` element containing a set of 
`<nd/>` elements, each referencing a node in the concentrator. All is sent in an `<iq type="get"/>` to the concentrator, which responds with 
a `<bools/>` element, containing a sequence of `<bool/>` elements, each one containing the response related to the corresponding node in the 
request.

| Element         | Attribute  | Type          | Use      | Default  | Description                                 | 
|:----------------|:-----------|:--------------|:---------|:---------|:--------------------------------------------| 
| `containsNodes` | `dt`       | `xs:string`   | optional |          | Device token(s).                            |
|                 | `st`       | `xs:string`   | optional |          | Service token(s).                           |
|                 | `ut`       | `xs:string`   | optional |          | User token(s).                              |
| `nd`            | `id`       | `xs:string`   | required |          | Node identity.                              |
|                 | `src`      | `xs:string`   | optional |          | Source identity.                            |
|                 | `pt`       | `xs:string`   | optional |          | Partition.                                  |
| `bools`         |            |               |          |          | Encapsulates response.                      |
| `bool`          | (value)    | `xs:boolean`  |          |          | Response for corresponding node in request. |

### getNode

Gets information about a node in the concentrator. It is sent in an `<iq type="get"/>` to the concentrator, which responds with a 
`<nodeInfo/>` element containing the information. The `<nodeInfo/>` element in turn can have a sequence of parameter elements, named after 
their corresponding data type, and messages, if the request asked for such information.

| Element        | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getNode`      | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                | `parameters`      | `xs:boolean`  | optional | `false`  | If node parameters are included in the request.                                                                     |
|                | `messages`        | `xs:boolean`  | optional | `false`  | If node messages are included in the request.                                                                       |
|                | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nodeInfo`     | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable and can deliver sensor data to the client.                                                 |
|                | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable and publish control parameters to the client.                                          |
|                | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has any commands the client can access.                                                                     |
|                | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |
| `boolean`      | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:boolean`  | required |          | Boolean parameter value.                                                                                            |
| `color`        | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `Color`       | required |          | Color parameter value.                                                                                              |
| `dateTime`     | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:dateTime` | required |          | Date and time parameter value.                                                                                      |
| `double`       | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:double`   | required |          | Double-precision floating-point parameter value.                                                                    |
| `duration`     | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:duration` | required |          | Duration parameter value.                                                                                           |
| `int`          | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:int`      | required |          | 32-bit integer parameter value.                                                                                     |
| `long`         | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:long`     | required |          | 64-bit integer parameter value.                                                                                     |
| `string`       | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:string`   | required |          | String parameter value.                                                                                             |
| `time`         | `id`              | `xs:string`   | required |          | Parameter identity.                                                                                                 |
|                | `name`            | `xs:string`   | required |          | Human-readable, localized parameter name.                                                                           |
|                | `value`           | `xs:time`     | required |          | Time parameter value.                                                                                               |
| `message`      | (value)           | `xs:string`   |          |          | Human-readable message text.                                                                                        |
|                | `timestamp`       | `xs:dateTime` | required |          | Timestamp of message.                                                                                               |
|                | `type`            | `MessageType` | required |          | Type of message.                                                                                                    |
|                | `eventId`         | `xs:string`   | optional |          | Optional context/concentrator/manufacturer-specific identity, identifying the type of event the message represents. |

Node states are defined by the `NodeState` enumeration, which can take the following values:

| Value             | Description                                                                      |
|:------------------|:---------------------------------------------------------------------------------|
| `None`            | Represents a node with no messages logged on it.                                 |
| `Information`     | Represents a node with information messages logged on it.						   |
| `WarningSigned`   | Represents a node with warning messages logged on it that have been signed.	   |
| `WarningUnsigned` | Represents a node with warning messages logged on it that have not been signed.  |
| `ErrorSigned`     | Represents a node with error messages logged on it that have been signed.		   |
| `ErrorUnsigned`   | Represents a node with error messages logged on it that have not been signed.	   |

Message types are defined by the `MessageType` enumeration, which can take the following values:

| Value             | Description                                                              |
|:------------------|:-------------------------------------------------------------------------|
| `Information`     | Represents information about the node that is not a warning or an error. |
| `Warning`         | Represents a warning state. An error could occur unless action is taken. |
| `Error`           | Represents an error state. A process, device or algorithm failed.        |

### getNodes

Gets information about a set of nodes in the concentrator. It is sent in an `<iq type="get"/>` to the concentrator, which responds with a 
`<nodeInfos/>` element containing a sequence of `<nodeInfo/>` elements, each corresponding to a node in the request. The `<nodeInfo/>` 
element in turn can have a sequence of parameter elements, named after their corresponding data type, and messages, if the request asked 
for such information.

| Element        | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getNodes`     | `parameters`      | `xs:boolean`  | optional | `false`  | If node parameters are included in the request.                                                                     |
|                | `messages`        | `xs:boolean`  | optional | `false`  | If node messages are included in the request.                                                                       |
|                | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nd`           | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
| `nodeInfos`    |                   |               |          |          | Contains a set of `nodeInfo` elements.                                                                              |
| `nodeInfo`     | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable, and can deliver sensor data to the client.                                                 |
|                | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable, and publish control parameters to the client.                                          |
|                | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |

### getAllNodes

Gets information about all nodes in a source. The set of nodes can be restricted to nodes that derive from particular types. To restrict 
the request to nodes derived from a given set of types, `<onlyIfDerivedFrom/>` elements are added to the `<getAllNodes/>` element, each one
containing as a value the name of the corresponding type. The `<getAllNodes/>` element is sent in an `<iq type="get"/>` to the concentrator, 
which responds with a `<nodeInfos/>` element containing a sequence of `<nodeInfo/>` elements, each corresponding to a node in the request.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getAllNodes`       | `parameters`      | `xs:boolean`  | optional | `false`  | If node parameters are included in the request.                                                                     |
|                     | `messages`        | `xs:boolean`  | optional | `false`  | If node messages are included in the request.                                                                       |
|                     | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                     | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                     | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
| `onlyIfDerivedFrom` | (value)           | `xs:string`   | required |          | If specified, only return nodes that derive from one of these node types.                                           |
| `nodeInfos`         |                   |               |          |          | Contains a set of `nodeInfo` elements.                                                                              |
| `nodeInfo`          | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                     | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                     | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                     | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                     | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                     | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable, and can deliver sensor data to the client.                                                 |
|                     | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable, and publish control parameters to the client.                                          |
|                     | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                     | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                     | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                     | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                     | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |

### getNodeInheritance

Gets the type/class inheritances of a node in a concentrator. It is sent in an `<iq type="get"/>` to the concentrator, who responds with an 
`<inheritance/>` element, containing both base classes in a `<baseClasses/>` child element, and optionally also implemented interfaces in an 
`<interfaces/>` child element.

| Element              | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getNodeInheritance` | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                      | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                      | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                      | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                      | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                      | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `inheritance`        |                   |               |          |          | Response element.                                                                                                   |
| `baseClasses`        |                   |               |          |          | Contains base classes, each one in a separate `value` child element.                                                 |
| `interfaces`         |                   |               |          |          | Contains implemented interfaces, if any, each one in a separate `value` child element.                              |
| `value`              | (value)           | `xs:string`   |          |          | Contains a base class or interface name.                                                                            |

### getRootNodes

Gets information about all root nodes in a source. The `<getRootNodes/>` element is sent in an `<iq type="get"/>` to the concentrator, which 
responds with a `<nodeInfos/>` element containing a sequence of `<nodeInfo/>` elements, each corresponding to a root node in the source.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getRootNodes`      | `parameters`      | `xs:boolean`  | optional | `false`  | If node parameters are included in the request.                                                                     |
|                     | `messages`        | `xs:boolean`  | optional | `false`  | If node messages are included in the request.                                                                       |
|                     | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                     | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                     | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
| `nodeInfos`         |                   |               |          |          | Contains a set of `nodeInfo` elements.                                                                              |
| `nodeInfo`          | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                     | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                     | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                     | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                     | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                     | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable, and can deliver sensor data to the client.                                                 |
|                     | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable, and publish control parameters to the client.                                          |
|                     | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                     | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                     | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                     | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                     | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |

### getChildNodes

Gets information about all child nodes of a node. The `<getChildNodes/>` element is sent in an `<iq type="get"/>` to the concentrator, which 
responds with a `<nodeInfos/>` element containing a sequence of `<nodeInfo/>` elements, each corresponding to a root node in the source.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getChildNodes`     | `parameters`      | `xs:boolean`  | optional | `false`  | If node parameters are included in the request.                                                                     |
|                     | `messages`        | `xs:boolean`  | optional | `false`  | If node messages are included in the request.                                                                       |
|                     | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                     | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                     | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nodeInfos`         |                   |               |          |          | Contains a set of `nodeInfo` elements.                                                                              |
| `nodeInfo`          | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                     | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                     | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                     | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                     | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                     | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable, and can deliver sensor data to the client.                                                 |
|                     | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable, and publish control parameters to the client.                                          |
|                     | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                     | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                     | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                     | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                     | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |

### getAncestors

Gets information about the node and all its ancestors (parent, grandparent, etc., until a root node is found). The `<getAncestors/>` element 
is sent in an `<iq type="get"/>` to the concentrator, which responds with a `<nodeInfos/>` element containing a sequence of `<nodeInfo/>` 
elements, each corresponding to a node in sequence.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getAncestors`      | `parameters`      | `xs:boolean`  | optional | `false`  | If node parameters are included in the request.                                                                     |
|                     | `messages`        | `xs:boolean`  | optional | `false`  | If node messages are included in the request.                                                                       |
|                     | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                     | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                     | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nodeInfos`         |                   |               |          |          | Contains a set of `nodeInfo` elements.                                                                              |
| `nodeInfo`          | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                     | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                     | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                     | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                     | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                     | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable, and can deliver sensor data to the client.                                                 |
|                     | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable, and publish control parameters to the client.                                          |
|                     | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                     | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                     | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                     | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                     | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |

Managing Nodes
--------------------

Dynamic concentrators allow clients (with sufficient access rights) to manage (create, edit and delete) nodes. The following operations provide means for
such clients to perform these tasks. The group operations should be implemented by concentrators supporting huge quantities of nodes, where individual
management is not always feasible or desirable, and where batch access is required.

### getNodeParametersForEdit

Gets the parameters for a node, for editing. The `<getNodeParametersForEdit/>` element is sent in an `<iq type="get"/>` to the concentrator, 
which returns a data form containing the editable node parameters.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getNodeParametersForEdit` | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `x:x`                      |                   |               |          |          | Contains a data form with editable node parameters.                                                                 |

Some useful extensions related to data forms in XMPP:

* [XEP-0004: Data Forms](https://xmpp.org/extensions/xep-0004.html)
* [XEP-0122: Data Forms Validation](https://xmpp.org/extensions/xep-0122.html)
* [XEP-0141: Data Forms Layout](https://xmpp.org/extensions/xep-0141.html)
* [XEP-0221: Data Forms Media Element](https://xmpp.org/extensions/xep-0221.html)
* [XEP-0331: Data Forms - Color Field Types](https://xmpp.org/extensions/xep-0331.html)
* [XEP-0336: Data Forms - Dynamic Forms](https://xmpp.org/extensions/xep-0336.html)

### setNodeParametersAfterEdit

Sets the parameters for a node, after editing. The `<setNodeParametersForEdit/>` element, containing the parameters as a submitted form, is 
sent in an `<iq type="set"/>` to the concentrator, which returns a `<nodeinfo/>` element (in an `<iq type="result"/>`) if the parameters 
could be set, or a data form (in an `<iq type="error"/>`) containing the editable node parameters and any error messages, if the operation 
could not be completed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `setNodeParametersForEdit` | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `x:x`                      |                   |               |          |          | Contains a data form with edited node parameters.                                                                   |

**Note**: The form might be partial, i.e. only contain a subset of the parameters available on the node. Parameters not referenced, should keep their
values unchanged.

### getCommonNodeParametersForEdit

To get a set of parameters that are common to a set of nodes, the `<getCommonNodeParametersForEdit/>` element is sent in an 
`<iq type="get"/>` to the concentrator. Each node is referenced by a separate `<nd/>` child element. The response is a data form, in which 
all parameters that do not exist in at least one of the referenced nodes have been removed. Parameters that have different values in the 
different referenced nodes should report the value of the first node, and then mark the field with the `<xdd:notSame/>` element, as defined 
in [XEP-0336](https://xmpp.org/extensions/xep-0336.html#sect-idm45589980289936).

| Element                          | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getCommonNodeParametersForEdit` | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                                  | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                                  | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nd`                             | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                                  | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                                  | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
| `x:x`                            |                   |               |          |          | Contains a data form with edited node parameters.                                                                   |


### setCommonNodeParametersAfterEdit

Sets the parameters for a set of nodes, after editing. The `<setCommonNodeParametersAfterEdit/>` element, containing the parameters as a 
submitted form, is sent in an `<iq type="set"/>` to the concentrator, which returns with an empty response (in an `<iq type="result"/>`) 
if the parameters could be set, or a data form (in an `<iq type="error"/>`) containing the editable node parameters and any error messages, 
if the operation could not be completed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `setNodeParametersForEdit` | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nd`                       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
| `x:x`                      |                   |               |          |          | Contains a data form with edited node parameters.                                                                   |

**Note**: The form might be partial, i.e. only contain a subset of the parameters available on the node. Parameters not referenced, should keep their
values unchanged.

### getAddableNodeTypes

Gets the types of nodes that can be added to a given node in a concentrator. A `<getAddableNodeTypes/>` element is sent in an 
`<iq type="get"/>` to the concentrator, who responds with a `<nodeTypes/>` element. This element contains a sequence of `<nodeType/>` 
elements, each one describing a node type.

| Element               | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:----------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getAddableNodeTypes` | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                       | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                       | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                       | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                       | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                       | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nodeTypes`           |                   |               |          |          | Array of node type.                                                                                                 |
| `nodeType`            | `type`            | `xs:string`   | required |          | Machine-readable, and concentrator specific, node type.                                                             |
|                       | `name`            | `xs:string`   | required |          | Human-readable, localized, name of node type.                                                                       |

### getParametersForNewNode

Gets editable parameters for the creation of a new node. The `<getParametersForNewNode/>` element is sent in an `<iq type="get"/>` to the 
concentrator, which returns a data form containing the editable node parameters. The node referenced in the request, is the node that will 
receive the new created node as a child.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getParametersForNewNode`  | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `type`            | `xs:string`   | required |          | Machine-readable, and concentrator specific, node type.                                                             |
| `x:x`                      |                   |               |          |          | Contains a data form with editable node parameters.                                                                 |

### createNewNode

Creates a new node. The `<createNewNode/>` element, containing the parameters as a submitted form, is sent in an `<iq type="set"/>` to the 
concentrator, which returns a `<nodeinfo/>` element (in an `<iq type="result"/>`) if the node could be created, or a data form (in an 
`<iq type="error"/>`) containing the editable node parameters and any error messages, if the operation could not be completed. The node 
referenced in the request, is the node that will receive the new created node as a child.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `createNewNode`            | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `type`            | `xs:string`   | required |          | Machine-readable, and concentrator specific, node type.                                                             |
| `x:x`                      |                   |               |          |          | Contains a data form with edited node parameters.                                                                   |

### destroyNode

Destroys a new node. The `<destroyNode/>` element is sent in an `<iq type="set"/>` to the concentrator, which returns an empty response 
(in an `<iq type="result"/>`) if the node was destroyed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `destroyNode`              | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |

### moveNodeUp

Moves a node up one step among its siblings. The `<moveNodeUp/>` element is sent in an `<iq type="set"/>` to the concentrator, which 
returns an empty response (in an `<iq type="result"/>`) if the operation was performed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `moveNodeUp`               | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |

### moveNodeDown

Moves a node down one step among its siblings. The `<moveNodeDown/>` element is sent in an `<iq type="set"/>` to the concentrator, which 
returns an empty response (in an `<iq type="result"/>`) if the operation was performed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `moveNodeDown`             | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |

### moveNodesUp

Moves a set of nodes up one step among its siblings. The `<moveNodesUp/>` element references the nodes to move in separate `<nd/>` child 
elements, and is sent in an `<iq type="set"/>` to the concentrator, which returns an empty response (in an `<iq type="result"/>`) if the 
operation was performed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `moveNodesUp`              | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nd`                       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |

### moveNodesDown

Moves a set of nodes down one step among its siblings. The `<moveNodesDown/>` element references the nodes to move in separate `<nd/>` child 
elements, and is sent in an `<iq type="set"/>` to the concentrator, which returns an empty response (in an `<iq type="result"/>`) if the 
operation was performed.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `moveNodesDown`            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nd`                       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |

Commands
--------------------

To interact with the nodes of a concentrator, apart from reading sensor data or perform control operations, a node is allowed to publish 
any number of commands clients (with sufficient privileges) can access and execute. The following operations describe these tasks.

### getNodeCommands

Gets a list of available commands for a node. The `<getNodeCommands/>` element is sent in an `<iq type="get"/>` to the concentrator, which 
responds with a `<commands/>` element if successful. The `<commands/>` element contains a sequence of `<command/>` elements, each one
describing a command.

| Element                    | Attribute            | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:---------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getNodeCommands`          | `id`                 | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`                | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`                 | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`                 | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`                 | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`                 | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `commands`                 |                      |               |          |          | Contains a sequence of `command` elements.                                                                          |
| `command`                  | `command`            | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
|                            | `name`               | `xs:string`   | required |          | Human-readable, localized name of command.                                                                          |
|                            | `type`               | `CommandType` | required |          | Type of command.                                                                                                    |
|                            | `sortCategory`       | `xs:string`   | optional |          | Category under which the command should be sorted, in GUIs.                                                         |
|                            | `sortKey`            | `xs:string`   | optional |          | How the command should be sorted in its category, in GUIs.                                                          |
|                            | `confirmationString` | `xs:string`   | optional |          | An optional, human-readable, localized, confirmation string shown to human users, before executing the command.     |
|                            | `failureString`      | `xs:string`   | optional |          | An optional, human-readable, localized, failure string shown to human users, if failing to execute the command.     |
|                            | `successString`      | `xs:string`   | optional |          | An optional, human-readable, localized, string shown to human users, if successfully able to execute the command.   |

The following types of commands are available (defined by the `CommandType` enumeration):

| Value             | Description                                                                                                                                                |
|:------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Simple`          | Simple commands do not need parametrization and run invisibly.                                                                                            |
| `Parameterized`   | Parametrized commands allow the user to fill in a form of command parameters that can be used to configure the command. The command is then run invisibly. |
| `Query`           | Allows the user to parametrize the command. During execution of the command, feedback can be sent back to the user asynchronously.                         |

### getCommandParameters

Gets the parameters for a parametrized node command or query. A `<getCommandParameters/>` element is sent in an `<iq type="get"/>` to the 
concentrator, which returns a data form containing the parameters of the parametrized command or query if successful.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getCommandParameters`     | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
| `x:x`                      |                   |               |          |          | Contains a data form with command parameters.                                                                       |

### executeNodeCommand

Executes (or starts) a simple or parametrized node command. The `<executeNodeCommand/>` element, containing any parameters as a submitted 
form for parametrized commands, is sent in an `<iq type="set"/>` to the concentrator, which returns an empty response (in an 
`<iq type="result"/>`) if the command could be executed (or started), or a data form (in an `<iq type="error"/>`) containing the command 
parameters and any error messages, if the command could not be executed or started. 

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `executeNodeCommand`       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
| `x:x`                      |                   |               |          |          | Contains a data form with command parameters.                                                                       |

### executeNodeQuery

Starts the execution of a parametrized node query. The `<executeNodeQuery/>` element, containing any parameters as a submitted form, is sent 
in an `<iq type="set"/>` to the concentrator, which returns an empty response (in an `<iq type="result"/>`) if the query could be started, 
or a data form (in an `<iq type="error"/>`) containing the command parameters and any error messages, if the query could not be executed or 
started. The client has to invent a `queryId` which query events use to reference the executing query. Sufficient entropy should be given 
this identifier, so that it does not collide with other queries being executed or is simple to guess.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `executeNodeQuery`         | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
|                            | `queryId`         | `xs:string`   | required |          | Machine-readable identity of the query instance being executed.                                                     |
| `x:x`                      |                   |               |          |          | Contains a data form with command parameters.                                                                       |

### getCommonNodeCommands

To get a set of commands that are common to a set of nodes, the `<getCommonNodeCommands/>` element is sent in an `<iq type="get"/>` to the 
concentrator. Each node is referenced by a separate `<nd/>` child element. The concentrator responds with a `<commands/>` element if 
successful, listing commands that are available on all referenced nodes in separate `<command/>` elements.

| Element                    | Attribute            | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:---------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getCommonNodeCommands`    | `dt`                 | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`                 | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`                 | `xs:string`   | optional |          | User token(s).                                                                                                      |
| `nd`                       | `id`                 | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`                | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`                 | `xs:string`   | optional |          | Partition.                                                                                                          |
| `commands`                 |                      |               |          |          | Contains a sequence of `command` elements.                                                                          |
| `command`                  | `command`            | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
|                            | `name`               | `xs:string`   | required |          | Human-readable, localized name of command.                                                                          |
|                            | `type`               | `CommandType` | required |          | Type of command.                                                                                                    |
|                            | `sortCategory`       | `xs:string`   | optional |          | Category under which the command should be sorted, in GUIs.                                                         |
|                            | `sortKey`            | `xs:string`   | optional |          | How the command should be sorted in its category, in GUIs.                                                          |
|                            | `confirmationString` | `xs:string`   | optional |          | An optional, human-readable, localized, confirmation string shown to human users, before executing the command.     |
|                            | `failureString`      | `xs:string`   | optional |          | An optional, human-readable, localized, failure string shown to human users, if failing to execute the command.     |
|                            | `successString`      | `xs:string`   | optional |          | An optional, human-readable, localized, string shown to human users, if successfully able to execute the command.   |

### getCommonCommandParameters

To get a set of common parameters for a command common to a set of nodes, the `<getCommonCommandParameters/>` element is sent in an 
`<iq type="get"/>` to the concentrator. The command is referenced by the `command` attribute, and each node is referenced by separate 
`<nd/>` child elements. The response is a data form, in which all parameters that do not exist in the command parameters from at least one 
of the nodes have been removed. Parameters that have different values in the different referenced nodes should report the value of the first 
node, and then mark the field with the `<xdd:notSame/>` element, as defined in 
[XEP-0336](https://xmpp.org/extensions/xep-0336.html#sect-idm45589980289936).

| Element                          | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `getCommonCommandParameters`     | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                                  | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                                  | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                                  | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
| `nd`                             | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                                  | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                                  | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
| `x:x`                            |                   |               |          |          | Contains a data form with edited node parameters.                                                                   |

### executeCommonNodeCommand

Starts the execution of a parametrized node command, common to a set of nodes. The `<executeCommonNodeCommand/>` element, containing any 
parameters as a submitted form, is sent in an `<iq type="set"/>` to the concentrator. The command is referenced by the `command` attribute,
and each node is referenced by separate `<nd/>` child elements. The concentrator returns a `<partialExecution/>` element (in an 
`<iq type="result"/>`) if the command could be started on at least one of the nodes, or a data form (in an `<iq type="error"/>`) 
containing the command parameters and any error messages, if the command could not be executed or started. The `<partialExecution/>` element 
consists of a sequence of `<result/>` elements, each one representing one of the referenced nodes. The value indicates if the
command was executed (or started) on the corresponding node. If not, the `error` attribute describes why the command could not be executed 
(or started) on the corresponding node.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `executeCommonNodeCommand` | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
| `nd`                       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
| `x:x`                      |                   |               |          |          | Contains a data form with command parameters.                                                                       |
| `partialExecution`         |                   |               |          |          | Representation of execution status, per individual node a command was executed on.                                  |
| `result`                   | (value)           | `xs:boolean`  |          |          | If the command executed successfully on the corresponding node.                                                     |
|                            | `error`           | `xs:string`   | optional |          | If a command failed, this attribute contains an error message describing what went wrong for the particular node.   |

### executeCommonNodeQuery

Starts the execution of a parametrized node query, common to a set of nodes. The `<executeCommonNodeQuery/>` element, containing any 
parameters as a submitted form, is sent in an `<iq type="set"/>` to the concentrator, which returns a `<partialExecution/>` element 
(in an `<iq type="result"/>`) if the query could be started on at least one of the nodes, or a data form (in an `<iq type="error"/>`) 
containing the command parameters and any error messages, if the query could not be executed or started. The `<partialExecution/>` 
element consists of a sequence of `<result/>` elements, each one representing one of the referenced nodes. The value indicates if the
query was started on the corresponding node. If not, the `error` attribute describes why the command could not be started on the 
corresponding node. The client has to invent a `queryId` which query events use to reference the executing query. Sufficient entropy 
should be given this identifier, so that it does not collide with other queries being executed, or is simple to guess.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `executeCommonNodeQuery`   | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
|                            | `queryId`         | `xs:string`   | required |          | Machine-readable identity of the query instance being executed.                                                     |
| `nd`                       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
| `x:x`                      |                   |               |          |          | Contains a data form with command parameters.                                                                       |
| `partialExecution`         |                   |               |          |          | Representation of execution status, per individual node a command was executed on.                                  |
| `result`                   | (value)           | `xs:boolean`  |          |          | If the command executed successfully on the corresponding node.                                                     |
|                            | `error`           | `xs:string`   | optional |          | If a command failed, this attribute contains an error message describing what went wrong for the particular node.   |

### abortNodeQuery

Aborts a query that is being executed on a node in a concentrator. The `<abortNodeQuery/>` element is sent in an `<iq type="set"/>` to the 
concentrator, which returns an empty response (in an `<iq type="result"/>`) if the query could be aborted.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `abortNodeQuery`           | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                            | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
|                            | `queryId`         | `xs:string`   | required |          | Machine-readable identity of the query instance being executed.                                                     |

### abortCommonNodeQuery

Aborts a query that is being executed on a set of nodes in a concentrator. The `<abortCommonNodeQuery/>` element, containing any node 
references in `<nd/>` child elements, is sent in an `<iq type="set"/>` to the concentrator, which returns an empty response (in an 
`<iq type="result"/>`) if the query could be aborted.

| Element                    | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `abortCommonNodeQuery`     | `dt`              | `xs:string`   | optional |          | Device token(s).                                                                                                    |
|                            | `st`              | `xs:string`   | optional |          | Service token(s).                                                                                                   |
|                            | `ut`              | `xs:string`   | optional |          | User token(s).                                                                                                      |
|                            | `command`         | `xs:string`   | required |          | Machine-readable identity of the command.                                                                           |
|                            | `queryId`         | `xs:string`   | required |          | Machine-readable identity of the query instance being executed.                                                     |
| `nd`                       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                            | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                            | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |

### queryProgress

During the execution of a query, the concentrator sends progress updates to the client by sending asynchronous messages containing the 
`<queryProgress/>` element, referencing the same `queryId` as defined by the client when requesting the query to be executed, and the 
node reporting the progress. The `<queryProgress/>` element contains a set of child elements that report the progress, and that can be 
used to build a report on the results of the query.

| Element                    | Attribute         | Type                    | Use      | Default  | Description                                                                                                                                                                   | 
|:---------------------------|:------------------|:------------------------|:---------|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| `<queryProgress/>`         | `queryId`         | `xs:string`             | required |          | Machine-readable identity of the query instance being executed.                                                                                                               |
|                            | `id`              | `xs:string`             | required |          | Node identity.                                                                                                                                                                |
|                            | `src`             | `xs:string`             | optional |          | Source identity.                                                                                                                                                              |
|                            | `pt`              | `xs:string`             | optional |          | Partition.                                                                                                                                                                    |
| `<queryStarted/>`          |                   |                         |          |          | Query progress element, showing query execution has started.                                                                                                                  |
| `<queryDone/>`             |                   |                         |          |          | Query progress element, showing query execution has completed.                                                                                                                |
| `<queryAborted/>`          |                   |                         |          |          | Query progress element, showing query execution has been aborted.                                                                                                             |
| `<newTable/>`              |                   |                         |          |          | Query progress element that reports the creation of a new table, at the current position in the response. Contains a set of `<column/>` child elements.                          |
|                            | `tableId`         | `xs:string`             | required |          | Identity of the table. Will be used in progress updates adding records to the table.                                                                                          |
|                            | `tableName`       | `xs:string`             | required |          | Human-readable, localized name of the table.                                                                                                                                  |
| `<column/>`                | `columnId`        | `xs:string`             | required |          | Identity of the column.                                                                                                                                                       |
|                            | `header`          | `xs:string`             | optional |          | Human-readable, localized header for the column.                                                                                                                              |
|                            | `src`             | `xs:string`             | optional |          | If provided, the values in the column are considered to be references to nodes in a data source, identified by this attribute.                                                |
|                            | `pt`              | `xs:string`             | optional |          | If provided, defines the partition in which the node identities referenced by the values of the column resides.                                                               |
|                            | `fgColor`         | `Color`                 | optional |          | Foreground color of column.                                                                                                                                                   |
|                            | `bgColor`         | `Color`                 | optional |          | Background color of column.                                                                                                                                                   |
|                            | `alignment`       | `Alignment`             | optional |          | Alignment of column.                                                                                                                                                          |
|                            | `nrDecimals`      | `xs:nonNegativeInteger` | optional |          | Number of deciamals of values in the column.                                                                                                                                  |
| `<newRecords/>`            |                   |                         |          |          | Query progress element that reports new records which have been added to a table. Contains a set of `<record/>` child elements.                                                  |
|                            | `tableId`         | `xs:string`             | required |          | Identity of the table.                                                                                                                                                        |
| `<record/>`                |                   |                         |          |          | Contains the cells of one row as individual child elements, based on the underlying type of data presented.                                                                   |
| `<boolean/>`               | (value)           | `xs:boolean`            |          |          | A Boolean-valued cell.                                                                                                                                                        |
| `<color/>`                 | (value)           | `Color`                 |          |          | A color-valued cell.                                                                                                                                                          |
| `<date/>`                  | (value)           | `xs:date`               |          |          | A date-valued cell.                                                                                                                                                           |
| `<dateTime/>`              | (value)           | `xs:dateTime`           |          |          | A date and time-valued cell.                                                                                                                                                  |
| `<double/>`                | (value)           | `xs:double`             |          |          | A double precision floating point-valued cell.                                                                                                                                |
| `<duration/>`              | (value)           | `xs:duration`           |          |          | A duration-valued cell.                                                                                                                                                       |
| `<int/>`                   | (value)           | `xs:int`                |          |          | A 32-bit integer-valued cell.                                                                                                                                                 |
| `<long/>`                  | (value)           | `xs:long`               |          |          | A 64-bit integer-valued cell.                                                                                                                                                 |
| `<string/>`                | (value)           | `xs:string`             |          |          | A string-valued cell.                                                                                                                                                         |
| `<time/>`                  | (value)           | `xs:time`               |          |          | A time-valued cell.                                                                                                                                                           |
| `<base64/>`                | (value)           | `xs:base64Binary`       |          |          | A cell containing encoded content.                                                                                                                                            |
|                            | `contentType`     | `xs:string`             | required |          | Internet Content Type of encoded data.                                                                                                                                        |
| `<void/>`                  |                   |                         |          |          | An empty cell.                                                                                                                                                                |
| `<tableDone/>`             |                   |                         |          |          | Query progress element that reports a table has been marked as completed.                                                                                                     |
|                            | `tableId`         | `xs:string`             | required |          | Identifies which table is complete.                                                                                                                                           |
| `<newObject/>`             |                   | `xs:base64Binary`       |          |          | Query progress element that reports the creation of a new object, at the current position in the response.                                                                    |
|                            | `contentType`     | `xs:string`             | required |          | Internet Content Type of encoded data.                                                                                                                                        |
| `<queryMessage/>`          |                   | `xs:string`             |          |          | Query progress element that reports a new message. Messages are not part of the visual report, rather they contain informative information about what happens during the execution. |
|                            | `type`            | `EventType`             | optional |          | Type of message being reported.                                                                                                                                               |
|                            | `level`           | `EventLevel`            | optional |          | Level of seriousness/importance of the message being reported.                                                                                                                |
| `<title/>`                 |                   |                         |          |          | Query progress element that reports a title for the resulting report.                                                                                                         |
|                            | `name`            | `xs:string`             | required |          | Human-readable title of report.                                                                                                                                               |
| `<status/>`                |                   |                         |          |          | Query progress element that reports the current status of the query being executed.                                                                                           |
|                            | `message`         | `xs:string`             | required |          | Human-readable, localized status message describing the current state of the query.                                                                                           |
| `<beginSection/>`          |                   |                         |          |          | Query progress element that reports a new section (or subsection) of the report.                                                                                              |
|                            | `header`          | `xs:string`             | required |          | Human-readable, localized header for the new section.                                                                                                                         |
| `<endSection/>`            |                   |                         |          |          | Query progress element that reports the end of the current section of the report.                                                                                             |

Colors (type `Color`) are defined as 6-digit case-insensitive hexadecimal strings in the format `RRGGBB`.

Column alignment, as defined by the `Alignment` enumeration, can take one of the following values:

| Value    | Description       |
|:---------|:------------------|
| `Left`   | Left alignment.   |
| `Center` | Center alignment. |
| `Right`  | Right alignment.  |

Event message type, as defined by the `EventType` enumeration, can take one of the following values:

| Value         | Description                                                              |
|:--------------|:-------------------------------------------------------------------------|
| `Exception`   | An exception represents an unexpected/unhandled fault condition.         |
| `Error`       | Represents an error state. A process, device or algorithm failed.        |
| `Warning`     | Represents a warning state. An error could occur unless action is taken. |
| `Information` | Represents information about the node that is not a warning or an error. |

Representations of level of seriousness/importance of an event message, is defined by the `EventLevel` enumeration, can take one of the 
following values:

| Value    | Description                                                                                                                                                                             |
|:---------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Major`  | Event is of major importance, and probably affect operations. Represents major changes in state, objects created, deleted or failed.                                                    |
| `Medium` | Events of more significance, but probability of affecting operations is small. Represents normal changes in state, audits, events that could become major if not properly managed, etc. |
| `Minor`  | Event is of lesser importance, frequently occurring, expected or common.                                                                                                                |

**Note**: Reporting of records in a table can continue, even if the enclosing section of the report has been closed.

Events
------------

To keep a synchronized view of a data source in a concentrator, the client can subscribe to events from the concentrator (if this feature is supported).
The concentrator informs subscribers of changes to the source, as they occur.

### subscribe

To subscribe to events from a data source in a a concentrator, the client sends the `<subscribe/>` element in an `<iq type="set"/>` to the 
concentrator, which returns an empty response is successful. If an existing subscription exists, that subscription is renewed, and new event 
types are added. (No existing event types are removed.) 

| Element                    | Attribute           | Type                 | Use      | Default  | Description                                                                                                                                         | 
|:---------------------------|:--------------------|:---------------------|:---------|:---------|:----------------------------------------------------------------------------------------------------------------------------------------------------| 
| `subscribe`                | `dt`                | `xs:string`          | optional |          | Device token(s).                                                                                                                                    |
|                            | `st`                | `xs:string`          | optional |          | Service token(s).                                                                                                                                   |
|                            | `ut`                | `xs:string`          | optional |          | User token(s).                                                                                                                                      |
|                            | `src`               | `xs:string`          | required |          | Source identity.                                                                                                                                    |
|                            | `ttl`               | `xs:positiveInteger` | required |          | How long the subscription will be active, in seconds. Subscription should be renewed before the subscription expires, to maintain receiving events. |
|                            | `getEventsSince`    | `xs:dateTime`        | optional |          | If provided, all events from this point in time (inclusive) are replayed as events sent to the subscriber.                                          |
|                            | `parameters`        | `xs:boolean`         | optional | `false`  | If node parameters are included in the subscription.                                                                                                |
|                            | `messages`          | `xs:boolean`         | optional | `false`  | If node messages are included in the subscription.                                                                                                  |
|                            | `nodeAdded`         | `xs:boolean`         | optional | `true`   | If `<nodeAdded/>` events are included in the subscription.                                                                                          |
|                            | `nodeUpdated`       | `xs:boolean`         | optional | `true`   | If `<nodeUpdated/>` events are included in the subscription.                                                                                        |
|                            | `nodeStatusChanged` | `xs:boolean`         | optional | `true`   | If `<nodeStatusChanged/>` events are included in the subscription.                                                                                  |
|                            | `nodeRemoved`       | `xs:boolean`         | optional | `true`   | If `<nodeRemoved/>` events are included in the subscription.                                                                                        |
|                            | `nodeMovedUp`       | `xs:boolean`         | optional | `true`   | If `<nodeMovedUp/>` events are included in the subscription.                                                                                        |
|                            | `nodeMovedDown`     | `xs:boolean`         | optional | `true`   | If `<nodeMovedDown/>` events are included in the subscription.                                                                                      |

### unsubscribe

Unsubscribes from events from a data source in a concentrator. If an existing subscription exists, selected event types are removed from 
that subscription. If no event types are left, the subscription is cancelled. The `<unsubscribe/>` element is sent in an `<iq type="set"/>` 
to the concentrator, which returns an empty response is successful. 

| Element                    | Attribute           | Type                 | Use      | Default  | Description                                                                                                                                         | 
|:---------------------------|:--------------------|:---------------------|:---------|:---------|:----------------------------------------------------------------------------------------------------------------------------------------------------| 
| `unsubscribe`              | `dt`                | `xs:string`          | optional |          | Device token(s).                                                                                                                                    |
|                            | `st`                | `xs:string`          | optional |          | Service token(s).                                                                                                                                   |
|                            | `ut`                | `xs:string`          | optional |          | User token(s).                                                                                                                                      |
|                            | `src`               | `xs:string`          | required |          | Source identity.                                                                                                                                    |
|                            | `nodeAdded`         | `xs:boolean`         | optional | `true`   | If `<nodeAdded/>` events should be excluded from the subscription.                                                                                  |
|                            | `nodeUpdated`       | `xs:boolean`         | optional | `true`   | If `<nodeUpdated/>` events should be excluded from the subscription.                                                                                |
|                            | `nodeStatusChanged` | `xs:boolean`         | optional | `true`   | If `<nodeStatusChanged/>` events should be excluded from the subscription.                                                                          |
|                            | `nodeRemoved`       | `xs:boolean`         | optional | `true`   | If `<nodeRemoved/>` events should be excluded from the subscription.                                                                                |
|                            | `nodeMovedUp`       | `xs:boolean`         | optional | `true`   | If `<nodeMovedUp/>` events should be excluded from the subscription.                                                                                |
|                            | `nodeMovedDown`     | `xs:boolean`         | optional | `true`   | If `<nodeMovedDown/>` events should be excluded from the subscription.                                                                              |

### nodeAdded

Event sent in a `<message/>` from concentrator to subscriber, when a node has been added to a data source. If requested in the original 
subscription request, the `<nodeAdded/>` element will also contain the set of available node parameters.

| Element        | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `nodeAdded`    | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable and can deliver sensor data to the client.                                                 |
|                | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable and publish control parameters to the client.                                          |
|                | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |
|                | `aid`             | `xs:string`   | optional |          | If provided specifies the new node was added after the sibling identified with this attribute.                      |
|                | `apt`             | `xs:string`   | optional |          | If provided, specifies the partition in which the `aid` attribute refers.                                           |
|                | `ts`              | `xs:dateTime` | required |          | Timestamp of event.                                                                                                 |

### nodeUpdated

Event sent in a `<message/>` from concentrator to subscriber, when a node has been updated in a data source. If requested in the original 
subscription request, the `<nodeUpdated/>` element will also contain the updated set of node parameters.

| Element        | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:---------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `nodeUpdated`  | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                | `displayName`     | `xs:string`   | optional |          | Human readable, localized node name.                                                                                |
|                | `nodeType`        | `xs:string`   | optional |          | Machine-readable node type, understood by the concentrator.                                                         |
|                | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                | `hasChildren`     | `xs:boolean`  | required |          | If the node has child-nodes.                                                                                        |
|                | `childrenOrdered` | `xs:boolean`  | optional | `false`  | If the order of the child nodes is important in the context.                                                        |
|                | `isReadable`      | `xs:boolean`  | optional | `false`  | If the node is readable and can deliver sensor data to the client.                                                 |
|                | `isControllable`  | `xs:boolean`  | optional | `false`  | If the node is controllable and publish control parameters to the client.                                          |
|                | `hasCommands`     | `xs:boolean`  | optional | `false`  | If the node has commands the client can access.                                                                     |
|                | `sniffable`       | `xs:boolean`  | optional | `false`  | If the node supports sniffing, i.e. can allow the client to attach a sniffer to it, to troubleshoot communication.  |
|                | `parentId`        | `xs:string`   | optional |          | The identity of the parent node, if any. Root nodes do not have parent nodes.                                       |
|                | `parentPartition` | `xs:string`   | optional |          | The parent node partition, if available.                                                                            |
|                | `lastChanged`     | `xs:dateTime` | optional |          | When the node was last changed, for synchronization.                                                                |
|                | `oid`             | `xs:string`   | optional |          | If provided, contains the identity of the node before the update.                                                   |
|                | `ts`              | `xs:dateTime` | required |          | Timestamp of event.                                                                                                 |

### nodeStatusChanged

Event sent in a `<message/>` stanza from concentrator to subscriber, when the state of a node has changed in a data source. The event may 
include a sequence of `<message/>` element, each containing a node message, if such were requested in the original subscription request.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `nodeStatusChanged` | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `state`           | `NodeState`   | required |          | Current state of node.                                                                                              |
|                     | `ts`              | `xs:dateTime` | required |          | Timestamp of event.                                                                                                 |
| `message`           | (value)           | `xs:string`   |          |          | Human-readable message text.                                                                                        |
|                     | `timestamp`       | `xs:dateTime` | required |          | Timestamp of message.                                                                                               |
|                     | `type`            | `MessageType` | required |          | Type of message.                                                                                                    |
|                     | `eventId`         | `xs:string`   | optional |          | Optional context/concentrator/manufacturer-specific identity, identifying the type of event the message represents. |

### nodeRemoved

Event sent in a `<message/>` stanza from concentrator to subscriber, when a node has been removed from a data source.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `nodeRemoved`       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `ts`              | `xs:dateTime` | required |          | Timestamp of event.                                                                                                 |

### nodeMovedUp

Event sent in a `<message/>` stanza from concentrator to subscriber, when a node has been moved up among its siblings in a data source.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `nodeMovedUp`       | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `ts`              | `xs:dateTime` | required |          | Timestamp of event.                                                                                                 |

### nodeMovedDown

Event sent in a `<message/>` stanza from concentrator to subscriber, when a node has been moved down among its siblings in a data source.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `nodeMovedDown`     | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `localId`         | `xs:string`   | optional |          | Optional local identity, unique among siblings.                                                                     |
|                     | `logId`           | `xs:string`   | optional |          | Optional log identity, related to node, if different from node identity.                                            |
|                     | `ts`              | `xs:dateTime` | required |          | Timestamp of event.                                                                                                 |


Troubleshooting
---------------------

Clients with sufficient privileges can, if the concentrator supports it, use *sniffers* to troubleshoot communication problems in remote devices controlled
by the concentrator. This is particularly relevant if the concentrator is a protocol bridge. To troubleshoot communication, the client can register a
*sniffer* with the corresponding node. If accepted, the concentrator will update the client on what communication is occurring on the node, by sending
event messages to the client.

### registerSniffer

Registers a sniffer on a node in a concentrator, for troubleshooting. The `<registerSniffer/>` element is sent in an `<iq type="set"/>` to 
the concentrator, which responds with a `<sniffer/>` element if accepting the request. All sniffers have an expiry point in time. The client 
can request a given expiry time, but the concentrator decides how long a sniffer is allowed to be active.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `registerSniffer`   | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `expires`         | `xs:dateTime` | optional |          | Requested expiry time. If not provided, the concentrator automatically chooses an expiration date and time.         |
| `sniffer`           |                   |               |          |          | Contains information about a sniffer in the concentrator.                                                           |
|                     | `snifferId`       | `xs:string`   | required |          | Sniffer identity, selected by the concentrator.                                                                     |
|                     | `expires`         | `xs:dateTime` | required |          | When the sniffer automatically expires.                                                                             |

### unregisterSniffer

Unregisters a sniffer on a node in a concentrator, before it expires. The `<unregisterSniffer/>` element is sent in an `<iq type="set"/>` 
to the concentrator, which responds with an empty response if accepting the request.

| Element             | Attribute         | Type          | Use      | Default  | Description                                                                                                         | 
|:--------------------|:------------------|:--------------|:---------|:---------|:--------------------------------------------------------------------------------------------------------------------| 
| `unregisterSniffer` | `id`              | `xs:string`   | required |          | Node identity.                                                                                                      |
|                     | `src`             | `xs:string`   | optional |          | Source identity.                                                                                                    |
|                     | `pt`              | `xs:string`   | optional |          | Partition.                                                                                                          |
|                     | `snifferId`       | `xs:string`   | required |          | Sniffer identity.                                                                                                   |

### sniff

The concentrator asynchronously updates the client on what the sniffer records by sending `<message/>` stanzas to the client containing 
the `<sniff/>` element. This element in turn contains child elements describing  what has happened.

| Element                    | Attribute         | Type                    | Use      | Default  | Description                                 | 
|:---------------------------|:------------------|:------------------------|:---------|:---------|:--------------------------------------------|
| `sniff`                    | `snifferId`       | `xs:string`             | required |          | Sniffer identity.                           |
|                            | `timestamp`       | `xs:dateTime`           | required |          | Timestamp of message.                       |
| `expired`                  |                   |                         |          |          | Informs the client the sniffer has expired. |
| `rxBin`                    | (value)           | `xs:base64Binary`       |          |          | Binary data has been received.              |
| `txBin`                    | (value)           | `xs:base64Binary`       |          |          | Binary data has been transmitted.           |
| `rx`                       | (value)           | `xs:string`             |          |          | Text has been received.                     |
| `tx`                       | (value)           | `xs:string`             |          |          | Text has been transmitted.                  |
| `info`                     | (value)           | `xs:string`             |          |          | Information about what is happening.        |
| `warning`                  | (value)           | `xs:string`             |          |          | A warning message.                          |
| `error`                    | (value)           | `xs:string`             |          |          | An error message.                           |
| `exception`                | (value)           | `xs:string`             |          |          | An exception message.                       |
