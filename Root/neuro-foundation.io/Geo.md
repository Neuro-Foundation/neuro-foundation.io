Title: Geo-spatial information
Description: Geo-spatial information page of neuro-foundation.io
Date: 2025-05-21
Author: Peter Waher
Master: Master.md

=============================================

Geo-spatial information
==========================

This document outlines the XML representation of real-time communication of geo-spatial
information. The XML representation is modelled using an annotated XML Schema:

| Peer-to-Peer communication              ||
| ------------|----------------------------|
| Namespace:  | `urn:nf:iot:geo:1.0`       |
| Schema:     | [Geo.xsd](Schemas/Geo.xsd) |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The method of communicating geo-spatial information described here, is designed with the 
following goals in mind:

* The underlying communication method is similar to Publish/Subscribe, with the following
major differences:

    * Information can be found using approximate location, instead of exact identifiers.

    * Clients can publish, update and delete geo-spatial information, using Latitude, Longitude
    and optionally altitude floating-point components.

    * Clients can subscribe to and unsubscribe from geo-spatial information using bounding boxes 
    using the Mercator projection.

    * Subscriptions limited to connections or time. When disconnected, or elapsed, subscriptions 
    are removed.

* Information can be transient or persistent, with an optional life-time defined.

* Information can be identifiable using unique identifiers.

* Set of information publishable is extensible, and support Internet-Content and URIs.

* Each broker can provide an implementation-specific set of service levels for different types 
of clients. Service levels may control number of items a client can publish, maximum or total 
size of published content, life time of published entries, number of concurrent subscriptions 
or maximum sizes of bounding boxes.

* The geo-spatial edge service is provided by a component on the broker, and identifies using
Service-Discovery.

Subscribing to geo-spatial events
------------------------------------

The client subscribes to geo-spatial information using a bounding box. The bounding box is
defined using to coordinates using the Mercator projection, which is a cylindrical map 
projection. The bounding box is defined using the following four required and two optional
floating-point components:

| Subscription attributes                                                          |||
|:---------|:--------:|:-------------------------------------------------------------|
| `id`     | Optional | Identifier of existing subscription.                         |
| `minLat` | Required | The minimum latitude of the bounding box, in degrees.        |
| `maxLat` | Required | The maximum latitude of the bounding box, in degrees.        |
| `minLon` | Required | The minimum longitude of the bounding box, in degrees.       |
| `maxLon` | Required | The maximum longitude of the bounding box, in degrees.       |
| `minAlt` | Optional | The minimum altitude of the bounding box, in meters.         |
| `maxAlt` | Optional | The maximum altitude of the bounding box, in meters.         |
| `ttl`    | Optional | Number of seconds before the subscription gets unsubscribed. |

**Note**: If the `minLon` is greater than the `maxLon` value, the bounding box is assumed to
wrap around the antimeridian, or the +- 180 degree longitude meridian.

**Note 2**: A client automatically unsubscribes a subscription if the time elapses and the
subscription is not updated, or, if the client is connected to the same broker, the client
connection closes. Due to network latency and other factors, a subscription should be
updated with a margin before the time elapses.

**Note 3**: The server may choose a lower `ttl` value, if the client requests a value that is
larger than the maximum allowed value for the client.

The client subscribes to geo-spatial information sending an `iq set` stanza as follows:

```xml
<iq type='set' id='1' from='client@example.com/resource' to='geo.example.com'>
    <subscribe xmlns='urn:nf:iot:geo:1.0'
               minLat='60.123' maxLat='60.456'
               minLong='10.789' maxLon='11.012'/>
</iq>
```

The component responds with an identifier for the subscription, and the number of seconds before
the subscription will be automatically unsubscribed:

```xml
<iq id='1' type='result' to='client@example.com/resource' from='geo.example.com'>
    <subscribed xmlns='urn:nf:iot:geo:1.0' id='7b102c7f-84ce-489b-998d-346bbb322997' ttl='60'/>
</iq>
```

The client can update the subscription, if moving it, or resizing it, by including the
identifier in a new subscription call:

```xml
<iq type='set' id='2' from='client@example.com/resource' to='geo.example.com'>
    <subscribe xmlns='urn:nf:iot:geo:1.0'
               id='7b102c7f-84ce-489b-998d-346bbb322997'
               minLat='60.123' maxLat='60.456'
               minLong='10.789' maxLon='11.012'/>
</iq>
```

The component must return an error if a client attempts to update a subscription that does not
exist, or that was created by another client (as evidenced by the Bare JID of the caller). If 
the update is approved, the component acknowledges the update, without returning the identifier 
again:

```xml
<iq id='2' type='result' to='client@example.com/resource' from='geo.example.com'>
    <subscribed xmlns='urn:nf:iot:geo:1.0' ttl='60'/>
</iq>
```

If a subscription elapses, a message is sent to the client informing the client that the
subscription has been terminated:

