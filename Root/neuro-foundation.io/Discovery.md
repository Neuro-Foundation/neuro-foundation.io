Discovery
==================

This document outlines the XML representation of the Thing Registry and discovery service, as defined by the IEEE XMPP IoT Working Group. 
The Discovery service, and its use of *Thing Registries* provide several important services to IoT networks:

1. Managing the lifecycle of things.
2. Pairing of things with their corresponding owners.
3. Transfer of ownership.
4. Allowing third parties to find relevant things that are publicly available.
 
The XML representation is modelled using an annotated XML Schema:

| Discovery                                                             ||
| ------------|----------------------------------------------------------|
| Namespace:  | urn:ieee:iot:disco:1.0                                   |
| Schema:     | [Discovery.xsd](Schemas/Discovery.xsd)                   |

Motivation and design goal
----------------------------

The discovery feature described in this document, is designed with the following goals in mind:

* Thing Registries must be decentralized and federated.
* Method to pair devices with their owners must be secure and minimize the risk of malicious users hijacking devices.
* A device can only have zero or one owner at a time.
* It must be possible to disown a device and allow for reclaiming device by another owner (i.e. transfer ownership).
* Owners must be able to choose if device information in registries are publicly visible or private.
* Devices must be allowed to own themselves.
* A device must be able to post any amount of meta-data about itself to the registry.
* An owner must be able to post any amount of meta-data about any of its devices to the registry.
* A device must be able to update its meta-data in the registry at any time.
* An owner must be able to update the meta-data of any of its devices in the registry at any time.
* An owner must be allowed to remove devices it owns from the registry. (The device is still in operation, but not available in the registry.)
* An owner must be allowed to decommission devices it owns. (Devices are taken out of service.)
* It must be possible to search for public devices in the registry by third parties, using available meta-data to limit the result set to suitable devices.
* Links to single devices, or sets of devices, must be easy to share, via URIs.


Legacy
-------------

