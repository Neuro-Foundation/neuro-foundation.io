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

    * Subscriptions limited to connections. When disconnected, subscriptions are removed.

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

| Subscription attributes                                                                          |||
|:---------|:--------:|:-----------------------------------------------------------------------------|
| `id`     | Optional | Identifier of existing subscription.                                         |
| `minLat` | Required | The minimum latitude of the bounding box, in degrees.                        |
| `maxLat` | Required | The maximum latitude of the bounding box, in degrees.                        |
| `minLon` | Required | The minimum longitude of the bounding box, in degrees.                       |
| `maxLon` | Required | The maximum longitude of the bounding box, in degrees.                       |
| `minAlt` | Optional | The minimum altitude of the bounding box, in meters.                         |
| `maxAlt` | Optional | The maximum altitude of the bounding box, in meters.                         |
| `ttl`    | Optional | Number of seconds before the subscription gets unsubscribed, if not updated. |

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
the subscription will be automatically unsubscribed, unless updated:

```xml
<iq id='1' type='result' to='client@example.com/resource' from='geo.example.com'>
    <subscribed xmlns='geo.example.com' id='7b102c7f-84ce-489b-998d-346bbb322997' ttl='60'/>
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
exist, or that was created by another client. If the update is approved, the component 
acknowledges the update, without returning the identifier again:

```xml
<iq id='2' type='result' to='client@example.com/resource' from='geo.example.com'>
    <subscribed xmlns='geo.example.com' ttl='60'/>
</iq>
```

If a subscription elapses, a message is sent to the client informing the client that the
subscription has been terminated:

```xml
<message id='3' to='client@example.com/resource' from='geo.example.com'>
    <unsubscribed xmlns='geo.example.com' id='7b102c7f-84ce-489b-998d-346bbb322997'/>
</message>
```

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
    <unsubscribed xmlns='geo.example.com' id='7b102c7f-84ce-489b-998d-346bbb322997'/>
</iq>
```

The component must return an error if a client attempts to unsubscribe a subscription that does 
not exist, or that was created by another client.


Publishing geo-spatial information
-------------------------------------

Deleting geo-spatial information
-----------------------------------

Searching for geo-spatial information
----------------------------------------
