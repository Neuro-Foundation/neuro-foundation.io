The [Software updates namespace](Schemas/SoftwareUpdates.xsd) [defines](SoftwareUpdates.md) 
the following elements that can be sent in stanzas. The following table lists the elements, the 
type of stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client making the requests
is assumed to be an XMPP Client, and the Service Component an XMPP Component on the broker the
client is connected to. The broker itself can also be an XMPP client to a parent broker from 
which it receives software updates.

| Namespace elements                                              ||||
| Element              | Stanza Type | Client     | Service Component |
|:---------------------|:------------|:-----------|:------------------|
| `getPackageInfo`     | `iq get`    |>> ==>    <<| Required          |
| `packageInfo`        | `iq result` | Required   |>> <==           <<|
| `getPackages`        | `iq get`    |>> ==>    <<| Required          |
| `packages`           | `iq result` | Required   |>> <==           <<|
| `subscribe`          | `iq set`    |>> ==>    <<| Required          |
| `unsubscribe`        | `iq set`    |>> ==>    <<| Required          |
| `packageInfo`        | `message`   | Required   |>> <==           <<|
| `packageDeleted`     | `message`   | Required   |>> <==           <<|
| `getSubscriptions`   | `iq get`    |>> ==>    <<| Required          |
| `subscriptions`      | `iq result` | Required   |>> <==           <<|