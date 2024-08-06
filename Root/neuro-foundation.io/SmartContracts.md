Title: Smart Contracts
Description: Smart Contracts page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Smart Contracts
=====================

Users with [legal identities](LegalIdentities.md) can sign smart contracts. Smart contracts are machine-readable contracts that are legally 
binding for the parts that have signed them. Smart contracts are divided into two parts: One container, that encapsulates the contract and 
provides state information and signatures. The second part is an XML document, whose semantic meaning is defined by the qualified name of 
the root. By providing XML schemas, the server can make sure contracts are well-defined and contain all required information. The server 
attests to the validity of the contents of the contract, its integrity and all signatures. Contracts can be used to automate different 
aspects in a smart city, such as provisioning for instance.

| Legal Identities                                                      ||
| ------------|----------------------------------------------------------|
| Namespace:  | `urn:nf:iot:leg:sc:1.0`                                  |
| Schema:     | [SmartContracts.xsd](Schemas/SmartContracts.xsd)         |


Motivation and design goal
----------------------------

The method of managing smart contracts, as described here, is designed with the following goals in mind:

* Smart Contracts must be both machine readable and human readable.

* The contents and legal integrity of each contract must be assured, and verifiable. The role of validating the integrity of a smart contract
is called an *electronic notary*.

* The contract model must support variable amounts of roles, parts and parameters, a completely customizable machine-readable section and
the possibility for multiple localizations of the human-readable section.

* To allow for automatic use of smart contracts, validated templates must be supported. Such templates have the integrity of their contents 
asserted by the electronic notary but may lack parameter values and signatures. Validated templates can be used as the foundation of 
creating new valid smart contracts.

* Contracts are signed using the cryptographic keys defined for the corresponding [legal identities](LegalIdentities.md) signing the 
contract. Parts of contracts may be from any domain in the federated network, as long as they have validated 
[legal identities](LegalIdentities.md). The signatures form cryptographic proof that the holder of the private key of corresponding
to the legal identity, has signed the contract.

* Contents of a contract must be updatable. Once signed by the first part, contract contents and parameters become immutable.

* Privacy must be considered. Access to contracts must be restricted to authorized individuals only. By default, this is restricted to
the parts of the contract, as well as the designated staff acting as electronic notaries of the operator (Trust Provider) that hosts the 
contract.

* Other entities can make petitions to access the personal information available in smart contracts. At least one part in the contract 
must consent before access to the contract can be granted, mimicking real-world management of contracts: Each part retains a copy of a 
contract, and can share it with others for their purposes. The other parts in a contract cannot deny this. But at least one part must 
consent before access to the smart contract can be granted.

* Contracts are limited in time. After being obsoleted, and after a specified archiving period specific to the contract, contracts must 
be purged from the corresponding domains.

* Contracts can have a variable number of signed attachments associated with it.

Contract structure
-----------------------

A smart contract is a specific type of object managed by a broker. Before going into the different operations that can be made on a smart 
contract, a brief introduction to the contract object, and its XML representation, is made.

```uml:Contract
@startuml
object contract
contract : id
contract : visibility
contract : canActAsTemplate
contract : duration
contract : archiveReq
contract : archiveOpt
contract : signAfter
contract : signBefore

object "~#~#any" as any
contract "1" *-- "1" any

object role
contract "1" *-- "*" role
role : name
role : minCount
role : maxCount

object description
role "1" *-- "1..*" description 

object parts
contract "1" *-- "0..1" parts

object part
parts "1" *-- "1..*" part
part : legalId
part : role

object open
parts "1" *-- "1" open

object templateOnly
parts "1" *-- "1" templateOnly

role "1" -- "*" part

note "Only one of these options are used." as N1
part .. N1
open .. N1
templateOnly .. N1

object parameters
contract "1" *-- "0..1" parameters

parameters "1" *-- "1..*" Parameter
Parameter : name

object "description" as description2
Parameter "1" *-- "1..*" description2

object stringParameter
Parameter <|-- stringParameter
stringParameter : value

object numericalParameter
Parameter <|-- numericalParameter
numericalParameter : value

object booleanParameter
Parameter <|-- booleanParameter
booleanParameter : value

object dateParameter
Parameter <|-- dateParameter
dateParameter : value

object dateTimeParameter
Parameter <|-- dateTimeParameter
dateTimeParameter : value

object timeParameter
Parameter <|-- timeParameter
timeParameter : value

object durationParameter
Parameter <|-- durationParameter
durationParameter : value

object humanReadableText
contract "1" *-- "1..*" humanReadableText

object signature
contract "1" *-- "0..*" signature
signature : legalId
signature : bareJid
signature : role
signature : timestamp
signature : s

object status
contract "1" *-- "0..1" status
status : provider
status : state
status : created
status : updated
status : from
status : to
status : templateId
status : schemaDigest
status : schemaHashFunction

object serverSignature
contract "1" *-- "0..1" serverSignature
serverSignature : timestamp
serverSignature : s

note "Each instance represents the same human readable text, but for different locales." as N2
description .. N2
description2 .. N2
humanReadableText .. N2
@enduml
```

### General properties

The root element is the `<contract/>` element. It contains general properties related to visibility, template usage and key time-points in the 
lifecycle of the contract:

| Attribute          | Type                 | Use      | Description                                                                            |
|:-------------------|:---------------------|:---------|----------------------------------------------------------------------------------------|
| `id`               | `xs:string`          | Optional | An identifier assigned to the contract. The identifier is formed as a JID but is not a JID. The domain part corresponds to the domain of the Trust Provider. A client must not include an identifier when it creates a contract on the Trust Provider. |
| `visibility`       | `ContractVisibility` | Required | What visibility the contract should have. |
| `canActAsTemplate` | `xs:boolean`         | Required | If the contract can act as a template for future contracts. |
| `duration`         | `xs:duration`        | Required | The duration of the contract. The duration is calculated from the time of the last required signature. |
| `archiveReq`       | `xs:duration`        | Required | After a legally binding contract expires, this attribute specifies for how long the contract is required to be persisted in the archives before it can be manually deleted. |
| `archiveOpt`       | `xs:duration`        | Required | After a legally binding contract expires, and the `archiveReq` period has expired, this attribute specifies an additional duration after which it is automatically deleted. |
| `signAfter`        | `xs:dateTime`        | Optional | Signatures will only be accepted after this point in time.[^SignatureAfterBefore] |
| `signBefore`       | `xs:dateTime`        | Optional | Signatures will only be accepted until this point in time.[^SignatureAfterBefore] |

[^SignatureAfterBefore]: `signAfter` (if provided) must occur before `signBefore` (if provided).

Possible values of the `ContractVisibility` enumeration:

| `ContractVisibility` | Description                                                                                                                            |
|:---------------------|:---------------------------------------------------------------------------------------------------------------------------------------|
| `CreatorAndParts`    | Contract is only accessible to the creator, and any parts in the contract.                                                             |
| `DomainAndParts`     | Contract is accessible to the creator of the contract, any parts in the contract, and any account on the Trust Provider server domain. |
| `Public`             | Contract is accessible by everyone requesting it. It is not searchable.                                                                |
| `PublicSearchable`   | Contract is accessible by everyone requesting it. It is also searchable.                                                               |

Following the opening tag, follows a sequence of child elements with different information and meanings. The following sub-sections describe these
child element, in the order they may appear in the contract representation.

### Machine-readable section

The first child element of the `<contract/>` element, can be any XML from any namespace. The fully qualified name (local name + namespace) is used by the 
reader of the contract to know what this machine-readable portion of the contract means. The namespace can also be used to select an XML Schema for
validation purposes.

One of the tasks during validation of the legal integrity of a newly created smart contract, is to validate that the machine-readable content is valid,
according to the fully qualified name of the top element, as well as make sure the contents correspond to any human-readable text provided in the contract.

### Roles

A contract may contain any number of pre-defined *roles*. A role assigns certain responsibilities to any part of the contract, signing for that role.
A role is assigned a *name*, as well as the smallest and largest amounts of parts signing the contract, for the contract to be valid. Each role is defined
using a `<role/>` element following the machine-readable element. The `<role/>` element contains the following attributes:

| Attribute          | Type                    | Use      | Description                                                                            |
|:-------------------|:------------------------|:---------|----------------------------------------------------------------------------------------|
| `name`             | `NonEmptyString`        | Required | Machine readable name of the role. |
| `minCount`         | `xs:nonNegativeInteger` | Required | Minimum number of signatures required for this role, to make the contract legal.[^A value of zero (0) defines an optional role.] |
| `maxCount`         | `xs:nonNegativeInteger` | Required | Maximum number of signatures allowed for this role. |
| `canRevoke`        | `xs:boolean`            | Optional | If parts having this role, can revoke their signature, once signed. (Default=`false`) |

