Sensor Data Event Subscription communication pattern
========================================================

You can subscribe to sensor data from a device, or nodes in a device, by sending a subscription request to the device describing the data you are 
interested in, and parameters describing when events should be triggered. This document describes this pattern. This document outlines the XML 
representation of sensor data. The XML representation is modelled using an annotated XML Schema:

| Event subscription                                                  ||
| ------------|--------------------------------------------------------|
| Namespace:  | urn:nf:iot:events:1.0                                  |
| Schema:     | [EventSubscription.xsd](Schemas/EventSubscription.xsd) |

It also relies on the [Sensor Data Request/Response pattern](SensorDataRequestResponse.md) and the [Sensor Data Representation](SensorData.md).

Motivation and design goal
----------------------------

The event subscription pattern for sensor data described in this document, is designed with the following goals in mind:

* Pattern should tie into the request/response pattern as easily as possible.
* Pattern should allow client to specify when events should be triggered.
* Pattern should avoid complex semantics in setting up trigger rules.


Building the subscription request
---------------------------------------

The request is sent using an `<iq type="set"/>` stanza with a `<subscribe/>` element to the device. This request may optionally include references to nodes 
(if the device supports nodes) and field names the request should be limited to. If no field names are provided, all fields names are implied.
If no node references are provided, only devices not supporting nodes are implied. Concentrators should interpret this as an empty request, reading zero nodes.

Each field can provide trigger parameters, allowing the device to know when an event should be triggered, based on how much the field value changes.
The subscription request can also include a minimum and/or maximum time interval attributes, defining a smallest and a largest time interval between
successive triggers.

