Title: Federation
Description: Federation page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Federation
========================

Federation is the process in which brokers cooperate on the Internet to pass stanzas between different domains. When an entity sends a stanza to an
entity on another domain, the first broker connects to the second (unless a connection already exists) and establishes a connection between the two.
The second broker connects to the first just to make sure the first is the broker it claims to be. In both connections, the certificate of the other is
used to validate the domain name of the corresponding broker. If both brokers have been successfully validated, the first broker sends the stanza to the
second, who in turn forwards it to the corresponding client. This process of federation allows XMPP networks go grow globally in a natural way, without
limiting participants with whom they are able to communicate.

```uml:Federation
@startuml
Activate Sender

Sender -> Broker1 : stanza(to@domain2,type,content)

Activate Broker1
Deactivate Sender

Broker1 -> Broker1 : lookup(domain)

Broker1 -> Broker2 : connect

Activate Broker2

Broker2 -> Broker2 : validate

Broker1 <- Broker2 : dialback

Activate Broker1

Broker1 -> Broker1 : validate

Broker1 -> Broker2 : stanza(from@domain1,to@domain2,type,content)

Deactivate Broker1
Deactivate Broker1
Activate Broker2

Broker2 -> Receiver : stanza(from@domain1,to@domain2,type,content)

Deactivate Broker2
Deactivate Broker2
Activate Receiver
@enduml
```
