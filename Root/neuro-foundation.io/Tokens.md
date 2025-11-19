Title: Tokens
Description: Tokens page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Tokens
=============

This document outlines the XML representation of token management. Using tokens is an optional method services, users or devices can use to identify 
themselves. The recipient of sensor or actuator commands can base their security decisions based on the XMPP address of the immediate sender, the 
domain of the immediate sender, and any device, user or service tokens. The XML representation is modelled using an annotated XML Schema:

| Tokens                                                                ||
| ------------|----------------------------------------------------------|
| Namespace:  | `urn:nfi:iot:prov:t:1.0`                                 |
| Schema:     | [ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd) |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The method of token management described here, is designed with the following goals in mind:

* Entities are connected *ad hoc* in a global federated network.

* Tokens should be short and light-weight so they can be distributed easily.

* Tokens should be easy to validate, regardless who issued the token.

* Tokens should be difficult to forge.

* Transmitting shared secrets or private keys should be avoided.


Getting a token
------------------------

For a client to use a token, it needs to get one from its provisioning server first. This is accomplished using two request/response pairs. First, the client
requests a token, by sending an `<iq type="get"/>` request containing a `<getToken/>` element with the *public part* of a certificate identifying the client (whether it be 
as a device, service or user) to the provisioning server. The provisioning server validates the certificate. If OK, it generates a random number with sufficient
entropy, encrypts it with the public certificate sent by the client (using OAEP padding), and sends it as a challenge to the client in an `<iq type="result">` with a
`<getTokenChallenge/>` element, to see if the client holds the *private part* of the certificate. The client decrypts the challenge and returns the response in a 
new `<iq type="get"/>` request with a `<getTokenChallengeResponse/>` element. The provisioning uses a `seqnr` attribute to match the challenge with the response.
If it finds the response is equal to the original random number it generated for the challenge, it accepts the request, and returns the token to the client
in an `<iq type="result"/>` containing a `<getTokenResponse/>` element.

```uml:Getting a token
@startuml
Activate Client
Client -> "Provisioning Server" : getToken(Certificate.Pub)

Activate "Provisioning Server"

"Provisioning Server" -> "Provisioning Server" : Validate(Certificate.Pub)

"Provisioning Server" -> "Provisioning Server" : Challenge:=Certificate.Pub.Encrypt(Random,OAEP)

Client <- "Provisioning Server" : getTokenChallenge(seqnr,Challenge)
Deactivate "Provisioning Server"

Activate Client

Client -> Client : Certificate.Priv.Decrypt(Challenge,OAEP)

Client -> "Provisioning Server" : getTokenChallengeResponse(seqnr,Response)

Activate "Provisioning Server"

"Provisioning Server" -> "Provisioning Server" : Response=Random?

Client <- "Provisioning Server" : getTokenResponse(token) [yes]

Deactivate "Provisioning Server"
Deactivate Client
Deactivate Client
@enduml
```

Following are some details on the XML elements defined by the [ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd) schema.

### getToken

Gets a token from the provisioning server.
The contents of the element should be the BASE64 encoded public part of a X.509 certificate, for which the server is to provide a token.

### getTokenChallenge

The provisioning server response to the `<getToken/>` request with a challenge. It contains BASE64-encoded binary data, encrypted with the public key of the 
certificate provided, using OAEP padding. The provisioning server adds a `seqnr` attribute to be able to match responses to challenges.

### getTokenChallengeResponse

The client responds to the challenge issuing a new request, containing the decrypted binary data, BASE64-encoded, to the provisioning server, using the
same `seqnr` provided with the challenge.

### getTokenResponse

On the receipt of a successful response to the challenge, the provisioning server responds with a token. It's placed in the `token` attribute of a
`<getTokenResponse/>` element. The format of the token should be the address of the provisioning server issuing the token, followed by a colon (`:`), 
followed by a random string with sufficient entropy.

Challenging a token
-----------------------

The first time an entity receives a token in a request from a particular sender, it can challenge it to make sure the original sender has the right to use the 
token. To do this, the receiver needs to get the certificate from the corresponding provisioning server first, unless it has it from an earlier operation. 
To get the corresponding certificate, first, the address to the provisioning server is extracted from the token. (There may be multiple provisioning servers 
used in the network.) It then sends the token to the corresponding broker using an `<iq type="get"/>` request with a `<getCertificate/>` element containing the token in 
the `token` attribute. If the provisioning server recognizes the token, it returns the public part of the certificate base64-encoded inside a `<certificate/>` 
element in an `<iq type="result"/>` response stanza.

The next step is to challenge the sender of the token. The challenge consists of a BASE-64 encoded binary challenge inside a `<tokenChallenge/>` element.
The challenge consists of a random number with sufficient entropy, encrypted using the public part of the certificate (using OAEP padding). It also includes the 
original token in the `token` attribute. If an intermediate sender receives such a challenge, it needs to pass it on to the entity it received the original
request from, since only the original sender is able to respond to the challenge. The original sender in turn, when receiving the challenge, first has to
make sure it sent a request to the entity receiving the challenge from recently. If so, it decrypts the challenge using the private part of the certificate
and returns the result base64 encoded in a `<tokenChallengeResponse/>` element in an `<iq type="result">` stanza. An intermediate must pass the result on to the entity
sending the original challenge. If the challenge response is not equal to the original random number, the original request should be rejected.

```uml:Challenging a token
@startuml
Activate Sender

Sender -> Intermediary : operation(token)

Intermediary -> Receiver : suboperation(token)

Activate Receiver

Receiver -> Receiver : Extract address to provisioning server from token

Receiver -> "Provisioning Server" : getCertificate(token)

Activate "Provisioning Server"

Receiver <- "Provisioning Server" : certificate(Certificate.Pub)

Deactivate "Provisioning Server"

Receiver -> Receiver : Challenge:=Certificate.Pub.Encrypt(Random,OAEP)

Receiver -> Intermediary : tokenChallenge(Challenge)

Intermediary -> Sender : tokenChallenge(Challenge)

Activate Sender

Sender -> Sender : Certificate.Priv.Decrypt(Challenge,OAEP)

Intermediary <- Sender : tokenChallengeResponse(Response)

Receiver <- Intermediary : tokenChallengeResponse(Response)

Deactivate Sender

Receiver -> Receiver : Response=Random?

Receiver -> Receiver : Perform action [yes]

Intermediary <- Receiver : subResult

Sender <- Intermediary : Result

Deactivate Receiver
Deactivate Sender
@enduml
```

### getCertificate

Anyone presented with a token, can send a request with this element to the provisioning server in order to get the public part of the corresponding 
X.509 certificate. Token is provided in `token` attribute.

### certificate

Contains an X.509 certificate, base-64 encoded.

### tokenChallenge

The recipient of a token can challenge the sender, especially the first time a token is received from a given sender.
The challenge consists of a BASE-64 encoded encrypted binary challenge, that the sender needs to decrypt and return.
In distributed transactions, where tokens are forwarded, challenges need to be forwarded to the original issuer of the request.
Token being challenge is available in the `token` attribute.

### tokenChallengeResponse

Decrypted binary data, base64-encodded as a response to the challenge.
