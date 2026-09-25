Title: Tokens
Description: Tokens page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Tokens
=============

This document outlines the XML representation of token management. Using tokens is an optional 
feature that services, users or devices can use to identify themselves in distributed
environments. The recipient of sensor or actuator commands can base their security decisions 
based on the XMPP address of the immediate sender, the domain of the immediate sender, and any 
device, user or service tokens presented, representing the origin of the transaction resulting 
in the request. Most tokens can be challenged. The XML representation is modelled using an 
annotated XML Schema:

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

* Tokens can be challenged, to reduce the risk of malicious actors reutilizing tokens they
find.

* Tokens should be difficult to forge.

* Transmitting shared secrets or private keys should be avoided.


Requirements
---------------

![Tokens Requirements](TokensRequirements.md)

Types of tokens
------------------

There are three different kinds of tokens that can be used with this infrastructure:

#. A Legal Identity identifier is a token that can be easily distributed. It is presented in 
the form `GUID@DOMAIN`, as defined in the [Legal Identities section](LegalIdentities.md). The
`DOMAIN` is the domain name of the Legal Component validating the corresponding Legal Identity.

#. An [X.509 Certificate](https://datatracker.ietf.org/doc/html/rfc5280) token. It is a 
short-form representation of an X.509 Certificate, in the form `DOMAIN:RND`. The `DOMAIN` 
part is the domain of the Provisioning Component where the public part of the certificate has 
been registered, and `RND` is a random identifier referencing this registration.

#. A [JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519). JWT tokens can be
used as well. Challenging and validating such tokens must be done out-of-scope however.

Common for all these tokens, is that they do not include white-space characters. When 
providing tokens in a request, it is therefore possible to provide multiple tokens of 
different types, separated by space characters.

Creating a token
-------------------

For a client to use a token, it needs to create one first. Creating a token is done 
differently, depending on the type of token.

### Creating a Legal Identity token