Each `<role/>` element must have at least one `<description/>` element containing human-readable text containing a short description of the role. The 
languages used for each descriptive text is specified using the `xml:lang` attribute. The requirements placed on parts assigned the role can be described 
later in the human-readable contract text.

**Note**: Revoking a signature can be used as a means to model consent-based agreements. Consent, in a privacy perspective, can typically be 
revoked. Revoking a signature is done, by calling `obsoleteContract`.

### Parts

There are four different types of contract objects, as it relates to parts:

1.	The contract has one or more pre-defined parts. In that case, each part is defined in a `<part/>` element in in sequence inside a `<parts/>` element.
2.	The contract is an open contract. Anyone can sign the contract, given they have a valid [legal identity](LegalIdentities.md).
	In this case, an empty `<open/>` element is presented inside the `<parts/>` element.
3.	The contract is only used as a template and cannot be signed. In this case, an empty `<templateOnly/>` element is presented inside the `<parts/>` element.
4.	The contract reuses the parts defined in its template. In such a case, the contract lacks a `<parts/>` element.

If the contract defines parts, each one is defined in a `<part/>` element, using the following attributes:

| Attribute | Type             | Use      | Description                                                                            |
|:----------|:-----------------|:---------|----------------------------------------------------------------------------------------|
| `legalId` | `NonEmptyString` | Required | Refers to a legal identity representing a part of the contract. |
| `role`    | `NonEmptyString` | Required | Refers to one of the roles defined for the contract. |

### Parameters

When facilitating the generation of new meaningful contracts from templates, contracts can be *parametrized*. When creating new contracts from templates,
new parameter values can be provided, without the need to change the machine-readable or human-readable parts of the contract. If parameters are available
in the contract, they are defined inside a `<parameters/>` element. The type of parameter defined is determined by the local name of the parameter element.
Regardless of type, each parameter can have any number of `<description/>` elements containing localized human-readable text describing the parameter.
The languages used for each descriptive text is specified using the `xml:lang` attribute. When creating contracts from a template, descriptions need not 
to be provided if text is available in the template.

#### Parameter Types

Parameters are classified by the type of value they can contain. The following subsections describe the different parameter types available.
Parameter values are optional for templates and required for contracts.

##### String-valued parameters

String-valued parameters are defined using the `<stringParameter/>` element.

| Attribute     | Type                    | Use      | Description                                                                |
|:--------------|:------------------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString`        | Required | Name of the parameter within the scope of the contract.                    |
| `value`       | `xs:string`             | Optional | The value of the parameter.                                                |
| `guide`       | `xs:string`             | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`         | `xs:string`             | Optional | A simple script expression validating the parameter.                       |
| `regEx`       | `xs:string`             | Optional | Optional regular expression to validate the value of the string parameter. |
| `min`         | `xs:string`             | Optional | Optional minimum value of the parameter.                                   |
| `minIncluded` | `xs:boolean`            | Optional | If the `min` value is part of the valid range or not.                      |
| `max`         | `xs:string`             | Optional | Optional maximum value of the parameter.                                   |
| `maxIncluded` | `xs:boolean`            | Optional | If the `max` value is part of the valid range or not.                      |
| `minLength`   | `xs:nonNegativeInteger` | Optional | Optional minimum lenth of the value of the parameter.                      |
| `maxLength`   | `xs:PositiveInteger`    | Optional | Optional maximum lenth of the value of the parameter.                      |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Numerical parameters

Numerical parameters are defined using the `<numericalParameter/>` element.

| Attribute     | Type             | Use      | Description                                                                |
|:--------------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `value`       | `xs:decimal`     | Optional | The value of the parameter.                                                |
| `guide`       | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`         | `xs:string`      | Optional | A simple script expression validating the parameter.                       |
| `min`         | `xs:decimal`     | Optional | Optional minimum value of the parameter.                                   |
| `minIncluded` | `xs:boolean`     | Optional | If the `min` value is part of the valid range or not.                      |
| `max`         | `xs:decimal`     | Optional | Optional maximum value of the parameter.                                   |
| `maxIncluded` | `xs:boolean`     | Optional | If the `max` value is part of the valid range or not.                      |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Boolean parameters

Boolean parameters are defined using the `<booleanParameter/>` element.

| Attribute | Type             | Use      | Description                                                                |
|:----------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`    | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `value`   | `xs:boolean`     | Optional | The value of the parameter.                                                |
| `guide`   | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`     | `xs:string`      | Optional | A simple script expression validating the parameter.                       |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Date parameters

Date parameters are defined using the `<dateParameter/>` element.

| Attribute     | Type             | Use      | Description                                                                |
|:--------------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `value`       | `xs:date`        | Optional | The value of the parameter.                                                |
| `guide`       | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`         | `xs:string`      | Optional | A simple script expression validating the parameter.                       |
| `min`         | `xs:date`        | Optional | Optional minimum value of the parameter.                                   |
| `minIncluded` | `xs:boolean`     | Optional | If the `min` value is part of the valid range or not.                      |
| `max`         | `xs:date`        | Optional | Optional maximum value of the parameter.                                   |
| `maxIncluded` | `xs:boolean`     | Optional | If the `max` value is part of the valid range or not.                      |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Date & Time parameters

Date & time parameters are defined using the `<dateTimeParameter/>` element.

| Attribute     | Type             | Use      | Description                                                                |
|:--------------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `value`       | `xs:dateTime`    | Optional | The value of the parameter.                                                |
| `guide`       | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`         | `xs:string`      | Optional | A simple script expression validating the parameter.                       |
| `min`         | `xs:dateTime`    | Optional | Optional minimum value of the parameter.                                   |
| `minIncluded` | `xs:boolean`     | Optional | If the `min` value is part of the valid range or not.                      |
| `max`         | `xs:dateTime`    | Optional | Optional maximum value of the parameter.                                   |
| `maxIncluded` | `xs:boolean`     | Optional | If the `max` value is part of the valid range or not.                      |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Duration parameters

Duration parameters are defined using the `<durationParameter/>` element.

| Attribute     | Type             | Use      | Description                                                                |
|:--------------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `value`       | `xs:duration`    | Optional | The value of the parameter.                                                |
| `guide`       | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`         | `xs:string`      | Optional | A simple script expression validating the parameter.                       |
| `min`         | `xs:duration`    | Optional | Optional minimum value of the parameter.                                   |
| `minIncluded` | `xs:boolean`     | Optional | If the `min` value is part of the valid range or not.                      |
| `max`         | `xs:duration`    | Optional | Optional maximum value of the parameter.                                   |
| `maxIncluded` | `xs:boolean`     | Optional | If the `max` value is part of the valid range or not.                      |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Time parameters

Date parameters are defined using the `<timeParameter/>` element.

| Attribute     | Type             | Use      | Description                                                                |
|:--------------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `value`       | `xs:time`        | Optional | The value of the parameter.                                                |
| `guide`       | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |
| `exp`         | `xs:string`      | Optional | A simple script expression validating the parameter.                       |
| `min`         | `xs:time`        | Optional | Optional minimum value of the parameter.                                   |
| `minIncluded` | `xs:boolean`     | Optional | If the `min` value is part of the valid range or not.                      |
| `max`         | `xs:time`        | Optional | Optional maximum value of the parameter.                                   |
| `maxIncluded` | `xs:boolean`     | Optional | If the `max` value is part of the valid range or not.                      |
| `transient`   | `xs:boolean`     | Optional | If parameter is transient or not.                                          |

##### Calculation parameters

Calculation parameters are formulas, that calculate a value based on the input of other parameters. They are defined
using the `<calcParameter/>` element. Expressions used to calculate values reference other parameter values by name.
Only non-calculation parameters (anywhere in the contract), or calculation parameters defined before a calculation 
parameter being evaluated, can be referenced however, in order to avoid circular recursion.

| Attribute     | Type             | Use      | Description                                                                |
|:--------------|:-----------------|:---------|----------------------------------------------------------------------------|
| `name`        | `NonEmptyString` | Required | Name of the parameter within the scope of the contract.                    |
| `exp`         | `xs:string`      | Optional | A simple script expression providing the value of the parameter.           |
| `guide`       | `xs:string`      | Optional | A guiding text, that can be displayed to a user if no value is available.  |

#### Parameter Validation

Parameters can have optional validation rules attached to them. Some apply to only one parameter type, others apply to different parameter
types. The following subsections lists available validation rules that can be applied.

