Title: neuro-foundation.io
Description: Main page of neuro-foundation.io
Date: 2024-08-02
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Neuro-Foundation Harmonized IoT Interfaces
=============================================

This repository contains Neuro-Foundation XMPP interfaces for the Internet of Things and Smart Societies. For usage of the contents on this site,
see the [open source](https://github.com/Trust-Anchor-Group/neuro-foundation.io) [license agreement](Copyright.md).

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


Operation
-------------------

* [Concentrators ("Things of Things")](Concentrator.md)
* [Discovery](Discovery.md)
* [Clock & Event Synchronization](ClockSynchronization.md)
* [Software Updates](SoftwareUpdates.md)


Marketplace
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
* [P2P.xsd](Schemas/P2P.xsd)
* [ProvisioningDevice.xsd](Schemas/ProvisioningDevice.xsd)
* [ProvisioningOwner.xsd](Schemas/ProvisioningOwner.xsd)
* [ProvisioningTokens.xsd](Schemas/ProvisioningTokens.xsd)
* [SensorData.xsd](Schemas/SensorData.xsd)
* [SmartContracts.xsd](Schemas/SmartContracts.xsd)
* [SoftwareUpdates.xsd](Schemas/SoftwareUpdates.xsd)
* [Synchronization.xsd](Schemas/Synchronization.xsd)


Implementations
---------------------

### Generic XMPP libraries

| Project                                                                                  | Language | Environment  | Source Code                                                                                         | Description                                     |
|------------------------------------------------------------------------------------------|----------|--------------|-----------------------------------------------------------------------------------------------------|-------------------------------------------------|
| [Waher.Networking.XMPP](https://www.nuget.org/packages/Waher.Networking.XMPP/)           | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP)     | Generic extensible XMPP client library.         |
| [Waher.Networking.XMPP.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.UWP/)   | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.UWP) | Generic extensible XMPP client library for UWP. |

### Libraries related to Sensor data

| Project                                                                                                | Language | Environment  | Source Code                                                                                                | Description                                                                                                                                                   |
|--------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Sensor](https://www.nuget.org/packages/Waher.Networking.XMPP.Sensor/)           | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Sensor)     | Sensor data library. Handles sensor data requests, event subscriptions as well as publish/subscribe using PEP. Both client and server side supported.         |
| [Waher.Networking.XMPP.Sensor.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.Sensor.UWP/)   | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Sensor.UWP) | Sensor data library for UWP. Handles sensor data requests, event subscriptions as well as publish/subscribe using PEP. Both client and server side supported. |

### Libraries related to Control actions

| Project                                                                                                | Language | Environment  | Source Code                                                                                                 | Description                                                                                                                            |
|--------------------------------------------------------------------------------------------------------|----------|--------------|-------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Control](https://www.nuget.org/packages/Waher.Networking.XMPP.Control/)         | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Control)     | Control library. Handles both simple and data form control parameter operations. Both client and server side supported.                |
| [Waher.Networking.XMPP.Control.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.Control.UWP/) | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Control.UWP) | Control library for UWP. Handles both simple and data form control parameter operations. Both client and server side supported.        |

### Libraries related to Concentrators

| Project                                                                                                          | Language | Environment  | Source Code                                                                                                      | Description                                                                                                                                            |
|------------------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Concentrator](https://www.nuget.org/packages/Waher.Networking.XMPP.Concentrator/)         | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Concentrator)     | Concentrator library. Handles discovery and management of data sources and nodes inside a concentrator. Both client and server side supported.         |
| [Waher.Networking.XMPP.Concentrator.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.Concentrator.UWP/) | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Concentrator.UWP) | Concentrator library for UWP. Handles discovery and management of data sources and nodes inside a concentrator. Both client and server side supported. |

### Libraries related to Thing Registries

| Project                                                                                                          | Language | Environment  | Source Code                                                                                                      | Description                                                                                                                                                       |
|------------------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Provisioning](https://www.nuget.org/packages/Waher.Networking.XMPP.Provisioning/)         | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Provisioning)     | Thing Registry and Provisioning library. Handles registration, claims and searching in thing registries, as well as support for provisioning for clients.         |
| [Waher.Networking.XMPP.Provisioning.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.Provisioning.UWP/) | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Provisioning.UWP) | Thing Registry and Provisioning library for UWP. Handles registration, claims and searching in thing registries, as well as support for provisioning for clients. |

### Libraries related to Provisioning

