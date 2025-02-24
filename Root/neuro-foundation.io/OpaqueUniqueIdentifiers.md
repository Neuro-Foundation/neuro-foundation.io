Title: Opaque Unique Identifiers
Description: Opaque Unique Identifiers page of neuro-foundation.io
Date: 2025-02-18
Author: Peter Waher
Master: Master.md

=============================================

Opaque Unique Identifiers
============================

This document outlines the XML representation of the Opaque Unique Identifiers service provided to devices in the federated network.
While each connected entity has a unique global identity on the XMPP network called the JID, and each entity connected to the XMPP network via
a [*concentrator*](Concentrator.md) has a unique global identity in the *quadruple* (`JID`, `NodeId`, `SourceId`, `Partition`), there is
sometimes also a need for an opaque unique identifier, that is not directly related to any communication protocol. Typically, applications use
`GUID`s or `UUID`s for this purpose. But these cannot be used to find a device in a federated network in the general case. For this purpose, 
the Neuro-Foundation infrastructure provides a way to generate *opaque unique identifiers*, similar to `GUID`s or `UUID`s, that can be used as 
identifiers in other systems, but that can also be resolved to a `JID` in the connected case, or a *quadruple* (`JID`, `NodeId`, `SourceId`, 
`Partition`) in the general case.

| Provisioning                                          ||
| ------------|------------------------------------------|
| Namespace:  | `urn:nf:iot:uuid:1.0`                    |
| Schema:     | [OpaqueUuid.xsd](Schemas/OpaqueUuid.xsd) |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The method of generating UUIDs described here, is designed with the following goals in mind:

* Provide Globally Unique IDs having the same format as traditional UUIDs and GUIDs, for storage and processing in external systems.

* The Globally Unique IDs should be opaque, i.e. not reveal any information about the device, its owner, or its location, by itself.

* A method should exist whereby authorized parties are allowed to resolve a Globally Unique ID to a `JID` in the federated network, or a 
  *quadruple* (`JID`, `NodeId`, `SourceId`, `Partition`) in the general concentrator case.

IEEE 1451.0 UUID
-------------------

The IEEE 1451.0 standard defines a Universally Unique Identifier (UUID) format, that can be used for the above mentioned purposes, with some 
alterations. The original definition contains the following fields (see standard for details):

| IEEE 1451.0 UUID                                                    |||
| Field           | Bytes | Description                                 |
|:----------------|------:|:--------------------------------------------|
| Geolocation     |     6 | Longitude and Latitude of manufacturer      |
| Manufacturer ID |     3 | A Manfacturer ID chosen by the manufacturer |
| Year            |     2 | Year of manufacture                         |
| Time            |     5 | Time of manufacture                         |

The rationale here, is that anyone can generate a UUID without a central registry. The Geolocation + Manufacturer ID, selected by each 
manufacturer, has sufficient entropy to "very probably" generate uniqueness. In the case there is a collision, the stadard defers to the
manufacturers, who are supposed to reside close to each other (if they follow the standard), to resolve the issue. There is also no protection
against spoofing in the method proposed. Anyone can very easily pretend to be someone else and generate any number of UUIDs using the same
Geolocation and Manufacturer ID as someone else.

For a federated network, this solution does not work either, as it is written. But with a simple alteration, it can be made to work also for 
a federated network, such as the one defined by Neuro-Foundation. It can also be made more secure, by protecting against spoofing, as described
below.

Domain as Manufacturer
-------------------------

In a federated network, the concept of a domain is crucial. The Neuro-Foundation infrastructure is based on brokers (Trust Providers),
providing services to entities in the domain that make it possible to interoperate in an open and yet secure manner. The broker on the domain
is a key player for tying the network together. It therefore makes sense, that the broker itself, becomes a manufacturer of UUIDs, and that its
main domain is tied together witg a unique Manufacturer ID issued to it.

A registry of registered domains and their Manufacturer IDs can be kept to ensure that at most one domain corresponds to a Manufacturer ID. 
Reversely, given a Manufacturer ID, the domain can be resolved, as access to the registry is public and downloadable. Each broker can have a 
copy of registered Manufacturer IDs and their corresponding domain names, to avoid creating a bottle-neck. Furthermore, a broker on a domain, 
is an authority and Trust Provider on that domain. The broker is furthermore tasked to recognize the UUIDs it has created, and to what connected 
entity (`JID`) each UUID belongs. Each connected entity (`JID`) can request UUIDs, and in doing so, gets a unique identity (since domains are 
separated by the registry), and each broker can register which UUIDs have been generated for which connected entities (`JID`). In the case of 
concentrators, a request can then be made to the resolved `JID`, to get the additional (`NodeId`, `SourceId` and `Partition`) associated with 
the UUID.

### Getting Manufacturer ID

A broker can get its Manufacturer ID from the *authoratative trust anchor* by sending a `<getManufacturerId/>` request without attributes to the 
trust anchor broker, which for this specification is `neuro-foundation.io`. Only brokers are allowed to send this request. All other senders 
will receive a `<forbidden/>` error as a response.

