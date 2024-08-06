Data Form Control Actions
==========================

Data form control actions can be used if human interfaces are used to interact with users. Forms can also be used to get an inventory of available
control parameters, and how they are grouped, validated and supposed to work. The data form is first retrieved from the control server by sending a
`<getForm/>` element in an `<iq type="get"/>` stanza to the control server. It will respond with a data form. To set the parameters retrieved in the form, two
options are available. Either the parameters are set using [simple control actions](ControlSimpleActions.md), or they are set sending a form of type
`submit` in a `<set/>` element in an `<iq type="set"/>` stanza to the control server. Note that it is permitted to send only a partial form back to the control server.

```uml:Simple Control
@startuml
Client -> Device : iq[type=get](getForm)
Activate Device

Device -> Device : get parameters
Activate Device

Client <- Device : iq[type=result](x)
Deactivate Device
Deactivate Device

Client -> Device : iq[type=set](set(x))
Activate Device

Device -> Device : set parameters in form
Activate Device

Client <- Device : iq[type=result](resp)
Deactivate Device
Deactivate Device
@enduml
```

If the device is divided into nodes, both the `<getForm/>` and the `<set/>` elements can include node definitions to specify which nodes are implied.
The response is also the same, regardless if a form or a set of simple control parameter actions are sent. It is either an `<iq type="error"/>` stanza, 
in case the operation is rejected, or an `<iq type="result"/>` stanza, in case the operation succeeded, or was partially accepted. The result contains 
the nodes and parameters successfully operated on. If this set is smaller than the original request, the device decided to reduce the request, 
probably due to restrictions based on the sender identity. If the device denies all control operations, an error is returned instead of a partial result.


Examples
---------------

Getting a control form from a spotlight:

```xml
<iq type='get' from='client@example.org/1234' to='device@example.org/abcd' id='R0001'>
  <getForm xmlns='urn:ieee:iot:ctr:1.0'/>
</iq>
```

Data form response:

```xml
<iq type='result' from='device@example.org/abcd' to='client@example.org/1234' id='R0001'>
  <x type='form'
      xmlns='jabber:x:data'
      xmlns:xdv='http://jabber.org/protocol/xdata-validate'
      xmlns:xdl='http://jabber.org/protocol/xdata-layout'
      xmlns:xdd='urn:xmpp:xdata:dynamic'>
    <title>Spotlight</title>
    <xdl:page label='Output'>
      <xdl:fieldref var='MainSwitch'/>
    </xdl:page>
    <xdl:page label='Direction'>
      <xdl:fieldref var='HorizontalAngle'/>
      <xdl:fieldref var='ElevationAngle'/>
    </xdl:page>
    <field var='xdd session' type='hidden'>
      <value>83CAA4BC-6D3A-40E6-90DC-5C3CAA030AE1</value>
    </field>
    <field var='MainSwitch' type='boolean' label='Main switch'>
      <desc>If the spotlight is turned on or off.</desc>
      <value>true</value>
      <xdd:notSame/>
    </field>
    <field var='HorizontalAngle' type='text-single' label='Horizontal angle:'>
      <desc>Horizontal angle of the spotlight.</desc>
      <value>0</value>
      <xdv:validate datatype='xs:double'>
        <xdv:range min='-180' max='180'/>
      </xdv:validate>
      <xdd:notSame/>
      <pGroup xmlns='urn:ieee:iot:ctr:1.0' name='direction'/>
    </field>
    <field var='ElevationAngle' type='text-single' label='Elevation angle:'>
     <desc>Elevation angle of the spotlight.</desc>
     <value>0</value>
     <xdv:validate datatype='xs:double'>
       <xdv:range min='-90' max='90'/>
     </xdv:validate>
     <xdd:notSame/>
     <pGroup xmlns='urn:ieee:iot:ctr:1.0' name='direction'/>
    </field>
  </x>
</iq>
```

Setting parameters using a data form. In this case, note that only the field values and types are included, as outlined in 
[XEP-0004](https://xmpp.org/extensions/xep-0004.html):

```xml
<iq type='set' from='client@example.org/1234' to='device@example.org/abcd' id='R0002'>
  <set xmlns='urn:ieee:iot:ctr:1.0'>
    <x type='submit' xmlns='jabber:x:data'>
      <field var='xdd session' type='hidden'>
        <value>83CAA4BC-6D3A-40E6-90DC-5C3CAA030AE1</value>
      </field>
      <field var='MainSwitch' type='boolean'>
        <value>true</value>
      </field>
      <field var='HorizontalAngle' type='text-single'>
        <value>0</value>
      </field>
      <field var='ElevationAngle' type='text-single'>
       <value>0</value>
      </field>
    </x>
  </set>
</iq>
```

Example response:

```xml
<iq type='result' from='device@example.org/abcd' to='client@example.org/1234' id='R0002'>
  <resp xmlns='urn:ieee:iot:ctr:1.0'>
    <p n="MainSwitch"/>
    <p n="HorizontalAngle"/>
    <p n="ElevationAngle"/>
  </resp>
</iq>
```