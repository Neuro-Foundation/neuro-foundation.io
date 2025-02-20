Title: Authorization
Description: Authorization page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Basic Authorization
========================

XMPP ([RFC 6120](https://tools.ietf.org/html/rfc6120), [RFC 6121](https://tools.ietf.org/html/rfc6121)) provides three base message types, called **stanzas**:

* Asynchronous messages are send using the `<message/>` stanza. These can be sent either to a full JID, in which it is delivered only to the corresponding
entity, or to a bare JID. In the latter case, the brokers may distribute the message to all entities connected using the same bare JID.

* Request/response is performed using the information query, or `<iq/>` stanza. To send an `<iq/>` stanza to a connected entity, you need its full JID.
It is not sufficient with knowing the bare JID of the entity. In order to perform an information query on a connected entity, its corresponding
resource part, or full JID, is required.

* Presence publish/subscribe is performed using the `<presence/>` stanza. It is sent to all contacts for which presence subscription has been approved.
An entity can send a presence subscription request to the bare JID of an entity. But only if the entity accepts the subscription, will the caller be
added to the list of contacts that will receive presence updates. An entity can at any time revoke the presence subscription approval.

Since all transmitted stanzas are annotated with the full JID of the sender, successfully subscribing to the presence of another entity provides the
first with the full JID of the other, when a presence is received. By basing important operations on the `<iq/>` stanza, then effectively makes sure only
approved contacts are able to send such commands.

**Note**: Clients still need to check incoming messages to make sure they are sent from trusted sources. They should also still check incoming
information requests, to make sure they also come from trusted sources, even if the infrastructure will provide a basic authorization mechanism to
begin with.

IoT Harmonization provides more detailed authorization for devices requesting [decision support](DecisionSupport.md).