**Note**: A server must not allow the creation of contracts whose parameters break validation rules. When creating a contract from a
template, it is also important to assure that client does not attempt to change types of parameters, and any validation rules defined
in the template.

##### Range validation

A valid range can be specified using four optional attributes: `min`, `max`, `minIncluded` and `maxIncluded`. Open ranges can be
specified by omitting either `min` or `max`. Ranges include the endpoints by default. By excluding them, set the `minIncluded` or
`maxIncluded` to `false` respectively. Comparison is done in accordance with the underlying parameter data type.

##### Size validation

The size of a string parameter value can be controlled by the two optional attributes `minLength` and `maxLength`. By omitting both, no
size limits are imposed. By omitting one, no limit in the corresponding direction exists.

##### Regular Expression validation

String parameters can be validated using regular expressions. Named groups can be used to extract parts of the value, and referencing them
from mathematical expression validation rules.

**Note**: Due to lack of standards for regular expressions, evaluation of expressions is done mainly on the server side, and is considered
implementation specific. A client or a peer that understands the syntax of a regular expression, can use it to guide users in user interfaces
during the creation of a contract. But when retrieving a created contract, it is assumed servers have already validated parameter values 
before allowing the contract to be created. Still, most regular expression dialects share common elements, which makes common regular 
expressions understandable across clients and technology boundaries.

##### Mathematical Expression validation

Parameters, as a set, can be validated using mathematical script expressions. Such expressions may refer to parameter values using their
parameter names, and use common arithmetic and comparison operators to impose rules on valid values, referencing multiple parameters in
a single expression. Expressions may also reference intrinsic contract properties. The following table lists such contract properties:

| Property   | Type          | Description                    |
|:-----------|:--------------|:-------------------------------|
| `Duration` | `xs:duration` | The duration of the contract . |

**Note**: Evaluation of mathematical expressions is done mainly on the server side, and is considered implementation specific. A client or 
a peer that understands the syntax of an expression, can use it to guide users in user interfaces during the creation of a contract. But 
when retrieving a created contract, it is assumed servers have already validated parameter values before allowing the contract to be created.
Still, common operators (`+`, `-`, `*`, `/`, `<`, `>`, `=`, `!=`, `<=`, `>=`, `!`) are often understood by many expression evaluators, which 
makes common expressions understandable across clients and technology boundaries.

##### Transient parameters

Transient parameters are parameters whose values are only available *in transit*, i.e. they are not persisted together with the contract.
Instead, the values are replaced by GUID values, and the actual values are transmitted outside the scope of the contract. All signatures
are calculated on the GUIDs, not the actual parameter values.

Transient parameter can be used in special circumstances where special care has to be made to protect the privacy or confidentiality of
the underlying information, but still use smart contracts and digital signatures to show that the signatories have agreed on the terms
of the contract. Examples can inlclude sensitive information such as choices during closed voting procedures, credit card details for
payments, etc.

### Human-readable text

Human-readable text matching the machine-readable contents defined in the first contract element is defined in one or more `<humanReadableText/>`
elements. if specifying multiple elements, the `xml:lang` attribute is used to specify the language used for each element. When validating the
consistency and legal integrity of the contract, the electronic notary must validate that each human-readable section corresponds to the machine-readable
contents of the contract, and that the content is legal.

All human-readable text, whether it is defined using the `<humanReadableText/>` element, or any of the `<description/>` elements, consists of a sequence
of one or more *block elements*, defined in the following subsections.

#### Block elements

Block elements define blocks of text, typically ordered vertically in a flowing text.

##### Paragraphs

Paragraphs of human-readable text are defined using `<paragraph/>` elements. Paragraphs take a sequence of one or more *inline elements*.

##### Sections

Sections and sub-sections are defined using the `<section/>` element. Each `<section/>` element contains a `<header/>` element and a `<body/>` element.
The `<header/>` element contains one or more *inline elements*, while the `<body/>` element contains one or more *block elements*. Nested use of
the `<section/>` element creates sub-sections to the current section. Any level of nesting is permitted by the representation.

##### Bullet lists

Bullet lists are defined using the `<bulletItems/>` element. Each item in the list is defined in a separate `<item/>` element, each one containing
one or more *inline elements*.

##### Numbered lists

Numbered lists are defined using the `<numberedItems/>` element. Each item in the list is defined in a separate `<item/>` element, each one containing
one or more *inline elements*.

#### Inline elements

Inline elements define portions of human-readable text, typically ordered horizontally in a flowing text, with the exception of word-wrapping along
any margins.

##### Readable text

Readable text is provided using the `<text/>` element. The actual text is provided between the start and ending tag of the element.

##### parameter

A reference to a parameter value is made using the `<parameter/>` element. The element is replaced by the value of the parameter being referenced.
This removes the need to edit the human-readable text, just because parameters vary across contracts. The parameter being referenced is defined in the
`name` attribute of the element.

##### Bold text

Bold text is specified using the `<bold/>` element. It contains a sequence of one or more *inline elements*.

##### Italic text

Italic text is specified using the `<italic/>` element. It contains a sequence of one or more *inline elements*.

##### Underlined text

Underlined text is specified using the `<underline/>` element. It contains a sequence of one or more *inline elements*.

##### Strike-through

Text that is stricken through is specified using the `<strikeThrough/>` element. It contains a sequence of one or more *inline elements*.

##### Super-script

Super-script text is specified using the `<super/>` element. It contains a sequence of one or more *inline elements*.

##### Sub-script

Sub-script text is specified using the `<sub/>` element. It contains a sequence of one or more *inline elements*.

### Signatures

Following the human-readable text, comes signatures made by parts in the contract. Each signature is represented by a `<signature/>` element.
Signatures are calculated using the private key corresponding to the [legal identity](LegalIdentities.md) performing the signature. It is calculated
on the contract contents according to the following rules:

* Signatures are calculated on the contract element excluding the `id` attribute and the `<signature/>`, `<status/>` and `<serverSignature/>` elements.
* All text nodes and attribute values are normalized (using Unicode NFC).
* Unnecessary whitespace is removed.
* The SPACE character is the only allowed whitespace.
* `&`, `<`, `>`, `"` and `'` consistently escaped to `&amp;`, `&lt;`, `&gt;`, `&quot;` and `&apos;` respectively.
* Empty elements are closed using `/>` (without whitespace).
* XML Attributes are serialized in alphabetical order, using double quotes.
* The `xmlns` attribute of the `<contract/>` element is omitted. The Smart Contract namespace used by the client is assumed.[^Versioning] 
The `xmlns` attribute is then only used when needed to define new default namespaces or namespace prefixes.
* The generated content is UTF-8 encoded before being signed.

[^Versioning]: The reasoning behind omitting the namespace declaration of the `<contract/>` element, is to allow the protocol version to be increased,
without affecting signatures. It would also allow clients using different versions of the communication protocol, to agree on signatures for the
contracts object, as long as unrecognized elements and attributes are normalized and ordered according to the rules defined.

The attributes available for the `<signature/>` element are:

| Attribute   | Type              | Use      | Description                                                                            |
|:------------|:------------------|:---------|----------------------------------------------------------------------------------------|
| `legalId`   | `NonEmptyString`  | Required | The ID of the legal identity used to generate the signature. |
| `bareJid`   | `NonEmptyString`  | Required | The Bare JID of the client used to generate the signature. |
| `role`      | `NonEmptyString`  | Required | The role the legal identity assumes when signing the contract. |
| `timestamp` | `xs:dateTime`     | Required | When the signature was generated. |
| `s`         | `xs:base64Binary` | Required | Digital signature generated by the corresponding asymmetric cipher algorithm. |

### Contract Status

The broker (i.e. Trust Provider) hosting the contract, and attesting to the validity, consistency and integrity of the contract, adds a `<status/>` 
element describing the current status of the contract object. The status object is created and managed by the Trust Provider.
Authorized clients can always get the latest version of the contract by requesting it from the trust provider, given the `id` of the contract.
The `<status/>` element contains the following attributes:

| Attribute            | Type              | Use      | Description                                                                            |
|:---------------------|:------------------|:---------|----------------------------------------------------------------------------------------|
| `provider`           | `NonEmptyString`  | Required | JID of Trust Provider validating the correctness of the contract. |
| `state`              | `ContractState`   | Required | Contains information about the current statue of the contract. |
| `created`            | `xs:dateTime`     | Required | When the contract was first created. |
| `updated`            | `xs:dateTime`     | Optional | When the contract was last updated. |
| `from`               | `xs:dateTime`     | Optional | From when the contract is legally binding. |
| `to`                 | `xs:dateTime`     | Optional | Until when the contract is legally binding. |
| `templateId`         | `NonEmptyString`  | Optional | Contract ID of template used to create the contract. |
| `schemaDigest`       | `xs:base64Binary` | Optional | If the contents element has been validated using a schema, the hash digest of the schema used, base64 encoded, will be made available here. |
| `schemaHashFunction` | `HashFunction`    | Optional | The Hash function used to compute the Hash Digest. |

