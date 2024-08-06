Sensor Data Publish/Subscribe communication pattern
========================================================

XMPP supports three Publish/Subscribe communication patterns:

1.  Using the `<presence/>` stanza. All presence stanzas will be forwarded to all contacts with an approved presence subscription. Since the presence stanza
    can contain custom XML, it is possible to embed sensor data XML in a presence stanza, and have it forwarded to approved contacts. There is no way for
	subscribers to state if they really want the information they are receiving or not.

2.  Publishing information on a node on a Publish/Subscribe service on an XMPP broker, in accordance with [XEP-0060](https://xmpp.org/extensions/xep-0060.html).
    This is the recommended method for concentrators wishing to publish information from internal nodes.

3.  Publishing information using the Personal Eventing Protocol in XMPP, as defined in [XEP-0163](https://xmpp.org/extensions/xep-0163.html). It's a much-simplified
    way to implement Publish/Subscribe for sensor data from simple devices (not concentrators) using XMPP.

**Note**: The Publish/Subscribe pattern might be an efficient way to distribute sensor data to many subscribers. But it comes at the price of flexibility and
privacy. Only use the Publish/Subscribe pattern from devices that actually have many subscribers, and in cases where data does not need to be tailored for
individual receivers, such as is the case if using provisioning on a field level. The Publish/Subscribe pattern also leaves little room for subscribers to tailor
under what circumstances they want to be updated. Note also that the data is processed and persisted on the broker (to some extent). End-to-end encryption is
not supported. If privacy, flexibility or customization are concerns, the [Request/Response](SensoDataRequestResponse.md) or
[Event Subscription](SensorDataEventSubscription.md) patterns might be more suitable. They also place less load on the broker if there are few subscribers.

In all three cases, [sensor data](SensorData.md) is represented using the same XML representation as used in the other sensor data related 
communication patterns.

| Sensor Data                                           ||
| ------------|------------------------------------------|
| Namespace:  | urn:ieee:iot:sd:1.0                      |
| Schema:     | [SensorData.xsd](Schemas/SensorData.xsd) |

Examples
-----------------

### Publishing data using the Personal Eventing Protocol (PEP)

When using the Personal Eventing Protocol extension ([XEP-0163](https://xmpp.org/extensions/xep-0163.html)), sensors publish data to their broker,
without specifying any node. Doing so, the data is published to the bare JID of the sensor. Anyone subscribing to the presence of the sensor, and
with entity capabilities showing they receive sensor data, will automatically be notified by the broker about the data that has been published (see below). PEP
provides a simple publish-subscribe protocol, that includes a consent-based authorization step. Only clients with an accepted presence subscription to
the sensor will be able to receive the data. The sensor can remove the authorization by removing the presence subscription.

```uml:Publish/Subscribe with PEP
@startuml
Activate Client
Activate Broker1
Activate Broker2
Activate Sensor

Client -> Broker1 : subscribe presence[to=sensorJid]
Broker1 -> Broker2 : subscribe presence[from=clientJid, to=sensorJid]
Broker2 -> Sensor : subscribe presence[from=clientJid, jid=sensorJid]
Sensor -> Broker2 : accept
Broker2 -> Broker2 : update roster
Broker2 -> Broker1 : accept
Broker1 -> Broker1 : update roster
Broker1 -> Client : accept

Sensor -> Broker2 : publish[sensor data]
Broker2 --> Sensor : ok
Broker2 -> Broker1 : notification[if client capabilities show interest]
Broker1 -> Client : notification[if client capabilities show interest]

Deactivate Client
Deactivate Broker1
Deactivate Broker2
Deactivate Sensor
@enduml
```

PEP is fully described in [XEP-0163](https://xmpp.org/extensions/xep-0163.html). Please read this document for details.

```xml
<iq from='client@example.org/1234' type='set' id='pub1'>
  <pubsub xmlns='http://jabber.org/protocol/pubsub'>
    <publish node='urn:ieee:iot:sd:1.0'>
      <item>
        <resp xmlns="urn:ieee:iot:sd:1.0" id="00000001">
          <ts v="2017-09-22T15:22:33Z">
            <q n="Temperature" v="12.3" u="C" m="true" ar="true"/>
            <s n="SN" v="12345678" i="true" ar="true"/>
          </ts>
        </resp>
      </item>
    </publish>
  </pubsub>
</iq>
```

**Note**: There is no destination address in the `iq` stanza. This means the stanza is sent to the server. A PEP-compliant XMPP server (broker) treats
all accounts as individual Publish/Subscribe services.

### Implicit subscription of data using the Personal Eventing Protocol (PEP)

A contact implicitly subscribes to sensor data if it does the following:

1.  Supports [XEP-0030: Service Discovery](https://xmpp.org/extensions/xep-0030.html). (Most XMPP clients do.)
2.  Supports [XEP-0115: Entity Capabilities](https://xmpp.org/extensions/xep-0115.html). (Most XMPP clients do.)
3.  Publishes support for the feature `urn:ieee:iot:sd:1.0+notify`.
4.  Subscribes to the presence of the sensor.

The Publish/Subscribe service managed by PEP, checks all contacts of the sensor for the sensor data feature, and forwards published data to them.

### Receiving sensor data events using the Personal Eventing Protocol (PEP)

The PEP service forwards published information as messages. It can optionally append information about the full JID of the published in an
`<addresses/>` element in accordance with [XEP-0033: Extended Stanza Addressing](https://xmpp.org/extensions/xep-0033.html), to make it possible for 
the subscriber to differentiate between multiple connections using the same account.

```xml
<message from='device@example.org'
         to='client@example.org/1234'
         type='normal'
         id='event1'>
  <event xmlns='http://jabber.org/protocol/pubsub#event'>
    <items node='urn:ieee:iot:sd:1.0'>
      <item id='22e25a6a-ce75-251a-880b-a4ac42e4101b' publisher='device@example.org'>
        <resp id="00000001" xmlns="urn:ieee:iot:sd:1.0">
          <ts v="2017-09-22T15:22:33Z">
            <q n="Temperature" v="12.3" u="C" m="true" ar="true"/>
            <s n="SN" v="12345678" i="true" ar="true"/>
          </ts>
        </resp>
      </item>
    </items>
  </event>
  <addresses xmlns='http://jabber.org/protocol/address'>
    <address type='replyto' jid='device@example.org/abcd'/>
  </addresses>
</message>
```
