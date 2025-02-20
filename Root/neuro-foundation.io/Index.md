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
* [Opaque Unique Identifiers](OpaqueUniqueIdentifiers.md)


Operation
-------------------

* [Concentrators ("Things of Things")](Concentrator.md)
* [Discovery](Discovery.md)
* [Clock & Event Synchronization](ClockSynchronization.md)
* [Software Updates](SoftwareUpdates.md)


Agreements
------------------

* [Legal Identities](LegalIdentities.md)
* [Smart Contracts](/SmartContracts.md)
* Automatic provisioning using smart contracts

Schemas
-------------

XML Schemas in alphabetical order:

* [Concentrator.xsd](Schemas/Concentrator.xsd)
* [Control.xsd](Schemas/Control.xsd)
* [Discovery.xsd](Schemas/Discovery.xsd)
* [E2E.xsd](Schemas/E2E.xsd)
* [EventSubscription.xsd](Schemas/EventSubscription.xsd)
* [LegalIdentities.xsd](Schemas/LegalIdentities.xsd)
* [OpaqueUuid.xsd](Schemas/OpaqueUuid.xsd)
* [P2P.xsd](Schemas/P2P.xsd)
* [ProvisioningDevice.xsd](Schemas/ProvisioningDevice.xsd)
* [ProvisioningOwner.xsd](Schemas/ProvisioningOwner.xsd)
* [ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd)
* [SensorData.xsd](Schemas/SensorData.xsd)
* [SmartContracts.xsd](Schemas/SmartContracts.xsd)
* [SoftwareUpdates.xsd](Schemas/SoftwareUpdates.xsd)
* [Synchronization.xsd](Schemas/Synchronization.xsd)


Agent API
-----------

A simplified HTTP-based RESTful API called the [Agent API](/Documentation/Neuron/Agent.md) is also available. It maps HTTP requests to the 
Neuro-Foundation interface operations. Due to limitations of the HTTP protocol, it does not have full support of features that do not conform to 
the basic request-response pattern available in HTTP. 

Software
-----------

A list of software available implementing the interfaces defined on this site, is available in the [Implementations page](Implementations.md).
