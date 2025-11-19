The [Geo-spatial namespace](Schemas/Geo.xsd) [defines](Geo.md) the following elements that 
can be sent in stanzas. The following table lists the elements, the type of stanza used, the 
entities that can or need to handle incoming stanzas containing the corresponding element, as 
well as implementation requirements, if the namespace is present in the service component's 
[XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* response. Elements 
associated with any response stanzas are assumed to be implemented by the entity making the 
corresponding request. The Client making the requests is assumed to be an XMPP Client, and the 
Service Component an XMPP Component.

| Namespace elements                                              ||||
| Element              | Stanza Type | Client     | Service Component |
|:---------------------|:------------|:-----------|:------------------|
| `subscribe`          | `iq set`    |>> ==>    <<| Required          |
| `subscribed`         | `iq result` | Required   |<< <==           >>|
| `unsubscribe`        | `iq set`    |>> ==>    <<| Required          |
| `unsubscribed`       | `iq result` | Required   |<< <==           >>|
| `publish`            | `iq set`    |>> ==>    <<| Required          |
| `published`          | `iq result` | Required   |<< <==           >>|
| `delete`             | `iq set`    |>> ==>    <<| Required          |
| `deleted`            | `iq result` | Required   |<< <==           >>|
| `search`             | `iq get`    |>> ==>    <<| Required          |
| `references`         | `iq result` | Required   |<< <==           >>|
| `added`              | `message`   | Required   |<< <==           >>|
| `updated`            | `message`   | Required   |<< <==           >>|
| `removed`            | `message`   | Required   |<< <==           >>|