```xml
<message id='3' to='client@example.com/resource' from='geo.example.com'>
    <unsubscribed xmlns='urn:nf:iot:geo:1.0' id='7b102c7f-84ce-489b-998d-346bbb322997'/>
</message>
```

**Note**: If a subscription is removed due to the client's connection being closed, no message
is sent to the client, as this would only generate an offline message that will be sent next
time the client reconnects. Instead, it is assumed that the client looses all subscriptions when
the connection closes.

Unsubscribing from geo-spatial events
----------------------------------------

The client unsubscribes from geo-spatial information using the identifier of the subscription
created when subscribing to geo-spatial information.

| Unsubscription attributes                                |||
|:---------|:--------:|:-------------------------------------|
| `id`     | Optional | Identifier of existing subscription. |

The client unsubscribes a geo-spatial subscription sending an `iq set` stanza as follows:

```xml
<iq type='set' id='4' from='client@example.com/resource' to='geo.example.com'>
    <unsubscribe xmlns='urn:nf:iot:geo:1.0'
                 id='7b102c7f-84ce-489b-998d-346bbb322997'/>
</iq>
```

The component responds with an acknowledgement of the unsubscription:

```xml
<iq id='4' type='result' to='client@example.com/resource' from='geo.example.com'>
    <unsubscribed xmlns='urn:nf:iot:geo:1.0' id='7b102c7f-84ce-489b-998d-346bbb322997'/>
</iq>
```

The component must return an error if a client attempts to unsubscribe a subscription that does 
not exist, or that was created by another client (evidenced by the Bare JID of the caller).


Publishing geo-spatial information
-------------------------------------

The client publishes geo-spatial information associating it with a geo-spatial point of
reference. Active subscriptions are used to determine which clients should receive notification
about the new or updated information. Each item of information is also associated with a
unique identifier. This identifier can be used in the publish statement, to inform the
broker that the information is being updated, rather than created. An `iq set` stanza is
sent with a `publish` element, containing the following attributes:

| Publish attributes                                                                                    |||
|:---------|:--------:|:----------------------------------------------------------------------------------|
| `id`     | Optional | Identifier if updating existing information. The identifier can be an URL or URI. |
| `lat`    | Required | Latitude of the geo-spatial point of reference, in degrees.                       |
| `lon`    | Required | Longitude of the geo-spatial point of reference, in degrees.                      |
| `alt`    | Optional | Altitude of the geo-spatial point of reference, in meters.                        |
| `ttl`    | Optional | Number of seconds before the information gets deleted.                            |

The following example publishes new ephemeral information (i.e. not persisted) about the 
location of a legal identity:

```xml
<iq type='set' id='5' from='client@example.com/resource' to='geo.example.com'>
    <publish xmlns='urn:nf:iot:geo:1.0'
             id='iotid:cf8a82a3-1b28-4a34-80d6-a497080b57b3@legal.example.com'
             lat='60.253' long='10.923'/>
</iq>
```

The following example publishes persisted information about a smart contract associated with
a location, available for 2 years:

```xml
<iq type='set' id='6' from='client@example.com/resource' to='geo.example.com'>
    <publish xmlns='urn:nf:iot:geo:1.0'
             id='iotsc:9af22dac-01f4-410b-b334-389959254331@legal.example.com'
             lat='60.253' long='10.923' ttl='63115200'/>
</iq>
```

The following information publishes custom ephemeral information for display in a map,
associated with a legal identity, for communication purposes:

```xml
<iq type='set' id='7' from='client@example.com/resource' to='geo.example.com'>
    <publish xmlns='urn:nf:iot:geo:1.0'
             lat='60.253' long='10.923'>
        <display xmlns='http://example.com/Custom.xsd'
                 friendlyName='John Doe'
                 ref='iotid:cf8a82a3-1b28-4a34-80d6-a497080b57b3@legal.example.com'
                 icon="https://example.com/Images/JohnDoe.jpg"
                 iconWidth='64' iconHeight='64'/>
    </publish>
</iq>
```

**Note**: Content XML can be any valid XML with a size acceptable to the broker and the client's
service level. The XML should use a custom namespace. The content will not be validated by the
broker.

The component responds with an identifier for the item, if one is not provided in the 
publication, and the number of seconds before the item will be automatically removed, if
persisted:

```xml
<iq id='7' type='result' to='client@example.com/resource' from='geo.example.com'>
    <published xmlns='urn:nf:iot:geo:1.0' id='bbd54a92-24fd-4263-85a2-5e5c17454ddf'/>
</iq>
```

The component must return an error if a client attempts to update information that was created
by another client (evidenced by the Bare JID of the caller). The broker can also return an error
if the client has exceeded its service level.


Deleting geo-spatial information
-----------------------------------

Searching for geo-spatial information
----------------------------------------


TODO: object reference added, updated, removed event notifications