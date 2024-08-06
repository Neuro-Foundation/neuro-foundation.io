Title: Transport Encryption
Description: Transport Encryption page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Transport Encryption
========================

XMPP supports **ubiquitous encryption**. This means all connections and all transports are encrypted. The methods used to encrypt each transport depends
on the underlying binding method used:

* For traditional socket connections, HTTP-based connections or web-socket connections, TLS transport encryption is used. Brokers are authenticated using
certificates, and clients using appropriate SASL mechanisms.

* For experimental UDP connections, DTLS is used.

* In federated communications, server connections are encrypted using TLS. Domains are validated using certificates and dial-back, as defined in 
[XEP-0220](https://xmpp.org/extensions/xep-0220.html).

Note however, that transport encryption only protects against eavesdropping. Encrypted stanzas are decrypted at each node. To make sure the contents
of stanzas are not compromised at the nodes, use [End-to-End encryption](E2eEncryption.md).