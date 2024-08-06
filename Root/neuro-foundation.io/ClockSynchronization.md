Title: Clock Synchronization
Description: Clock synchronization page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Clock & Event Synchronization
===================================

This document outlines the XML representation of clock and event synchronization. The XML representation is modelled using an annotated XML Schema:

| Clock Synchronization                                           ||
| ------------|----------------------------------------------------|
| Namespace:  | `urn:nf:iot:synchronization:1.0`                   |
| Schema:     | [Synchronization.xsd](Schemas/Synchronization.xsd) |


Motivation and design goal
----------------------------

The method of clock synchronization described here, is designed with the following goals in mind:

* Entities are connected *ad hoc* in a global federated network.

* There is no master in a federated network.

* It should be possible for each entity in the network to estimate the difference of its internal clock with respect to the internal clock of any other entity
to a relative high degree of accuracy.

* The method should allow for varying latency in the network.

* The method should allow for varying latency between different nodes in the network.


Process
------------------------

The Synchronization namespace defines one element: `<req/>`, which is used in an `<iq type="get"/>` stanza to request information about the clock of the destination.
It responds with an `<iq type="result"/>` stanza containing an `<resp/>` element. It has a required value containing the current date and time, in the format of
simple type `xs:dateTime`. Note that an arbitrary precision can be used in the decimal part of the second portion of the `xs:dateTime` data type.
Optionally, the `<resp/>` element can also contain information about the high-frequency timer on the destination machine, if one is available. This is done
through the optional attributes `hf` and `freq`. The `hf` attribute contains the number of ticks since the timer started, and the `freq` attribute contains
the number of increments `hf` makes in one second. This high-frequency timer can be used instead of the date and time value, if high-precision synchronization 
is required, without knowledge about the exact date and time of day.

**Note**: The reference of the high-frequency timer may change when the clock source restarts, or if another machine responds, such as might be the case if the
clock source is hosted in a cluster or in the cloud.

The client makes a note of its time (in UTC) ct<sub>1</sub> of its internal clock. It then sends a `<req/>` request to the clock source, who immediately responds 
with a `<resp/>` element of its own, containing its time (in UTC) st. When the client receives the response, it notes its own time again (in UTC) ct<sub>2</sub>.

```uml:Clock Synchronization
@startuml
Activate Client

group Average results using time window

Client -> Client : <math>ct_1=ClientTime_{UTC}</math>
Client -> Source : req

Activate Source

Source -> Source : <math>st=SourceTime_{UTC}</math>
Client <-- Source : resp(st)

Deactivate Source

Client -> Client : <math>ct_2=ClientTime_{UTC}</math>

note right
<math>Δt_1=st-ct_1≈l+Δt</math>
<math>Δt_2=ct_2-st≈l-Δt</math>
<math>Δt_1+Δt_2≈2*l</math>
<math>Δt_1-Δt_2≈2*Δt</math>
end note

end

Deactivate Client
@enduml
```

Given variation in the network and operating system processes, Δt<sub>1</sub>=st-ct<sub>1</sub> is approximately equal to the latency in the network l plus the 
difference between the client and source clocks Δt. The response, which travels in the other direction, can be used to calculate Δt<sub>2</sub>=ct<sub>2</sub>-st,
which is approximately equal to the latency in the network l minus the difference between the client and source clocks Δt. The latency l is therefore approximately 
half of Δt<sub>1</sub>+Δt<sub>2</sub>. The difference in clocks Δt is approximately half of Δt<sub>1</sub>-Δt<sub>2</sub>.

To decrease the variation of network and process activity, estimated values should be filtered to remove suspected measurement errors due to random events. An average 
value over a given window of filtered values should also be used, to decrease error. The internal clocks of the client and server can be
considered as more stable than the latency in the network. The bulk of the variance in the measured l and Δt can therefore be attributed to variance in the network,
as well as concurrent processes and loads on the client and clock source.

Examples
-------------

Following are some examples of the synchronization process.

### Clock Synchronization

A simple clock synchronization request can look as follows:

```xml
<iq type='get' id='3' from='client@server1/resource' to='source@server2/resource'>
    <req xmlns='urn:nf:iot:synchronization:1.0'/>
</iq>
```

The source responds:

```xml
<iq id='3' type='result' to='client@server1/resource' from='source@server2/resource'>
    <resp xmlns='urn:nf:iot:synchronization:1.0' hf='29774635776511' freq='2630640'>2018-07-02T09:47:38.5102314Z</resp>
</iq>
```

**Note**: The `xs:dateTime` data type allows for arbitrary resolution of the seconds part. In this example, a resolution of 100 ns has been used,
conforming to the capabilities of systems having an on-board high-resolution clock.

**Note 2**: The clock source may be a server or a component as well, in which the server JID or component JID is used.

### Clock Source Query

An entity can ask another entity what clock source it uses:

```xml
<iq id='4' type='get' to='client@server1/resource' from='client@server2/resource'>
    <sourceReq xmlns='urn:nf:iot:synchronization:1.0'/>
</iq>
```

If the entity is synchronizing its clock with an external clock source, it responds:

```xml
<iq type='result' id='4' to='client@sever2/resource' from='client@server1/resource'>
    <sourceResp xmlns='urn:nf:iot:synchronization:1.0'>source@server2/resource</source>
</iq>
```
