Title: Legal Identities
Description: Legal Identities page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Legal Identities
=====================

It is possible to assign a legal identity to an account. By assigning a legal identity to the account, it becomes possible for the account 
to sign legal contracts. Such contracts can be used by owners to regulate conditions for accessing their things, allowing for automation of 
decision support and provisioning.

| Legal Identities                                                      ||
| ------------|----------------------------------------------------------|
| Namespace:  | `urn:nf:iot:leg:id:1.0`                                  |
| Schema:     | [LegalIdentities.xsd](Schemas/LegalIdentities.xsd)       |

![Table of Contents](toc)

Motivation and design goal
----------------------------

The method of managing legal identities described here, is designed with the following goals in mind:

* Legal Identities are protected using public key cryptography, where the client retains a private key that it does not share with anyone,
and registers the identity with a public key, that everyone with access to the identity receives. The private key is used by the client to
sign its legal identity application. The public key is used to validate the signature.

* Legal Identities are only available to their corresponding owners, parts in smart contracts, and operator (Trust Provider) staff,
acting as electronic notaries attesting to the validity of the legal identities.

* Other entities can make petitions to access the personal information available in legal identities. Owners of the identities must 
first consent before access can be granted.

* The broker (Trust Provider) maintains its own public and private key. Everyone has access to the public key. The private key is used by
the broker to sign that it attests to the validity of a claim, such as the integrity of a legal identity.

* Legal Identities can have a variable number of signed attachments associated with it.

Getting Server Public Key
------------------------------

To get the public key of the server, the `<getPublicKey/>` element is sent in an `<iq type='get'/>` stanza to the corresponding component.

Example:

```xml
<iq type='get' id='3' to='legal.example.org'>
   <getPublicKey xmlns="urn:nf:iot:leg:id:1.0"/>
</iq>
```

The response contains the public key in a `<publicKey/>` element, if successful. Public keys are encoded using the 
[End-to-End Encryption](E2E.md) namespace and elements.

Example:

```xml
<iq id='3' type='result' to='client@example.org/e36120d6a04244576b22c2f7b2c8bc5c' from='legal.example.org'>
   <publicKey xmlns='urn:nf:iot:leg:id:1.0'>
      <ed448 pub='24XPfS5oQ2nljCLpJGHn9O9sSiJ0K5/yymfiHssXGizeV+TS9dLWxQHKXXRYHjKptWieSD+OZdeA' xmlns='urn:nf:iot:e2e:1.0'/>
   </publicKey>
</iq>
```

Applying for Legal Identity registration
------------------------------------------

Legal identities are validated and attested by the broker out-of-band. To start the process, the client sends an application for a
legal identity to be registered by sending the `<apply/>` element in an `<iq type='set'/>` stanza to the legal component of the server. The operator 
is notified, and validation can be performed, either manually, or automatically, depending on the context. How this process is done lies 
outside the scope of this specification.

The `<apply/>` element must contain the information about the legal identity, encoded in an `<identity/>` element. This element must not contain
an `id` attribute. Such requests must be rejected. The `id` attribute is added by the broker, after validating the request. The `<identity/>`
element contains a sequence of child elements, however. The first is a `<clientPublicKey/>` element, which contains the public key of the client 
making the request. The corresponding private key will be used to sign the request later. Then comes a sequence of `<property/>` elements. Each 
one encodes a `name`/`value` attribute pair. It is up to the client to decide the number of properties included, and which ones. Any names can be used.
Some names are predefined however, as described in the following table:

| Property      | Description                                                |
|:--------------|:-----------------------------------------------------------|
| `FIRST`       | First name                                                 |
| `MIDDLE`      | Middle name                                                |
| `LAST`        | Last name                                                  |
| `PNR`         | Personal number                                            |
| `ADDR`        | Address                                                    |
| `ADDR2`       | Address, second line                                       |
| `ZIP`         | Zip or postal code                                         |
| `AREA`        | Area                                                       |
| `CITY`        | City                                                       |
| `REGION`      | Region, state                                              |
| `COUNTRY`     | Country                                                    |
| `NATIONALITY` | Nationality                                                |
| `GENDER`      | Gender (`M` or `F`)                                        |
| `PHONE`       | Phone number, international phone number format.           |
| `DOMAIN`      | If the ID represents the legal representative of a domain. |
| `ORGNAME`     | Name of organization                                       |
| `ORGNR`       | Organization number                                        |
| `ORGDEPT`     | Organization department, where person works.               |
| `ORGROLE`     | Role of person in organization.                            |
| `ORGADDR`     | Address of organization.                                   |
| `ORGADDR2`    | Address of organization, second line                       |
| `ORGZIP`      | Zip or postal code of organization                         |
| `ORGAREA`     | Area of organization.                                      |
| `ORGCITY`     | City of organization.                                      |
| `ORGREGION`   | Region or state of organization.                           |
| `ORGCOUNTRY`  | Country code of organization.                              |