The subscription also contains an **Identity**, that will be used when sending sensor data to the client. As with sensor data requests, you can limit the 
subscription to available field **categories**. The device filters the response, as to only return fields in these categories. The special `all` attribute can 
be used, to mean all categories. Authorization of subscriptions in a distributed environment is facilitated by the use of [tokens](#tokens).

```uml:Sensor Data Subscription
@startuml
Subscription "1" --> "*" Node
Subscription "1" --> "*" Field

Subscription : Id
Subscription : Categories
Subscription : Max Age
Subscription : Max Interval
Subscription : Min Interval
Subscription : Tokens
Subscription : Request

Node : Node ID
Node : Source ID
Node : Partition

Field : Name
Field : Current Value
Field : Change By
Field : Change Up
Field : Change Down
@enduml
```

### XML representation

| Entity       | Element     | Use      | Attributes | Type          | Use      | Description                                                                                                                                                              |
|--------------|-------------|----------|------------|---------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Subscription | `subscribe` | Required | `id`       | `xs:string`   | Required | Subscription identity                                                                                                                                                   |
|              |             |          | `m`        | `xs:boolean`  | Optional | Include momentary values                                                                                                                                                |
|              |             |          | `p`        | `xs:boolean`  | Optional | Include peak values                                                                                                                                                     |
|              |             |          | `s`        | `xs:boolean`  | Optional | Include status values                                                                                                                                                   |
|              |             |          | `c`        | `xs:boolean`  | Optional | Include computed values                                                                                                                                                 |
|              |             |          | `i`        | `xs:boolean`  | Optional | Include identity values                                                                                                                                                 |
|              |             |          | `h`        | `xs:boolean`  | Optional | Include historical values                                                                                                                                               |
|              |             |          | `all`      | `xs:boolean`  | Optional | Include all categories of fields                                                                                                                                        |
|              |             |          | `maxAge`   | `xs:dateTime` | Optional | Maximum age of historical data to return                                                                                                                                |
|              |             |          | `minInt`   | `xs:dateTime` | Optional | Smallest amount of time between successive events                                                                                                                       |
|              |             |          | `maxInt`   | `xs:dateTime` | Optional | Largest amount of time between successive events                                                                                                                        |
|              |             |          | `st`       | `xs:string`   | Optional | Service token                                                                                                                                                           |
|              |             |          | `dt`       | `xs:string`   | Optional | Device token                                                                                                                                                            |
|              |             |          | `ut`       | `xs:string`   | Optional | User token                                                                                                                                                              |
|              |             |          | `req`      | `xs:string`   | Optional | If the subscription is also a sensor data request (i.e. trigger event immediately)                                                                                      |
| Node         | `nd`        | Optional | `id`       | `xs:string`   | Required | Node identity                                                                                                                                                           |
|              |             |          | `src`      | `xs:string`   | Optional | Source identity                                                                                                                                                         |
|              |             |          | `pt`       | `xs:string`   | Optional | Partition                                                                                                                                                               |
| Field        | `f`         | Optional | `n`        | `xs:string`   | Required | Unlocalized field name                                                                                                                                                  |
|              |             |          | `v`        | `xs:string`   | Optional | Current value, as perceived by the client. Change measurements will be made against this value. If not provided, the current value, as seen by the device, will be used. |
|              |             |          | `by`       | `xs:string`   | Optional | If change is larger than this value, in any direction, the event is triggered                                                                                           |
|              |             |          | `up`       | `xs:string`   | Optional | If change is larger than this value, upwards, the event is triggered. Can be used together with 'dn'.                                                                    |
|              |             |          | `dn`       | `xs:string`   | Optional | If change is larger than this value, downwards, the event is triggered. Can be used together with 'up'.                                                                  |


Events
------------

Each event is sent with an `id` attribute containing the subscription identity. This identity is unique, within the scope of the full JID of the sender.
The device must be able to differ between subscription identities from different senders. The subscription request is sent using an `<iq type="set"/>` stanza containing
the `<subscribe/>` element. The device responds to a successful request with an `<iq type="result"/>` stanza containing an `<accepted/>` element.

Events are triggered, either based on elapsed time since last trigger (or since the subscription if not triggered yet), or based on change in any of the
fields of the request. The time intervals and field change levels, are unique for each subscription. If an event triggers for one subscription, subscriptions
from other clients should not automatically trigger.

When an event is triggered, an implicit sensor data request is made internally by the client The response from that request, is sent back to the client,
as if the `<accepted/>` message has already been sent. (It was returned to the client as part of the accepted subscription response.)

```uml:Simple Events
@startuml
Client -> Device : iq[type=set](subscribe)
Activate Device

Client <- Device : iq[type=result](accepted)

group While subscription active

    == Wait for event to trigger ==

    Device -> Device : start readout
    Activate Device

    Client <- Device : message(resp)
    Deactivate Device

end

Client -> Device : iq[type=set](unsubscribe)
Client <- Device : iq[type=result]()

Deactivate Device
@enduml
```

Events can be slow and fragmented, just as sensor data responses can. The optional `<started/>` element can be used to inform the client that a slow readout
has been initiated. The `more` attribute can be used in messages to let the client know more fragments will be coming.

```uml:Fragmented Events
@startuml
Client -> Device : iq[type=set](subscribe)
Activate Device

Client <- Device : iq[type=result](accepted)

group While subscription active

    == Wait for event to trigger ==

    Device -> Device : start readout
    Activate Device

    opt
        Client <- Device : message(started)
        note right
            If readout slow, client can
            be alerted that readout has
            begun.
        end note
    end

    group Variable number of fragments

        == Delay ==

        Client <- Device : message(resp[more=true])
        note right
            Sensor data transmission
            can be fragmented into
            multiple messages.
        end note
    end

    == Delay ==

    Client <- Device : message(resp[more=false])
    Deactivate Device

end

Client -> Device : iq[type=set](unsubscribe)
Client <- Device : iq[type=result]()

Deactivate Device
@enduml
```

Unsubscribing
-----------------

Unsubscribing from active subscriptions is done by the client by simply sending an `<iq type="set"/>` stanza containing an `<unsubscribe/>` element. The device
returns an empty `<iq type="result"/>` stanza to show the subscription has been removed.

### Automatic unsubscription

To avoid the accumulation of unused subscriptions, a device should automatically remove active subscriptions when:

* Errors are returned by the broker, stating the client is no longer reachable.
* When a presence stanza is received showing the client is offline.
* When the device itself goes offline, is turned off, or is restarted.

### Monitoring subscriptions

The client should monitor its subscriptions, and issue new subscription requests, reusing the same identity used before, when it notices a subscription is not
alive. By using the maximum time interval attribute in the subscription request, the client has a means to monitor the subscription. If no event is received
within this time frame, plus an additional latency coefficient, the subscription might be down.

Note: Only reissue subscription requests if the device is online. If the device comes back online after having been offline, the subscription request can be
reissued.


Examples
-----------------

### Simple event subscription

Subscription request:

```xml
<iq type='get' id='28' from='client@example.org/1234' to='device@example.org/abcd'>
  <subscribe xmlns='urn:nf:iot:events:1.0' id='d4fe61155cb14e649e302092d3b406a8' m='true' minInt='PT1S' maxInt='PT1M'>
    <f n='Light' v='25.72' by='1'/>
    <f n='Motion' v='0' by='1'/>
  </subscribe>
</iq>
```

Subscription response:

```xml
<iq id='28' type='result' to='client@example.org/1234' from='device@example.org/abcd'>
  <accepted xmlns='urn:nf:iot:sd:1.0' id='d4fe61155cb14e649e302092d3b406a8'/>
</iq>
```

Event:

```xml
<message to='client@example.org/1234' from='device@example.org/abcd'>
  <resp id="d4fe61155cb14e649e302092d3b406a8" xmlns="urn:nf:iot:sd:1.0">
    <ts v="2018-07-18T15:19:57.732">
      <q n="Light" m="true" ar="true" v="26.11" u="%" />
      <b n="Motion" m="true" ar="true" v="true" />
    </ts>
  </resp>
</message>
```

Unsubscription request:

```xml
<iq type='get' id='29' from='client@example.org/1234' to='device@example.org/abcd'>
  <unsubscribe xmlns='urn:nf:iot:events:1.0' id='d4fe61155cb14e649e302092d3b406a8'/>
</iq>
```

Unsubscription response:

```xml
<iq id='29' type='result' to='client@example.org/1234' from='device@example.org/abcd'/>
```
