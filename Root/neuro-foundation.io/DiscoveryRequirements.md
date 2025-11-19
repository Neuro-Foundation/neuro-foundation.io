The [Discovery namespace](Schemas/Discovery.xsd) [defines](Discovery.md) 
the following elements that can be sent in stanzas. The following table lists the elements, the 
type of stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client making the requests
is assumed to be an XMPP Clients (either owners, devices, or applications), and the Service 
Component an XMPP Component on a broker, not necessarily the same broker as the client is 
connected to (depends on element).

| Namespace elements                                               ||||
| Element              | Stanza Type | Client     | Service Component |
|:---------------------|:-----------:|:----------:|:-----------------:|
| `register`           | `iq set`    | ==>        | Required          |
| `mine`               | `iq set`    | ==>        | Required          |
| `update`             | `iq set`    | ==>        | Required          |
| `claimed`            | `iq set`    | Required   | <==               |
| `remove`             | `iq set`    | ==>        | Required          |
| `removed`            | `iq set`    | Required   | <==               |
| `unregister`         | `iq set`    | ==>        | Required          |
| `disown`             | `iq set`    | ==>        | Required          |
| `disowned`           | `iq set`    | Required   | <==               |
| `search`             | `iq get`    | ==>        | Required          |
| `found`              | `iq result` | Required   | <==               |
