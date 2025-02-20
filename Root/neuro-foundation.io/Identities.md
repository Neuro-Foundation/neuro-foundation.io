Title: Identities
Description: Identities page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Identities
========================

To interoperate on the network, an entity, be it a thing, service or application, identifies itself using one or more identities. The following types of
identities are available:

* **Network identity**. The underlying XMPP protocol, used in IoT Harmonization, provides all connected entities with a global network identity. Each 
broker controls its own domain and set of accounts. The combination of account and domain, written in the form `account@domain`, is called a 
**bare JID**. (JID = Jabber ID, Jabber being the name of the original project where [XMPP](https://xmpp.org/) was developed.) In IoT Harmonization 
it is often also referred to as the **network identity** of the entity, as it is assumed only the device controls the account of the device. Once 
connected, a random resource is assigned to the connection. The **full JID**, written `account@domain/resource` is the network address of the entity.
There may be multiple connections open using the same account at the same time. There may therefore be multiple full JIDs available, for one bare JID.

	The XMPP address format is defined in [RFC 7622](https://tools.ietf.org/html/rfc7622). The XMPP protocol is defined in
	[RFC 6120](https://tools.ietf.org/html/rfc6120) and [RFC 6121](https://tools.ietf.org/html/rfc6121).

* **Conceptual identity**. The conceptual identity, which can include information such as serial number, manufacturer, make, model, etc., 
is used to discover devices, and pair devices with their corresponding owners. More information about this is available in the 
[discovery section](Discovery.md). Discovery is the process of matching the conceptual identity with the corresponding network identity. 
Discovery also allows each device to know who its corresponding owner is.

* **User identity**. IoT Harmonization requests can be tagged with the identity of the user originating the request. This is done using X.509 certificates
	and [tokens](Tokens.md). This allows owners to make security decisions based on the identity of the calling user, instead of the network identities
	of the entities making the requests.

* **Service identity**. IoT Harmonization requests can also be tagged with the identity of the service originating the request. As with user identities,
	this is done using X.509 certificates and [tokens](Tokens.md), and allows owners to make security decisions based on the identity of the calling service.

* **Device identity**. Requests can also be tagged with the identity of the device originating the request. This is also done using X.509 certificates
	and [tokens](Tokens.md). Security decisions can be based on the identity of the calling device, machine or host.