The following data model is based on work done in the [XMPP Standards Foundation (XSF)](https://xmpp.org/about/xmpp-standards-foundation.html),
[XEP-0347: Internet of Things - Discovery](https://xmpp.org/extensions/xep-0347.html). Following is a list of notable differences:

* An IEEE namespace is used.
* Only interfaces and services related to XMPP has been included.
* Extended address attributes of nodes are updated.
* The schema is now annotated.
* Thing Registries are always hosted as components on XMPP brokers.
* Search results don't contain JIDs to owners of things anymore, for privacy reasons.
* Additional predefined Tags have been introduced.
* Thing Registries are federated, and clearly identified in the `iotdisco` URI scheme.
* `iotdisco` URIs can now be used to encode searches as well as point to specific devices.

Introduction
----------------

When installing massive amounts of Things into public networks care has to be taken to make installation simple, but at the same time secure so that the Things cannot be 
hijacked or hacked, making sure access to the Thing is controlled by the physical owner of the Thing. One of the main problems is how to match the characteristics of a 
Thing, like serial number, manufacturer, model, etc., with information automatically created by the Thing itself, like perhaps its JID, in an environment with massive 
amounts of Things without rich user interfaces. Care has also to be taken when specifying rules for access rights and user privileges.

The architecture provided here is based on the XMPP protocol and it provides a means to safely install, configure, find and connect massive amounts of Things together, 
while at the same time minimizing the risk that Things get hijacked. It also provides information on how each individual step in the process can be performed with as 
little manual intervention as possible, aiming where possible at zero-configuration networking. Furthermore, this document specifies how to create a registry that allows 
simple access to public Things without risking their integrity unnecessarily.


Lifecycle
--------------

IoT Discovery provides several important services to facilitate the management of the product lifecycle of connected devices, and to achieve *zero-configuration networking* 
for the operator of IoT networks, with security and privacy taken into account.

A thing typically passes through the following phases:

```uml:Thing Lifecycle
@startuml
start;
:Production;
:Installation;
:Finding Network;
:Create Network Identity;
:Find Network Services;
:Register Conceptual Identity;
while (operational?) is (yes)
:Transfer Conceptual Identity;
:Ownership Claim;
while (same owner?) is (yes)
:Update Meta-Data;
:Operation;
endwhile (no)
:Disown;
endwhile (no)
:Unregister;
stop
@enduml
```

### Production

During production only the *conceptual identity* of the thing is known. This *conceptual identity* consists of information such as make, model, serial number, type,
class and manufacturer of device, etc. During mass-production typically the *network identity* or final *owner* of the device is not known.

### Installation

During installation, additional information (meta-data) can optionally be added to the *conceptual identity* of the things. This includes information
about location (Country, region, city, area, street, building, apartment, room, name, etc. as well as GPS-location information, etc.)

### Finding Network

Once power and network connectivity has been given to the thing, the process of finding network services begins. Once an IP network has been identified,
the device needs to find a suitable XMPP broker, to be able to connect to the XMPP network. Finding a suitable XMPP broker can be done using online services, network 
services (such as UPnP, DNS, DHCP, etc.) or be preprogrammed into the device. Optionally, conceptual location information from previous steps can be used to deduce which 
XMPP broker to connect to.

### Creating Network Identity

Once an XMPP broker has been found, the thing needs to create an account on the broker, if it doesn't have one already. Accounts can be created 
by devices using [XEP-0077: In-Band Registration](https://xmpp.org/extensions/xep-0077.html). To avoid allowing malicious users and bots to be able to create identities
on the broker, account registration should be protected by [XEP-0348: Signing Forms](https://xmpp.org/extensions/xep-0348.html). Once an account has been registered, the
device can connect to the XMPP network.

### Finding Network Services

Once connected to the network, the thing needs to search for available network services on the broker. This includes iterating through available
components on the broker and matching their features with the namespaces defined by the different services the thing will use. Each component has a separate JID that can
be used when communicating with it. For an XMPP broker to be compliant with this specification, it needs to provide components that publish features define by the services
defined in this specification. For the current section, this includes the *Thing Registry*. But it should also include components for decision support & provisioning, 
software updates, synchronization, legal identities and smart contracts.

**Note**: Services can be provided by a single component or multiple components. The features of available components need to be analysed to make sure what services are
available on the broker, and what components service the different features.

### Registering a Thing

Once a Thing Registry has been found and been befriended, the Thing can register itself with the registry. A concentrator can register itself, and its nodes if it wishes
to. Registration of a Thing requires the Thing to send its *conceptual identity* in a `<register/>` element to the Thing Registry in a `<iq type="set">` stanza. The 
following subsections describe different alternatives.

#### Registering a stand-alone Thing

The following example shows the registration of a stand-alone Thing:

```xml: Register Thing
<iq type='set'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='1'>
   <register xmlns='urn:ieee:iot:disco:1.0'>
       <str name='SN' value='98734238472634'/>
       <str name='MAN' value='www.example.org'/>
       <str name='MODEL' value='Device'/>
       <num name='V' value='1.0'/>
       <str name='KEY' value='3453485763440213840928'/>
   </register>
</iq>

<iq type='result'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='1'/>
```

There are two types of tags: Tags with string values and tags with numerical values. The distinction is important, since the type of value affects how comparisons are 
made later when performing searches in the registry.

The Thing should only register parameters required to be known by the owner of the Thing. Dynamic meta information must be avoided at this point. To claim the ownership 
of the Thing, the owner needs to present the same meta information as registered by the Thing. Before an owner has claimed ownership of the Thing, it will not be returned 
in any search results. A list of predefined meta tag names can be found in the [#metaTags](Meta Tags) section below. 

The Thing can register itself as many times as it wants, and the response is always empty. Only one record per Bare JID must be created. A new registration 
overrides any previous information, including meta tags previously reported but not available in the new registration. Once a Thing has been claimed by an owner, it 
should not register itself again, unless it is reset, and the installation process restarted. 

If the Thing tries to register itself even though the Thing has already been claimed in the registry, the registry must not update any meta data in the registry, and 
instead respond with the following response. When the thing receives this, it can safely extract the JID of the owner and switch its internal state to claimed. 

```xml: Registration response when already claimed
<iq type='result'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='1'>
   <claimed xmlns='urn:ieee:iot:disco:1.0' jid='owner@example.org'/>
</iq>
```

**Note**: Meta Tag names are case insensitive. In this document, all tag names have been written using upper case letters. 

#### Registering a self-owned Thing

If a thing is self-owned, it can register itself with the Registry as normal, with the addition of setting the attribute `selfOwned` to `true`, as is shown below. 
This registers the Thing directly as PUBLIC CLAIMED, with no need for an owner to claim ownership of the device. This can be useful if installing Things that should 
be publicly available. 

```xml: Register self-owned Thing
<iq type='set'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='2'>
   <register xmlns='urn:ieee:iot:disco:1.0' selfOwned='true'>
       <str name='SN' value='98734238472634'/>
       <str name='MAN' value='www.example.org'/>
       <str name='MODEL' value='Device'/>
       <num name='V' value='1.0'/>
       <str name='KEY' value='3453485763440213840928'/>
   </register>
</iq>

<iq type='result'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='2'/>
```

#### Registering a Thing behind Concentrator

A Thing might reside behind a gateway or [concentrator](Concentrator.md) and might not be directly connected to the XMPP network itself. In these cases, there are three 
optional attributes that can be used to identify the Thing behind the JID: The `id` attribute gives the ID of the Thing (a.k.a. "Node"). The Node might reside in specific 
Data Source (large systems might have multiple sources of nodes). In this case, the data source is specified in the `src` attribute. Normally, the Node ID is considered 
to be unique within the concentrator. If multiple data sources are available, the Node ID is unique within the data source. However, a third attribute allows the uniqueness 
to be restricted to a given partition. The partition is specified using the optional `pt` attribute. Finally, it is the quadruple (JID, `id`, `src`, `pt`) which guarantees 
uniqueness within the concentrator. 

For a Thing controlled by a concentrator to register itself in the Thing Registry, it simply adds the optional attributes `id`, `src` and `pt` as appropriate to the 
registration request, as follows: 

```xml: Register Thing behind Concentrator
<iq type='set'
    from='rack@example.org/plcs'
    to='discovery.example.org'
    id='3'>
   <register xmlns='urn:ieee:iot:disco:1.0' id='plc1' src='MeteringTopology'>
       <str name='SN' value='98734238472634'/>
       <str name='MAN' value='www.example.org'/>
       <str name='MODEL' value='Device'/>
       <num name='V' value='1.0'/>
       <str name='KEY' value='3453485763440213840928'/>
   </register>
</iq>

<iq type='result'
    from='discovery.example.org'
    to='rack@example.org/plcs'
    id='3'/>
```

If the Thing behind the concentrator is self-owned, it simply adds the `selfOwned` attribute to the request and sets it to `true`. 

### Transferring Conceptual Identity

As mentioned earlier, the owner of the Thing must provide the information provided by the Thing to the Registry, in order to claim ownership over it. To avoid the
possibility that somebody can guess the information, the device must use the `KEY` tag with a random value with sufficient entropy. But, for the owner to be able
to do a successful claim, the owner must receive the conceptual identity from the device out-of-band.

#### IoTDisco URI Scheme

To avoid errors when transferring the conceptual identity (collection of registered tags), different encoding mechanisms are available. One such, is the 
[`iotdisco` URI scheme](http://www.iana.org/assignments/uri-schemes/prov/iotdisco.pdf). It allows for the encoding of key/value pairs into a single URI. 
This URI can then be encoded and transmitted to the owner in multiple ways, for instance upon purchase, or delivery. It can be delivered electronically,
using e-mail, SMS, Bluetooth or embedded in a web page for instance, or visually, for instance on a display, or sticker, using some form of visual encoding, 
like QR-codes.

To generate a `iotdisco` URI, generate a string as follows: Begin with `iotdisco:` and append each meta tag in order. Each tag name is prefixed by a semi-colon `;`, 
and if the tag is numeric, the tag is further prefixed by an additional hash sign `#`. Each tag value is prefixed by an equal's sign `=`. If the meta value contains 
semi-colons or back-slashes, each one is prefixed by a backslash `\\`. When decoding the string, this allows the decoder to correctly differ 
between tag delimiters and characters belonging to tag values. A tag name must never contain equal characters (`=`), hash characters (`#`), lesser than characters (`<`),
greater than characters (`>`) or white space characters.

The  meta data presented in previous sections can be transferred using a `iotdisco` URI as follows:

```txt:String to encode as a QR-code
iotdisco:SN=98734238472634;MAN=www.example.org;MODEL=Device;#V=1.0;KEY=3453485763440213840928
```

If the address of the Thing Registry is known at the time of generating the URI, it can be included in the URI, by using the predefined `R` tag. Without the `R` tag,
it is assumed the client and thing finds, or knows, which Thing Registry to use. By using the `R` tag in the URI, you make sure the client, regardless of where it is
connected, finds the thing.

```txt:R Tag
iotdisco:SN=98734238472634;MAN=www.example.org;MODEL=Device;#V=1.0;KEY=3453485763440213840928;R=discovery.example.org
```

**Note**: `iotdisco` URIs used for claiming a device must include the `KEY` tag. `iotdisco` URIs without the `KEY` tag are considered searches (see below).

#### QR-codes

URIs are easy to encode using QR-codes. QR-codes are not mandatory to this specification. It just serves the purpose of illustrating how the conceptual identity
can be transferred from the device to the owner, out-of-band.

Using UTF-8 encoding when generating the QR-code, this string returns the following QR-code:

![`iotdisco` URI encoded as QR-code](/QR/iotdisco%3ASN%3D98734238472634%3BMAN%3Dwww.example.org%3BMODEL%3DDevice%3B%23V%3D1.0%3BKEY%3D3453485763440213840928%3BR%3Ddiscovery.example.org)

### Claiming Ownership of a Thing

Once the owner has the required meta information about the Thing to claim ownership of it, it sends a claim request to the Thing Registry, as follows:

```xml:Claim Ownership of public Thing
<iq type='set'
    from='owner@example.org/phone'
    to='discovery.example.org'
    id='4'>
   <mine xmlns='urn:ieee:iot:disco:1.0'>
       <str name='SN' value='98734238472634'/>
       <str name='MAN' value='www.example.org'/>
       <str name='MODEL' value='Device'/>
       <num name='V' value='1.0'/>
       <str name='KEY' value='3453485763440213840928'/>
   </mine>
</iq>
```

If this claim is successful, the Thing is marked as a public claimed Thing. The thing can always be removed later, but after the claim, the Thing is public. If you want 
to claim a private Thing, you can add the `public` attribute with value `false` to the claim, as follows:

```xml:Claim Ownership of private Thing
<iq type='set'
    from='owner@example.org/phone'
    to='discovery.example.org'
    id='4'>
   <mine xmlns='urn:ieee:iot:disco:1.0' public='false'>
       <str name='SN' value='98734238472634'/>
       <str name='MAN' value='www.example.org'/>
       <str name='MODEL' value='Device'/>
       <num name='V' value='1.0'/>
       <str name='KEY' value='3453485763440213840928'/>
   </mine>
</iq>
```

In this example, if the claim is successful, the Thing will not be made public in the Thing Registry, after the claim.

If a claim is successful, i.e. there's a Thing that has not been claimed with EXACTLY the same meta data (however, the order is not important), the Thing is marked in the
Registry as CLAIMED, and as public or private depending on the `public` attribute, its `KEY` tag is removed from the registry, and a `<claimed/>` element is returned in 
an `<iq type="result"/>` stanza.

```xml:Ownership claim successful
<iq type='result'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='4'>
   <claimed xmlns='urn:ieee:iot:disco:1.0' jid='thing@example.org'/>
</iq>
```

If the Thing that has been claimed resides behind a concentrator, the result will contain those of the attributes `id`, `src` and `pt` that are required to access the 
Thing. The following example illustrates a response where a Thing behind a Concentrator has been claimed:


```xml:Ownership claim of a Thing behind a concentrator successful
<iq type='result'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='4'>
   <claimed xmlns='urn:ieee:iot:disco:1.0' jid='rack@example.org/plcs' id='plc1' src='MeteringTopology'/>
</iq>
```

If, on the other hand, no such Thing was found, or if such a Thing was found, but it is already claimed by somebody else, a failure response is returned. This response
should avoid including information informing the client why the claim failed. Example:

```xml:Ownership claim failure
<iq type='error'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='4'>
   <error type='cancel'>
      <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
   </error>
</iq>
```

When the Thing has been successfully claimed, the Registry sends information about this to the Thing in a `<claimed/>` element in a `<iq type="set"/>` stanza, to inform 
it that it has been claimed and what the bare JID of owner is. After receiving this information, it doesn't need to register itself with the Registry anymore.

```xml:Ownership claimed
<iq type='set'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='5'>
   <claimed xmlns='urn:ieee:iot:disco:1.0' jid='owner@example.org'/>
</iq>
```

If the Thing was claimed as a private Thing, this is shown using the `public` attribute in the response, as follows:

```xml:Ownership of private thing claimed
<iq type='set'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='5'>
   <claimed xmlns='urn:ieee:iot:disco:1.0' jid='owner@example.org' public='false'/>
</iq>
```

**Note**: If the `public` attribute is present and has value `false`, it means no further meta data updates are necessary, since the device is not searchable through the 
Thing Registry.

If the Thing resides behind a concentrator, the request must contain those of the attributes `id`, `src` and `pt` that are required to access the Thing, as follows:

```xml:Ownership of Thing behind concentrator claimed
<iq type='set'
    from='discovery.example.org'
    to='rack@example.org/plcs'
    id='5'>
   <claimed xmlns='urn:ieee:iot:disco:1.0' jid='owner@example.org' id='plc1' src='MeteringTopology'/>
</iq>
```

The Thing returns an empty response to acknowledge the receipt of the ownership information, as follows:

```xml:Ownership claimed acknowledged
<iq type='result'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='5'/>
```

Once the Thing knows who its owner is, it can accept friendship requests from the corresponding owner. It can also safely send a friendship request to the owner.
A simplified diagram of a successful claim is follows:

```uml:Claim
@startuml
activate Owner
Owner -> Registry : <mine conceptualId KEY/>
activate Registry
Registry -> Registry : Match(conceptualId,KEY)
activate Registry
Registry -> Registry : Delete(KEY)
Owner <-- Registry : <claimed thing addr/>
Registry -> Thing : <claimed owner addr/>
Registry <-- Thing :
deactivate Registry
deactivate Registry
deactivate Owner
@enduml
```

**Note**: Meta Tag names are case insensitive. In this document, all tag names have been written using upper case letters.


### Removing Thing from Registry

After a Thing has been claimed and is registered as a PUBLIC CLAIMED Thing in the Registry, it is available in searches. The owner can choose to remove
the Thing from the Registry, to avoid that the Thing appears in future searches. To remove a Thing from the Registry the owner simply sends a removal request using a
`<remove/>` element in an `<iq type="set"/>` stanza to the Registry, containing the Bare JID of the Thing to remove. Example:

```xml:Remove Thing
<iq type='set'
    from='owner@example.org/phone'
    to='discovery.example.org'
    id='6'>
   <remove xmlns='urn:ieee:iot:disco:1.0' jid='thing@example.org'/>
</iq>
```

If the Thing resides behind a concentrator, the request must contain those of the attributes `id`, `src` and `pt` that are required to access the Thing. Example:

```xml:Remove Thing behind concentrator
<iq type='set'
    from='owner@example.org/phone'
    to='discovery.example.org'
    id='6'>
   <remove xmlns='urn:ieee:iot:disco:1.0' jid='rack@example.org/plcs' id='plc1' src='MeteringTopology'/>
</iq>
```

If such a Thing is found and is owned by the caller, it is removed from the Registry, and an empty response is returned, to acknowledge the removal of the Thing
from the registry, as follows:

```xml:Thing removed
<iq type='result'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='6'/>
```

However, if such a thing is not found, or if the thing is owned by someone else, an `item-not-found` error is returned, as follows:

```xml:Removal failure
<iq type='error'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='6'>
   <error type='cancel'>
      <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
   </error>
</iq>
```

After successfully removing a Thing from the Registry, the Registry informs the Thing it has been removed from the Registry. This is done to allow the Thing to
stop updating the Registry with updated meta data.

```xml:Thing removed from registry by owner
<iq type='set'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='7'>
   <removed xmlns='urn:ieee:iot:disco:1.0'/>
</iq>

<iq type='result'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='7'/>
```

If the Thing lies behind a concentrator, the removal request must include the appropriate `id`, `src` and `pt` attributes necessary to identify the thing. Example:

```xml:Thing behind concentrator removed from registry by owner
<iq type='set'
    from='discovery.example.org'
    to='rack@example.org/plcs'
    id='7'>
   <removed xmlns='urn:ieee:iot:disco:1.0' id='plc1' src='MeteringTopology'/>
</iq>
```

The Thing acknowledges the removal request by returning an empty response, as follows:

```xml:Removal acknowledgement
<iq type='result'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='7'/>
```


### Updating Meta Information about Thing in Registry

Once a Thing has been claimed and chooses to reside as a public Thing in the registry, it can update its meta information at any time. This meta information
will be available in searches made to the registry by third parties and is considered public. However, the Thing should be connected to a 
[provisioning server](DecisionSupport.md) at this point, so that correct decisions can be made regarding to friendship, readout and control requests made by parties 
other than the owner.

Meta information updated in this way will only overwrite tags provided in the request, and leave other tags previously reported as they are. To remove a string-valued tag,
it should be updated with an empty value. It is also recommended that key meta information required to claim ownership of the Thing after a factory reset is
either removed, truncated or otherwise modified after it has been claimed so that third parties with physical access to a public Thing cannot hijack it by searching
for it, extracting its meta information from the registry, then resetting it and then claiming ownership of it. The `KEY` tag must be removed by the Thing Registry
itself, upon a successful claim.

To update meta data about itself, a Thing simply sends a request to the Thing Registry, as follows:

```xml:Update Meta Data request
<iq type='set'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='8'>
   <update xmlns='urn:ieee:iot:disco:1.0'>
       <str name='CLASS' value='PLC'/>
       <num name='LON' value='-71.519722'/>
       <num name='LAT' value='-33.008055'/>
   </update>
</iq>
```

If the Thing resides behind a concentrator, the request must contain those of the attributes `id`, `src` and `pt` that are required to access the Thing, as follows:

```xml:Update Meta Data of Thing behind concentrator
<iq type='set'
    from='rack@example.org/plcs'
    to='discovery.example.org'
    id='8'>
   <update xmlns='urn:ieee:iot:disco:1.0' id='plc1' src='MeteringTopology'>
       <str name='CLASS' value='PLC'/>
       <num name='LON' value='-71.519722'/>
       <num name='LAT' value='-33.008055'/>
   </update>
</iq>
```

If the Thing is found in the registry and it is claimed, the registry simply acknowledges the update as follows:

```xml:Update Meta Data request acknowledgement
<iq type='result'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='8'/>
```

However, if the Thing is not found in the registry, probably because the owner has removed it from the registry, an error response is returned. When receiving
such a response, the Thing should assume it is the owner who has removed it from the registry, and that further meta data updates are not desired. The Thing
can then stop further meta data updates. The error response from the registry would look as follows:

```xml:Update Meta Data request failure
<iq type='error'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='8'>
   <error type='cancel'>
      <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
   </error>
</iq>
```

If the Thing on the other hand is found in the Registry, but is not claimed, the registry must not update any meta data in the registry, and instead
respond with the following response. When the thing receives this, the Thing can assume it has been disowned, and perform a new registration in the Registry to allow it
to be re-claimed.

```xml:Update Meta Data response to request from disowned Thing
<iq type='result'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='8'>
   <disowned xmlns='urn:ieee:iot:disco:1.0'/>
</iq>
```

**Note**: Meta Tag names are case insensitive. In this document, all tag names have been written using upper case letters.


### Owner updating Meta Information about Thing in Registry

An owner of a thing can also update the meta-data of a thing it has claimed. To do this, you simply add a `jid` attribute containing the JID of the thing to the
`<update/>` element. (If this attribute is not present, the JID is assumed to be that of the sender of the message.)

```xml:Owner requests an update of Meta Data of Thing
<iq type='set'
    from='owner@example.org/1234'
    to='discovery.example.org'
    id='8'>
   <update xmlns='urn:ieee:iot:disco:1.0' jid='thing@example.org'>
       <str name='ROOM' value='...'/>
       <str name='APT' value='...'/>
       <str name='BLD' value='...'/>
       <str name='STREET' value='...'/>
       <str name='STREETNR' value='...'/>
       <str name='AREA' value='...'/>
       <str name='CITY' value='...'/>
       <str name='REGION' value='...'/>
       <str name='COUNTRY' value='...'/>
   </update>
</iq>
```

The owner can update meta-data of things behind concentrators also. To do this, the corresponding attributes `id`, `src` and `pt` must be used to identify the thing, 
as follows:

```xml:Owner requests an update of Meta Data of Thing behind concentrator
<iq type='set'
    from='owner@example.org/1234'
    to='discovery.example.org'
    id='8'>
   <update xmlns='urn:ieee:iot:disco:1.0' jid='rack@example.org' id='plc1' src='MeteringTopology'>
       <str name='ROOM' value='...'/>
       <str name='APT' value='...'/>
       <str name='BLD' value='...'/>
       <str name='STREET' value='...'/>
       <str name='STREETNR' value='...'/>
       <str name='AREA' value='...'/>
       <str name='CITY' value='...'/>
       <str name='REGION' value='...'/>
       <str name='COUNTRY' value='...'/>
   </update>
</iq>
```

If the Thing is found in the registry and it is claimed by the sender of the current message (i.e. owner is the sender), the registry simply acknowledges the update 
as follows:

```xml:Owner updating thing Meta Data request acknowledgement
<iq type='result'
    from='discovery.example.org'
    to='owner@example.org/1234'
    id='8'/>
```

But if the owner is not the sender of the current message (i.e. owner is somebody else), or if the thing is not found at all, the server must report the node as 
*not existing* (i.e. not existing among the set of things claimed by the owner).

```xml:Owner updating thing Meta Data request failure
<iq type='error'
    from='discovery.example.org'
    to='owner@example.org/1234'
    id='8'>
   <error type='cancel'>
      <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
   </error>
</iq>
```


### Unregistering Thing from Registry


A thing can unregister itself from the Registry. This can be done in an uninstallation procedure for instance. To unregister from the registry, it simply sends
an un-registration request to the registry as follows.

```xml:Unregister Thing
<iq type='set'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='10'>
   <unregister xmlns='urn:ieee:iot:disco:1.0'/>
</iq>
```

If the Thing resides behind a concentrator, the request must contain those of the attributes `id`, `src` and `pt` that are required to access the Thing, as follows:

```xml:Unregistering Thing behind concentrator
<iq type='set'
    from='rack@example.org/plcs'
    to='discovery.example.org'
    id='10'>
   <unregister xmlns='urn:ieee:iot:disco:1.0' id='plc1' src='MeteringTopology'/>
</iq>
```

The registry always returns an empty response, simply to acknowledge the receipt of the request.

```xml:Unregister Thing acknowledgement
<iq type='result'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='10'/>
```

### Disowning Thing

The owner of a Thing can disown the Thing, returning it to a state without owner. This is done by sending the following request to the Thing Registry:

```xml:Disowning Thing
<iq type='set'
    from='owner@example.org/phone'
    to='discovery.example.org'
    id='11'>
   <disown xmlns='urn:ieee:iot:disco:1.0' jid='thing@example.org'/>
</iq>
```

If the Thing resides behind a concentrator, the request must contain those of the attributes `id`, `src` and `pt` that are required to access the Thing, as follows:

```xml:Disowning Thing behind concentrator
<iq type='set'
    from='owner@example.org/phone'
    to='discovery.example.org'
    id='11'>
   <disown xmlns='urn:ieee:iot:disco:1.0' jid='rack@example.org/plcs' id='plc1' src='MeteringTopology'/>
</iq>
```

If such a Thing is not found, or if the thing is not owned by the caller, an `item-not-found` error is returned, as follows:

```xml:Failure to disown Thing - Not Found
<iq type='error'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='11'>
   <error type='cancel'>
      <item-not-found xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
   </error>
</iq>
```

If such a Thing is found, and it is owned by the caller, but not online as a friend, the Thing cannot be disowned, since it might put the Thing in a state from which
it cannot be re-claimed. Therefore, the Thing Registry must respond with a `not-allowed` error, in the following manner:

```xml:Failure to disown Thing - Offline
<iq type='error'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='11'>
   <error type='cancel'>
      <not-allowed xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
   </error>
</iq>
```

Before returning a response to the caller, the Thing Registry informs the Thing it has been disowned.
It does this, so the Thing can remove the friendship to the owner and perform a new registration.

```xml:Thing disowned in registry by owner
<iq type='set'
    from='discovery.example.org'
    to='thing@example.org/resource'
    id='12'>
   <disowned xmlns='urn:ieee:iot:disco:1.0'/>
</iq>
```

If the Thing lies behind a concentrator, the disowned request would look as follows:

```xml:Thing behind concentrator disowned in registry by owner
<iq type='set'
    from='discovery.example.org'
    to='rack@example.org/plcs'
    id='12'>
   <disowned xmlns='urn:ieee:iot:disco:1.0' id='plc1' src='MeteringTopology'/>
</iq>
```

The Thing acknowledges that it has been disowned by returning an empty response, as follows:

```xml:Acknowledging disownment
<iq type='result'
    from='thing@example.org/resource'
    to='discovery.example.org'
    id='12'/>
```

When receiving the acknowledgement from the Thing, the Thing is set as an unclaimed Thing in the Registry. Furthermore, all tags corresponding to the Thing are removed 
from the registry, and a random `KEY` tag is added of sufficient complexity to make sure other clients cannot claim the Thing by guessing. (This `KEY` will later be 
overwritten by the thing, when it re-registers itself.) Finally, an empty response is returned, to acknowledge that the Thing has been disowned, as follows:

```xml:Thing disowned
<iq type='result'
    from='discovery.example.org'
    to='owner@example.org/phone'
    id='11'/>
```

**Notes**: 

* If for any reason, the Thing does not acknowledge the disowned request, or an error occurs, the Registry returns the same error as if the Thing would 
have been offline.
* The thing should make sure to respond to the `<disowned/>` request before sending a new `<register/>` request to the Thing Registry, preferably giving some
time for the Registry to process the response, before the new registration is received.


Search for Public Things in Registry
----------------------------------------

It is possible for anyone with access to the Thing Registry to search for public Things that have been claimed, including self-owned Things. Such searches
will never return things that have not been claimed or have been removed from the registry (i.e. are private).

A search is performed by providing one or more comparison operators in a search request to the registry. If more than one comparison operator is provided, the
search is assumed to be performed on the intersection (i.e. AND) of all operators. If the union (i.e. OR) of different conditions is desired, multiple consecutive
searches have to be performed.

The following table lists available search operators, their element names and meanings:

| Element        | Type    | Operator                     | Description |
|:---------------|:--------|:-----------------------------|:------------|
| `<strEq/>`     | String  | tag = c                      | Searches for string values tags with values equal to a provided constant value. |
| `<strNEq/>`    | String  | tag <> c                     | Searches for string values tags with values not equal to a provided constant value. |
| `<strGt/>`     | String  | tag > c                      | Searches for string values tags with values greater than a provided constant value. |
| `<strGtEq/>`   | String  | tag >= c                     | Searches for string values tags with values greater than or equal to a provided constant value. |
| `<strLt/>`     | String  | tag < c                      | Searches for string values tags with values lesser than a provided constant value. |
| `<strLtEq/>`   | String  | tag <= c                     | Searches for string values tags with values lesser than or equal to a provided constant value. |
| `<strRange/>`  | String  | min <(=) tag <(=) max        | Searches for string values tags with values within a specified range of values. The endpoints can be included or excluded in the search. |
| `<strNRange/>` | String  | tag <(=) min OR tag >(=) max | Searches for string values tags with values outside of a specified range of values. The endpoints can be included or excluded in the range (and therefore correspondingly excluded or included in the search). |
| `<strMask/>`   | String  | tag LIKE c                   | Searches for string values tags with values similar to a provided constant value including wildcards. |
| `<numEq/>`     | Numeric | tag = c                      | Searches for numerical values tags with values equal to a provided constant value. |
| `<numNEq/>`    | Numeric | tag <> c                     | Searches for numerical values tags with values not equal to a provided constant value. |
| `<numGt/>`     | Numeric | tag > c                      | Searches for numerical values tags with values greater than a provided constant value. |
| `<numGtEq/>`   | Numeric | tag >= c                     | Searches for numerical values tags with values greater than or equal to a provided constant value. |
| `<numLt/>`     | Numeric | tag < c                      | Searches for numerical values tags with values lesser than a provided constant value. |
| `<numLtEq/>`   | Numeric | tag <= c                     | Searches for numerical values tags with values lesser than or equal to a provided constant value. |
| `<numRange/>`  | Numeric | min <(=) tag <(=) max        | Searches for numerical values tags with values within a specified range of values. The endpoints can be included or excluded in the search. |
| `<numNRange/>` | Numeric | tag <(=) min OR tag >(=) max | Searches for numerical values tags with values outside of a specified range of values. The endpoints can be included or excluded in the range (and therefore correspondingly excluded or included in the search). |
[Search operators]

The following example shows how a search for specific devices within a specific geographic area can be found. More precisely, it searches for a certain kind of PLC
produced by a certain manufacturer, but only versions 1.0 <= v < 2.0 and with serial numbers beginning with 9873. The PLCs must also lie within latitude 33 ad 34
degrees south and between longitude 70 and 72 west.

```xml:Searching for Things
<iq type='get'
    from='curious@example.org/client'
    to='discovery.example.org'
    id='9'>
   <search xmlns='urn:ieee:iot:disco:1.0' offset='0' maxCount='20'>
       <strEq name='MAN' value='www.example.org'/>
       <strEq name='MODEL' value='Device'/>
       <strMask name='SN' value='9873*' wildcard='*'/>
       <numRange name='V' min='1' minIncluded='true' max='2' maxIncluded='false'/>
       <numRange name='LON' min='-72' minIncluded='true' max='-70' maxIncluded='true'/>
       <numRange name='LAT' min='-34' minIncluded='true' max='-33' maxIncluded='true'/>
   </search>
</iq>
```

The `offset` attribute tells the registry the number of responses to skip before returning found things. It provides a mechanism to page result sets
that are too large to return in one response. the `maxCount` attribute contains the desired maximum number of things to return in the response. The
registry can lower this value, if it decides the requested maximum number is too large.

If tag names are not found corresponding to the names provided in the search, the result set will always be empty. There's a reserved tag named `KEY`
that can be used to provide information shared only between things and their owners. If a search contains an operator referencing this tag name, the result set
must also always be empty. Searches on `KEY` MUST never find things. Furthermore, search results must never return `KEY` tags.

The registry returns any things found in a response similar to the following:

```xml:Search result
<iq type='result'
    from='discovery.example.org'
    to='curious@example.org/client'
    id='9'>
   <found xmlns='urn:ieee:iot:disco:1.0' more='false'>
       <thing jid='thing@example.org'>
          <str name='SN' value='98734238472634'/>
          <str name='MAN' value='www.example.org'/>
          <str name='MODEL' value='Device'/>
          <num name='V' value='1.0'/>
          <str name='CLASS' value='PLC'/>
          <num name='LON' value='-71.519722'/>
          <num name='LAT' value='-33.008055'/>
       </thing>
       ...
   </found>
</iq>
```

If a Thing resides behind a concentrator, the response must contain those of the attributes `id`, `src` and `pt` that are required to access the Thing, as follows:

```xml:Search result containing Thing behind a concentrator
<iq type='result'
    from='discovery.example.org'
    to='curious@example.org/client'
    id='9'>
   <found xmlns='urn:ieee:iot:disco:1.0' more='false'>
       <thing jid='rack@example.org' id='plc1' src='MeteringTopology'>
          <str name='SN' value='98734238472634'/>
          <str name='MAN' value='www.example.org'/>
          <str name='MODEL' value='Device'/>
          <num name='V' value='1.0'/>
          <str name='CLASS' value='PLC'/>
          <num name='LON' value='-71.519722'/>
          <num name='LAT' value='-33.008055'/>
       </thing>
       ...
   </found>
</iq>
```

If more results are available in the search (accessible by using the `offset` attribute in a new search), the `more` attribute is present with value `true`.

**Note**: Meta Tag names are case insensitive. In this document, all tag names have been written using upper case letters.

### IoTDisco URI Scheme for searches

The `iotdisco` URI scheme allows for encoding searches as one URI as well. This facilitates providing URIs for finding public devices based on their registered meta-data.
You encode a `iotdisco` search URI in the same way as a ownership claim URI, with the following differences:

* There is no `KEY` tag name present in the URI
* Apart from the equality operator (`=`), the URI can also include the lesser than (`<`), greater than (`>`), lesser than or equal to (`<=`),
greater than or equal to (`>=`) and the not equal to (`<>`) operators. The mask operator (`~`) can also be used. It is followed by the wildcard character to use, 
followed by the masked string to search for, which may include any number of wildcard characters.
* If a tag name occurs twice in the URI using alternative (`<`) or (`<=`) and (`>`) or (`>=`) operators, these will be interpreted as the in range or
not in range operators alternatively, as appropriate.

The search example provided earlier would be encoded as follows, as a `iotdisco` URI:

```txt:Search URI
iotdisco:MAN=www.example.org;MODEL=Device;SN~*9873*;#V>=1.0;#V<2;#LON>=-72;#LON<=-70;#LAT>=-34;#LAT<=-33
```


Meta Tags
------------

This document does not limit the number or names of tags used by Things to register meta information about themselves. However, it provides some general limits 
and defines the meaning of a few tags that must have the meanings specified herein.

The maximum length of a tag name is `32` characters. Tag names must not include colon (`:`), hash sign (`#`) or white space characters. String tag values
must not exceed `128` characters in length.

The following table lists predefined tag names and their corresponding meanings.

| Tag Name   | Type    | Description                                    |
|:-----------|:--------|:-----------------------------------------------|
| `ALT`      | Numeric | Altitude (meters)                              |
| `APT`      | String  | Apartment associated with the Thing            |
| `AREA`     | String  | Area associated with the Thing                 |
| `BLD`      | String  | Building associated with the Thing             |
| `CITY`     | String  | City associated with the Thing                 |
| `CLASS`    | String  | Class of Thing                                 |
| `COUNTRY`  | String  | Country associated with the Thing              |
| `KEY`      | String  | Key, shared between thing and owner            |
| `LAT`      | Numeric | Latitude (degrees)                             |
| `LON`      | Numeric | Longitude (degrees)                            |
| `MAN`      | String  | Domain name owned by the Manufacturer          |
| `MLOC`     | String  | Meter Location ID                              |
| `MNR`      | String  | Meter Number                                   |
| `MODEL`    | String  | Name of Model                                  |
| `NAME`     | String  | Name associated with the Thing                 |
| `PURL`     | String  | URL to product information for the Thing       |
| `R`        | String  | Registry Address. Used in `iotdisco` URIs only |
| `REGION`   | String  | Region associated with the Thing               |
| `ROOM`     | String  | Room associated with the Thing                 |
| `SN`       | String  | Serial Number                                  |
| `STREET`   | String  | Street Name                                    |
| `STREETNR` | String  | Street Number                                  |
| `V`        | Numeric | Version Number                                 |
 [Predefined tags]
 
It is up to the Thing Registry to choose which tags it persists and which tags it doesn't. To avoid the possibility of malicious reporting of tags, some limit should be
imposed on what tags are supported. As a minimum, a Thing Registry must support all predefined tags, as listed above.

**Note**: Meta Tag names are case insensitive. In this document, all tag names have been written using upper case letters.


Security Considerations
--------------------------

The following sub-sections contain important things to consider, from a security point-of-view.

### Key meta information in searches

Care should be taken what key meta information is used to accept an ownership claim. After a successful claim, leaving the thing as public, this meta information is still 
available in the registry, at least until the Thing is removed from the registry, or the meta-information is overwritten or explicitly removed. While public in the registry,
the meta information can be searched and presented to third parties. Make sure sensitive personal information is not registered as part of the conceptual identity of things.

### KEY tag

The `KEY` tag is unique in that it is not searchable nor available is search results. For this reason, it is ideal for providing secrets shared only
between the Thing and the owner. By providing a `KEY` tag with a value with sufficient entropy during registration, guessing the information even though
the other meta information is available, will be sufficiently hard to make it practically impossible.

Even though the `KEY` tag is not searchable or available in search results, it must be emptied by both the Thing and the Thing Registry after a successful claim, just 
to make sure the key cannot be learned and reused.

### Tag name spam

This document does not limit tag names or the number of tags that can be used by Things. This opens up the possibility of tag spam. Malicious things could fill the database
of the registry by reporting random tag names until the database is full.

To prevent such malicious attacks, the registry could limit the tags it allows to be stored in the database. The registry must however allow the storage of the predefined
tag names defined in this document. If it has a configurable list of approved tags that can be stored, or if it allows any tags is an implementation decision.

### External services for creating QR-codes

If using external services when creating QR-codes, like the Google Charts API, make sure HTTPS is used and certificates validated. If HTTP is used,
meta-data tags used in Thing Registry registrations can be found out by sniffing the network, making it possible to hijack the corresponding devices.
Also, sensitive information might leak to the host of the encoding service.
