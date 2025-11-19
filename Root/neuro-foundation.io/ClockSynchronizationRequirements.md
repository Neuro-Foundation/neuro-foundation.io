The [Clock-Synchronization namespace](Schemas/Synchronization.xsd) 
[defines](ClockSynchronization.md) the following elements that can be sent in stanzas. The 
following table lists the elements, the type of stanza used, the entities that can or need to 
handle incoming stanzas containing the corresponding element, as well as implementation 
requirements, if the namespace is present in the device's 
[XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* response. 
Elements associated with any response stanzas are assumed to be implemented by the entity 
making the corresponding request. Entities can be XMPP clients, components or brokers.

| Namespace elements                                      ||||
| Element      | Stanza Type | Entity        | Entity        |
|:-------------|:------------|:--------------|:--------------|
| `req`        | `iq get`    |>> ==>       <<| Required      |
| `resp`       | `iq result` | Required      |>> <==       <<|
| `sourceReq`  | `iq get`    |>> ==>       <<| Required      |
| `sourceResp` | `iq result` | Required      |>> <==       <<|
