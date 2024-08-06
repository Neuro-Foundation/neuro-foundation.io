Title: Binding
Description: Binding page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Binding
========================

To connect to the underlying XMPP network, an entity needs to select one of the available binding methods. There are various to choose from:

* [RFC 6120](https://tools.ietf.org/html/rfc6120) defines a binary full-duplex **socket** connection binding.

* [XEP-0124](https://xmpp.org/extensions/xep-0124.html) and [XEP-0206](https://xmpp.org/extensions/xep-0206.html) define a way to bind to the XMPP
network using HTTP.

* [RFC 7395](https://tools.ietf.org/html/rfc7395) defines a way to bind to the XMPP network using web-sockets.

There are also experimental ways to bind to the XMPP network:

* [XEP-0322](https://xmpp.org/extensions/xep-0322.html) provides a way to bind to the XMPP network using efficiently compressed XML using EXI.

* Using the [IoT Broker](https://waher.se/Broker.md), you can bind to the network using UDP and DTLS.