The [Event Subscription namespace](Schemas/EventSubscription.xsd) 
[defines](SensorDataEventSubscription.md) the following elements that can be sent in stanzas. 
The following table lists the elements, the type of stanza used, the entities that can or need 
to handle incoming stanzas containing the corresponding element, as well as implementation 
requirements, if the namespace is present in the device's 
[XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* response. 
Elements associated with any response stanzas are assumed to be implemented by the entity 
making the corresponding request. Both the Sensor Client and Sensor Server entities are XMPP 
clients. The Sensor Data Event Subscription namespace is primarily intended for connected 
clients. The broker is only involved in routing stanzas between sensor clients and sensor 
servers.

| Namespace elements                                       ||||
| Element       | Stanza Type | Sensor Client | Sensor Server |
|:--------------|:------------|:--------------|:--------------|
| `subscribe`   | `iq set`    |>> ==>       <<| Required      |
| `unsubscribe` | `iq set`    |>> ==>       <<| Required      |
