Title: Request/Response
Description: Sensor Data Request/Response page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Sensor Data Request/Response communication pattern
========================================================

You can retrieve sensor data from a device, or nodes in a device, by sending a request to the device. This document describes this pattern. This 
document outlines the XML representation of sensor data. The XML representation is modelled using an annotated XML Schema:

| Sensor Data                                           ||
| ------------|------------------------------------------|
| Namespace:  | `urn:nf:iot:sd:1.0`                      |
| Schema:     | [SensorData.xsd](Schemas/SensorData.xsd) |

Motivation and design goal
----------------------------

The request/response pattern for sensor data described in this document, is designed with the following goals in mind:

* Pattern should allow fast, quick readouts, where possible.
* Pattern should support slow asynchronous processes, with progress updates.
* Pattern should support both small and large data sets.
* Pattern should support both queueing and scheduling of requests.
* Pattern should support secure distributed transactions.
* Pattern should support limitation of requests.


Building the request
-------------------------

The request is sent using an `<iq type="get"/>` stanza with a `<req/>` element to the device. This request may optionally include references to nodes 
(if the device supports nodes) and field names the request should be limited to. If no field names are provided, all fields names are implied.
If no node references are provided, only devices not supporting nodes are implied. Concentrators should interpret this as an empty request, reading zero nodes.