Some property names are reserved as they can be used in role reference parameters to refer to
concatenations of multiple parameters:

| Property            | Description                                             |
|:--------------------|:--------------------------------------------------------|
| `FULLNAME`          | Full name  (`FIRST [ " " MIDDLE] LAST`)                 |
| `FULLADDR`          | Full address (`ADDR [ ", " ADDR2]`)                     |
| `FULLORGADDR`       | Full organization address (`ORGADDR [ ", " ORGADDR2]`)  |
| `SIGNATURE`         | Digital signature reference.                            |
| `SIGNATUREDATE`     | Date of digital signature.                              |
| `SIGNATURETIME`     | Time of digital signature.                              |
| `SIGNATUREDATETIME` | Date and Time of digital signature.                     |

Some property names are reserved for future use:

| Property  | Description                     |
|:----------|:--------------------------------|
| `FP`      | Fingerprint biometric data      |
| `VOICE`   | Voice biometric data            |
| `FR`      | Face recognition biometric data |

After all properties have been listed, the client signs the identity using a `<clientSignature/>` element. Client signatures are calculated
as follows:

* The signature is calculated on the identity element excluding the `id` attribute and the `<clientSignature/>`, `<status/>` and `<serverSignature/>`
elements.
* All text nodes and attribute values contain XML-encoded normalized Unicode text (in NFC).
* XML is normalized. Unnecessary white space removed. Space characters only allowed whitespace.
* The normalized XML, with attributes in alphabetical order, using double quotes, `xmlns` attributes only when required, 
`&`, `<`, `>`, `"` and `'` consistently escaped, empty elements are closed using `/>`, and no space when ending empty element, 
is UTF-8 encoded before being signed.
* The identity element never includes the `xmlns` attribute when calculating the signature.

**Note**: The purpose of the signature, is for the server to validate that the client has access to the private keys corresponding to the 
public keys registered with the trust provider, and that the contents of the identity is consistent over time.

**Note**: Legal identities are updated by the client regularly. Check with the server to get the most recent legal identity, if needed.

**Note**: Whitespace and indentation in the example above has been added for readability only.

**Note**: Legal identities are case insensitive in searches and references.

Example:

```xml
<iq type='set' id='4' to='legal.example.org'>
   <apply xmlns="urn:nf:iot:leg:id:1.0">
      <identity>
         <clientPublicKey>
            <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
         </clientPublicKey>
         <property name="FIRST" value="Jon"/>
         <property name="LAST" value="Doe"/>
         <property name="PNR" value="123456789-0"/>
         <property name="ADDR" value="Street 1A"/>
         <property name="ZIP" value="12345"/>
         <property name="CITY" value="Metropolis"/>
         <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      </identity>
   </apply>
</iq>
```

After passing all validation tests by the server, it responds with an annotated `<identity/>` element back to the client. The server attaches
an reference identity to the legal identity, which it makes available in the `id` attribute of the `<identity/>` element.
The identifier is formed as a JID, but is not a JID. The domain part corresponds to the domain of the Trust Provider.
The `<identity/>` element provided by the server contains the original information provided by the client, as well as some state information 
about the identity, encoded in a `<status/>` element. This element can have the following attributes:

| Attribute   | Type            | Use      | Description                                                                       |
|:------------|:----------------|:---------|-----------------------------------------------------------------------------------|
| `provider`  | `xs:string`     | Required | JID of Trust Provider validating the correctness of the identity.                 |
| `state`     | `IdentityState` | Required | Contains information about the current statue of the legal identity registration. |
| `created`   | `xs:dateTime`   | Required | When the legal identity was first created.                                        |
| `updated`   | `xs:dateTime`   | Optional | When the legal identity was last updated.                                         |
| `from`      | `xs:date`       | Optional | From what date (inclusive) the legal identity can be used.                        |
| `to`        | `xs:date`       | Optional | To what date (inclusive) the legal identity can be used.                          |