Legal Identity identifiers are created when [applying for a Legal Identity](LegalIdentities.md#applyingForLegalIdentityRegistration).
These identifiers can be used as tokens as-is.

### Creating a JWT token

JWT tokens are created out-of-band, and is not described further in this specification. JWT
tokens can be used in this specification, as a means to integrate web-based systems using
JWT Bearer tokens as the basis for authenticating entities.

### Creating an X.509 Certificate token

An X.509 Certificate token is created, by registering the certificate with the Provisioning
Component, as follows.

The registration is accomplished using two request/response pairs. First, the client requests 
a token, by sending an `<iq type="get"/>` request containing a `<getToken/>` element with the 
*public part* of a certificate identifying the client (whether it be as a device, service or 
user) to the provisioning server. The provisioning server validates the certificate. If OK, 
it generates a random number with sufficient entropy, encrypts it with the public certificate 
sent by the client (using OAEP padding), and sends it as a challenge to the client in an 
`<iq type="result">` with a `<getTokenChallenge/>` element, to see if the client holds the 
*private part* of the certificate. The client decrypts the challenge and returns the response 
in a new `<iq type="get"/>` request with a `<getTokenChallengeResponse/>` element. The 
provisioning uses a `seqnr` attribute to match the challenge with the response. If it finds 
the response is equal to the original random number it generated for the challenge, it accepts
the request, and returns the token to the client in an `<iq type="result"/>` containing a 
`<getTokenResponse/>` element.

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

Following are some details on the XML elements defined by the 
[ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd) schema.

#### getToken

Gets a token from the provisioning server. The contents of the element should be the BASE64 
encoded public part of a X.509 certificate, for which the server is to provide a token.

#### getTokenChallenge

The provisioning server response to the `<getToken/>` request with a challenge. It contains 
BASE64-encoded binary data, encrypted with the public key of the certificate provided, using 
OAEP padding. The provisioning server adds a `seqnr` attribute to be able to match responses 
to challenges.

#### getTokenChallengeResponse

The client responds to the challenge issuing a new request, containing the decrypted binary 
data, BASE64-encoded, to the provisioning server, using the same `seqnr` provided with the 
challenge.

#### getTokenResponse

On the receipt of a successful response to the challenge, the provisioning server responds 
with a token. It's placed in the `token` attribute of a `<getTokenResponse/>` element. The 
format of the token should be the address of the provisioning server issuing the token, 
followed by a colon (`:`), followed by a random string with sufficient entropy.

#### Example of creating an X.509 Certificate token

Example of a client registering a public certificate to its Provisioning Component:

```xml
<iq type='get'
    from='service@example.org/abcd'
    to='provisioning.example.org'
    id='28'>
   <getToken xmlns='urn:nfi:iot:prov:t:1.0'>
      BASE64-encoded public DER-encoded X.509 certificate
   </getToken>
</iq>
```

A challenge is returned in the response:

```xml
<iq type='result'
    from='provisioning.example.org'
    to='service@example.org/abcd'
    id='28'>
   <getTokenChallenge xmlns='urn:nfi:iot:prov:t:1.0' seqnr='3'>
      BASE64-encoded binary challenge
   </getTokenChallenge>
</iq>
```

The challenge is decrypted and sent to the Provisioning Component:

```xml
<iq type='get'
    from='service@example.org/abcd'
    to='provisioning.example.org'
    id='29'>
   <getTokenChallengeResponse xmlns='urn:nfi:iot:prov:t:1.0' seqnr='3'>
      BASE64-encoded decrypted challenge
   </getTokenChallengeResponse>
</iq>
```

A token representing the X.509 certificate is returned in the response:

```xml
<iq type='result'
    from='provisioning.example.org'
    to='service@example.org/abcd'
    id='29'>
   <getTokenResponse xmlns='urn:nfi:iot:prov:t:1.0' 
                     token='provisioning.example.org:...'/>
</iq>
```

Getting the Identity represented by a token
----------------------------------------------

Getting the identity represented by a token is done differently, depending on the type of 
token. The following subsections describe the different methods.

### Getting a Legal Identity

Getting a Legal Identity, using its identifier, is described in the
[Legal Identities section](#gettingLegalIdentities). If the Identity has `Public` visibility, 
anyone can get the Legal Identity directly. If it has `Domain` visibility, only Entities with
accounts on the same domain can get it directly. Other Entities must first
[Petition access to the Legal Identity](LegalIdentities.md#petitioningAccessToALegalIdentity)
from the owner. If the Legal Identity has `Private` visibilty (which is the default), all
Entities must first petition access to the Legal Identity, to be able to get it.

### Getting an Identity from a JWT token

JWT tokens encode the identity into the token itself. Getting the identity is a matter of
parsing it. JWT tokens should only be used if the distribution of its JWT tokens can be
controlled.

### Getting the X.509 Certificate from a Certificate token

To get the certificate corresponding to a token, the address to the provisioning server is 
extracted from the token. (There may be multiple provisioning servers used in the network.) 
The client then sends the token to the corresponding component using an `<iq type="get"/>` 
request with a `<getCertificate/>` element containing the token in the `token` attribute. If 
the provisioning server recognizes the token, it returns the public part of the certificate 
base64-encoded inside a `<certificate/>` element in an `<iq type="result"/>` response stanza
back to the client.

Following are some details on the XML elements defined by the 
[ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd) schema.

#### getCertificate

Anyone presented with a token, can send a request with this element to the provisioning server 
in order to get the public part of the corresponding X.509 certificate. Token is provided in 
`token` attribute.

#### certificate

Contains an X.509 certificate, BASE64 encoded.

#### Example of getting the X.509 Certificate from a Certificate token

A client requests the public X.509 certificate associated with a token from the 
Provisioning Component encoded into the token:

```xml
<iq type='get'
    from='service2@example.org/efgh'
    to='provisioning.example.org'
    id='30'>
   <getCertificate xmlns='urn:nfi:iot:prov:t:1.0'>
      provisioning.example.org:...
   </getCertificate>
</iq>
```

A challenge is returned in the response:

```xml
<iq type='result'
    from='provisioning.example.org'
    to=service2@example.org/efgh'
    id='30'>
   <certificate xmlns='urn:nfi:iot:prov:t:1.0'>
      BASE64-encoding of DER-encoded X.509 Certificate
   </certificate>
</iq>
```

Challenging a token
----------------------

The first time an entity receives a token in a request from a particular sender, it must 
challenge the sender to make sure the sender has the right to use the token. Challenging a
token is done differently, depending on the type of token.

### Challenging a Legal Identity or X.509 Certificate token

To challenge the sender of a Legal Identity or an X.509 Certificate token, a 
`<tokenChallenge/>` element is sent in an `<iq type="set">` stanza to the sender. The 
challenge consists of a random number with sufficient entropy, encrypted using either the 
public key in the Legal Identity, or the public part of the certificate (using OAEP padding). 
When encrypting the challenge for a Legal Identity, a symmetric cipher needs to be selected 
as well, as the Legal Identity only contains a reference to the asymmetric cipher. The
symmetric cipher used is defined using the `ln` and `ns` attributes, which are selected to
be `aes` and `urn:nfi:iot:e2e:1.0` by default, if not specified. (See section about
[End-to-End Encryption](E2E.md) for more information about ciphers available.) The 
`<tokenChallenge/>` element also includes the original token in the `token` attribute. If an
intermediate sender receives such a challenge, it needs to forward it to the entity it 
received the original request from, since only the original sender is able to respond to the 
challenge. The original sender in turn, when receiving the challenge, first has to make sure 
it sent a request to the entity receiving the challenge from recently. If so, it decrypts the 
challenge using either the private key of the Legal Identity, or the private part of the 
certificate and returns the result base64 encoded in a `<tokenChallengeResponse/>` element 
in an `<iq type="result">` stanza. An intermediate must pass the result on to the entity 
sending the original challenge. If the challenge response is not equal to the original random 
number, the original request must be rejected.

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

Following are some details on the XML elements defined by the 
[ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd) schema.

#### tokenChallenge

The recipient of a token can challenge the sender, especially the first time a token is 
received from a given sender. The challenge consists of a BASE64 encoded encrypted binary 
challenge, that the sender needs to decrypt and return. In distributed transactions, where 
tokens are forwarded, challenges need to be forwarded to the original issuer of the request.
Token being challenge is available in the `token` attribute. If encrypting a challenge for
a Legal Identity token, the attributes `ln` and `ns` are used to specify the symmetric
cipher used in the encryption, if different from AES-256, which is the default cipher.

#### tokenChallengeResponse

Decrypted binary data, base64-encodded as a response to the challenge.

#### Example of challenging a Legal Identity or X.509 Certificate token

A client sends a challenge to an Entity from which it has received a token:

```xml
<iq type='get'
    from='service2@example.org/efgh'
    to='service@example.org/abcd'
    id='31'>
   <tokenChallenge xmlns='urn:nfi:iot:prov:t:1.0'
                   Token='provisioning.example.org:...'>
      BASE64-encoded binary challenge
   </tokenChallenge>
</iq>
```

The decrypted challenge is returned as a response to the challenge:

```xml
<iq type='result'
    from='service@example.org/abcd'
    to='service2@example.org/efgh'
    id='31'>
   <tokenChallengeResponse xmlns='urn:nfi:iot:prov:t:1.0'>
      BASE64-encoded decrypted challenge
   </tokenChallengeResponse>
</iq>
```

#### Example of challenging a Legal Identity token

A client sends a challenge to an Entity from which it has received a token:

```xml
<iq type='get'
    from='service2@example.org/efgh'
    to='service@example.org/abcd'
    id='32'>
   <tokenChallenge xmlns='urn:nfi:iot:prov:t:1.0'
                   token='...@provisioning.example.org'
                   ln='acp'>
      BASE64-encoded binary challenge
   </tokenChallenge>
</iq>
```

The decrypted challenge is returned as a response to the challenge:

```xml
<iq type='result'
    from='service@example.org/abcd'
    to='service2@example.org/efgh'
    id='32'>
   <tokenChallengeResponse xmlns='urn:nfi:iot:prov:t:1.0'>
      BASE64-encoded decrypted challenge
   </tokenChallengeResponse>
</iq>
```

### Challenging a JWT token

Challenging the use of a JWT token is handled out-of-band, and not covered by this 
specification.