The request also contains an **Identity**, that will be used to match response messages to the original request. Field **categories** are also included in the
request. The device filters the response, as to only return fields in these categories. The special `all` attribute can be used, to mean all categories.
**Time intervals** can be defined using a `from` and a `to` attribute. The readout can also be scheduled by using the `when` attribute. Distributed transactions can be executed by the
use of [tokens](#tokens).

```uml:Sensor Data Request
@startuml
Request "1" --> "*" Node
Request "1" --> "*" Field

Request : Id
Request : Categories
Request : From
Request : To
Request : When
Request : Tokens

Node : Node ID
Node : Source ID
Node : Partition

Field : Name
@enduml
```

### XML representation

| Entity    | Element   | Use      | Attributes | Type          | Use      | Description                                      |
|-----------|-----------|----------|------------|---------------|----------|--------------------------------------------------|
| Request   | `req`     | Required | `id`       | `xs:string`   | Required | Request identity                                 |
|           |           |          | `m`        | `xs:boolean`  | Optional | Include momentary values                         |
|           |           |          | `p`        | `xs:boolean`  | Optional | Include peak values                              |
|           |           |          | `s`        | `xs:boolean`  | Optional | Include status values                            |
|           |           |          | `c`        | `xs:boolean`  | Optional | Include computed values                          |
|           |           |          | `i`        | `xs:boolean`  | Optional | Include identity values                          |
|           |           |          | `h`        | `xs:boolean`  | Optional | Include historical values                        |
|           |           |          | `all`      | `xs:boolean`  | Optional | Include all categories of fields                 |
|           |           |          | `from`     | `xs:dateTime` | Optional | Only return fields not older than this timestamp |
|           |           |          | `to`       | `xs:dateTime` | Optional | Only return fields not newer than this timestamp |
|           |           |          | `when`     | `xs:dateTime` | Optional | Timestamp of when the request is to be executed  |
|           |           |          | `st`       | `xs:string`   | Optional | Service token                                    |
|           |           |          | `dt`       | `xs:string`   | Optional | Device token                                     |
|           |           |          | `ut`       | `xs:string`   | Optional | User token                                       |
| Node      | `nd`      | Optional | `id`       | `xs:string`   | Required | Node identity                                    |
|           |           |          | `src`      | `xs:string`   | Optional | Source identity                                  |
|           |           |          | `pt`       | `xs:string`   | Optional | Partition                                        |
| Field     | `f`       | Optional | `n`        | `xs:string`   | Required | Unlocalized field name                           |


Responses
------------

When receiving a request, a device can respond in several manners:

* Returning the sensor data immediately.
* Returning a response, letting the client know the readout has commenced, but data is not yet available.
* Returning a response, letting the client know the request has been accepted, but not yet started.
* Returning an error response.

### Returning sensor data immediately

A simple readout just returns the sensor data in an `<iq type="result"/>` stanza with a `<resp/>` element. This is typically the pattern of small devices having
the current values in internal memory.

```uml:Simple Readout
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Device -> Device : start readout
Activate Device

Client <- Device : iq[type=result](resp)
Deactivate Device
Deactivate Device
@enduml
```

### Slow responses

If it takes time to collect the data to return, the device returns a `<started/>` element in an `<iq type="result"/>` stanza immediately to the client. This allows the
client to know the request has been accepted and started, and that data will be sent later. When data is available, it is sent asynchronously to the client,
using the `<message/>` stanza containing a `<resp/>` element.

```uml:Slow Readout
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Device -> Device : start readout
Activate Device

Client <- Device : iq[type=result](started)

== Delay ==

Client <- Device : message(resp)
Deactivate Device
Deactivate Device
@enduml
```

### Scheduled or queued responses

If a request is scheduled or queued for some reason, the device returns an `<accepted/>` element in an `<iq type="result"/>` stanza back to the client. The client then knows
the request has been accepted, and either scheduled for execution at a later time, or queued for execution as soon as the device is able. The `<accepted/>` element
has a `queued` attribute that can be used to let the client know the request has been queued.

```uml:Scheduled Readout
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Client <- Device : iq[type=result](accepted)

== Delay ==

Device -> Device : start readout
Activate Device

Client <- Device : message(resp)
Deactivate Device
Deactivate Device
@enduml
```

Depending on the type of readout, the device can either send the response back immediately, using a `<resp/>` element in a `<message/>` stanza, or first send a `<started/>` 
element in a separate `<message/>` stanza, before the actual response is returned.

```uml:Scheduled Slow Readout
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Client <- Device : iq[type=result](accepted)

== Delay ==

Device -> Device : start readout
Activate Device

Client <- Device : message(started)

== Delay ==

Client <- Device : message(resp)
Deactivate Device
Deactivate Device
@enduml
```

### Fragmented responses

Responses are allowed to be fragmented. Reasons can be to either fit a large data set into the limited maximum stanza size provided by the XMPP network, 
reporting multiple nodes in separate response messages, or to allow the client to continuously follow the progress of a long readout process. Fragmentation
is done by setting the `more` attribute in the `<resp/>` element to `true`. This alerts the client that more is on the way. If the `more` attribute is
omitted, or explicitly set to `false`, no more fragments are expected for the current request.

```uml:Simple Fragmented Response
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Device -> Device : start readout
Activate Device

Client <- Device : iq[type=result](resp[more=true])

group Variable number of fragments

    Client <- Device : message(resp[more=true])

end

Client <- Device : message(resp[more=false])

Deactivate Device
Deactivate Device
@enduml
```

Fragmented responses can be used in any of the response patterns described.

```uml:Scheduled Slow Fragmented Response
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Client <- Device : iq[type=result](accepted)

== Delay ==

Device -> Device : start readout
Activate Device

Client <- Device : message(started)

group Variable number of fragments

    == Delay ==

    Client <- Device : message(resp[more=true])

end

== Delay ==

Client <- Device : message(resp[more=false])

Deactivate Device
Deactivate Device
@enduml
```

### Completion

It might happen that the device, when sending the last response message, doesn't know it is the last response message. For such cases, a separate `<done/>`
element can be sent in a `<message/>` stanza back to the client, to notify the client the request has been completely processed.

```uml:Asynchronous Completion
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Device -> Device : start readout
Activate Device

group Variable number of fragments

    Client <- Device : message(resp[more=true])

    == Delay ==

end

Client <- Device : message(done)

Deactivate Device
Deactivate Device
@enduml
```

### Cancelling request

A request that has been scheduled or queued, can be cancelled. Cancelling a request is done by sending an `<iq type="set"/>` stanza with a `<cancel/>` element to the 
device, with the identifier used to identify the request. The device responds with an empty `<iq type="result"/>` stanza. Optionally, a device may also support the 
cancellation of ongoing readouts. 

```uml:Cancel Readout
@startuml
Client -> Device : iq[type=get](req)
Activate Device

Device -> Device : start readout
Activate Device

group Variable number of fragments

    Client <- Device : message(resp[more=true])

    == Delay ==

end

Client -> Device : iq[type=set](cancel)

Client <- Device : iq[type=result]()

Destroy Device
Deactivate Device
@enduml
```

### Request identities

Request identities are strings. The identities are invented by the client, and are supposed to be unique from the full JID of the client
making the request.

### Sensor Data

The `<resp/>` element contains [sensor data](SensorData.md) as payload. If the device supports nodes, `<nd/>` elements should be used to identify which
nodes are reporting sensor data back. If nodes are not supported, the response contains `<ts/>` elements, corresponding to the timestamps where data
is being reported back.

### XML representation

| Entity              | Element    | Use      | Attributes | Type          | Use      | Description                                                                    |
|---------------------|------------|----------|------------|---------------|----------|--------------------------------------------------------------------------------|
| Response            | `resp`     | Required | `id`       | `xs:string`   | Required | Request identity                                                               |
|                     |            |          | `more`     | `xs:boolean   | Optional | If more data is expected. Default value is `false`.                            |
| Accept notification | `accepted` | Optional | `id`       | `xs:string`   | Required | Request identity                                                               |
|                     |            |          | `queued`   | `xs:boolean   | Optional | If the request has been queued for later processing. Default value is `false`. |
| Start notification  | `started`  | Optional | `id`       | `xs:string`   | Required | Request identity                                                               |
| Completion          | `done`     | Optional | `id`       | `xs:string`   | Required | Request identity                                                               |
| Cancel request      | `cancel`   | Optional | `id`       | `xs:string`   | Required | Request identity                                                               |
| Request cancelled   | `cancel`   | Optional | `id`       | `xs:string`   | Required | Request identity                                                               |


Tokens
------------

To support distributed transactions, where the identity of the original actors are used to authorize requests, a set of **tokens** can be 
provided in the request. Tokens can be used to identify a **device**, a **service** and a **user**. They can be validated and challenged.
For more information, see the article on [Tokens](Tokens.md).


Legacy
-------------

The following data model is based on work done in the [XMPP Standards Foundation (XSF)](https://xmpp.org/about/xmpp-standards-foundation.html),
[XEP-0323: Internet of Things - Sensor Data](https://xmpp.org/extensions/xep-0323.html).

Apart from the differences noted in the [Sensor Data document](SensorData.md#legacy), regarding the sensor data representation, here follows a 
list of notable differences:

* A separation of XML representation and communication pattern has been done.
* Documentation has been simplified.
* Easier to respond for small/quick devices.
* More data is signaled using a `more` attribute, instead of a lack of a `done` attribute.
* The `<cancelled/>` element has been removed.
* Request identities are now strings, instead of sequence numbers.


Determining Support
-------------------------

Devices supporting the protocol described in this document should advertise this fact, by including the `urn:nf:iot:sd:1.0` namespace in the features list in responses to
[Service Discover](https://xmpp.org/extensions/xep-0030.html) requests.


Examples
-----------------

### Simple readout

Request:

```xml
<iq type='get' from='client@example.org/1234' to='device@example.org/abcd' id='R0001'>
  <req xmlns="urn:nf:iot:sd:1.0" id="00000001" all="true"/>
</iq>
```

Simple response:

```xml
<iq type='result' from='device@example.org/abcd' to='client@example.org/1234' id='R0001'>
  <resp xmlns="urn:nf:iot:sd:1.0" id="00000001">
    <ts v="2017-09-22T15:22:33Z">
      <q n="Temperature" v="12.3" u="C" m="true" ar="true"/>
      <s n="SN" v="12345678" i="true" ar="true"/>
    </ts>
  </resp>
</iq>
```