The `state` attribute can have one of the following values:

| IdentityState                                                                                           ||
|:--------------|:-----------------------------------------------------------------------------------------|
| `Created`     | An application has been received and is pending confirmation out-of-band.                |
| `Rejected`    | The legal identity has been rejected.                                                    |
| `Approved`    | The legal identity is authenticated and approved by the Trust Provider.                  |
| `Obsoleted`   | The legal identity has been explicitly obsoleted by its owner, or by the Trust Provider. |
| `Compromised` | The legal identity has been reported compromised by its owner, or by the Trust Provider. |

Finally, the server signs the identity to attest to the validity and integrity of the information encoded inside. This signature is
encoded in the `<serverSignature/>` element. The server signature is calculated as follows:

* The signature is calculated on the `<identity/>` element excluding the `<serverSignature/>` element.
* All text nodes and attribute values contain XML-encoded normalized Unicode text (in NFC).
* XML is normalized. Unnecessary white space removed. Space characters only allowed whitespace.
* The normalized XML, with attributes in alphabetical order, using double quotes, `xmlns` attributes only when required, 
`&`, `<`, `>`, `"` and `'` consistently escaped, empty elements are closed using `/>`, and no space when ending empty element, 
is UTF-8 encoded before being signed.
* The identity element never includes the `xmlns` attribute when calculating the signature.

**Note**: The purpose of the server signature, is to validate the legal identity to other clients that have access to the server public keys.

**Note**: Server keys may change over time. If a signature does not validate, make sure to get the most recent public key from the server 
and check signature again.

Example:

```xml
<iq id='4' type='result' to='client@example.org/eb91cd17167933bcdb6860fbf095a98d' from='legal.example.org'>
   <identity id="24902199-6e17-46be-fc55-bae978c1fe10@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0">
      <clientPublicKey>
         <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
      </clientPublicKey>
      <property name="FIRST" value="Jon"/>
      <property name="LAST" value="Doe"/>
      <property name="PNR" value="123456789-0"/>
      <property name="ADDR" value="Street 1A"/>
      <property name="ZIP" value="12345"/>
      <property name="CITY" value="Metropolis"/>
      <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      <status created="2019-06-09T21:59:17.000"
              from="2019-06-09T00:00:00.000"
              provider="legal.example.org" 
              state="Created"
              to="2021-06-09T00:00:00.000"/>
      <serverSignature>JK6blBGAzEOD9Q4ica4NodNMO4Lt9prcaNl7T96YYvrYTtwfeyLMgsTHf1Dl+UqxCwWRb8wQl2YA2yljTyhEiFYXMIs8wBR1S0Nz7rBbbZO9SGMaJWKkrHMoAyHgales6k6sIVEFwAf+Q4l3Flnu8TwA</serverSignature>
   </identity>
</iq>
```

Identity state changes
----------------------------

Whenever the state of the legal identity is changed on the server, a message is sent to the bare JID of the account containing the identity,
in an `<identity/>` element. Identities must only be accepted, if the provider corresponds to the sender, and if the server signature is 
valid, and corresponds to the public key of the server.

Example:

```xml
<message to='client@example.org/8a7c35a7d545bfc83c6928f48e5fcb86' from='legal.example.org'>
   <identity id="2490219b-6e17-46c0-fc55-bae978192cf4@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0">
      <clientPublicKey>
         <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
      </clientPublicKey>
      <property name="FIRST" value="Jon"/>
      <property name="LAST" value="Doe"/>
      <property name="PNR" value="123456789-0"/>
      <property name="ADDR" value="Street 1A"/>
      <property name="ZIP" value="12345"/>
      <property name="CITY" value="Metropolis"/>
      <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      <status created="2019-06-09T21:59:23.000"
              from="2019-06-09T00:00:00.000"
              provider="legal.example.org"
              state="Approved"
              to="2021-06-09T00:00:00.000"
              updated="2019-06-09T21:59:24.000"/>
      <serverSignature>GnlKyllIGAfIDLoYTF8TyrsgzgR9dCVsf812gVjPfUoqzmUSF7d4qoxXV3zY7aEdjuJzoHx9/9eAkXqcRjILy727+cCCjwbTXhlwgAWHsKjfsbJC0pXX0QXGu6sVmxz8LchfrIAQi/YnBd+39zgURDUA</serverSignature>
   </identity>
</message>
```