| Project                                                                                                          | Language | Environment  | Source Code                                                                                                      | Description                                                                                                                                                       |
|------------------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Provisioning](https://www.nuget.org/packages/Waher.Networking.XMPP.Provisioning/)         | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Provisioning)     | Thing Registry and Provisioning library. Handles registration, claims and searching in thing registries, as well as support for provisioning for clients.         |
| [Waher.Networking.XMPP.Provisioning.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.Provisioning.UWP/) | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Provisioning.UWP) | Thing Registry and Provisioning library for UWP. Handles registration, claims and searching in thing registries, as well as support for provisioning for clients. |

### Libraries related to Legal Identities

| Project                                                                                                          | Language | Environment  | Source Code                                                                                                      | Description                                                                                                                                                       |
|------------------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Contracts](https://www.nuget.org/packages/Waher.Networking.XMPP.Contracts/)               | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Contracts)        | Helps apply for and manage legal identities, as well as upload and sign smart contracts, from a client perspective.                                                                       |

### Libraries related to Smart Contracts

| Project                                                                                                          | Language | Environment  | Source Code                                                                                                      | Description                                                                                                                                                       |
|------------------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Contracts](https://www.nuget.org/packages/Waher.Networking.XMPP.Contracts/)               | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Contracts)        | Helps apply for and manage legal identities, as well as upload and sign smart contracts, from a client perspective.                                                                       |

### Libraries related to Clock Synchronization

| Project                                                                                                                | Language | Environment  | Source Code                                                                                                         | Description                                                                                |
|------------------------------------------------------------------------------------------------------------------------|----------|--------------|---------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Synchronization.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.Synchronization.UWP/) | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Synchronization.UWP) | Can be used to synchronize clocks between entities in a global federated network, for UWP. |
| [Waher.Networking.XMPP.Synchronization](https://www.nuget.org/packages/Waher.Networking.XMPP.Synchronization/)         | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Synchronization)     | Can be used to synchronize clocks between entities in a global federated network.          |

### Libraries related to Publish/Subscribe

| Project                                                                                              | Language | Environment  | Source Code                                                                                                | Description                                                                                                        |
|------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.PEP](https://www.nuget.org/packages/Waher.Networking.XMPP.PEP/)               | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.PEP)        | Support for the Personal Eventing Protocol (PEP) simplified Publish/Subscrube pattern in XMPP (XEP-0163).          |
| [Waher.Networking.XMPP.PEP.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.PEP.UWP/)       | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.PEP.UWP)    | Support for the Personal Eventing Protocol (PEP) simplified Publish/Subscrube pattern in XMPP (XEP-0163), for UWP. |
| [Waher.Networking.XMPP.PubSub](https://www.nuget.org/packages/Waher.Networking.XMPP.PubSub/)         | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.PubSub)     | Support for generic Publish/Subscribe in XMPP (XEP-0060).                                                          |
| [Waher.Networking.XMPP.PubSub.UWP](https://www.nuget.org/packages/Waher.Networking.XMPP.PubSub.UWP/) | C#       | UWP          | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.PubSub.UWP) | Support for generic Publish/Subscribe in XMPP (XEP-0060), for UWP.                                                 |

### Libraries related to Peer-to-Peer communication

| Project                                                                                              | Language | Environment  | Source Code                                                                                                | Description                                                                                                        |
|------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.P2P](https://www.nuget.org/packages/Waher.Networking.XMPP.P2P/)               | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.P2P)        | Support for serverless XMPP communication, as well as end-to-end security.                                         |

### Libraries related to End-to-End encryption

| Project                                                                                              | Language | Environment  | Source Code                                                                                                | Description                                                                                                        |
|------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.P2P](https://www.nuget.org/packages/Waher.Networking.XMPP.P2P/)               | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.P2P)        | Support for serverless XMPP communication, as well as end-to-end security.                                         |

### Libraries related to Elliptic Curve Cryptography

| Project                                                                                              | Language | Environment  | Source Code                                                                                                | Description                                                                                                        |
|------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [Waher.Security.EllipticCurves](https://www.nuget.org/packages/Waher.Security.EllipticCurves/)       | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Security/Waher.Security.EllipticCurves)      | Contains a class library implementing algorithms for Elliptic Curve Cryptography, such as ECDH, ECDSA, NIST P-192, NIST P-224, NIST P-256, NIST P-384 and NIST P-521 |

### Libraries related to Remote Software Updates

| Project                                                                                              | Language | Environment  | Source Code                                                                                                | Description                                                                                                         |
|------------------------------------------------------------------------------------------------------|----------|--------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| [Waher.Networking.XMPP.Software](https://www.nuget.org/packages/Waher.Networking.XMPP.Software/)     | C#       | .NET Std 1.3 | [GitHub](https://github.com/PeterWaher/IoTGateway/tree/master/Networking/Waher.Networking.XMPP.Software)   | Contains a class library implementing a client for managing and downloading software packages and software updates. |

### Client software

| Project                                                                                                          | Language | Environment   | Description                                                                                                                                                                                                        |
|------------------------------------------------------------------------------------------------------------------|----------|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Simple IoT Client](https://github.com/PeterWaher/IoTGateway/tree/master/Clients/Waher.Client.WPF)               | C#       | Windows (x86) | Simple Windows tool (WPF), supporting both M2M (IoT XEPs) and H2M (chat) interfaces. Can be used to monitor communication and test device interfaces. Support for Thing Registries and Provisioning also provided. |
| [TAG Legal Lab Windows Application](https://github.com/Trust-Anchor-Group/LegalLab)                              | C#       | Windows       | Windows Application (WPF) allowing you to design, create, sign and propose smart contracts, using Neuro-Foundation interfaces.                                                                                     |
| [TAG white-label Neuro-Access App](https://github.com/Trust-Anchor-Group/NeuroAccessMaui)                        | C#       | Android, iOS  | Simple Smart Phone App (Maui), utilizing Neuro-Foundation interfaces for digital identities, smart contracts, as well as interacting with others and devices                                                       |
| [TAG ComSim Communication Simulator](https://github.com/Trust-Anchor-Group/ComSim)                               | C#       | .NET Core     | Command-Line tool that can simulate large numbers of devices and usage by users over time based on stochastic models.                                                                                              |

### Example applications

| Project                                                                               | Language | Environment | Description                                                                                                                                                                                                                                                                      |
|---------------------------------------------------------------------------------------|----------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [SensorXmpp](https://github.com/PeterWaher/MIoT/tree/master/SensorXmpp)               | C#       | UWP         | Simple Sensor, running on Windows 10 IoT on Raspberry Pi with Arduino. Senses Light and Motion.                                                                                                                                                                                  |
| [SensorXmpp2](https://github.com/PeterWaher/MIoT/tree/master/SensorXmpp2)             | C#       | UWP         | Similar to the SensorXmpp project, except that it supports provisioning, allowing its owner control who can access it and read what from it.                                                                                                                                     |
| [ActuatorXmpp](https://github.com/PeterWaher/MIoT/tree/master/ActuatorXmpp)           | C#       | UWP         | Simple Actuator, running on Windows 10 IoT on Raspberry Pi with Arduino. Controls a Relay.                                                                                                                                                                                       |
| [ActuatorXmpp2](https://github.com/PeterWaher/MIoT/tree/master/ActuatorXmpp2)         | C#       | UWP         | Similar to the ActuatorXmpp project, except that it supports provisioning, allowing its owner control who can access it and read what from it.                                                                                                                                   |
| [ConcentratorXmpp](https://github.com/PeterWaher/MIoT/tree/master/ConcentratorXmpp)   | C#       | UWP         | Simple Concentrator, running on Windows 10 IoT on Raspberry Pi with Arduino. Embeds the sensor and actuator projects as internal nodes inside a concentrator device using a single JID.                                                                                          |
| [ConcentratorXmpp2](https://github.com/PeterWaher/MIoT/tree/master/ConcentratorXmpp2) | C#       | UWP         | Similar to the ConcentratorXmpp project, except that it supports provisioning, allowing its owner control who can access it and read what from its individual nodes.                                                                                                             |
| [ControllerXmpp](https://github.com/PeterWaher/MIoT/tree/master/ControllerXmpp)       | C#       | UWP         | Simple Controller, running on Windows 10 IoT on Raspberry Pi with Arduino. Uses a Thing Registry to find a sensor and an actuator, on which it performs control actions based on input from the sensor. Sensor and actuators can be standalone, or reside behind a concentrator. |
| [OpenWeatherMapSensor](https://github.com/PeterWaher/OpenWeatherMapSensor)            | C#       | UWP         | Simple Sensor that maps a backend interface (here, using Open Weather Map API) to Neuro-Foundation harmonized IoT interfaces. Example runs on Windows 10 IoT on Raspberry Pi with Arduino.                                                                                       |
