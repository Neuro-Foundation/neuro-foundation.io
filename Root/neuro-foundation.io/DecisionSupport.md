Decision Support
==================

This document outlines the XML representation of the decision support service provided to devices, as defined by the IEEE XMPP IoT Working Group. 
When new operations occur, and the device needs to make new security decisions, it can ask the provisioning server for help with making the decision.
The provisioning server maintains information about who owns the device, and what the owner wants with regards to the question the device poses.
If not, the provisioning server automatically denies the request, but informs the owner that a new situation has occurred, to which the owner can respond.
The interface to the owner is described in [provisioning for owners](Provisioning.md). When an entity receives a response from the provisioning server,
it caches the response locally, so that if the same operation occurs again, it knows the answer. The provisioning server can inform entities to clear their
cache when new rules exist for them, effectively making sure the entities adapt to the new rules by asking the relevant decision support questions again.
The XML representation is modelled using an annotated XML Schema:

| Decision Support                                                      ||
| ------------|----------------------------------------------------------|
| Namespace:  | urn:ieee:iot:prov:d:1.0                                  |
| Schema:     | [ProvisioningDevice.xsd](Schemas/ProvisioningDevice.xsd) |


Motivation and design goal
----------------------------

The method of decision support described here, is designed with the following goals in mind:

* Decision support should not affect the operator, only the device and its owner.

* The load on the provisioning server should be proportional to the change in the network. No change should imply no additional load for providing 
decision support.

* All relevant operations for things should be supported by the decision support infrastructure.

* Both general and detailed decisions should be supported.

* Partial permissions should be permitted.

* Decisions should be possible to base on any of available [identities](Identities.md): network identity, domain identity, user, service or device identity.

Checking friendships
--------------------------

If an entity tries to subscribe to the presence of a device, the device must choose to accept or reject the request. Accepting the request means the
remote entity will gain access to the full JID of the device, and therefore also be able to send requests to it.

If the device does not know how to act, it simply sends an `<isFriend/>` element in an `<iq type="get"/>` stanza to the provisioning server, with the bare JID of the entity
making the request in the `jid` attribute. The provisioning server responds to the device with an `<isFriendResponse/>` element containing a `jid` attribute
with the same bare JID, and a `result` attribute containing the Boolean answer to the question. The device can then act accordingly.

```uml:Is Friend?
@startuml
Activate Entity

Entity -> Device : subscribe

Activate Device

Device -> Device : Can I accept? (checking cache)

Activate Device

Device -> Provisioning : isFriend(jid) [Don't know]

Activate Provisioning

Device <- Provisioning : isFriendResponse(jid,result)

Device -> Device : Store in cache

Deactivate Provisioning

Entity <- Device : Accept [If true]

Entity <- Device : Reject [If false]

Deactivate Device
Deactivate Device
Deactivate Entity
@enduml
```

Friendship recommendations
---------------------------

The provisioning service can send friendship recommendations in asynchronous messages to devices. Devices must always check the sender of stanzas to make
sure they are sent from the provisioning service they trust.

If the privisioning service (on behalf of the device's owner) sends an `<unfriend/>` element to the device, it should revoke the presence subscription
of the contact with the bare JID equal to the value of the `jid` attribute.

On the other hand, if the provisioning service (on behalf of the device's owner) sends a `<friend/>` element to the device, it should send a presence
subscription to the bare JID available in the `jid` attribute.

Sensor data authorization
------------------------------

When a sensor data request or subscription is received, the device must decide whether to accept it, reject it or limit its scope. If it does not know how to
do this, it can ask the provisioning service for help. It does this, by sending a `<canRead/>` element to the provisioning service in an `<iq type="get"/>` stanza. The
request contains a copy of the sensor data request or subscription parameters, as well as information about from where the request came. This includes any
user, device or service tokens available in the request. The provisioning service returns a response with a `<canReadResponse/>` element containing a `result` 
attribute telling the device if the readout should be accepted or rejected. It also contains new sensor-data readout parameters corresponding to the readout
that the device is allowed to process. So, if the device accepts the sensor data readout or subscription, it parses the parameters from the response provided
by the provisioning service instead of the parameters available in the request. This allows the provisioning service to restrict the original request to include
only data to whom the requesting entity is permitted.

```uml:Can Read?
@startuml
Activate Entity

Entity -> Device : Request readout

Activate Device

Device -> Device : Can I accept? (checking cache)

Activate Device

Device -> Provisioning : canRead(jid,tokens,parameters) [Don't know]

Activate Provisioning

Device <- Provisioning : canReadResponse(jid,tokens,result,parameters)

Device -> Device : Store in cache

Deactivate Provisioning

Device -> Device : Process readout [if true]

Entity <- Device : Response [If true]

Entity <- Device : Reject [If false]

Deactivate Device
Deactivate Device
Deactivate Entity
@enduml
```

Control operation authorization
----------------------------------

When a control operation request is received, the device must decide whether to perform it, reject it or limit its scope. As with sensor data requests,
it can ask the provisioning service for help if it does not know how to do this. It does this, by sending a `<canControl/>` element to the provisioning service 
in an `<iq type="get"/>` stanza. The request contains a copy of the control operation request parameters, as well as information about from where the request 
came. This includes any user, device or service tokens available in the request. The provisioning service returns a response with a `<canControlResponse/>` element 
containing a `result` attribute telling the device if the control operation should be accepted or rejected. It also contains new control operation parameters 
corresponding to the operation that the device is allowed to perform. So, if the device accepts the request, it parses the parameters from the response provided
by the provisioning service instead of the parameters available in the original request. This allows the provisioning service to restrict the original request 
to include only parameters to whom the requesting entity is permitted.

```uml:Can Control?
@startuml
Activate Entity

Entity -> Device : Control Operation

Activate Device

Device -> Device : Can I accept? (checking cache)

Activate Device

Device -> Provisioning : canControl(jid,tokens,parameters) [Don't know]

Activate Provisioning

Device <- Provisioning : canControlResponse(jid,tokens,result,parameters)

Device -> Device : Store in cache

Deactivate Provisioning

Device -> Device : Process operation [if true]

Entity <- Device : Response [If true]

Entity <- Device : Reject [If false]

Deactivate Device
Deactivate Device
Deactivate Entity
@enduml
```

Clearing the cache
----------------------

When the provisioning server, or the owner, wants to clear the cache of a device, it sends a `<clearCache/>` element in an `<iq type="set"/>` stanza to the device.
This makes the device re-ask the questions to the provisioning server, making sure any new rules are effectively applied.