Getting legal identity
---------------------------

You can get a legal identity from the server, if it belongs to you. You send the `<getLegalIdentity/>` element 
with the `id` attribute set to the identity of the legal identity object in an `<iq type='get'/>` to the server.

**Notes**:

* To get the legal identity from a signature, see `<validateSignature/>`.
* To get the legal identities related to contracts, see `<getLegalIdentities/>` element in the 
[Smart Contracts](/SmartContracts.md) namespace.

Example:

```xml
<iq type='get' id='5' to='legal.example.org'>
   <getLegalIdentity id="2490219b-6e17-46bf-fc55-bae9786b6757@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0"/>
</iq>
```

The server responds, after making sure you're authorized to view the identity, with 
an `<identity/>` object representing the legal identity you requested for.

Example:

```xml
<iq id='5' type='result' to='client@example.org/3179ba14cb1bbd5aa7d68003fc8aec48' from='legal.example.org'>
   <identity id="2490219b-6e17-46bf-fc55-bae9786b6757@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0">
      <clientPublicKey>
         <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
      </clientPublicKey>
      <property name="FIRST" value="Jon"/>
      <property name="LAST" value="Doe"/>
      <property name="PNR" value="123456789-0"/>
      <property name="ADDR" value="Street 1A"/>
      <property name="ZIP" value="12345"/>
      <property name="CITY" value="Metropolis"/>
      <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      <status created="2019-06-09T21:59:23.000" 
              from="2019-06-09T00:00:00.000" 
              provider="legal.example.org" 
              state="Created" 
              to="2021-06-09T00:00:00.000"/>
      <serverSignature>fR4LuS4Tg34dHY6NlyH9hB91RCdxNSYHWhqxbpYESXAotbnqNHUfbvhI7oEtEp7Lax2U0RPT8t+ADc5BZw0+iNQsRh7rkr+dwoV9iIswg9JQSsiLM7aNI2oZSP5n1zFrexD/3r1TeyGvnpFNtWnmqxQA</serverSignature>
   </identity>
</iq>
```

Validating signature
---------------------------

If an endpoint receives a signature on some data, referenced only through its legal identity ID, the endpoint can 
ask the Trust Provider hosting the legal identity to validate the signature. If it is valid, the Trust Provider 
returns the legal identity.

Example:

```xml
<iq type='get' id='5' to='legal.example.org'>
   <validateSignature
      data="UJCr/5nIuJdrijSdGpeQzW7XgPGKXXNVTwvN32zmW6aCeG2DttdeOGUbKx1..."
	  id="2490219e-6e17-46c2-fc55-bae978d9a180@legal.example.org"
	  s="urdAv/mtnKxG6I9WnStDNpAytiqW3/zN4KQefhFKBLV1tK9SC/JGd6QugxTC+f..."
	  xmlns="urn:nf:iot:leg:id:1.0"/>
</iq>
```

If the server finds the signature match the public key of the legal identity, it returns information
about the legal identity in an `<identity/>` element.

**Note**: You can use the `bareJid` attribute instead of the `id` attribute, to reference an account
on the Trust Providers. Current approved legal identities for this account will be used to validate
the signature.

**Note 2**: If omitting both the `id` and `bareJid` attributes, current approved legal identities 
of the sender will be used to validate the signature.

Example:

```xml
<iq id='5' type='result' to='client@example.org/3954d7dc9705417fcc09527bb4d98465' from='legal.example.org'>
   <identity id="2490219e-6e17-46c2-fc55-bae978d9a180@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0">
      <clientPublicKey>
         <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
      </clientPublicKey>
      <property name="FIRST" value="Jon"/>
      <property name="LAST" value="Doe"/>
      <property name="PNR" value="123456789-0"/>
      <property name="ADDR" value="Street 1A"/>
      <property name="ZIP" value="12345"/>
      <property name="CITY" value="Metropolis"/>
      <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      <status created="2019-06-09T21:59:26.000" 
              from="2019-06-09T00:00:00.000" 
              provider="legal.example.org" 
              state="Created" 
              to="2021-06-09T00:00:00.000"/>
      <serverSignature>2QhPLCgwudKChLoOYFAK04gePlGMyEkzHzjMDXMx9GU5EgM1SXi/pu/Uz6Huylhc80eBT2w9SGqAFzHtyVUC2oOU/K0Yne4cgxDKoxv58AKFG6PiFeFGZLnXYNFraJvpvvaIyfd8yctSzfhocN7irSoA</serverSignature>
   </identity>
</iq>
```

