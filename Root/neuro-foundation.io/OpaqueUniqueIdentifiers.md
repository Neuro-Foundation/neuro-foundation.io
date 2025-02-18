Title: Opaque Unique Identifiers
Description: Opaque Unique Identifiers page of neuro-foundation.io
Date: 2025-02-18
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Opaque Unique Identifiers
============================

While each connected entity has a unique global identity on the XMPP network called the JID, and each entity connected to the XMPP network via
a [*concentrator*](Concentrator.md) has a unique global identity in the *quadruple* (`JID`, `NodeId`, `SourceId`, `Partition`), there is
sometimes also a need for an opaque unique identifier, that is not directly related to any communication protocol. Typically, applications use
`GUID`s or `UUID`s for this purpose. But these cannot be used to find a device in a federated network in the general case. For this purpose, 
the Neuro-Foundation infrastructure provides a way to generate *opaque unique identifiers*, similar to `GUID`s or `UUID`s, that can be used as 
identifiers in other systems, but that can also be resolved to a `JID` in the connected case, or a *quadruple* (`JID`, `NodeId`, `SourceId`, 
`Partition`) in the general case.

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
main domain is tied together to a unique Manufacturer ID issued to it. A registry of registered domains and their Manufacturer IDs can be kept
to ensure that at most one domain corresponds to a Manufacturer ID. Reversely, given a Manufacturer ID, the domain can be resolved, as access
to the registry is public. Furthermore, the broker on that domain, is an authority and Trust Provider on that domain. The broker is furthermore
tasked to recognize the UUIDs it has created, and to what connected entity (`JID`) it belongs. Each connected entity (`JID`) can request UUIDs,
and in doing so, gets a unique identity (since domains are separated by the registry), and each broker can register which UUIDs have been
generated for which connected entities (`JID`). In the case of concentrators, a request can then be made to the resolved `JID`, to get the
additional (`NodeId`, `SourceId` and `Partition`) associated with the UUID.


Manufacturer ID Registry
---------------------------




Resolving a UUID
-------------------

UUID -> Domain -> JID -> Quadruple

