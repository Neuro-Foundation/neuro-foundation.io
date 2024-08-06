Provisioning
==================

This document outlines the XML representation of the provisioning service provided to owners of devices. When new operations occur to devices, they 
ask the provisioning service for advice on what to do. If the provisioning service does not know, it responds with a negative by default, and then 
asks the corresponding owners what to do. The responses provided by the owners are used when evaluating future responses by the provisioning service. 
While waiting for the owner to respond to provisioning questions, the provisioning service denies all requests it cannot answer by default. The XML 
representation is modelled using an annotated XML Schema:

| Provisioning                                                        ||
| ------------|--------------------------------------------------------|
| Namespace:  | urn:nf:iot:prov:o:1.0                                  |
| Schema:     | [ProvisioningOwner.xsd](Schemas/ProvisioningOwner.xsd) |

See also:

* The interface for devices is described in the chapter about [decision support](DecisionSupport.md).
* The pairing of things with their owners is described in the chapter about [discovery](Discovery.md).


Motivation and design goal
----------------------------

The method of decision support described here, is designed with the following goals in mind:

* Decision support should not affect the operator, only the device and its owner.

* The load on the provisioning service should be proportional to the change in the network. No change should imply no additional load for providing 
decision support.

* All relevant operations for things should be supported by the decision support infrastructure.

* Both general and detailed decisions should be supported.

* Partial permissions should be permitted.

* Decisions should be possible to base on any of available [identities](Identities.md): network identity, domain identity, user, service or device identity.

* Decision making by the owner should be completely decoupled from decision support to devices. Responses to devices occur in real-time. Responses from
owners in asynchronous human-time (i.e. whenever the owner has time or opportunity to respond.)

Authorizing friendships
--------------------------

The provisioning service can ask an owner if one of its things can accept the presence subscription of another entity. This is done by sending a
`<isFriend/>` element in a `<message/>` stanza to the owner. (Messages are used, since the offline storage feature in the XMPP broker allows the message to
be delivered when the owner comes online). The element contains three attributes:

| Attribute   | Type        | Description                                          |
|:------------|:------------|:-----------------------------------------------------|
| `jid`       | `xs:string` | Bare JID of device.                                  |
| `remoteJid` | `xs:string` | Bare JID of entity requesting presence subscription. |
| `key`       | `xs:string` | Key related to the event.                            |

After reviewing the event, the owner can tell the provisioning service how to process the event, and future similar events, by adding a rule to the set
of rules pertaining to the given device. It does this by sending a `<isFriendRule/>` element in an `<iq type="set"/>` stanza to the provisioning service.
The `<isFriendRule/>` element contains five attributes:

| Attribute   | Type         | Description                                                  |
|:------------|:-------------|:-------------------------------------------------------------|
| `jid`       | `xs:string`  | Bare JID of device.                                          |
| `remoteJid` | `xs:string`  | Bare JID of entity requesting presence subscription.         |
| `key`       | `xs:string`  | Key related to the event.                                    |
| `result`    | `xs:boolean` | How similar future requests should be handled by the device. |
| `range`     | `RuleRange`  | The range of the rule.                                       |

Possible values of the `range` attribute are:

| Value    | Description                                                                                                   |
|:---------|:--------------------------------------------------------------------------------------------------------------|
| `Caller` | The rule only applies to the caller (`remoteJid`).                                                            |
| `Domain` | The rule applies to all future requests from the caller domain (all accounts from the domain of `remoteJid`). |
| `All`    | If the rule applies to all future requests.                                                                   |


Authorizing access to sensor data
------------------------------------

The provisioning service can ask the owner what to permit regarding access to any sensor data from any of the owner's devices. It does this by sending a
`<canRead/>` element in a `<message/>` stanza to the owner. Apart from the attributes, nodes and field specifications and tokens available in a sensor-data
request or subscription, it also contains the following attributes:

| Attribute   | Type        | Description                                          |
|:------------|:------------|:-----------------------------------------------------|
| `jid`       | `xs:string` | Bare JID of device.                                  |
| `remoteJid` | `xs:string` | Bare JID of entity requesting sensor data.           |
| `key`       | `xs:string` | Key related to the event.                            |

After reviewing the event, the owner can tell the provisioning service how to process the event, and future similar events, by adding a rule to the set
of rules pertaining to the given device. It does this by sending a `<canReadRule/>` element in an `<iq type="set"/>` stanza to the provisioning service.
The `<canReadRule/>` element contains four attributes:

| Attribute   | Type         | Description                                                                  |
|:------------|:-------------|:-----------------------------------------------------------------------------|
| `jid`       | `xs:string`  | Bare JID of device.                                                          |
| `remoteJid` | `xs:string`  | Bare JID of entity requesting sensor data.                                   |
| `key`       | `xs:string`  | Key related to the event.                                                    |
| `result`    | `xs:boolean` | If the operation should be accepted (albeit perhaps partially) or rejected.  |