Obsoleting legal identity
---------------------------

A client can obsolete one of its legal identities on the server. The client sends the 
`<obsoleteLegalIdentity/>` element with the `id` attribute set to the identity of the 
legal identity object in an `<iq type='set'/>` to the server.

Example:

```xml
<iq type='set' id='5' to='legal.example.org'>
   <obsoleteLegalIdentity id="2490219b-6e17-46c0-fc55-bae978192cf4@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0"/>
</iq>
```

The server responds, after making sure you're authorized to update the identity, with 
an `<identity/>` object representing the updated legal identity.

Notes:

* Obsoleting a legal identity application (in `Created` state) automatically turns it 
to `Rejected`.
* Trying to obsolete a rejected or compromised identity returns a forbidden error.

Example:

```xml
<iq id='5' type='result' to='client@example.org/8a7c35a7d545bfc83c6928f48e5fcb86' from='legal.example.org'>
   <identity id="2490219b-6e17-46c0-fc55-bae978192cf4@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0">
      <clientPublicKey>
         <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
      </clientPublicKey>
      <property name="FIRST" value="Jon"/>
      <property name="LAST" value="Doe"/>
      <property name="PNR" value="123456789-0"/>
      <property name="ADDR" value="Street 1A"/>
      <property name="ZIP" value="12345"/>
      <property name="CITY" value="Metropolis"/>
      <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      <status created="2019-06-09T21:59:23.000" 
              from="2019-06-09T00:00:00.000" 
              provider="legal.example.org" 
              state="Obsoleted" 
              to="2021-06-09T00:00:00.000" 
              updated="2019-06-09T21:59:24.000"/>
      <serverSignature>GnlKyllIGAfIDLoYTF8TyrsgzgR9dCVsf812gVjPfUoqzmUSF7d4qoxXV3zY7aEdjuJzoHx9/9eAkXqcRjILy727+cCCjwbTXhlwgAWHsKjfsbJC0pXX0QXGu6sVmxz8LchfrIAQi/YnBd+39zgURDUA</serverSignature>
   </identity>
</iq>
```

Reporting a legal identity as compromised
---------------------------------------------

A client can report one of its legal identities as compromised on the server. The client 
sends the `<compromisedLegalIdentity/>` element with the `id` attribute set to the identity of the 
legal identity object in an `<iq type='set'/>` to the server.

Example:

```xml
<iq type='set' id='5' to='legal.example.org'>
   <compromisedLegalIdentity id="2490219d-6e17-46c1-fc55-bae9783cf992@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0"/>
</iq>
```

The server responds, after making sure you're authorized to update the identity, with 
an `<identity/>` object representing the updated legal identity.

Notes:

* Reporting a legal identity application (in `Created` state) as compromised 
automatically turns it to `Rejected`.
* Trying to report a rejected identity as compromised returns a forbidden error.

Example:

```xml
<iq id='5' type='result' to='client@example.org/032e50a69ad719e1e347661394fb6a45' from='legal.example.org'>
   <identity id="2490219d-6e17-46c1-fc55-bae9783cf992@legal.example.org" xmlns="urn:nf:iot:leg:id:1.0">
      <clientPublicKey>
         <ed448 pub="0nvHYWUD3BZZe96Nz8DROhpyg4FII4b2guBk2cQ7cSCc57sDMABWguYBIQ0zRtY+Y2L76CB7FI6A" xmlns="urn:nf:iot:e2e:1.0"/>
      </clientPublicKey>
      <property name="FIRST" value="Jon"/>
      <property name="LAST" value="Doe"/>
      <property name="PNR" value="123456789-0"/>
      <property name="ADDR" value="Street 1A"/>
      <property name="ZIP" value="12345"/>
      <property name="CITY" value="Metropolis"/>
      <clientSignature>RKeeeS7CdtKX0rbCitiI0dM6ZSCAGqoXcFYyNbNat9oJfQ1aeC4NvMWaI/XWhyyH328joYCkdciAoHrEZhH0bIxy2d1t9jO5zbL+BB10zRIors4I9wBpsUECxstNXr/Eokqkr1A+mcsLIykf/BgJyiAA</clientSignature>
      <status created="2019-06-09T21:59:25.000" 
              from="2019-06-09T00:00:00.000" 
              provider="legal.example.org" 
              state="Rejected" 
              to="2021-06-09T00:00:00.000" 
              updated="2019-06-09T21:59:25.000"/>
      <serverSignature>8cJy/lI4GuYP0wQ54z6mLA3Ojjr2K3H6OGzvYFsRCvWsywPT94tlpoXPB3eGR9wPdYlT73Qv0c2AekJolA6M1LyoQNd1ZDhDlxSAaDNpEUUtW2RmhCuZqtTWl1xrdEQTGWUPYnYBF5vKvA2dvOgRIiAA</serverSignature>
   </identity>
</iq>
```

