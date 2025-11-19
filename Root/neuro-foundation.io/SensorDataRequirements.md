The [Sensor Data namespace](Schemas/SensorData.xsd) [defines](SensorData.md) the following 
elements that can be sent in stanzas. The following table list the elements, the type of 
stanza used, the entities that can or need to handle incoming stanzas containing the 
corresponding element, as well as implementation requirements, if the namespace is present in 
the device's [XEP-0030](https://xmpp.org/extensions/xep-0030.html) *Service Discovery* response. 
Elements associated with any response stanzas are assumed to be implemented by the entity 
making the corresponding request. Both the Sensor Client and Sensor Server entities are XMPP 
clients. The Sensor Data namespace is primarily intended for connected clients. The broker is 
only involved in routing stanzas between sensor clients and sensor servers.

| Namespace elements                                    ||||
| Element    | Stanza Type | Sensor Client | Sensor Server |
|:-----------|:------------|:--------------|:--------------|
| `req`      | `iq get`    |>> ==>       <<| Required      |
| `accepted` | `iq result` | Required^1    |>> <==       <<|
| `started`  | `iq result` | Required^2    |>> <==       <<|
|            | `message`   | Required^3    |>> <==       <<|
| `resp`     | `iq result` | Required^4    |>> <==       <<|
|            | `message`   | Required^5    |>> <==       <<|
| `cancel`   | `iq set`    |>> ==>       <<| Required      |
| `done`     | `message`   | Required^6    |>> <==       <<|

1. A sensor server can choose to start readout at a later time, and returning the `accepted`
element in the response, to let the client know the request has been received and been 
accepted, but the sensor data readout has not yet started.

2. A sensor server can choose to return the `started` element in the response, to let the
client know the request has been accepted, and that the sensor data readout has started, but
there are yet no data to return.

3. If the sensor server responded to the request with an `accepted` response, it sends the
`started` element in a message stanza, when the readout starts.

4. The sensor server can choose to return sensor data directly in the response to the request,
by returning a `resp` element in the `iq result` stanza. This means the request has been
accepted, the readout has started, and sensor data is being returned. The sensor data does not
have to be complete, and further data can be sent in subsequent message stanzas. This is
indicated using a `more` attribute on the `resp` element.

5. If the sensor server has responded to the request using any of the `accepted`, `started`
or `resp` elements, any further sensor data reported is sent in separate message stanzas.
Any of the `resp` elements without a `more` attribute having value `true` indicates that the
readout is complete.

6. If the sensor server has indicated that more information is to be sent (either by returning
`accepted` or `started` in the response, but not included any `resp` messages, or by sending
an `resp` in a message, with a `more` attribute set to `true`), but there is no more sensor
data to report, a `done` element is sent in a message to conclude the readout.
