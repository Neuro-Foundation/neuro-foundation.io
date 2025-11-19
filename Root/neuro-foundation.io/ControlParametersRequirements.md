The [Control namespace](Schemas/Control.xsd) [defines](ControlParameters.md) the following 
elements that can be sent in stanzas. The following table lists the elements, the type of 
stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the device's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* 
response. Elements associated with any response stanzas are assumed to be implemented by the 
entity making the corresponding request. Both the Control Client and Control Server entities 
are XMPP clients. The Control namespace is primarily intended for connected clients. The 
broker is only involved in routing stanzas between control clients and control servers.

| Namespace elements                                     ||||
| Element   | Stanza Type | Control Client | Control Server |
|:----------|:-----------:|:--------------:|:--------------:|
| `set`     | `iq set`    | ==>            | Required       |
| `getForm` | `iq get`    | ==>            | Required       |