Petitioning access to a legal identity
-----------------------------------------

TODO

Security considerations
------------------------------

### Client key compromised

In case the private key of the client is compromised, other entities will be able to sign using this key, and thus be able to create
fraudulent signatures in smart contracts. Since all signatures are attested by the server, these fraudulent signatures will be detected
if sent directly to other peers. To bypass this, an attacker would have to trick the server into attesting the signature. To do this,
the attacker would have to have access to the XMPP credentials also, to be able to connect as the client, and thus submit the fraudulent
signature using the correct account to the server. The server and peers subscribing to the presence of the client can detect this, since
an additional resource will be generated, and sent to presence subscribers.

To minimize the risk of attackers getting hold of both the private key, and the corresponding XMPP credentials of a client, these should
be stored in a protected storage, such as an encrypted database or key vault.

When suspecting a key might have been compromised, the compromised legal identity should be obsoleted by the client as soon as possible,
and a new key should be generated, and a new legal identity applied for. There is no need to update contracts, since these are validated
by the server signature, and parts can retrieve the legal identity history, with timestamps and states, of all parts in the contract.

Clients are also encouraged to regularly create new keys and corresponding legal identities. Servers can enforce this by assigning a
limited timestamp for an identity when approving it.

Clients should use keys with a security strength comparable to the server key security strength, with at least a minimum of 128, but
preferably greater, depending on use cases involved.

### Server key compromised

In case the private key of the server is compromised, other entities will be able to create fraudulent smart contracts in the name of the
server. Clients who are parts in a contract can always retrieve the contract from the server using the contract identity. Doing this allows
clients to compare the server contract with the fraudulent contract, and detect differences, or if the contract at all exists. An attacker
would have to have control of the server, to be able to introduce fraudulent contracts into the system.

To minimize the risk of attackers getting hold of both the server private key, as be able to inject smart contracts, these should
be stored in a protected storage, such as an encrypted database or key vault.

If the server generates a new private key, any server signatures in attested artefacts have to be recalculated to match the new public key.

The server should use a relatively high security strength for its keys, at least 192 or 256, depending on use case.

### Management of client signatures

Having access to a client signature, as well as the data on which the signature is calculated, provides the holder with the means
to access the information encoded in the legal identity as well. Therefore, client signatures should be handled as confidential,
by any entity who has been entrusted with the signatures.

Examples of where client signatures are used:

* In the encoding of the legal identities themselves. Having access to the legal identity, obviously already gives access to the same
legal identity. Care should be taken to manage the legal identities of others, since it is sensitive personal information.

* In signatures of smart contracts. Anyone with access to a signed smart contract, also have access to the contents and digital signatures
made by the legal identities signing the contracts. This gives the holder of the smart contract access to the legal identities of the
clients that have signed the contract, just as in the case of a normal contract. For this reason, care should be taken when managing 
smart contracts, and only give access to them to parties who are entrusted with managing the legal identities of the parts. Since the legal
identities are sensitive personal information, so are signed smart contracts.

* When a client signs something and presents the signature to a third party. By signing something, gives the receiver of the signature
access to the information in the legal identity.

**Note**: Having access to the information encoded with the legal identity does not give the holder the ability to forge signatures using the
legal identity. To sign something using the legal identity, access to the private keys is required. Private keys are not encoded with the
legal identity, or stored on the Trust Provider, or even presented to the Trust Provider. Only the client itself should have access to its
private keys.