Possible states of a contract is defined by the `ContractState` enumeration. Possible values are:

| `ContractState` | Description                                                                                                                            |
|:----------------|:---------------------------------------------------------------------------------------------------------------------------------------|
| `Proposed`      | The contract has been proposed as a new contract. It needs to be reviewed and approved by the Trust Provider before it can be used as a template or be signed. |
| `Rejected`      | The contract has been deemed incomplete, inconsistent, or otherwise faulty. A rejected contract cannot be used as a template or be signed. A rejected contract can be updated by the creator, and thus be put in a Proposed state again. |
| `Approved`      | The contract has been reviewed and approved. It is still not signed, but can act as a template for other contracts. |
| `BeingSigned`   | The contract is being signed. Not all required roles have signed however, and the contract is not legally binding. |
| `Signed`        | The contract has been signed by all required parties, and is legally binding. |
| `Failed`        | The contract, once signed, has either manually, or automatically, been deemed failed, by the Trust Provider. This can happen when any of the parties fail to fulfill their obligations as defined by the contract. |
| `Obsoleted`     | The contract has been explicitly obsoleted by its owner, or by the Trust Provider. |

Possible values of the `HashFunction` enumeration are:

| `HashFunction` | Description                                                                                                                            |
|:---------------|:-----------------------|
| `SHA256`       | SHA-256 Hash function. |
| `SHA384`       | SHA-384 Hash function. |
| `SHA512`       | SHA-512 Hash function. |

### Server Attestation

The Trust Provider always attests any changes made to the contract object. This attestation is made available in a `<serverSignature/>` element at the end,
which can be verified by clients.[^PublicKey] Server Signatures are calculated using the private key of the Trust Provider. It is calculated
on the contract contents according to the following rules:

* Signatures are calculated on the contract element excluding the `<serverSignature/>` element.
* All text nodes and attribute values are normalized (using Unicode NFC).
* Unnecessary whitespace is removed.
* The SPACE character is the only allowed whitespace.
* `&`, `<`, `>`, `"` and `'` consistently escaped to `&amp;`, `&lt;`, `&gt;`, `&quot;` and `&apos;` respectively.
* Empty elements are closed using `/>` (without whitespace).
* XML Attributes are serialized in alphabetical order, using double quotes.
* The `xmlns` attribute of the `<contract/>` element is omitted. The Smart Contract namespace used by the client is assumed.[^Versioning] 
The `xmlns` attribute is then only used when needed to define new default namespaces or namespace prefixes.
* The generated content is UTF-8 encoded before being signed.

[^PublicKey]: The public key used to validate a signature of a Trust Provider can be retrieved using `<getPublicKey/>` request, 
as defined in [legal identities](LegalIdentities.md). Server keys may change over time. If a signature does not validate, make sure to get the most 
recent public key from the server and check signature again.

The attributes available for the `<serverSignature/>` element are:

| Attribute   | Type              | Use      | Description                                                                            |
|:------------|:------------------|:---------|----------------------------------------------------------------------------------------|
| `timestamp` | `xs:dateTime`     | Required | When the signature was generated. |
| `s`         | `xs:base64Binary` | Required | Digital signature generated by the corresponding asymmetric cipher algorithm. |


Creating a new contract
-----------------------------

To create a new smart contract in the account of the sender, a `<createContract/>` element is sent in an `<iq type="set"/>` stanza to the Trust Provider.
The expected response in a `<contract/>` element with the created contract. There are two options to the client creating a new contract:

1. Create a completely new contract.
2. Create a contract based on an existing template.

**Note**: The client creating a contract is required to have a valid legal identity to create a contract, even if the contract is not signed. It is the
legal identity that is considered the creator of the new contract.

### Creating a completely new contract

When creating a completely new contract, the `<createContract/>` element simply includes a `<contract/>` element specifying the contract it wishes to
create. The Trust Provider validates the consistency of the request and makes sure no rules are broken. If passing all tests, a new contract object
with a new identity is created in the `Proposed` state and returned to the client.

**Note**: A contract has to be reviewed and approved by the electronic notary of the Trust Provider before the contract can be signed. The review-process is 
performed out-of-band.

If an XML schema is available on the server defining the structure of the machine-readable contents of the contract, based on its qualified name, 
it will be used to validate the contents of the contract. If that validation fails, an error is returned, and the contract is not created. If validation 
succeeds, information about this will be made available in the state portion of the contract. XML Schemas can either be registered with the Trust Provider 
out-of-band, or downloaded by the Trust Provider automatically, if accessible through the namespace URI, if it's using a downloadable URI scheme. The XML 
Schema must not contain processing instructions.

Whenever a contract is created on the server, a `<message/>` stanza is sent to the bare JIDs of all parties of the contract, including the 
creator if not signed, containing a reference to the created contract in a `<contractCreated/>` element. The element contains only a `contractId` attribute 
containing the identity of the contract that has been created.

### Creating a contract based on a template

