The [End-to-End encryption namespace](Schemas/E2E.xsd) [defines](E2E.md) the following 
elements that can be sent in stanzas. The following table lists the elements, the type of 
stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the device's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* response. 
Elements associated with any response stanzas are assumed to be implemented by the entity 
making the corresponding request. All Peers are XMPP clients. The End-to-End encryption
namespace is primarily intended for connected clients. The broker is only involved in routing 
stanzas between peers.

| Namespace elements                                    ||||
| Element    | Stanza Type | Peer          | Peer          |
|:-----------|:-----------:|:-------------:|:-------------:|
| `e2e`      | `presence`  | ==>           | Optional      |
| `aes`      | Any         | ==>           | Required      |
| `cha`      | Any         | ==>           | Required      |
| `acp`      | Any         | ==>           | Required      |
| `synchE2e` | `iq set`    | ==>           | Required      |
