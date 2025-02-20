Title: Communication Model
Description: Describes the communication model of the Neuro-Foundation interfaces.
Date: 2025-02-03
Author: Peter Waher
Master: Master.md

=============================================

Communication Model
========================

The Neuro-Foundation interfaces are based on the [XMPP](https://xmpp.org/) protocol, 
and provide an open infrastructure for open, harmonized and secure real-time communication 
over the Internet. The interfaces permit interoperation of devices based on different
technologies. The communication model extends the [operational model](OperationalModel.md)
and [conceptual model](ConceptualModel.md) presented earlier, with the following concepts:

Connected Entity

:	Connected Entities are the basic building blocks of the connected network. Connected 
	entities can be devices, services, brokers, user applications or any other entity that can 
	communicate over the Internet, using XMPP. Connected Entities are identified by a unique 
	identifier, called the XMPP Address. The XMPP Address is for historical reasons often 
	referred to as a `JID`, or Jabber ID, from the name of the first project where XMPP was 
	created. Each Connected Entity needs to be authenticated and authorized access to the 
	network before it can communicate with other entities.