If the request concerns nodes in a [concentrator](Concentrator.md), both the `<canRead/>` and `<canReadRule/>` elements contain one or more 
`<nd/>` elements referencing the nodes in question. The `<canReadRule/>` element can also contain a `<partial/>` element telling the provisioning service
that the remote entity is only authorized to access some of the sensor data available. The partial set of sensor-data can either be specified explicitly 
as a sequence of fields, using `<f/>` child elements, or implicitly using field categories. Finally, the owner can specify the range of the rule, by specifying that the rule applies to similar requests, based on its origin, as follows:

| Child element | Attribute | Description                                                          |
|:--------------|:----------|:---------------------------------------------------------------------|
| `fromJid`     | N/A       | Rule will apply to future request made from the same bare JID.       |
| `fromDomain`  | N/A       | Rule will apply to future request made from the same domain.         |
| `fromService` | `token`   | Rule will apply to future request made using the same service token. |
| `fromDevice`  | `token`   | Rule will apply to future request made using the same device token.  |
| `fromUser`    | `token`   | Rule will apply to future request made using the same user token.    |
| `all`         | N/A       | Rule will apply to all future requests.                              |


Authorizing control operations
--------------------------------------

The provisioning service can ask the owner what to permit regarding control operations related to any of the owner's devices. It does this by sending a
`<canControl/>` element in a `<message/>` stanza to the owner. Apart from the attributes, nodes and parameter specifications and tokens available in a 
control operation request, it also contains the following attributes:

| Attribute   | Type        | Description                                          |
|:------------|:------------|:-----------------------------------------------------|
| `jid`       | `xs:string` | Bare JID of device.                                  |
| `remoteJid` | `xs:string` | Bare JID of entity requesting the control operation. |
| `key`       | `xs:string` | Key related to the event.                            |

After reviewing the event, the owner can tell the provisioning service how to process the event, and future similar events, by adding a rule to the set
of rules pertaining to the given device. It does this by sending a `<canControlRule/>` element in an `<iq type="set"/>` stanza to the provisioning service. The `<canControlRule/>` element contains four attributes:

| Attribute   | Type         | Description                                                                  |
|:------------|:-------------|:-----------------------------------------------------------------------------|
| `jid`       | `xs:string`  | Bare JID of device.                                                          |
| `remoteJid` | `xs:string`  | Bare JID of entity requesting the control operation.                         |
| `key`       | `xs:string`  | Key related to the event.                                                    |
| `result`    | `xs:boolean` | If the operation should be accepted (albeit perhaps partially), or rejected. |

If the request concerns nodes in a [concentrator](Concentrator.md), both the `<canControl/>` and `<canControlRule/>` elements contain one or more 
`<nd/>` element referencing the nodes in question. The `<canControlRule/>` element can also contain a `<partial/>` element telling the provisioning 
service that the remote entity is only authorized to control some of the control parameters available. The partial set of parameters are specified explicitly as a sequence of parameters, using `<p/>` child elements. Finally, the owner can specify the range of the rule, by specifying that the rule applies to similar requests, based on its origin, as follows:

| Child element | Attribute | Description                                                          |
|:--------------|:----------|:---------------------------------------------------------------------|
| `fromJid`     | N/A       | Rule will apply to future request made from the same bare JID.       |
| `fromDomain`  | N/A       | Rule will apply to future request made from the same domain.         |
| `fromService` | `token`   | Rule will apply to future request made using the same service token. |
| `fromDevice`  | `token`   | Rule will apply to future request made using the same device token.  |
| `fromUser`    | `token`   | Rule will apply to future request made using the same userr token.   |
| `all`         | N/A       | Rule will apply to all future requests.                              |


Refreshing rules in device
--------------------------------------

The owner can request the provisioning service to request the cache to be cleared in one of its devices. This can be useful to make sure rules are 
up-to-date in the device. The owner simply sends a `<clearCache/>` element in an `<iq type="set"/>` stanza to the provisioning service. The element 
should contain the bare JID of the device in the `jid` attribute.


Deleting rules for device
--------------------------------------

The owner can ask the provisioning service to delete all rules pertaining to a specific device, or node in a concentrator. This is done by sending a
`<deleteRules/>` element in an `<iq type="set"/>` stanza to the provisioning service, with the bare JID of the device in the `jid` attribute. If the 
device is a concentrator, you also need to specify the corresponding node. After deleting all rules, any new operations performed on the device will 
cause events to be sent to owner, letting the owner reprovision the device or node.


Getting list of devices
---------------------------

An owner can get a list of its devices from the provisioning service. This is done by sending a `<getDevices/>` element in an `<iq type="get"/>` stanza 
to the provisioning service. The response conforms to search results in [XEP-0347](https://xmpp.org/extensions/xep-0347.html). The `<getDevices/>` 
element takes two optional attributes:

| Attribute  | Type                    | Description                                                    |
|:-----------|:------------------------|:---------------------------------------------------------------|
| `maxCount` | `xs:positiveInteger`    | Maximum number of devices to return in the response.           |
| `offset`   | `xs:nonNegativeInteger` | Starting offset into the list of things to return. (Default=0) |