The authorotative trust anchor checks if the sender (i.e. the domain of the sending broker) has a Manufacturer ID registered. If so, that one
is returned. If not, a new Manufacturer ID is generated and return. Together with the Manufacturer ID, the IP Endpoint of the request is returned.
The response may also contain the latitude and longitude of the endpoint, if the trust anchor has access to this information. If not, the IP 
Endpoint can be used by the broker to resolve the geolocalization of the public IP the broker is using. All that is left for the broker to do to
in order to create new UUIDs, is to append the year and time components. The response is returned using a `<manufacturerId/>` element in an 
`iq result` stanza. Attributes include:

| Attribute | Type        | Description                                                             |
|:----------|:------------|:------------------------------------------------------------------------|
| `ep`      | `xs:string` | Endpoint of the broker making the request, as seen by the trust anchor. |
| `lat`     | `xs:double` | Optional Latitude of the endpoint.                                      |
| `long`    | `xs:double` | Optional Longitude of the endpoint.                                     |

In the following example, the broker at `broker.example.com` requests its Manufacturer ID from `neuro-foundation.io`, which responds with
the manufacturer ID `0012ab`, i.e. first byte is `00`, second is `12` and third is `ab`, in hecadecimal notation:

```xml
<iq type='get' id='0001' from='broker.example.com' to='neuro-foundation.io' xmlns='urn:nf:iot:uuid:1.0'>
  <getManufacturerId/>
</iq>

<iq type='result' id='0001' from='neuro-foundation.io' to='broker.example.com'>
  <manufacturerId xmlns='urn:nf:iot:uuid:1.0' ep='1.2.3.4:56789' lat='12.345678' long='23.456789'>0012ab</manufacturerId>
</iq>
```

### Resolving Manufacturer ID

A broker can resolve a Manufacturer ID to a domain by sending a `<resolveManufacturerId/>` request with the Manufacturer ID as an attribute to
the authoritative trust anchor. Only brokers are allowed to send this request. All other senders will receive a `<forbidden/>` error as a response.
This is not the primary way to resolve a Manufacturer ID, as the registry is public and downloadable, and should be distributed among the brokers
on other ways. Using the registry is preferred, as it avoids creating a bottle-neck and single point of failure. The `<resolveManufacturerId/>`
exists as a reference, and can be used, for instance, in cases where the Manufacturer ID is not available in the registry as the broker knows it.
The Manufacturer ID might, for example, be new. The request takes one attribute:

| Attribute        | Type             | Description                     |
|:-----------------|:-----------------|:--------------------------------|
| `manufacturerId` | `ManufacturerID` | The Manufacturer ID to look up. |

The trust anchor broker returns the domain, if found, using the `<domain/>` element. The response has no additional attributes. If no domain
is found, an error with a `<item-not-found/>` element is returned. 

In the following example, the broker at `broker2.example.com` resolves the Manufacturer ID `0012ab` to the domain `broker.example.com`:

```xml
<iq type='get' id='0002' from='broker2.example.com' to='neuro-foundation.io' xmlns='urn:nf:iot:uuid:1.0'>
  <resolveManufacturerId manufacturerId='0012ab'/>
</iq>

<iq type='result' id='0002' from='neuro-foundation.io' to='broker2.example.com'>
  <domain xmlns='urn:nf:iot:uuid:1.0'>broker.example.com</domain>
</iq>
```

In the following example, the broker at `broker2.example.com` resolves tries to resolve the non-existent Manufacturer ID `fe12ac`:

```xml
<iq type='get' id='0003' from='broker2.example.com' to='neuro-foundation.io' xmlns='urn:nf:iot:uuid:1.0'>
  <resolveManufacturerId manufacturerId='fe12ab'/>
</iq>

<iq type='error' id='0003' from='neuro-foundation.io' to='broker2.example.com'>
  <error type='cancel'>
    <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
  </error>
</iq>
```

### Downloading Manufacturer Registry

A broker can download the Manufacturer Registry from the authoritative trust anchor by first getting an URL for the registry. This URL is
retrieved by sending a `<getManufacturerRegistry/>` request in an `iq get` stanza to the trust anchor broker. Only brokers are allowed to
send this request. All other senders will receive a `<forbidden/>` error as a response. The request has no attributes. The trust anchor
responds with a URL to the registry, using the `<manufacturersUrl/>` element that will contain the URL inside.

Example:

```xml
<iq type='get' id='0004' from='broker.example.com' to='neuro-foundation.io' xmlns='urn:nf:iot:uuid:1.0'>
  <getManufacturerRegistry/>
</iq>

<iq type='result' id='0004' from='neuro-foundation.io' to='broker.example.com'>
  <manufacturersUrl xmlns='urn:nf:iot:uuid:1.0'>https://neuro-foundation.io/registry/manufacturer</registryUrl>
</iq>
```

Once the URL has been retrieved, it can be used to download the registry. The registry is a simple XML file, containing the Manufacturer IDs
registered, and the domains associated with them. The registry contains a root element named `<manufacturers/>`, containing zero or more
`<man/>` elements (short for manufacturer). Each `<man/>` element contains the following attributes:

