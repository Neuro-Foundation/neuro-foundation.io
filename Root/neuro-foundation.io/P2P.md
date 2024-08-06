Peer-to-Peer communication
===============================

This document outlines the XML representation of peer-to-peer communication. The XML representation is modelled using an annotated XML Schema:

| Peer-to-Peer communication              ||
| ------------|----------------------------|
| Namespace:  | urn:nf:iot:p2p:1.0         |
| Schema:     | [P2P.xsd](Schemas/P2P.xsd) |


Motivation and design goal
----------------------------

The method of peer-to-peer communication (P2P) described here, is designed with the following goals in mind:

* Connections are based on XMPP over TCP/IP, as described in [XEP-0174: Serverless Messaging](https://xmpp.org/extensions/xep-0174.html).

* Solution allows [End-to-End encryption](E2E.md), which can be used to authenticate the other party in P2P communication.

* Information about how to connect to a device is published by the device itself, using the `<presence/>` stanza. This permits any device with 
presence subscription to learn how to connect to the device.

* P2P communication is optional, and can be used where privacy or band-width concerns are such that P2P connections are warranted.


Registering with Internet Gateway
--------------------------------------

Peer-to-Peer communication between devices residing behind different firewalls, require the devices to register themselves with the firewalls
(or Internet Gateways), and allow the gateways to pass on incoming connections to a certain port on a gateway to a certain port on the corresponding 
device. The process for how this is done is beyond the scope of this specification. There are different protocols available for how to accomplish this.
One such protocol is Universal Plug-and-Play (UPnP).

Once a device is registered, it has an **External IP Address**, together with an **External Port Number**, as well as a **Local IP Address**, and
a **Local Port Number**. Connections made to the External IP Address and Port are seamlessly passed on to the internal network to the corresponding 
Local IP Address and Port.


Publishing P2P Information
-------------------------------

Once the device goes online on the XMPP network, or when the P2P parameters change, it publishes them by including a `<p2p/>` element in its presence.
Any contact that has subscribed to the device's presence will receive this information and will be able to connect to the device directly.

To connect to a device directly, the first device first analyzes the External IP Address of the second device. If it is the same as the External IP Address
of the first device, they reside on the same local network. Connections can be made using the Local IP Address and port directly. Otherwise, a connection
is made using the External IP Address and Port.


Authenticating communication
--------------------------------

Since devices alone do not have access to the account databases of their brokers, they cannot authenticate the other using traditional means. Instead,
they can employ a two-stage authentication mechanism as follows.

The device receiving a P2P connection receives in the `<stream/>` header the claimed full JID of the sender. The receiver checks this full JID with its
internal roster and received `<presence/>` stanzas. If the device is not there, does not have a presence subscription to the device, or has not published
P2P information itself, the connection is immediately rejected. If P2P information is available from the claimed full JID, the information is used to check
the validity of the connection: If the devices share the same External IP Address, the remote IP address should be equal to the Local IP Address made available in the P2P Information. If not, the connection is rejected. If the devices do not share the same External IP Address, the remote IP address 
should be equal to the External IP Address made available in the P2P Information. If not, the connection is rejected.

The second stage is to make sure all stanzas transmitted over peer-to-peer connections are [End-to-End encrypted](E2E.md) as well. This makes sure that the 
entity claiming to be a given full JID corresponds to the public key information published by the same full JID on the traditional XMPP network,
and an impostor on the same network or same machine. Since all E2E-encrypted stanzas are signed with the private key of the sender, and encrypted using the
public key of the receiver, only the receiver can decrypt the message with its private key. The receiver can also validate the signature, using the public
key of the sender. This effectively authenticates both to each other. The sender can make sure the receiver only receives the message, if it is the intended
receiver. And the receiver can make sure the sender is who it claims to be.

Example
------------

Following is an example of a device publishing its Peer-to-Peer and End-to-End encryption information at the same time:

```
<presence>
    <show>chat</show>
    <e2e xmlns="urn:nf:iot:e2e:1.0">
        <x25519 pub="giAy8BZRKUjsyQgha387ftNCfodSB..." />
        <x448 pub="k48EIdyM35m4y/+fKfjfhsofi6Q/dtV..." />
        <ed25519 pub="QsPrTABTXqQudCO3TVZTzEbVPc5k..." />
        <ed448 pub="v4dQTfx8iSoA05yhoScZjyHwvmDKFb..." />
        <p192 pub="FLHB42q85QMcShfE2gprKA38nLz6CRc..." />
        <p224 pub="lo0KVbyJ/8ObVtcECwc+nrvSOgjk5NM..." />
        <p256 pub="1AaD2CmGjXuCl20nGVxDELkCOfjV7T8..." />
        <p384 pub="L+sPifULzzU4OnSE3OIgs+fw7PMN/Bz..." />
        <p521 pub="7P0RVNIGeMVvZZ2+Lrc4WbW5fCSrUDx..." />
        <rsa pub="AAzJMMn/cK5hqiaWvc3i3aS3e2NosJdm..." />
    </e2e>
    <p2p xmlns="urn:nf:iot:p2p:1.0" extIp="81.229..." extPort="64152" locIp="192.168.1.219" locPort="64152" />
    <c xmlns="http://jabber.org/protocol/caps" hash="sha-256" node="..." ver="..." />
</presence>
```
