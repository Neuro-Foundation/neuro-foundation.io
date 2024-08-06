Title: End-to-End Encryption
Description: End-to-End Encryption page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

End-to-End encryption
===============================

This document outlines the XML representation of end-to-end encryption. The XML representation is modelled using an annotated XML Schema:

| End-to-End encryption                   ||
| ------------|----------------------------|
| Namespace:  | `urn:nf:iot:e2e:1.0`       |
| Schema:     | [E2E.xsd](Schemas/E2E.xsd) |


Motivation and design goal
----------------------------

The method of end-to-end encryption (E2E) described here, is designed with the following goals in mind:

* Peers should be able to choose which algorithms to use.

* Hybrid algorithms should be supported, where an asymmetric cipher with a public/private key pair is used to negotiate a symmetric key for a 
symmetric cipher, which is then used to encrypt/decrypt the payload of the stanza. The symmetric key is unique for each stanza.

* Both the `<message/>` and `<iq/>` stanzas should be possible to encrypt, together with all their contents.

* Signatures should be used to authenticate the sender.

* E2E communication is optional and can be used where privacy or confidentiality concerns are such that E2E connections are warranted.

* Public keys should be short-lived to maintain forward secrecy. If a public/private key is broken, only stanzas encrypted with the help of 
that public/private key pair are affected.


Hybrid Ciphers
--------------------

Ciphers used in End-to-End Encryption have two components: An asymmetric cipher using public keys for encryption and signature validation, 
and private keys for decryption and signature generation. This cipher is also used to derive shared symmetric keys. These are used by the
corresponding symmetric cipher to encrypt and decrypt the actual payload. Once the symmetric key has been used, it can be discarded. 
Asymmetric keys are regenerated as often as required by the sensitivity of the data being communicated. Available asymmetric ciphers are 
presented by clients supporting End-to-End Encryption in their presence. Symmetric ciphers are later chosen in the actual End-to-End 
Encrypted stanzas.

Publishing E2E Information
-------------------------------

When a device starts, it generates new public/private keys for the asymmetric ciphers it supports. Every time it gets connected it 
should publish its public key(s) using `<presence/>`, so that everyone with a presence subscription is aware of the current public key(s). 
Every time new public/private keys are generated the public keys should also be published in a new `<presence/>`. Apart from the most 
recent public/private key pair, the previous pair should also be kept in memory. There might be a delay in propagating new keys. Keeping
the previous key as well allows the recipient to receive and decrypt stanzas that have been encrypted using the previous key.

### Presence instead of handshake

To avoid having to negotiate keys when setting up E2E communication, public keys are published using `<presence/>`. This allows anyone to
send an end-to-end encrypted message to the entity, without first having to do a handshake. This saves time, in case an end-to-end encrypted
message needs to be sent as quickly as possible. The sender can choose to send an end-to-end encrypted message at any time without performing 
a handshake, and the receiver will be able to decrypt it. The number of E2E stanzas transmitted and received is the same as the number of 
unencrypted stanzas, plus the number of presence stanzas transmitted. While this typically reduces the number of messages required to 
establish E2E communication between peers, it is not designed for the generation of new public keys for every single stanza. Instead, 
public/private keys are generated on a timely fashion, depending on context, or after concluding a series of stanzas (a communication 
session). This allows anyone starting a new E2E session with the entity to do so using new keys. Public keys should be short-lived. This
assures that there is no added risk that messages in past sessions be broken, in case a public/private key pair is broken (forward secrecy).

Asymmetric Ciphers
---------------------

The following subsections list asymmetric ciphers that can be used to define for End-to-End Encryption Endpoints.

### RSA

The `<rsa/>` element implements support for the RSA public/private key algorithm. RSA does not support a method to calculate a common
shared secret. Instead, the sender randomly generates a 32-byte key, and uses the public key of the recipient to encrypt it and send it
to the recipient (using SHA-256 and OAEP padding). The sender uses the RSA private key to sign the payload (using SHA-256 and PSS padding).

Support for RSA asymmetric cipher endpoint is shown by including the `<rsa/>` element inside the `<e2e/>` element in the `<presence/>` 
stanza. The public key is published in the `pub` attribute. It is a BASE64-encoded binary representation of the key size, modulus and
exponent parts of the public key. The first two bytes contain the 16-bit key size (in bits), in little-endian order, followed by the
modulus, followed by the exponent.

### Elliptic Curve Cryptography (ECC)

Elliptic Curve Cryptography can be used together with a symmetric cipher to encrypt content between endpoints. The Elliptic Curve 
is used to derive a shared secret (key) for use with the symmetric cipher using ECDH. There is therefore no need to generate a shared secret
and send it to the recipient when using ECC. If the curve supports signature generation, the private key is used to sign the unencrypted 
content using ECDSA or EdDSA, depending on type of curve.

