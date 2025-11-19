The [Concentrator namespace](Schema/Concentrator.xsd) [defines](Concentrator.md) the following 
elements that can be sent in stanzas. The following table lists the elements, the type of 
stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the device's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* 
response. Elements associated with any response stanzas are assumed to be implemented by
the entity making the corresponding request. Both the Concentrator Client and Concentrator
Server entities are XMPP clients. The Concentrator namespace is primarily intended for
connected clients. The broker is only involved in routing stanzas between concentrator 
clients and concentrator servers.

| Namespace elements                                                                            |||||
| Element                            | Stanza Type | Concentrator Client |     | Concentrator Server |
|:-----------------------------------|:------------|:--------------------|:---:|:--------------------|
| `getCapabilities`                  | `iq get`    |                     | ==> | Required            |
| `getAllDataSources`                | `iq get`    |                     | ==> | Optional^1          |
| `getRootDataSources`               | `iq get`    |                     | ==> | Optional^1          |
| `getChildDataSources`              | `iq get`    |                     | ==> | Optional^1          |
| `containsNode`                     | `iq get`    |                     | ==> | Optional^1          |
| `containsNodes`                    | `iq get`    |                     | ==> | Optional^1          |
| `getNode`                          | `iq get`    |                     | ==> | Optional^1          |
| `getNodes`                         | `iq get`    |                     | ==> | Optional^1          |
| `getAllNodes`                      | `iq get`    |                     | ==> | Optional^1          |
| `getNodeInheritance`               | `iq get`    |                     | ==> | Optional^1          |
| `getRootNodes`                     | `iq get`    |                     | ==> | Optional^1          |
| `getChildNodes`                    | `iq get`    |                     | ==> | Optional^1          |
| `getAncestors`                     | `iq get`    |                     | ==> | Optional^1          |
| `getNodeParametersForEdit`         | `iq get`    |                     | ==> | Optional^1          |
| `setNodeParametersAfterEdit`       | `iq set`    |                     | ==> | Optional^1          |
| `getCommonNodeParametersForEdit`   | `iq get`    |                     | ==> | Optional^1          |
| `setCommonNodeParametersAfterEdit` | `iq set`    |                     | ==> | Optional^1          |
| `getAddableNodeTypes`              | `iq get`    |                     | ==> | Optional^1          |
| `getParametersForNewNode`          | `iq get`    |                     | ==> | Optional^1          |
| `createNewNode`                    | `iq set`    |                     | ==> | Optional^1          |
| `destroyNode`                      | `iq set`    |                     | ==> | Optional^1          |
| `moveNodeUp`                       | `iq set`    |                     | ==> | Optional^1          |
| `moveNodeDown`                     | `iq set`    |                     | ==> | Optional^1          |
| `moveNodesUp`                      | `iq set`    |                     | ==> | Optional^1          |
| `moveNodesDown`                    | `iq set`    |                     | ==> | Optional^1          |
| `subscribe`                        | `iq set`    |                     | ==> | Optional^1          |
| `unsubscribe`                      | `iq set`    |                     | ==> | Optional^1          |
| `nodeAdded`                        | `message`   | Optional            | <== |                     |
| `nodeUpdated`                      | `message`   | Optional            | <== |                     |
| `nodeStatusChanged`                | `message`   | Optional            | <== |                     |
| `nodeRemoved`                      | `message`   | Optional            | <== |                     |
| `nodeMovedUp`                      | `message`   | Optional            | <== |                     |
| `nodeMovedDown`                    | `message`   | Optional            | <== |                     |
| `getNodeCommands`                  | `iq get`    |                     | ==> | Optional^1          |
| `getCommandParameters`             | `iq get`    |                     | ==> | Optional^1          |
| `executeNodeCommand`               | `iq set`    |                     | ==> | Optional^2          |
| `executeNodeQuery`                 | `iq set`    |                     | ==> | Optional^3          |
| `getCommonNodeCommands`            | `iq get`    |                     | ==> | Optional^1          |
| `getCommonCommandParameters`       | `iq get`    |                     | ==> | Optional^1          |
| `executeCommonNodeCommand`         | `iq set`    |                     | ==> | Optional^4          |
| `executeCommonNodeQuery`           | `iq set`    |                     | ==> | Optional^5          |
| `abortNodeQuery`                   | `iq set`    |                     | ==> | Optional^3          |
| `abortCommonNodeQuery`             | `iq set`    |                     | ==> | Optional^5          |
| `queryProgress`                    | `message`   | Optional^6          | <== |                     |
| `queryStarted`                     | `message`   | Optional^6          | <== |                     |
| `queryDone`                        | `message`   | Optional^6          | <== |                     |
| `queryAborted`                     | `message`   | Optional^6          | <== |                     |
| `newTable`                         | `message`   | Optional^6          | <== |                     |
| `newRecords`                       | `message`   | Optional^6          | <== |                     |
| `tableDone`                        | `message`   | Optional^6          | <== |                     |
| `newObject`                        | `message`   | Optional^6          | <== |                     |
| `queryMessage`                     | `message`   | Optional^6          | <== |                     |
| `title`                            | `message`   | Optional^6          | <== |                     |
| `status`                           | `message`   | Optional^6          | <== |                     |
| `beginSection`                     | `message`   | Optional^6          | <== |                     |
| `endSection`                       | `message`   | Optional^6          | <== |                     |
| `registerSniffer`                  | `iq set`    |                     | ==> | Optional^1          |
| `unregisterSniffer`                | `iq set`    |                     | ==> | Optional^1          |
| `sniff`                            | `message`   | Optional^7          | <== |                     |

1. Optional to implement, depending on concentrator capabilities, which the concentrator server
defines in the response to the `getCapabilities` request.`

2. Needs to be implenented if the `getNodeCommands` operation returns commands that can be
executed and which are not queries.

3. Needs to be implenented if the `getNodeCommands` operation returns queries that can be
executed.

4. Needs to be implenented if the `getCommonNodeCommands` operation returns commands that can 
be executed and which are not queries.

5. Needs to be implenented if the `getCommonNodeCommands` operation returns queries that can 
be executed.

6. Requires implementation if client executes node queries on the concentrator server.

7. Requires implementation if client registers sniffers on the concentrator server.