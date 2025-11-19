The [Decision Support namespace](Schemas/ProvisioningDevice.xsd) [defines](DecisionSupport.md) 
the following elements that can be sent in stanzas. The following table lists the elements, the 
type of stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client making the requests
is assumed to be an XMPP Client, and the Service Component an XMPP Component on the broker the
client is connected to.

| Namespace elements                                              ||||
| Element              | Stanza Type | Client     | Service Component |
|:---------------------|:------------|:-----------|:------------------|
| `isFriend`           | `iq get`    |>> ==>    <<| Required          |
| `isFriendResponse`   | `iq result` | Required   |>> <==           <<|
| `canRead`            | `iq get`    |>> ==>    <<| Required          |
| `canReadResponse`    | `iq result` | Required   |>> <==           <<|
| `canControl`         | `iq get`    |>> ==>    <<| Required          |
| `canControlResponse` | `iq result` | Required   |>> <==           <<|
| `clearCache`         | `iq set`    | Required   |>> <==           <<|
| `unfriend`           | `message`   | Optional   |>> <==           <<|
| `friend`             | `message`   | Optional   |>> <==           <<|
