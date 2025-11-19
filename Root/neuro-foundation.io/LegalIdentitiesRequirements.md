The [Legal Identities namespace](Schemas/LegalIdentities.xsd) [defines](LegalIdentities.md) 
the following elements that can be sent in stanzas. The following table lists the elements, the 
type of stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client making the requests
is assumed to be an XMPP Client, and the Service Component an XMPP Component on the broker the
client is connected to.

| Namespace elements                                                         ||||
| Element                        | Stanza Type | Client     | Service Component |
|:-------------------------------|:-----------:|:----------:|:-----------------:|
| `getPublicKey`                 | `iq get`    | ==>        | Required          |
| `publicKey`                    | `iq result` | Required   | <==               |
| `apply`                        | `iq set`    | ==>        | Required          |
| `identity`                     | `iq result` | Required   | <==               |
| `getLegalIdentities`           | `iq get`    | ==>        | Required          |
| `identities`                   | `iq result` | Required   | <==               |
| `getLegalIdentity`             | `iq get`    | ==>        | Required          |
| `validateSignature`            | `iq get`    | ==>        | Required          |
| `obsoleteLegalIdentity`        | `iq set`    | ==>        | Required          |
| `compromisedLegalIdentity`     | `iq set`    | ==>        | Required          |
| `petitionIdentity`             | `iq set`    | ==>        | Required          |
| `petitionIdentityMsg`          | `message`   | Required   | <==               |
| `petitionIdentityResponse`     | `iq set`    | ==>        | Required          |
| `petitionIdentityResponseMsg`  | `message`   | Required   | <==               |
| `petitionSignature`            | `iq set`    | ==>        | Required          |
| `petitionSignatureMsg`         | `message`   | Required   | <==               |
| `petitionSignatureResponse`    | `iq set`    | ==>        | Required          |
| `petitionSignatureResponseMsg` | `message`   | Required   | <==               |
| `addAttachment`                | `iq set`    | ==>        | Required          |
| `removeAttachment`             | `iq set`    | ==>        | Required          |
| `clientMessage`                | `message`   | Optional   | <==               |
| `identityReview`               | `message`   | Required   | <==               |
| `getTrustChain`                | `iq get`    | ==>        | Required          |
| `trustChain`                   | `iq result` | Required   | <==               |