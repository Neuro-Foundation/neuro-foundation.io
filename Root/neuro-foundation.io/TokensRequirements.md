The [Tokens namespace](Schemas/ProvisioningTokens.xsd) [defines](Tokens.md) the following 
elements that can be sent in stanzas. The following table lists the elements, the type of 
stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client requesting to create
a token is assumed to be an XMPP Client, and the Service Component an XMPP Component on the 
broker the client is connected to. Third party entities can be any connected XMPP entity, a
client, component or broker.

| Namespace elements                                                              |||||
| Element                     | Stanza Type | Client   | Service Component | Entity   |
|:----------------------------|:------------|:---------|:------------------|:---------|
| `getToken`                  | `iq get`    |>> ==>  <<| Required          |          |
| `getTokenChallenge`         | `iq result` | Required |>> <==           <<|          |
| `getTokenChallengeResponse` | `iq get`    |>> ==>  <<| Required          |          |
| `getTokenResponse`          | `iq result` | Required |>> <==           <<|          |
| `getCertificate`            | `iq get`    |          | Required          |>> <==  <<|
| `certificate`               | `iq result` |          |>> ==>           <<| Required |
| `tokenChallenge`            | `iq get`    | Required |                   |>> <==  <<|
| `tokenChallengeResponse`    | `iq result` |>> ==>  <<|                   | Required |