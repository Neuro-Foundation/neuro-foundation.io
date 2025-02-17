Title: Conceptual Model
Description: Describes the conceptual model of the Neuro-Foundation interfaces.
Date: 2025-02-03
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Conceptual Model
========================

The Neuro-Foundation interfaces are designed to harmonize devices using different technologies
on the Internet, so they can communicate and interoperate with each other. These interfaces use
the following conceptual model:

Entity

:	The most abstract concept in the model, and represents anything that can be encapsulated
	as a unit, and that can be referred to by a reference.

Thing

:	Things are physical or virtual entities that can (for our purposes) communicate over the 
	Internet, either directly (a connected thing), or indirectly (using a bridge for 
	connectivity). Things can be sensors, actuators, concentrators, or combinations of several 
	of such.

Sensor

:	A sensor is an entity that can report sensor data, and support basic sensor data operations.
	They can be physical sensors that measure physical quantities of the physical environment. 
	They can also be virtual or informatical, "measuring" virtual properties or information 
	available in the cyber-environment.

Actuator

:	An actuator is an entity that contains control parameters that control its operation. An
	actuator also support basic control operations. They can be physical actuators that can 
	affect the physical environment. They can also be virtual actuators that affect or control
	information processes in the cyber-environment.

Concentrator

:	A concentrator is an entity that organizes multiple things into one entity, as well as
	providing a single (concentrated) point of access to all things. Things are organized as
	nodes into tree structures or flat lists, optionally hosted by sources, which may 
	optionally be divided into partitions.

Bridge

:	A bridge is a special form of concentrator that connects things using one type of technology
	to the harmonize Neuro-Foundation network. By interconnecting multiple bridges, things using
	different technologies are able to interoperate. Bridges can be physical or virtual, and can
	translate between different communication protocols, data formats, or security mechanisms.

Standalone Thing

:	A standalone (connected) device, or standalone (connected) thing, is a thing that is 
	directly connected to the harmonized Neuro-Foundation network, by itself.

Node

:	A node is a representation of an entity or a thing inside a concentrator. Nodes are 
	organized as tree structures or as flat lists. They may be hosted by data sources.
	A node is identified using a Node ID, which must be unique within the scope it is defined.
	If no sources are used (for simpler concentrators), the Node ID must be unique within the 
	concentrator. If a node resides in a data source, the Node ID must be unique within that 
	data source. If the data source is partitioned, the Node ID must be unique within that 
	partition of the data source.

Parent

:	A parent (node) is a node that contains other nodes. A parent node may typically contain 
	any number of child nodes. Such child nodes may be parent node also, forming a tree structure
	of nodes.

	Likewise, a parent (source) is a source that contains other sources.

Child

:	A child (node) is a node that is contained by another node, its parent. A child node may 
	typically only have one parent node in a tree structure. A node without a parent is a root
	node.

	Likewise, a child (source) is a source that is contained by another source.

Sibling

:	Sibling (nodes) are nodes that have the same parent node. Likewise, sibling (sources)
	have the same parent source.

Root

:	A root (node) has no parent, but may act as the parent node to nodes in a tree structure.

Source

:	A concentrator hosts multiple nodes. These nodes may be organized into data sources,
	depending on context. A Data source may optionally be divided into partitions. A
	source is identified in a concentrator using a Source ID. Some data sources may have
	specific purposes, such as the `MeteringTopology` source, which contains the topology
	of metering devices and physical sensor networks.

	Sources may be organized into a tree structure of sources in a concentrator.

Partition

:	Large systems can choose to partition their sources into smaller parts, to simplify
	management and improve performance. Partitions are identified using a Partition ID.
	Partitions also allow for the embedding and nesting of systems and subsystems to an
	arbitrary level, each subsystem working with their own identities without the risk of
	colliding with other subsystems. Parititioning allows for such subsystems to seamlessly
	form super-systems with each sub-system supporting local governance, while the larger
	system working as whole complete systems in their own regard.

Sensor Data

:	Sensor data is data reported by sensors. It can be physical data, such as temperature,
	humidity, pressure, light, sound, etc. It can also be virtual data, such as information
	about the state of a system, or the result of a calculation. Sensor data consists of a
	collection of fields.

Field

:	An item of information in a sensor data collection. A field has a name, a timestamp, a
	reference to the entity or node reporting it, a type and a value, depending on the type. 
	The field type may also contain other information such as, a unit, precision, classification,
	as well as other meta-data about the value.

Property

:	A (node) property is a property of a node. The properties of a node define the different 
	capabilities of the node, and how the software determines how to interact with the 
	underlying thing or entity. It might be a network address, for example, or a meta-data 
	element, etc.

Parameter

:	A (controllable) parameter is a parameter of an actuator that can be controlled to change 
	the behaviour or output of the actuator.

Network Identity

:	A network identity is an identity that is used to identify and communicate with a connected 
	entity on a network.

Cryptography Identity

:	A cryptographic identity consists of a public-key cryptographic algorithm together with 
	a corresponding public key and and a cryptographic signature (made by the corresponding
	private key). Recipients of the cryptographic identity can verify the validity of the
	signature, using only the public key.

Conceptual Identity

:	A conceptual identity is a set of meta-data key-value pairs of information describing an
	entity.

Legal Identity

:	A legal identity, as it relates to the Neuro-Foundation interfaces, is a conceptual identity 
	describing a legal person, together with a network identity (for communication purposes),
	and a cryptographic identity, where the digital signature protects the meta-data of the
	conceptual identity, and a method of integrity validation, where a Trust Provider, and a 
	variable amount of peers validate the integrity of the information provided in the 
	conceptual identity, to give it sufficient trust for use in agreements between parts.

Smart Contract

:	A smart contract is a legal agreement between two or more entities with legal identities.
	The smart contract contains both human-readable information, as well as machine-readable
	instructions that can be automatically processed by computer programs, when certain
	conditions are met. Smart contracts can be used to automatically provision devices, 
	authorize access to resources, or to perform other operations in the network. Smart contracts
	form the bases of interoperation across domains, where each domain is locally governed by
	different interests.

Part

:	A part (of a smart contract) is an entity with a legal identity, that has signed the smart
	contract, and is bound by the terms and conditions of the smart contract, as long as the
	contract has been completely signed. A part may be a person, a company, a device, a service, 
	or any other entity that can be represented by a valid legal identity within the context, as
	defined by the corresponding Trust Provider.

Domain

:	An (internet) domain is defined by a domain name, and operated by a domain owner. A domain owner is
	responsible for the governance of the domain, and can define its own rules, policies and
	agreements.

Trust Provider

:	An actor that provides trust in the federated network by operating one or more brokers on
	one or more internet domains. A trust provider provides access to the network, authenticates 
	and authorizes access to the federated network, validates signatures and claims and brokers 
	interaction in the network. The Trust Provider is a key actor that permits the creation of 
	open networks that are secure at the same time.

Peer

:	Peers in the network are connected entities of similar status.

Broker

:	A broker is a network service available publicly on the Internet that helps connected 
	entities communicate with each other, wether they are connected to the same broker, or to 
	different brokers. The brokers interoperate to exchange messages between connected entities
	on different domains. Brokers thus help establish secure communication channels between 
	connected entities, protecting the connected entities as they are not required to open
	channels accessible directly via the Internet.

Discovery

:	Discovery provides two mechanism in the federated network. First, it is the process of 
	pairing things with their owners. Secondly, once claimed is the process of finding connected entities on the network, and establishing
	communication with them. 

Provisioning


Ownership
Claim