Support for Elliptic Curve encryption endpoints is shown by including the curve algorithm element inside the `<e2e/>` element in the 
`<presence/>` stanza. Each curve element includes a `pub` attribute containing a BASE64-encoded binary representation of the public key.
The list of supported curves may change over time.

| Curve Name             | Element   | Security Level | RSA equivalent | Signatures                     | Safe[^Safe] |
|:-----------------------|:----------|:--------------:|:--------------:|:-------------------------------|:-----------:|
| Curve25519[^RFC7748]   | `x25519`  | 128            |  3072          | N/A[^CurveNote]                | Yes         |
| Curve448[^RFC7748]     | `x448`    | 224            |  7680          | N/A[^CurveNote]                | Yes         |
| Edwards25519[^RFC8032] | `ed25519` | 128            |  3072          | EdDSA, SHA-512                 | Yes         |
| Edwards448[^RFC8032]   | `ed448`   | 224            |  7680          | EdDSA, SHAKE256[114][^FIPS202] | Yes         |
| NIST P-192[^FIPS1864]  | `p192`    |  96            |  1024          | ECDSA, SHA-256                 | No          |
| NIST P-224[^FIPS1864]  | `p224`    | 112            |  2048          | ECDSA, SHA-256                 | No          |
| NIST P-256[^FIPS1864]  | `p256`    | 128            |  3072          | ECDSA, SHA-256                 | No          |
| NIST P-384[^FIPS1864]  | `p384`    | 192            |  7680          | ECDSA, SHA-512                 | No          |
| NIST P-521[^FIPS1864]  | `p521`    | 256            | 15360          | ECDSA, SHA-512                 | No          |

