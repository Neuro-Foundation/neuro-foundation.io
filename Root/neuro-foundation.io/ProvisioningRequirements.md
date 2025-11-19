The [Provisioning namespace](Schemas/ProvisioningOwner.xsd) [defines](Provisioning.md) 
the following elements that can be sent in stanzas. The following table lists the elements, the 
type of stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client making the requests
is assumed to be an XMPP Client, and the Service Component an XMPP Component on the broker the
client is connected to.

| Namespace elements                                               ||||
| Element              | Stanza Type | Client     | Service Component |
|:---------------------|:------------|:-----------|:------------------|
| `isFriend`           | `message`   | Required   |>> <==           <<|
| `isFriendRule`       | `message`   |>> ==>    <<| Required          |
| `canRead`            | `message`   | Required   |>> <==           <<|
| `canReadResponse`    | `message`   |>> ==>    <<| Required          |
| `canControl`         | `message`   | Required   |>> <==           <<|
| `canControlResponse` | `message`   |>> ==>    <<| Required          |
| `clearCache`         | `message`   |>> ==>    <<| Required          |
| `getDevices`         | `iq get`    |>> ==>    <<| Required          |
| `deleteRules`        | `iq set`    |>> ==>    <<| Required          |
