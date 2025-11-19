The [Smart Contracts namespace](Schemas/SmartContracts.xsd) [defines](SmartContracts.md) 
the following elements that can be sent in stanzas. The following table lists the elements, the 
type of stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the service component's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) 
*Service Discovery* response. Elements associated with any response stanzas are assumed to be 
implemented by the entity making the corresponding request. The Client making the requests
is assumed to be an XMPP Client, and the Service Component an XMPP Component on the broker the
client is connected to.

| Namespace elements                                                                             |||||
| Element                        | Stanza Type | Client     | Service Component | External Component |
|:-------------------------------|:-----------:|:----------:|:-----------------:|:------------------:|
| `createContract`               | `iq set`    | ==>        | Required          |                    |
| `contract`                     | `iq result` | Required   | <==               |                    |
| `signContract`                 | `iq set`    | ==>        | Required          |                    |
| `contractSigned`               | `message`   | Required   | <==               |                    |
| `getCreatedContracts`          | `iq get`    | ==>        | Required          |                    |
| `getSignedContracts`           | `iq get`    | ==>        | Required          |                    |
| `getContract`                  | `iq get`    | ==>        | Required          |                    |
| `getContracts`                 | `iq get`    | ==>        | Required          |                    |
| `contractReferences`           | `iq result` | Required   | <==               |                    |
| `contracts`                    | `iq result` | Required   | <==               |                    |
| `isPart`                       | `iq get`    | ==>        | Required          |                    |
| `part`                         | `iq result` | Required   | <==               |                    |
| `obsoleteContract`             | `iq set`    | ==>        | Required          |                    |
| `deleteContract`               | `iq set`    | ==>        | Required          |                    |
| `contractCreated`              | `message`   | Required   | <==               |                    |
| `contractUpdated`              | `message`   | Required   | <==               |                    |
| `contractDeleted`              | `message`   | Required   | <==               |                    |
| `updateContract`               | `iq set`    | ==>        | Required          |                    |
| `getSchemas`                   | `iq get`    | ==>        | Required          |                    |
| `schemas`                      | `iq result` | Required   | <==               |                    |
| `getSchema`                    | `iq get`    | ==>        | Required          |                    |
| `schema`                       | `iq result` | Required   | <==               |                    |
| `getLegalIdentities`           | `iq get`    | ==>        | Required          |                    |
| `getNetworkIdentities`         | `iq get`    | ==>        | Required          |                    |
| `networkIdentities`            | `iq result` | Required   | <==               |                    |
| `searchPublicContracts`        | `iq get`    | ==>        | Required          |                    |
| `searchResult`                 | `iq result` | Required   | <==               |                    |
| `petitionContract`             | `iq set`    | ==>        | Required          |                    |
| `petitionContractMsg`          | `message`   | Required   | <==               |                    |
| `petitionContractResponse`     | `iq set`    | ==>        | Required          |                    |
| `petitionContractResponseMsg`  | `message`   | Required   | <==               |                    |
| `addAttachment`                | `iq set`    | ==>        | Required          |                    |
| `removeAttachment`             | `iq set`    | ==>        | Required          |                    |
| `contractProposal`             | `message`   | Required   | <==               |                    |
| `failContract`                 | `message`   | Required   |                   | <==                |