[^RFC7748]: Curve25519 and Curve448 are described in [RFC 7748](https://tools.ietf.org/html/rfc7748). This includes binary representations
of public keys and signatures.
[^RFC8032]: Edwards25519 and Edwards448 are described in [RFC 8032](https://tools.ietf.org/html/rfc8032). This includes binary representations
of public keys and signatures.
[^FIPS1864]: NIST curves are described in [NIST FIPS 186-4](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf). The binary 
representation of public keys consist of the binary representation of the X-coordinate followed by the binary representation of the 
Y-coordinate, both in little-endian form.
[^FIPS202]: The SHAKE256 algorithm is defined in [NIST FIPS 202](https://nvlpubs.nist.gov/nistpubs/fips/nist.fips.202.pdf).
[^Safe]: [safecurves.cr.yp.to](http://safecurves.cr.yp.to/) publishes evaluation criteria for elliptic curves.
[^CurveNote]: Authentication of the sender by the receiver is done implicitly by the fact that the shared secret used to decrypt an 
end-to-end encrypted message requires knowledge about the private key of the sender. The same is required for generating a signature.
Since no signature is provided by default when using Curve25519 or Curve448, the AEAD-ChaCha20-Poly1305 symmetric cipher can be used to 
add an extra layer of authentication of the sender and integrity protection of the message, if desired.

Symmetric ciphers
-----------------------

The following subsections list symmetric ciphers that can be used for End-to-End Encryption. The algorithm used is defined in each stanza
by the element that encapsulates the encrypted data. Available elements include:

| Algorithm              | Element | Security Level |
|------------------------|---------|----------------|
| AEAD-ChaCha20-Poly1305 | `acp`   | 256            |
| AES-256                | `aes`   | 256            |
| ChaCha20               | `cha`   | 256            |

Symmetric cipher elements share the following attributes:

| Attribute | Type              | Use      | Description |
|-----------|-------------------|----------|-------------|
| `r`       | `xs:string`       | Required | Reference to the remote endpoint encrypting the data. This corresponds to the local name of the asymmetric cipher used to derive the shared secret. If the cipher is defined in another namespace, the value is prefixed by this namespace followed by a `#` and the local name of the cipher. |
| `c`       | `xs:unsignedInt`  | Required | Counter used to derive the Initiation Vector (IV). Incremented once for every encrypted stanza. Can be reset when a new key is generated. |
| `k`       | `xs:base64Binary` | Optional | If the public-key algorithm referenced does not support derivation of shared keys (such as RSA), the AES shared secret is explicitly generated by the sender, encrypted using the public key of the recipient, and sent in this attribute. |
| `s`       | `xs:base64Binary` | Optional | Signature of sender, if public-key algorithm supports signatures. |

### AES-256 

The 256-bit Advanced Encryption Standard (AES-256[^FIPS197]) can be used as a symmetric cipher to encrypt and decrypt content.
The asymmetric cipher can be used to provide a shared AES key to use. It can also be used to provide a digital signature of the
content, and verify that signatures are valid. The encrypted content is placed in an `<aes/>` element. 

The 16-byte Initiation Vector (IV) is calculated as follows: The first 12 bytes consists of the first 12 bytes of the
SHA-256 hash of the UTF-8 encoded concatenation of the `id`, `type`, `from` and `to` attributes of the stanza element, in that order.
The last 4 bytes consist of a 32-bit counter, in little-endian order. The counter is reset when asymmetric key(s) are regenerated
and incremented for each stanza encrypted. This guarantees a unique IV for every combination of key and stanza sent. The counter
is transmitted in the stanza, to avoid synchronization problems.

The data to encrypt is prefixed by its length. The number of bytes used for the length is variable. The length is encoded as a sequence 
of 7-bit value bytes (least significant part first). The 8th bit is used to inform the reader if more length bytes are following (1), or 
if the byte is the last length byte (0). Following the encoded data length comes the data to be encrypted. AES-256 has a block size of 
16 bytes. Any unused bytes in the last block are filled with random bytes before encryption. Blocks are chained together during encryption 
using Cipher Block Chaining (CBC).

**Note**: AES-256 encryption and decryption does not include any additional data. It should be used in conjunction with asymmetric ciphers
that support digital signatures and validation of signatures.

[^FIPS197]: AES-256 is defined in [NIST FIPS 197](https://nvlpubs.nist.gov/nistpubs/fips/nist.fips.197.pdf).

### ChaCha20

The symmetric ChaCha20 cipher[^ChaCha20] is an alternative to the popular AES cipher. In case the AES cipher gets compromised, secure
communication can still be achieved using the ChaCha20 cipher. On machines that lack hardware support for AES, ChaCha20 also provides
a higher performance without compromising security.

ChaCha20 requires a 12-byte nonce, or Initiation Vector (IV). It is calculated as follows: The first 8 bytes consists of the first 8 bytes 
of the SHA-256 hash of the UTF-8 encoded concatenation of the `id`, `type`, `from` and `to` attributes of the stanza element, in that order.
The last 4 bytes consist of a 32-bit counter, in little-endian order. The counter is reset when asymmetric key(s) are regenerated
and incremented for each stanza encrypted. This guarantees a unique IV for every combination of key and stanza sent. The counter
is transmitted in the stanza, to avoid synchronization problems.

The data to encrypt is not prefixed with the length of the content before encryption, since the ChaCha20 is a stream cipher, and not a
block cipher. The ChaCha20 encryption and decryption algorithm starts with block counter 1 for each stanza.

[^ChaCha20]: AEAD-ChaCha20-Poly1305 is defined in [RFC 8439](https://tools.ietf.org/html/rfc8439).

### AEAD-ChaCha20-Poly1305

As mentioned, the symmetric ChaCha20 cipher[^ChaCha20] is an alternative to the popular AES cipher. It can be used in conjunction with 
the Poly1305 authentication algorithm and Authenticated Encryption with Associated Data (AEAD) to provide for efficient symmetric encryption 
and message authentication. This provides additional protection of message integrity, especially if the asymmetric cipher does not support
means for generating and validating signatures directly, such as the Montgomery curves Curve25519 and Curve448.

The same method for computing the Initiation Vector (IV) as for ChaCha20 is used. The data to encrypt is not prefixed before encryption. 
Instead, the encrypted data is suffixed by the 16-byte Message Authentication Code (MAC) generated by the Poly1305 algorithm. The Associated 
Data (AD) used in the AEAD algorithm is the UTF-8 encoding of the `from` attribute value on the stanza (i.e. full JID of the sender).

**Note**: The MAC does not guarantee that the sender has the private key, only that the message has not been tampered with. Authentication
of the identity of the sender is done using the asymmetric cipher. It is done either by using an algorithm for computing a shared common
secret (such as ECDH), or generating digital signatures (such as ECDSA, EdDSA or RSA), or both. The full JID of a sender is known to all
with a presence subscription approved by the sender.

Encrypting stanzas
-------------------

When E2E-encrypting a `<message/>` stanza, it is encrypted in its entirety (entire XML stanza), and then placed in the symmetric cipher
element, as defined above. This element then sent in a *normal*, unadorned `<message/>` stanza by itself. The only attributes transferred 
from the original message, are the `id` and `to` attributes. The rest is protected inside the encrypted element.

When E2E-encrypting an `<iq/>` stanza, only the contents of the stanza is encrypted, and then placed in the symmetric cipher element. This 
element is then sent in an `<iq/>` stanza with the same `type`, `id`, `to` and `from` attributes as the original stanza.

In both cases, the signatures are calculated on the unencrypted part of the payload that is to be encrypted. Encoding of XML text to bytes 
is always done using UTF-8 encoding.

Examples
-----------

Following are some examples of stanzas related to End-to-End encryption.

### Publishing public keys

The following example shows a `<presence/>` stanza, where the sender publishes a set of
public keys for available asymmetric ciphers.

```
<presence>
    <show>chat</show>
    <e2e xmlns="urn:nf:iot:e2e:1.0">
        <x25519 pub="giAy8BZRKUjsyQgha387ftNCfodSB..." />
        <x448 pub="k48EIdyM35m4y/+fKfjfhsofi6Q/dtV..." />
        <ed25519 pub="QsPrTABTXqQudCO3TVZTzEbVPc5k..." />
        <ed448 pub="v4dQTfx8iSoA05yhoScZjyHwvmDKFb..." />
        <p192 pub="FLHB42q85QMcShfE2gprKA38nLz6CRc..." />
        <p224 pub="lo0KVbyJ/8ObVtcECwc+nrvSOgjk5NM..." />
        <p256 pub="1AaD2CmGjXuCl20nGVxDELkCOfjV7T8..." />
        <p384 pub="L+sPifULzzU4OnSE3OIgs+fw7PMN/Bz..." />
        <p521 pub="7P0RVNIGeMVvZZ2+Lrc4WbW5fCSrUDx..." />
        <rsa pub="AAzJMMn/cK5hqiaWvc3i3aS3e2NosJdm..." />
    </e2e>
    <p2p xmlns="urn:nf:iot:p2p:1.0" extIp="81.229..." extPort="64152" locIp="192.168.1.219" locPort="64152" />
    <c xmlns="http://jabber.org/protocol/caps" hash="sha-256" node="..." ver="..." />
</presence>
```

### Sending an E2E encrypted message

In the following example, a sender sends a `<message/>` stanza end-to-end encrypted using
the Edwards25519 curve, Elliptic Curve Diffie-Hellman (ECDH) for shared secret evaluation, 
Edwards-curve Digital Signature Algorithm (EdDSA) algorithm for digital signatures and the
AES-256 symmetric cipher to encrypt the payload. (BASE-64 encoded values have been
shortened for readability.)

```
<message id='1' to='...'>
   <aes xmlns="urn:nf:iot:e2e:1.0" r="ed25519" c="1" 
        s="V23wQRWkJ0/hVmVsMCXbfFNIpbpkqKr57+FjV7q...">
      IJR9OxAHQzltyAT+deEIN8Uj7ds6MXCeF/XL6G6ulbub...
   </aes>
</message>
```

**Note**: When sending a stanza, there is no need to add a `from` attribute. It is added 
by the broker, to make sure it is not forged. The receiver receives the from attribute 
from its broker and uses it to decrypt the end-to-end encrypted content.

### Sending an E2E encrypted information query

In the following example, a sender sends a `<iq type="set"/>` stanza end-to-end encrypted 
using the Curve25519 curve, Elliptic Curve Diffie-Hellman (ECDH) for shared secret 
evaluation, and Authenticated Encryption with Associated Data using ChaCha20 and Poly1305
symmetric cipher to encrypt the payload. (BASE-64 encoded values have been shortened for 
readability.)

```
<iq type='set' id='3' to='...'>
   <acp xmlns="urn:nf:iot:e2e:1.0" r="x25519" c="1">
      /oeKARaL/z77fGKxQpye5nkxf6qlcVCScsOWXWTHg/Le2...
   </acp>
</iq>
```

### Receiving an E2E encrypted response

In the following example, a response is returned to the previous query. It is End-to-End
Encrypted using the same algorithms as the original query.

```
<iq id='3' type='result' to='...' from='...'>
   <acp xmlns="urn:nf:iot:e2e:1.0" r="x25519" c="1">
      U+5v69FIcU16ocbHt/EpSKWe/49Sj0SqfkCyqlXakKJD0...
   </acp>
</iq>
```

**Note**: Responses or errors do not have to be end-to-end encrypted using the same
algorithms as the original request.

### Receiving an E2E encrypted error

In the following example, an error is returned to the previous query. It is End-to-End 
Encrypted using different algorithms (RSA, with encrypted secret and ChaCha20):

```
<iq id='3' type='error' to='...' from='...'>
   <cha xmlns="urn:nf:iot:e2e:1.0" r="rsa" c="1"
        k="lJZV4kdCXOUmYbV0p/Ohs0fmH8TgouTJ2Bu..."
        s="qAYGmemtF6nMRntlVaqGG8cz4ZJX96kO3b+...">
      DshwgJp0fg1RV3mQZKlzaI3akUOAg4LBKum/L390...
   </cha>
</iq>
```

**Note**: Using RSA results in significantly larger messages. It also takes time to
generate the prime numbers required to construct the private keys.