| Attribute | Type                    | Description                                                                                 |
|:----------|:------------------------|:--------------------------------------------------------------------------------------------|
| `id`      | `ManufacturerID`        | A Manufacturer ID.                                                                          |
| `n`       | `xs:string`             | The associated domain name.                                                                 |
| `t`       | `xs:dateTime`           | The date and time of registration of the manufacturer ID and the corresponding domain name. |
| `v`       | `xs:nonNegativeInteger` | A version number used, representing the namespace used to create the Manufacturer ID.       |

The registry recognizes the following versions:

| Version | Namespace             |
|--------:|:----------------------|
|	    0 | `urn:nf:iot:uuid:1.0` |

Example:

```xml
<manufacturers xmlns='urn:nf:iot:uuid'>
    <man id='000000' n='example.com' t='2023-10-07T12:31:55Z' v='0'/>
    ...
    <man id='0012ab' n='broker.example.com' t='2025-02-20T18:14:12Z' v='0'/>
    ...
</manufacturers>
```

**Note**: The URL may be temporary, and contain sufficient entropy to avoid guessing. The URL may 
also be signed, to ensure the integrity of the URL. For this reason, the URL should not be used for 
any other purpose than downloading the registry, and it should only be used to download the registry
once. The URL should also not be published. The next time the registry is needed, a new URL should be
requested from the trust anchor.

**Note 2**: To avoid bottle-necks and single points of failure, the registry should be distributed by 
alternative means, such as via parent brokers to child brokers, as described in the chapter on 
[Software Updates](/SoftwareUpdates.md). A broker detecting a new Manufacturer ID (or an unknown 
Manufacturer ID) can choose to download the registry and make it available to its child brokers
by publishing it as a software package. This way, child brokers will not need to download the registry
from the trust anchor, but can download it directly from its immediate parent broker. A root broker, 
or the trust anchor itself, can also regularly download or publish its registry to its children, for 
instance, once a month, to make sure the registry is disseminated to all brokers in the network, 
without placing undue load on single components.

Manufacturer ID via Thing Registry
-------------------------------------

The authorotative broker responsible for a Manufacturer ID knows the UUIDs itself has created. But the manufacturer operating the broker can
generate UUIDs out-of-band, for instance, in a production environment where devices are given UUIDs but not yet have JIDs, as they are not
installed yet. In this case, the broker cannot create a UUID for the device, as a request cannot be made on the federated network, from the 
device or its corresponding binding/concentrator. In such cases, the broker learns of the UUID when the device comes online and registers itself
with the Thing Registry on the broker. This registration can be temporary and private, in the case of ownership pairing, or a public registration
later during its life-cycle. The broker receiving the Thing Registry registration, detects the UUID and the manufacturer ID in it, and if it
matches the broker's own Manufacturer ID, it can register the UUID as belonging to the connected entity (`JID`) that registered the device.

Broker resolution of a UUID
------------------------------

The process of resolving a UUID to a `JID` in the federated network, or a *quadruple* (`JID`, `NodeId`, `SourceId`, `Partition`) in the general
case, can now be performed by a broker, by following these steps:

1.  First, the Manufacturer ID is extracted from the UUID.

2.  The domain associated with the Manufacturer ID is retrieved.

    * If the Manufacturer ID is known, from the most recently downloaded Registry, or from previous call using `<resolveManufacturerId/>`, 
use that domain.
    
    * If Manufacturer ID is not known, either trigger a new download of the registry, or use `<resolveManufacturerId/>` to resolve the
domain.

3.  The broker then sends a `<resolveUuid/>` request to the broker on the domain belonging to the Manufacturer ID.

    * The response may indicate only a `JID` in the federated network, or a *quadruple* (`JID`, `NodeId`, `SourceId`, `Partition`) in the general
case. If a *quadruple* is returned, the resolution is complete.

4.  If only a `JID` is returned, the broker can then send a `<resolveUuid/>` request to the corresponding Full JID of the associated `JID`.

    * If the device is not connected (and a Full JID is not available), further resolution is not possible, and a partial result is returned.

    * If the device is connected, a Full JID is available. If the device is a standalone device connected to the network it will return the
same `JID` as the one returned in step 3 (the Bare JID).

    * If the device is a concentrator on the other hand, it will return a *quadruple* (`JID`, `NodeId`, `SourceId`, `Partition`) to the
corresponding node, if the UUID is found.

5.  If in any of the steps above, the Manufacturer ID or UUID is not found, an error is returned, indicating the item was not found
(`<item-not-found/>`).


Client resolution of a UUID
------------------------------

A connected client (either standalone client, or a concentrator, such as a bridge), can also resolve a UUID, by requesting the broker to resolve
it for the client

TBD

Removal Registry

Using UUIDs in communication over XMPP

UUID move domain

UUID with PSK

PSK as UUID

Moving account with PSK

Registry XSLT

XML Registry in repository

Reserve highest bit in Manufacturer ID to allow for more bytes in the future.