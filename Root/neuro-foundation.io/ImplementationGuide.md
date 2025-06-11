Title: Implementation Guide
Description: Guide of how to plan and implement the interfaces
Date: 2025-06-11
Author: Peter Waher
Master: Master.md

=============================================

Implementation Guide
===========================

The following sections outlines steps that should be considered when planning a full or partial implementation of the interfaces published here.

![Table of Contents](toc)

Clients
----------

Many of the interfaces are client-side interfaces. They don't require special implementation on the XMPP broker side. Any XMPP broker can be
used as no special edge service is required from the broker. Before implementing the client-side interfaces you need to decide how to connect
to the XMPP network.

### XMPP Connections: Bindings

Directly connected entities need to connect and bind to the XMPP network. There are multiple ways, with their own pros and cons. XMPP supports
an extensible architecture for bindings, which allows for different protocols to be used for the same purpose. It also permits the implementor to
do custom binding mechanisms. 

1. **TCP/IP Socket Connection** is the most common binding, and is the one used by most XMPP clients. It is simple to implement and widely 
supported. This binding is the default binding for XMPP as described in [6120](https://datatracker.ietf.org/doc/html/rfc6120),
[6121](https://datatracker.ietf.org/doc/html/rfc6121) and [6122](https://datatracker.ietf.org/doc/html/rfc6122) and updates.

2. **WebSocket Connection** is also common, and permits connection to the XMPP network from web browsers and other applications that support 
WebSockets. XMPP over Websockets is available in most brokers and is standardized by the IETF in [RFC 7395](https://datatracker.ietf.org/doc/rfc7395/).

3. **BOSH (Bidirectional streams over HTTP)** is also available. It permits binding to the bidirection XMPP network by using a pair of HTTP
connections. It is more costly to maintain, for the broker, but permits connections from web browsers and other applications that support HTTP,
in cases firewalls and environment settings restrict communication to HTTP requests. BOSH is available in most standard XMPP brokers via
[XEP-0124](https://xmpp.org/extensions/xep-0124.html).

4. **QUIC** is a newer protocol that can be used for binding to the XMPP network. It is designed to be more efficient than TCP/IP and can reduce 
latency. It is available in some brokers via an experimental extension [XEP-0467](https://xmpp.org/extensions/xep-0467.html).

Other brokers may contain other custom binding methods, such as via UDP/DTLS. Check broker documentation for details.

### Via REST API: Ex. Neuron Agent API

Some brokers may provide a REST API for connecting to the XMPP network. This is not a standard XMPP binding, but it can be useful for web
applications, as it is easier to implement for simple interactions. Bidirectional communication is trickier to implement using a REST interface
however. As an example, check the [Agent API](/Documentation/Neuron/Agent.md) available on the TAG Neuron(R).

### Client-side Interfaces

* Sensor Data
* Sensor Operations
* Control Parameters
* Control Operations
* Thing Registry & Discovery
* Provisioning & Decision Support
* Digital Identities
* Smart Contract Signatures
* Clock synchronization
* Publish/Subscribe
* Event Subscription
* Peer-to-Peer communication
* End-to-End encryption
* Remote software updates
* Geo-spatial publish/subscribe

### Existing libraries

### Extending basic XMPP libraries

cf. xmpp.org


Gateways/Bridges
--------------------

A gateway & bridge, is a special type of XMPP client, with an additional set of interfaces:

* Concentrator


Brokers
------------

Broker-side edge services for:

* Thing Registry & Discovery
* Provisioning & Decision Support
* Digital Identities
* Smart Contract Signatures
* Clock synchronization
* Remote software updates
* Geo-spatial publish/subscribe

Standard in XMPP brokers:

* Publish/Subscribe

(All other interfaces are purely client-side libraries)

### Existing brokers with full support

Neuron

### Extending basic XMPP brokers

cf. xmpp.org


Simulating Networks
----------------------

ComSim

### Functional and Stress Testing

### Load Generation

### Performance measurement