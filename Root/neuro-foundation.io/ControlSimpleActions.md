Title: Simple Actions
Description: Control Simple Actions page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md

=============================================

Simple Control Actions
==========================

Simple control actions are sent to a control server by embedding a `<set/>` element in an `<iq type="set"/>` stanza.

```uml:Simple Control
@startuml
Client -> Device : iq[type=set](set)
Activate Device

Device -> Device : set parameters
Activate Device

Client <- Device : iq[type=result](resp)
Deactivate Device
Deactivate Device
@enduml
```

The `<set/>` element contains the set of control parameters with their corresponding values to be set. It can also optionally contain node definitions, 
if the control server is divided into nodes. The response is either an `<iq type="error"/>` stanza, in case the operation is rejected, or an `<iq type="result"/>` stanza,
in case the operation succeeded, or was partially accepted. The result contains the nodes and parameters successfully operated on. If this set is smaller
than the original request, the device decided to reduce the request, probably due to restrictions based on the sender identity. If the device denies all
control operations, an error is returned instead of a partial result.


Examples
---------------

Simple example, setting of parameters in a spotlight:

```xml
<iq type='set' from='client@example.org/1234' to='device@example.org/abcd' id='R0001'>
  <set xmlns='urn:nf:iot:ctr:1.0'>
    <b n="MainSwitch" v="true"/>
    <db n="HorizontalAngle" v="0"/>
    <db n="ElevationAngle" v="0"/>
  </set>
</iq>
```

Example response:

```xml
<iq type='result' from='device@example.org/abcd' to='client@example.org/1234' id='R0001'>
  <resp xmlns='urn:nf:iot:ctr:1.0'>
    <p n="MainSwitch"/>
    <p n="HorizontalAngle"/>
    <p n="ElevationAngle"/>
  </resp>
</iq>
```