By referencing a reviewed and approved contract instead of creating an absolutely new one, the legal identity can skip the review and approval steps 
otherwise required when creating a new contract. The client must be authorized to access the referenced contract, in order to be able to create new 
contracts based on the referenced one. The referenced contract must also permit it being used as a template (having the `canActAsTemplate` attribute set
to `true`. The new contract will contain the same information available in the template contract, except for certain properties that are allowed to be 
changed:

* Parts of the contract may change.
* Parameter values may be changed.
* Visibility and duration properties can be changed.
* The new contract will receive a new identity.

To create a new contract based on a template, the `<createContract/>` element includes a `<template/>` element specifying the referenced template contract,
together with the changes to make. The following attributes are available for the `<template/>` element:

| Attribute          | Type                 | Use      | Description                                                                            |
|:-------------------|:---------------------|:---------|----------------------------------------------------------------------------------------|
| `id`               | `xs:string`          | Required | The identifier of a contract the legal identity wishes to base the new contract on (i.e. act as template for the new contract). Contract must exist, be well-defined, and be in an `Approved`, `BeingSigned` or `Signed` state to be used. Referencing contracts that are `Proposed`, `Obsolete`, `Rejected` or `Failed` will result in a failure. If the contract resides on another trust provider, the actual trust provider must first get it using `<getContract/>`. If not able to, the operation fails. Contract IDs are case insensitive in searches and references. |
| `visibility`       | `ContractVisibility` | Required | What visibility the contract should have. |
| `canActAsTemplate` | `xs:boolean`         | Required | If the contract can act as a template for future contracts. |
| `duration`         | `xs:duration`        | Required | The duration of the contract. The duration is calculated from the time of the last required signature. |
| `archiveReq`       | `xs:duration`        | Required | After a legally binding contract expires, this attribute specifies for how long the contract is required to be persisted in the archives before it can be manually deleted. |
| `archiveOpt`       | `xs:duration`        | Required | After a legally binding contract expires, and the `archiveReq` period has expired, this attribute specifies an additional duration after which it is automatically deleted. |
| `signAfter`        | `xs:dateTime`        | Optional | Signatures will only be accepted after this point in time.[^SignatureAfterBefore] |
| `signBefore`       | `xs:dateTime`        | Optional | Signatures will only be accepted until this point in time.[^SignatureAfterBefore] |

If the new contract has modified parts, the `<template/>` element must contain a `<parts/>` element containing the parts the new contract is supposed to
include. The structure of the `<parts/>` element is the same as for the `<contract/>` element. Descriptive texts will be copied from the template, if
new texts are not provided.

If the new contract has modified parameter values, the `<template/>` element must contain a `<parameters/>` element containing the new parameter values
the new contract is supposed to use. The structure of the `<parameters/>` element is the same as for the `<contract/>` element but must not contain 
parameters not available in the referenced template contract. Parameters in the template not referenced in the `<template/>` element are used as-is,
and simply copied into the new contract. There is therefore no need to copy all parameters, if the new contract will be using the same values as the
template does.

Whenever a contract is created on the server, a `<message/>` stanza is sent to the bare JIDs of all parties of the contract, including the 
creator if not signed, containing a reference to the created contract in a `<contractCreated/>` element. The element contains only a `contractId` attribute 
containing the identity of the contract that has been created.

### Getting created contracts

A client can send a `<getCreatedContracts/>` element in an `<iq type="get"/>` stanza to a Trust Provider, to retrieve a list (possibly empty) of 
contracts created by the legal identity of the client on the provider. The expected response element is `<contractReferences/>`, if references
are to be returned, which contains a sequence of `<ref/>` elements, each one containing a reference to a contract in its `id` attribute.
Otherwise, a `<contracts>` element will be returnedwith a sequence of `<contract>` elements containing the actual contracts.

Attributes for request:

| Attribute    | Type                    | Use      | Description                                                         |
|:-------------|:------------------------|:---------|---------------------------------------------------------------------|
| `offset`     | `xs:nonNegativeInteger` | Optional | Result will start with the response at this offset into result set. |
| `maxCount`   | `xs:positiveInteger`    | Optional | Result will be limited to this number of items.                     |
| `references` | `xs:boolean`            | Optional | If references to contracts are to be returned. Default=`true`       |


### Getting a contract

To retrieve a specific contract given its ID, a client sends a `<getContract/>` element in an `<iq type="get"/>` stanza to a Trust Provider. 
The element only contains an `id` attribute, which must be set to the contract identity that the client wishes to get.
The server only returns contracts registered on itself. It also authorizes all request, only returning 
contracts the client is authorized to see. Expected response element is `<contract/>`.

If the client represents a part with a legal identity registered on a Trust Provider ("legal identity host") different from the Trust Provider hosting the 
contract ("contract host"), the contract host must check that the network identity used by the sender of the request, corresponds to any of the legal 
identities used by parts in the contract, before returning contracts limited to its parts to the client. This is done by sending an `<isPart/>` element in 
an `<iq type="get"/>` stanza from the contract host to the legal identity host. The element contains a `bareJid` attribute with the bare network identity
to check. The element also contains one or more `<idRef/>` child elements, each with an `id` attribute containing a legal identity hosted by the legal 
identity host. The expected response is a `<part/>` element, whose value is a `xs:boolean` showing if the Bare JID is related to any of the legal identities
referenced in the request.

**Note**: This request automatically fails if the request is sent by a client.


### Getting a set of contracts

To retrieve a set of contracts given their IDs, a client sends a `<getContracts/>` element in an `<iq type="get"/>` stanza to a Trust Provider. 
The element contains a sequence of `<ref/>` elements, each one with an `id` attribute, which must be set to the contract identity of each contract
that the client wishes to get. The server only returns contracts registered on itself. It also authorizes all request, only returning 
contracts the client is authorized to see. Expected response element is `<contracts/>`. All contracts that are found, and that the client
is authorized to see are returned in `<contract/>` child elements. All others are returned as references, with a `<ref/>` element.

Working with contracts
-------------------------

Once a contract has been created, it can be modified is various ways, by referencing its identity. The following subsections describe different
operations that can be made on contracts. Parts of contracts are always informed about changes made to contracts as they occur.

### Updating a contract

To update an existing contract, the creator sends an `<updateContract/>` element in an `<iq type="set"/>` stanza to the Trust Provider.
The expected response is a `<contract/>` element with the updated contract. The `<updateContract/>` element must include a `<contract/>` element 
specifying the updated contract. The Trust Provider validates the consistency of the request and makes sure no rules are broken. The expected
response element is `<contract/>`, with the updated contract.

**Notes**:

* Only contracts that are `Proposed`, `Rejected`, `Approved` (but without signatures) and `Obsoleted` (but without signatures) can be updated.
* If the contract is Approved, the contract will be put in a `Proposed` state after the update, with one exception: If the parameters 
validate, and the contract is based on a template, and only parameter values have changed within the valid range of each parameter, and
no other changes have been made to the contract, the contract will remain Approved.

If an XML schema is available on the server defining the structure of the machine-readable contents of the contract, based on its qualified name, 
it will be used to validate the contents of the contract. If that validation fails, an error is returned, and the contract is not created. If validation 
succeeds, information about this will be made available in the state portion of the contract. XML Schemas can either be registered with the Trust Provider 
out-of-band, or downloaded by the Trust Provider automatically, if accessible through the namespace URI, if it's using a downloadable URI scheme. The XML 
Schema must not contain processing instructions.


### Contract updates

Whenever the state of the contract is changed on the server, a `<message/>` stanza is sent to the bare JIDs of all parties of the contract, including the 
creator if not signed, containing a reference to the updated contract in a `<contractUpdated/>` element. The element contains only a `contractId` attribute 
containing the identity of the contract that has been updated. If the contact is deleted, a `<contractDeleted/>` element is sent instead.

**Note**: Only the contract identity is sent, not the contract itself. It is up to each recipient if they are interested in retrieving the latest version of 
the contract or not. Access to the contract is only granted to authorized clients, however.


### Signing a contract

To sign a contract, a client sends a `<signContract/>` element in an `<iq type="set"/>` stanza to the Trust Provider hosting the contract that the 
client wants to sign. The expected response element is the `<contract/>` element, containing the updated contract object. The signature must be calculated
using the algorithm provided above. Attributes of the `<signContract/>` element are:

| Attribute          | Type                 | Use      | Description                                                                            |
|:-------------------|:---------------------|:---------|----------------------------------------------------------------------------------------|
| `id`               | `xs:string`          | Required | Identifier of the contract to sign. |
| `role`             | `NonEmptyString`     | Required | The role the legal identity assumes when signing the contract. |
| `transferable`     | `xs:boolean`         | Optional | A transferable signature. Can be transferred to contracts that are based on the current contract. This is done however, only if all parameters and attributes remain the same in the new contract. (Changing any of the attributes or parameters of the contract will break the signature, and the signature will not be transferred to the new contract.) Default value is `false`. |
| `s`                | `xs:base64Binary`    | Required | Digital signature generated by the corresponding asymmetric cipher algorithm used by the legal identity of the client performing the signature. |

When a contract has been successfully signed by a part, the Trust Provider sends notification messages to concerned entities. These are `<message/>`
stanzas containing a `<contractSigned/>` element notifying the receiver of a new signature. It is sent between Trust Providers if the smart contract 
and the legal identity are hosted on separate brokers. It is also sent to the creator and parts of a contract, if a new signature has been added.

**Note**: To validate the signature, the contract, and possibly some keys, have to be retrieved and validated.

Attributes of the `<contractSigned/>` element are:

| Attribute          | Type                 | Use      | Description                                                                            |
|:-------------------|:---------------------|:---------|----------------------------------------------------------------------------------------|
| `contractId`       | `xs:string`          | Required | The identity of the contract that has received the signature. |
| `legalId`          | `xs:string`          | Required | The legal identity that has signed the contract. |

**Note**: It is up to the receiver of the notification message, if they want to download a new version of the contract, including the new signature, or not.
Access to the contract is only granted to authorized clients, however.

**Note**: A client can choose to sign a contract on the same broker/provider as its legal identity is defined on, or on the broker/provider hosting the 
contract, if they are different. In the first case, the request is forwarded to the second provider hosting the contract, and the response is likewise 
forwarded back to the client. The first broker takes the opportunity to record the signature as well, in case the request is successful. In the second case, 
the first broker hosting the legal identity of a successful signature is simply informed by the broker hosting the contract of the signature via the
`<contractSigned/>` notification message.

### Getting signed contracts

A client can send a `<getSignedContracts/>` element in an `<iq type="get"/>` stanza to its Trust Provider, to retrieve a list (possibly empty) of 
contracts signed by the legal identity of the client on the provider. The expected response element is `<contractReferences/>`, if references
are to be returned, which contains a sequence of `<ref/>` elements, each one containing a reference to a contract in its `id` attribute.
Otherwise, a `<contracts>` element will be returnedwith a sequence of `<contract>` elements containing the actual contracts.

Attributes for request:

| Attribute    | Type                    | Use      | Description                                                         |
|:-------------|:------------------------|:---------|---------------------------------------------------------------------|
| `offset`     | `xs:nonNegativeInteger` | Optional | Result will start with the response at this offset into result set. |
| `maxCount`   | `xs:positiveInteger`    | Optional | Result will be limited to this number of items.                     |
| `references` | `xs:boolean`            | Optional | If references to contracts are to be returned. Default=`true`       |


### Obsoleting a contract

To obsolete one of its contracts, a client sends a `<obsoleteContract/>` element in an `<iq type="set"/>` stanza to the Trust Provider hosting the 
contract that the client wants to obsolete. The element only contains an `id` attribute, which must be set to the contract identity that the client 
wishes to obsolete. Expected response element is `<contract/>`.

**Notes**: 

* A contract that is legally binding cannot be obsoleted.
* Obsoleting a proposed contract that has not been approved, automatically turns it to `Rejected`.
* Trying to obsolete a rejected or legally binding contract returns a forbidden error.
* `<contractUpdated/>` message notifications are generated when contracts are obsoleted.


### Deleting a contract

To delete one of its contracts, a client sends a `<deleteContract/>` element in an `<iq type="set"/>` stanza to the Trust Provider hosting the 
contract that the client wants to delete. The element only contains an `id` attribute, which must be set to the contract identity that the client 
wishes to delete. Expected response element is `<contract/>`.

**Notes**: 

* A contract that is legally binding cannot be deleted before its required archive duration has expired.
* `<contractDeleted/>` message notifications are generated when contracts are obsoleted.

### Getting legal identities of a contract

A client can get a list of legal identities related to parts in a contract the client has access to. This is done by sending a `<getLegalIdentities/>`
element in an `<iq type="get"/>` stanza to the Trust Provider. The `<getLegalIdentities/>` has the following attributes:

| Attribute          | Type                 | Use      | Description                                                                            |
|:-------------------|:---------------------|:---------|----------------------------------------------------------------------------------------|
| `contractId`       | `xs:string`          | Required | The identity of the contract whose legal identities are requested. |
| `current`          | `xs:boolean`         | Optional | By default, the legal identities returned correspond to the timestamp of their signatures. This allows the cryptographic signatures to be validated. If the current legal identities of the corresponding signatures is desired, this attribute should be set to `true`. If keys have been updated, they cannot be used for validating the corresponding cryptographic signature in the contract. Default value is `false`. |
| `historic`         | `xs:boolean`         | Optional | By default, the legal identities returned correspond to the timestamp of their signatures. This allows the cryptographic signatures to be validated. If this identity is not desired, this attribute should be set to `false`. Default value is `true`. |

The expected response is an `<identities/>` element from the [legal identities](LegalIdentities.md) namespace.

**Notes**:

* Both current and historic cannot both be `false`. Both can be `true`.
* Only clients authorized to view the contract itself, are allowed to view its associated legal identities.
* Request is authorized only if (1) the client has access to smart contract, or (2) sender is the same domain hosting the referenced contract.
* If the request is sent to the Trust Provider on which the contract is hosted, all legal identities are returned, if authorized.
* If the request is sent to a different Trust Provider, only legal identities on that Trust Provider, associated with the contract are returned, 
if the sender is the same as the domain of the referenced contract.

### Getting network identities related to a contract

A client can get a list of network identities associated with the legal identities that have signed a contract. This is done by sending a 
`<getNetworkIdentities/>` element in an `<iq type="get"/>` stanza to the Trust Provider. The `<getNetworkIdentities/>` has one attribute `contractId`,
which is used to identify the contract.

The expected response is a `<networkIdentities/>` element. It contains a sequence of `<networkIdentity/>` elements, each one relating a network identity
with a corresponding legal identity using the attributes `bareJid` for the network identity, and `legalId` for the legal identity.

**Notes**:

* If the request is sent to the Trust Provider on which the contract is hosted, all network identities are returned, if authorized.
* If the request is sent to a different Trust Provider, only network identities on that Trust Provider, associated with the contract are returned, 
if the sender is the same as the domain of the referenced contract.
* Only clients authorized to view the contract itself, are allowed to view its associated network identities.
* Request is authorized only if (1) the client has access to smart contract, or (2) sender is the same domain hosting the referenced contract.

### Proposing a contract to a new party

Once a contract is created, and made available for signing, the creator can inform parties about the contract proposal. This is done by
sending a normal message stanza directly to the indended parties, containing a `contractProposal` element. The client receiving such a
message, can decide wether they wish to review the contract, and proposed role.

The `contractProposal` element takes the following attributes:

| Attribute          | Type                 | Use      | Description                                                                            |
|:-------------------|:---------------------|:---------|----------------------------------------------------------------------------------------|
| `contractId`       | `xs:string`          | Required | The identity of the proposed contract. |
| `role`             | `xs:string`          | Required | The proposed role of the recipient in the proposed contract. |
| `message`          | `xs:string`          | Optional | An optional message to present to the recipient. |


Working with schemas
-------------------------

The Trust Provider uses schemas to validate the machine-readable sections of smart contracts, if it can. These schemas can be either downloaded 
automatically, if the namespace corresponds to a URL from which the schema can be downloaded, or they can be uploaded to the Trust provider out-of-band,
by its operator. Clients can access the schemas used by the Trust Provider, if it wants.

### Getting a list of available schemas

A client can get a list of XML Schemas available on the Trust Provider, by sending a `<getSchemas/>` element in an `<iq type="get"/>` stanza to it.
The expected response is a `<schemas/>` element which contains a sequence of `<schemaRef/>` elements. Each `<schemaRef/>` element references a
schema namespace in its `namespace` attribute. The element also contains a sequence of at least one `<digest/>` element, each one representing a
specific version of the schema. The `<digest/>` element specifies the hash function used in a `function` attribute and contains the base64-encoded
digest as a value of the element. The digest is simply computed over the binary representation of the corresponding XML schema file.

### Getting a specific schema

To get the contents of a specific schema, the client sends a `<getSchema/>` element in an `<iq type="get"/>` stanza to the Trust Provider. The
namespace is specified in the `namespace` attribute of the `<getSchema/>` element. If a specific version of the schema is desired, a `<digest/>`
child element is added, specifying the version the client is interested in. If the `<digest/>` element is omitted, the latest version of the schema
is returned. The expected response element is `<schema/>`, which contains the binary representation of the XML schema file, base-64 encoded, as its 
value.


Searching for public contracts
-----------------------------------

Contracts marked as `PublicSearchable` can be searched by clients. To search for public contracts, a `<searchPublicContracts/>` element is sent
in an `<iq type="get"/>` stanza to the Trust Provider. The element contains a set of operator child elements, that must be provided in a given order,
if present. The following table lists operator child-elements, as well as minimum and maximum number of occurrences:

| Child element  | Min | Max       | Description                                                                      |
|:---------------|:---:|:---------:|:---------------------------------------------------------------------------------|
| `<localName/>` | 0   | 1         | Places restrictions on the local name of the contents of public contracts.       |
| `<namespace/>` | 0   | 1         | Places restrictions on the namespace of the contents of public contracts.        |
| `<template/>`  | 0   | 1         | Places restrictions on the identity of the template used to create the contract. |
| `<role/>`      | 0   | unbounded | Places restrictions on the roles used in public contracts.                       |
| `<parameter/>` | 0   | unbounded | Places restrictions on parameters used in public contracts.                      |
| `<created/>`   | 0   | 1         | Places restrictions on when public contracts were created.                       |
| `<updated/>`   | 0   | 1         | Places restrictions on when public contracts were last updated.                  |
| `<from/>`      | 0   | 1         | Places restrictions on when public contracts became legally binding.             |
| `<to/>`        | 0   | 1         | Places restrictions on when public contracts cease to be legally binding.        |
| `<duration/>`  | 0   | 1         | Places restrictions on the duration of public contracts.                         |

Search results can be paginated. Pagination is controlled by attributes on the `<searchPublicContracts/>` element:

| Attribute          | Type                    | Use      | Description                                                                            |
|:-------------------|:------------------------|:---------|----------------------------------------------------------------------------------------|
| `offset`           | `xs:nonNegativeInteger` | Optional | Result will start with the response at this offset into result set. |
| `maxCount`         | `xs:positiveInteger`    | Optional | Result will be limited to this number of items. |

**Note**: Notice that the order of search operator elements is important.

The expected result of a search request is a `<searchResult/>` element. It contains a sequence (possibly empty) of `<ref/>` elements each one referencing
a contract (via its `id` attribute) that matches the search parameters. The `<searchResult/>` element might also contain a `more` attribute, which if
`true` indicates that there are more contracts available matching the search parameters. Use the pagination attributes in the search request to load more
contract references, if needed.

### Searching on local names

To search for local names of the root element of the machine-readable contents of contracts, the `<localName/>` operator element is added to the 
`<searchPublicContracts/>` element. The `<localName/>` element in turn can take either an `<eq/>` or `<like/>` child element. The first returns contracts
whose machine-readable root local name is equal to the string value of the `<eq/>` element. The second returns contracts whose machine-readable root local 
name matches a regular expression available in the value of the `<like/>` element.

### Searching on namespaces

To search for namespaces of the root element of the machine-readable contents of contracts, the `<namespace/>` operator element is added to the 
`<searchPublicContracts/>` element. The `<namespace/>` element in turn can take either an `<eq/>` or `<like/>` child element. The first returns contracts
whose machine-readable root namespace is equal to the string value of the `<eq/>` element. The second returns contracts whose machine-readable root 
namespace matches a regular expression available in the value of the `<like/>` element.

### Searching on template usage

To search for contracts created from specific templates, the `<template/>` operator element is added to the `<searchPublicContracts/>` element. The 
`<template/>` element in turn can take either an `<eq/>` or `<like/>` child element. The first returns contracts who are created based on a template whose
contract ID is equal to the string value of the `<eq/>` element. The second returns contracts who are created based on a template whose contract ID matches 
a regular expression available in the value of the `<like/>` element.

### Searching for roles

To search for contracts containing one or more roles defined, the `<role/>` operator element is added to the `<searchPublicContracts/>` element, one for
each role to search on. If multiple `<role/>` elements are added, contracts containing all specified roles are returned. Each `<role/>` element in turn can 
take either an `<eq/>` or `<like/>` child element. The first matches contracts who have a role definition equal to the string value of the `<eq/>` element.
The second matches contracts who have a role definition matching a regular expression available in the value of the `<like/>` element.

### Searching for parameter values

To search for contracts using contract parameters, the `<parameter/>` operator element is added to the `<searchPublicContracts/>` element, one for
each parameter to search on. If multiple `<parameter/>` elements are added, contracts matching all operators are returned. Each `<parameter/>` element 
defines which parameter it operates on by specifying the parameter name in a `name` attribute. The element can also take a variable number of child 
elements, as follows:

| Child element | Type          | Description                                                                                            |
|:--------------|:--------------|:-------------------------------------------------------------------------------------------------------|
| `<eqStr/>`    | `xs:string`   | Return public contracts defining a named string-valued parameter equal to this value.                  |
| `<neqStr/>`   | `xs:string`   | Return public contracts defining a named string-valued parameter not equal to this value.              |
| `<gtStr/>`    | `xs:string`   | Return public contracts defining a named string-valued parameter greater than this value.              |
| `<gteStr/>`   | `xs:string`   | Return public contracts defining a named string-valued parameter greater than or equal to this value.  |
| `<ltStr/>`    | `xs:string`   | Return public contracts defining a named string-valued parameter lesser than this value.               |
| `<lteStr/>`   | `xs:string`   | Return public contracts defining a named string-valued parameter lesser than or equal to this value.   |
| `<like/>`     | `xs:string`   | Return public contracts defining a named string-valued parameter that matches this regular expression. |
| `<eqNum/>`    | `xs:decimal`  | Return public contracts defining a named numerical parameter equal to this value.                      |
| `<neqNum/>`   | `xs:decimal`  | Return public contracts defining a named numerical parameter not equal to this value.                  |
| `<gtNum/>`    | `xs:decimal`  | Return public contracts defining a named numerical parameter greater than this value.                  |
| `<gteNum/>`   | `xs:decimal`  | Return public contracts defining a named numerical parameter greater than or equal to this value.      |
| `<ltNum/>`    | `xs:decimal`  | Return public contracts defining a named numerical parameter lesser than this value.                   |
| `<lteNum/>`   | `xs:decimal`  | Return public contracts defining a named numerical parameter lesser than or equal to this value.       |
| `<eqB/>`      | `xs:bool`     | Return public contracts defining a named Boolean parameter equal to this value.                        |
| `<neqB/>`     | `xs:bool`     | Return public contracts defining a named Boolean parameter not equal to this value.                    |
| `<eqD/>`      | `xs:date`     | Return public contracts defining a named date parameter equal to this value.                           |
| `<neqD/>`     | `xs:date`     | Return public contracts defining a named date parameter not equal to this value.                       |
| `<gtD/>`      | `xs:date`     | Return public contracts defining a named date parameter greater than this value.                       |
| `<gteD/>`     | `xs:date`     | Return public contracts defining a named date parameter greater than or equal to this value.           |
| `<ltD/>`      | `xs:date`     | Return public contracts defining a named date parameter lesser than this value.                        |
| `<lteD/>`     | `xs:date`     | Return public contracts defining a named date parameter lesser than or equal to this value.            |
| `<eqDT/>`     | `xs:dateTime` | Return public contracts defining a named date and time parameter equal to this value.                  |
| `<neqDT/>`    | `xs:dateTime` | Return public contracts defining a named date and time parameter not equal to this value.              |
| `<gtDT/>`     | `xs:dateTime` | Return public contracts defining a named date and time parameter greater than this value.              |
| `<gteDT/>`    | `xs:dateTime` | Return public contracts defining a named date and time parameter greater than or equal to this value.  |
| `<ltDT/>`     | `xs:dateTime` | Return public contracts defining a named date and time parameter lesser than this value.               |
| `<lteDT/>`    | `xs:dateTime` | Return public contracts defining a named date and time parameter lesser than or equal to this value.   |
| `<eqT/>`      | `xs:time`     | Return public contracts defining a named time parameter equal to this value.                           |
| `<neqT/>`     | `xs:time`     | Return public contracts defining a named time parameter not equal to this value.                       |
| `<gtT/>`      | `xs:time`     | Return public contracts defining a named time parameter greater than this value.                       |
| `<gteT/>`     | `xs:time`     | Return public contracts defining a named time parameter greater than or equal to this value.           |
| `<ltT/>`      | `xs:time`     | Return public contracts defining a named time parameter lesser than this value.                        |
| `<lteT/>`     | `xs:time`     | Return public contracts defining a named time parameter lesser than or equal to this value.            |
| `<eqDr/>`     | `xs:duration` | Return public contracts defining a named duration parameter equal to this value.                       |
| `<neqDr/>`    | `xs:duration` | Return public contracts defining a named duration parameter not equal to this value.                   |
| `<gtDr/>`     | `xs:duration` | Return public contracts defining a named duration parameter greater than this value.                   |
| `<gteDr/>`    | `xs:duration` | Return public contracts defining a named duration parameter greater than or equal to this value.       |
| `<ltDr/>`     | `xs:duration` | Return public contracts defining a named duration parameter lesser than this value.                    |
| `<lteDr/>`    | `xs:duration` | Return public contracts defining a named duration parameter lesser than or equal to this value.        |

### Searching on the creation timestamp

To search for contracts based on their creation timestamp, the `<created/>` operator element is added to the `<searchPublicContracts/>` element. The 
`<created/>` element in turn can take either any number of child elements:

| Child element | Type          |  Description                                                                            |
|:--------------|:--------------|:----------------------------------------------------------------------------------------|
| `<eq/>`       | `xs:dateTime` | Return public contracts with a creation timestamp equal to this value.                  |
| `<neq/>`      | `xs:dateTime` | Return public contracts with a creation timestamp not equal to this value.              |
| `<gt/>`       | `xs:dateTime` | Return public contracts with a creation timestamp greater than this value.              |
| `<gte/>`      | `xs:dateTime` | Return public contracts with a creation timestamp greater than or equal to this value.  |
| `<lt/>`       | `xs:dateTime` | Return public contracts with a creation timestamp lesser than this value.               |
| `<lte/>`      | `xs:dateTime` | Return public contracts with a creation timestamp lesser than or equal to this value.   |

### Searching on the update timestamp

To search for contracts based on their latest update timestamp, the `<updated/>` operator element is added to the `<searchPublicContracts/>` element. The 
`<updated/>` element in turn can take either any number of child elements:

| Child element | Type          | Description                                                                             |
|:--------------|:--------------|:----------------------------------------------------------------------------------------|
| `<eq/>`       | `xs:dateTime` | Return public contracts with an updated timestamp equal to this value.                  |
| `<neq/>`      | `xs:dateTime` | Return public contracts with an updated timestamp not equal to this value.              |
| `<gt/>`       | `xs:dateTime` | Return public contracts with an updated timestamp greater than this value.              |
| `<gte/>`      | `xs:dateTime` | Return public contracts with an updated timestamp greater than or equal to this value.  |
| `<lt/>`       | `xs:dateTime` | Return public contracts with an updated timestamp lesser than this value.               |
| `<lte/>`      | `xs:dateTime` | Return public contracts with an updated timestamp lesser than or equal to this value.   |

### Searching on the from timestamp

To search for contracts based on when they become or became legally binding, the `<from/>` operator element is added to the `<searchPublicContracts/>` 
element. The `<from/>` element in turn can take either any number of child elements:

| Child element | Type          | Description                                                                             |
|:--------------|:--------------|:----------------------------------------------------------------------------------------|
| `<eq/>`       | `xs:dateTime` | Return public contracts defining a from timestamp equal to this value.                  |
| `<neq/>`      | `xs:dateTime` | Return public contracts defining a from timestamp not equal to this value.              |
| `<gt/>`       | `xs:dateTime` | Return public contracts defining a from timestamp greater than this value.              |
| `<gte/>`      | `xs:dateTime` | Return public contracts defining a from timestamp greater than or equal to this value.  |
| `<lt/>`       | `xs:dateTime` | Return public contracts defining a from timestamp lesser than this value.               |
| `<lte/>`      | `xs:dateTime` | Return public contracts defining a from timestamp lesser than or equal to this value.   |

### Searching on the to timestamp

To search for contracts based on when they expire, the `<to/>` operator element is added to the `<searchPublicContracts/>` element. The `<to/>` element 
in turn can take either any number of child elements:

| Child element | Type          | Description                                                                             |
|:--------------|:--------------|:----------------------------------------------------------------------------------------|
| `<eq/>`       | `xs:dateTime` | Return public contracts defining a to timestamp equal to this value.                  |
| `<neq/>`      | `xs:dateTime` | Return public contracts defining a to timestamp not equal to this value.              |
| `<gt/>`       | `xs:dateTime` | Return public contracts defining a to timestamp greater than this value.              |
| `<gte/>`      | `xs:dateTime` | Return public contracts defining a to timestamp greater than or equal to this value.  |
| `<lt/>`       | `xs:dateTime` | Return public contracts defining a to timestamp lesser than this value.               |
| `<lte/>`      | `xs:dateTime` | Return public contracts defining a to timestamp lesser than or equal to this value.   |

### Searching on duration

To search for contracts based on their duration, the `<duration/>` operator element is added to the `<searchPublicContracts/>` element. The `<duration/>` 
element in turn can take either any number of child elements:

| Child element | Type          | Description                                                                   |
|:--------------|:--------------|:------------------------------------------------------------------------------|
| `<eq/>`       | `xs:duration` | Return public contracts with a duration equal to this value.                  |
| `<neq/>`      | `xs:duration` | Return public contracts with a duration not equal to this value.              |
| `<gt/>`       | `xs:duration` | Return public contracts with a duration greater than this value.              |
| `<gte/>`      | `xs:duration` | Return public contracts with a duration greater than or equal to this value.  |
| `<lt/>`       | `xs:duration` | Return public contracts with a duration lesser than this value.               |
| `<lte/>`      | `xs:duration` | Return public contracts with a duration lesser than or equal to this value.   |

Petitioning access to a smart contract
-----------------------------------------

TODO

Examples
-----------

Following is an example of a TLS-based security report, encoded as a verifiable Smart Contract. The security report can be distributed as a simple Contract ID,
interested parties can download it, and verify that the signatures from the manufacturer and the security authority are valid. If you trust the authority, you can
trust the validity and integrity of the report, as long as signatures are valid.

```xml
<contract xmlns="urn:nf:iot:leg:sc:1.0"
          archiveOpt="P1Y"
          archiveReq="P2Y"
          canActAsTemplate="false"
          duration="P5Y"
          id="ed1632fdf5ce45a8a5d2546e62aeab04@example.org"
          visibility="Public">
  <nd id="Device" xmlns="urn:nf:iot:sd:1.0">
    <ts v="2019-07-19T10:19:23Z">
      <s n="Overall Rating" v="B" m="true"/>
      <q n="Certificate" v="100" u="%" m="true"/>
      <q n="Protocol Support" v="95" u="%" m="true"/>
      <q n="Key Exchange" v="70" u="%" m="true"/>
      <q n="Cipher Strength" v="90" u="%"/>
      <s n="X.509, Subject" v="*.neuro-foundation.org" s="true"/>
      <!-- More X.509 fields -->
      <b n="SSL 2" v="false" s="true"/>
      <b n="SSL 3" v="false" s="true"/>
      <b n="TLS 1.0" v="false" s="true"/>
      <b n="TLS 1.1" v="true" s="true"/>
      <b n="TLS 1.2" v="true" s="true"/>
      <b n="TLS 1.3" v="false" s="true"/>
      <b n="TLS 1.3" v="false" s="true"/>
      <!-- More Protocol fields -->
      <b n="TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256" v="true" s="true"/>
      <!-- More Cipher fields -->
      <b n="DROWN" v="true" s="false"/>
      <!-- More fields related to protocol details / vulnerabilities -->
    </ts>
  </nd>
  <role name="Manufacturer" minCount="1" maxCount="1">
    <description xml:lang="en">
      <paragraph>
        <text>This role represents the manufacturer owner of the device which is referred to.</text>
      </paragraph>
    </description>
  </role>
  <role name="Authority" minCount="1" maxCount="1">
    <description xml:lang="en">
      <paragraph>
        <text>This role represents the certification authority validating the security declaration specified in this document.</text>
      </paragraph>
    </description>
  </role>
  <parts>
    <part role="Manufacturer" legalId="manufacturer@example.org"/>
    <part role="Authority" legalId="authority@example.org"/>
  </parts>
  <parameters>
    <stringParameter name="Overall Rating" value="B">
      <description>
        <paragraph>
          <text>The overall rating of server-side TLS capabilities, A=best, F=lowest.</text>
        </paragraph>
      </description>
    </stringParameter>
    <numericalParameter name="Certificate" value="100">
      <description>
        <paragraph>
          <text>Summary rating of certificate capabilities, in percent.</text>
        </paragraph>
      </description>
    </numericalParameter>
    <numericalParameter name="Protocol Support" value="95">
      <description>
        <paragraph>
          <text>Summary rating of protocol support capabilities, in percent.</text>
        </paragraph>
      </description>
    </numericalParameter>
    <numericalParameter name="Key Exchange" value="70">
      <description>
        <paragraph>
          <text>Summary rating of key exchange capabilities, in percent.</text>
        </paragraph>
      </description>
    </numericalParameter>
    <numericalParameter name="Cipher Strength" value="90">
      <description>
        <paragraph>
          <text>Summary rating of cipher strength capabilities, in percent.</text>
        </paragraph>
      </description>
    </numericalParameter>
  </parameters>
  <humanReadableText xml:lang="en">
    <section>
      <header>
        <text>SSL Report</text>
      </header>
      <body>
        <paragraph>
          <text>This contract contains information about a server-side TLS capabilities evaluation.</text>
        </paragraph>
        <section>
          <header>
            <text>Summary</text>
          </header>
          <body>
            <paragraph>
              <text>Overall rating: </text>
              <parameter name="Overall Rating"/>
            </paragraph>
            <paragraph>
              <text>Certificate: </text>
              <parameter name="Certificate"/>
              <text> %</text>
            </paragraph>
            <paragraph>
              <text>Protocol Support: </text>
              <parameter name="Protocol Support"/>
              <text> %</text>
            </paragraph>
            <paragraph>
              <text>Key Exchange: </text>
              <parameter name="Key Exchange"/>
              <text> %</text>
            </paragraph>
            <paragraph>
              <text>Cipher Strength: </text>
              <parameter name="Key Exchange"/>
              <text> %</text>
            </paragraph>
          </body>
        </section>
      </body>
    </section>
  </humanReadableText>
  <signature bareJid="manufacturer@example.org"
             legalId="9d308bf2d2004bff924049fb6c039484@example.org"
             role="Manufacturer"
             timestamp="2019-07-19T11:19:54Z"
             s="SGwfX9UpcCk4GmAa6u0DgimojoMeQB5bkbM2PlX9xak="/>
  <signature bareJid="authority@example.org"
             legalId="a6b8d8318e7540d4b38e5491222e1305@example.org"
             role="Authority"
             timestamp="2019-07-19T11:21:43Z"
             s="aLZB8rcWqVLVPjc0oQvUOwLKHFSd35jWHbIGQ6PVwf8="/>
  <status created="2019-07-19T10:19:23Z" 
          from="2019-07-19T11:21:43Z"
          to="2024-07-19T11:21:43Z"
          provider="provisioning.example.org" 
          schemaDigest="tPN8gzgusTSM56q9Se6uUyptnqFT9bTIACShZt+4xY0="
          schemaHashFunction="SHA256" 
          state="Approved" 
          templateId="9aadcc318c104d848ec5215264f5bf68@example.org"/>
  <serverSignature timestamp="2019-07-19T11:21:43Z"
                   s="swAqEaR9uDaZLxv/5xAvucj5OFX3+3vU1+pbP4jgUwY/IbPFYH7SHD+U/33WHaepMI9VKf61ASk="/>
</contract>
```