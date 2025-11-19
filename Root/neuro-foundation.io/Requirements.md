Title: Requirements
Description: Page summarizing the implementation requirements.
Date: 2025-11-19
Author: Peter Waher
Master: Master.md

=============================================

Implementation Requirements
==============================

Each article defining a namespace and its interfaces list requirements for implementations. 
These requirements are also summarized on this page, with references to the articles where
they are described.

![Table of Contents](toc)

Client <--> Client Interfaces
--------------------------------

Following requirements apply to interfaces between XMPP clients.

### Sensor Data

![Sensor Data Requirements](SensorDataRequirements.md)

### Event Subscription

![Sensor Data Event Subscription Requirements](SensorDataEventSubscriptionRequirements.md)

### Actuator Control

![Control Parameters Requirements](ControlParametersRequirements.md)

### Harmonized Interfaces

![Harmonized Interface Requirements](HarmonizedInterfacesRequirements.md)

### Peer-to-Peer Communication

![Peer-to-Peer Communication Requirements](P2PRequirements.md)

### End-to-End Encryption

![End-to-End Encryption Requirements](E2ERequirements.md)

### Concentrators

![Concentrator Requirements](ConcentratorRequirements.md)

Client <--> Broker Interfaces
--------------------------------

Following requirements apply to interfaces between XMPP clients and XMPP brokers or 
components.

### Tokens for distributed transactions

![Tokens Requirements](TokensRequirements.md)

### Decision Support

![Decision Support Requirements](DecisionSupportRequirements.md)

### Provisioning for Owners

![Provisioning Requirements](ProvisioningRequirements.md)

### Discovery

![Discovery Requirements](DiscoveryRequirements.md)

### Software Updates

![Software Updates Requirements](SoftwareUpdatesRequirements.md)

### Real-time Geo-spatial information

![Real-time Geo-spatial information Requirements](GeoRequirements.md)

### Legal Identities

![Legal Identities Requirements](LegalIdentitiesRequirements.md)

### Smart Contracts

![Smart Contracts Requirements](SmartContractsRequirements.md)

Mixed Interfaces
-------------------

Following requirements apply to interfaces that may be between any connected XMPP entities,
being clients, brokers or components.

### Clock Synchronization

![Clock Synchronization Requirements](ClockSynchronizationRequirements.md)
