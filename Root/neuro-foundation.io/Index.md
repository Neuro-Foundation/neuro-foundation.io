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

Neuro-Foundation presents communication infrastructure for a globally scalable, distributed infrastructure for smart societies, supporting:

* Local governance
* Definition of ownership
* Protection of privacy
* Consent-based communication
* High level of cybersecurity
* Cross-domain interoperability
* Cross-technology interoperability

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

XML Schemas by namespace:

* [`urn:nf:iot:concentrator:1.0`](Schemas/Concentrator.xsd) - Concentrators
* [`urn:nf:iot:ctr:1.0`](Schemas/Control.xsd) - Actuator Control
* [`urn:nf:iot:disco:1.0`](Schemas/Discovery.xsd) - Discovery
* [`urn:nf:iot:e2e:1.0`](Schemas/E2E.xsd) - End-to-End Encryption
* [`urn:nf:iot:events:1.0`](Schemas/EventSubscription.xsd) - Event subscription
* [`urn:nf:iot:leg:id:1.0`](Schemas/LegalIdentities.xsd) - Legal identities
* [`urn:nf:iot:leg:sc:1.0`](Schemas/SmartContracts.xsd) - Smart Contracts
* [`urn:nf:iot:p2p:1.0`](Schemas/P2P.xsd) - Peer-to-Peer Connectivity
* [`urn:nf:iot:prov:d:1.0`](Schemas/ProvisioningDevice.xsd) - Provisioning for Devices
* [`urn:nf:iot:prov:o:1.0`](Schemas/ProvisioningOwner.xsd) - Provisioning for Owners
* [`urn:nf:iot:prov:t:1.0`](Schemas/ProvisioningTokens.xsd) - Provisioning Tokens
* [`urn:nf:iot:sd:1.0`](Schemas/SensorData.xsd) - Sensor Data
* [`urn:nf:iot:swu:1.0`](Schemas/SoftwareUpdates.xsd) - Software Updates
* [`urn:nf:iot:synchronization:1.0`](Schemas/Synchronization.xsd) - Synchronization


Agent API
-----------

A simplified HTTP-based RESTful API called the [Agent API](/Documentation/Neuron/Agent.md) is also available. It maps HTTP requests to the 
Neuro-Foundation interface operations. Due to limitations of the HTTP protocol, it does not have full support of features that do not conform to 
the basic request-response pattern available in HTTP. 

Software
-----------

A list of software available implementing the interfaces defined on this site, is available in the [Implementations page](Implementations.md).
You can also review the [Implementation Guide](ImplementationGuide.md) if you plan on implementing the interfaces yourself.
