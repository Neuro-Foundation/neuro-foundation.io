Title: neuro-foundation.io
Description: Main page of neuro-foundation.io
Date: 2024-08-02
Author: Peter Waher
Master: Master.md

=============================================

Neuro-Foundation Harmonized IoT Interfaces
=============================================

This repository contains Neuro-Foundation [XMPP](https://xmpp.org/) interfaces for the Internet of Things and Smart Societies. For usage of the 
contents on this site, see the [open source](https://github.com/Trust-Anchor-Group/neuro-foundation.io) [license agreement](Copyright.md).

![Table of Contents](toc)

Introduction
----------------

Neuro-Foundation presents communication infrastructure for a globally scalable, distributed infrastructure for smart societies.
By harmonizing technologies (bridging technology boundaries), it allows different technologies to
interact and interoperate. The interfaces support:

* Local governance
* Definition of ownership
* Protection of privacy
* Consent-based communication
* High level of cybersecurity
* Cross-domain interoperability
* Cross-technology interoperability
* Self-sovereign digital identities
* Legally binding cross-domain agreements
* Distributed discovery and decision support
* Monetization and support for micro-transactions

For a brief introduction to the Neuro-Foundation infrastructure, and how it works, see the [Overview](Overview.md). If you want to test
integration services, brokers or devices, [cybercity.online](https://cybercity.online/) is available for this purpose.

Architectural Overview
--------------------------

* [Conceptual Model](ConceptualModel.md)
* [Operational Model](OperationalModel.md)
* [Communication Model](CommunicationModel.md)


Representation
-----------------

* [Sensor Data](SensorData.md)
* [Control Parameters](ControlParameters.md)
* [Units](Units.md)
* [Harmonized Interfaces](HarmonizedInterfaces.md)


Communication Patterns
----------------------------

* [Sensor Data Request/Response communication pattern](SensorDataRequestResponse.md)
* [Sensor Data Event Subscription communication pattern](SensorDataEventSubscription.md)
* [Sensor Data Publish/Subscribe communication pattern](SensorDataPublishSubscribe.md)
* [Simple Control Actions](ControlSimpleActions.md)
* [Data Form Control Actions](ControlDataForm.md)
* Queues
* Quality of Service


Data Protection, Security and Privacy
---------------------------------------

* [Identities](Identities.md)
* [Authentication](Authentication.md)
* [Basic Authorization](Authorization.md)
* [Binding](Binding.md)
* [Transport Encryption](TransportEncryption.md)
* [Federation](Federation.md)
* [Tokens for distributed transactions](Tokens.md)
* [Decision Support for devices](DecisionSupport.md)
* [Provisioning for owners](Provisioning.md)
* [Peer-to-Peer communication](P2P.md)
* [End-to-End encryption](E2E.md)


Operation
-------------------

* [Concentrators ("Things of Things")](Concentrator.md)
* [Discovery](Discovery.md)
* [Clock & Event Synchronization](ClockSynchronization.md)
* [Software Updates](SoftwareUpdates.md)
* [Real-time Geo-spatial information](Geo.md)


Agreements
------------------

* [Legal Identities](LegalIdentities.md)
* [Smart Contracts](/SmartContracts.md)
* Automatic provisioning using smart contracts

Schemas
-------------

All Neuro-Foundation namespaces are identified using the 
[URN Namespace Identifier `nfi`](https://www.iana.org/assignments/urn-formal/nfi). Each
interface namespace is defined in an XML Schema. You can access these schemas, by namespace
below:

* [`urn:nfi:iot:concentrator:1.0`](Schemas/Concentrator.xsd) - Concentrators
* [`urn:nfi:iot:ctr:1.0`](Schemas/Control.xsd) - Actuator Control
* [`urn:nfi:iot:disco:1.0`](Schemas/Discovery.xsd) - Discovery
* [`urn:nfi:iot:e2e:1.0`](Schemas/E2E.xsd) - End-to-End Encryption
* [`urn:nfi:iot:events:1.0`](Schemas/EventSubscription.xsd) - Event subscription
* [`urn:nfi:iot:geo:1.0`](Schemas/Geo.xsd) - Geo-spatial information
* [`urn:nfi:iot:hi:1.0`](Schemas/HarmonizedInterfaces.xsd) - Harmonized Interfaces
* [`urn:nfi:iot:leg:id:1.0`](Schemas/LegalIdentities.xsd) - Legal identities
* [`urn:nfi:iot:leg:sc:1.0`](Schemas/SmartContracts.xsd) - Smart Contracts
* [`urn:nfi:iot:p2p:1.0`](Schemas/P2P.xsd) - Peer-to-Peer Connectivity
* [`urn:nfi:iot:prov:d:1.0`](Schemas/ProvisioningDevice.xsd) - Provisioning for Devices
* [`urn:nfi:iot:prov:o:1.0`](Schemas/ProvisioningOwner.xsd) - Provisioning for Owners
* [`urn:nfi:iot:prov:t:1.0`](Schemas/ProvisioningTokens.xsd) - Provisioning Tokens
* [`urn:nfi:iot:sd:1.0`](Schemas/SensorData.xsd) - Sensor Data
* [`urn:nfi:iot:swu:1.0`](Schemas/SoftwareUpdates.xsd) - Software Updates
* [`urn:nfi:iot:synchronization:1.0`](Schemas/Synchronization.xsd) - Synchronization


Agent API
-----------

A simplified HTTP-based RESTful API called the [Agent API](/Documentation/Neuron/Agent.md) is also available. It maps HTTP requests to the 
Neuro-Foundation interface operations. Due to limitations of the HTTP protocol, it does not have full support of features that do not conform to 
the basic request-response pattern available in HTTP. 

Software
-----------

A list of software available implementing the interfaces defined on this site, is available in the [Implementations page](Implementations.md).
You can also review the [Implementation Guide](ImplementationGuide.md) if you plan on implementing the interfaces yourself.
