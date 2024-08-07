Title: Software Updates
Description: Software Updates page of neuro-foundation.io
Date: 2024-08-06
Author: Peter Waher
Master: Master.md
CSS: NeuroFoundationStyles.cssx

=============================================

Software Updates
==================

This document outlines the XML representation of the software updates service. The XML representation is modelled using an annotated XML Schema:

| Discovery                                                             ||
| ------------|----------------------------------------------------------|
| Namespace:  | `urn:nf:iot:swu:1.0`                                     |
| Schema:     | [Discovery.xsd](Schemas/SoftwareUpdates.xsd)             |

![Table of Contents](toc)

Motivation and design goal
----------------------------

It is important for things to be able to update their software, or firmware, in a timely fashion, as soon as manufacturers fix problems or 
provide new functionality. The federated, decentralized broker infrastructure can be used to distribute signed software packages to things, 
to facilitate keeping things up-to-date both quickly, and in a scalable manner.

The software update feature described in this document, is designed with the following goals in mind:

* Brokers are used to distribute software packages.
* Software packages must be digitally signed using public-key cryptography, to allow clients to detect the introduction of bad or fraudulent
software packages.
* Devices should be notified when new software is available.
* It should be easy to browse and download available software packages.
* The contents of software packages is manufacturer-specific.
* The infrastructure only distributes software packages.
* Package distribution must be scalable, to allow fo updating large amounts of devices over a short period of time.


Software packages
---------------------

Software packages are single binary files, identified by their local file name (i.e. no folder information in file names). Apart from the
binary file stored on the broker, the broker also maintains a set of meta-information about the file. This information is typically
represented as attributes in a `<packageInfo/>` element:

| Attribute    | Type                    | Use      | Description |
|:-------------|:------------------------|:---------|:------------|
| `fileName`   | `xs:string`             | Required | The local file name of the software package. |
| `signature`  | `xs:base64Binary`       | Required | Digital signature of software package. Choice of algorithms and keys that have been used to generate the signature is manufacturer specific. |
| `published`  | `xs:dateTime`           | Required | Timepoint when the software package was published. |
| `supersedes` | `xs:dateTime`           | Optional | If the current version supersedes an older version, this attribute contains the timepoint of the previous version of the package |
| `created`    | `xs:dateTime`           | Required | Timepoint when the software package record was created (when the first version of the package was published). |
| `url`        | `xs:anyURI`             | Required | URL to the corresponding software package. |
| `bytes`      | `xs:nonNegativeInteger` | Required | Size of package file, in number of bytes. |

Example:

```xml:Example package information
<packageInfo fileName='Software.package' 
             signature='GkFUpT+sCzDck5HcV6M8ueGz3B...' 
             published='2019-08-06T17:35:26.667Z' 
             supersedes='2019-08-06T15:33:47.696Z' 
             created='2019-07-11T14:23:31.479Z' 
             url='https://example.org/Packages/Software.package?s=GkFUpT+...?p=2019-08-06T17:35:26.667Z' 
             bytes='80459904' 
             xmlns='urn:nf:iot:swu:1.0'/>
```

### Downloading software packages

When downloading a software package, the `url` attribute contains a URL to the file. The URI scheme of the URL defines how the file should 
be downloaded. If it begins with `http:` or `https:`, the HTTP or HTTPS protocols are used respectively to download the file. Broker 
implementations can choose to provide other mechanisms as well. For instance, if the `httpx:` URI scheme is used, HTTP over XMPP is to be 
used, as defined in [XEP-0332: HTTP over XMPP](https://xmpp.org/extensions/xep-0332.html). Other well-known URI schemes can also be used, 
such as `ftp:` for the File Transfer Protocol.

### Distribution of package files

In order to allow for large-scale distribution of software packages, centralized resource locations for software packages should be avoided.
If millions or billions of devices get notified about the availability of new software from the manufacturer, they will act as an efficient
Distributed Denial of Service (DDoS) attack on the manufacturer's servers, if requesting the software at the same time, or during a short
time span. An alternative, is to use the federated broker infrastructure to mirror the software package across the network and allow the
devices to fetch the updated software from the brokers they are already connected to. This allows the brokers to control the distribution
of software packages, based on current load, as they also control the client notifications.

Furthermore, the brokers can be organized into a tree structure, where a broker can be connected to a parent broker, and so on. A child 
broker can subscribe to all software packages available on its parent broker, and download new packages as they become available, effectively
mirroring software packages available on the parent broker. Depending on the depth of such a broker hierarchy, such an architecture
efficiently distributes the load on the infrastructure, when distributing new software, as illustrated in the following diagram.

```uml:Package Distribution
@startuml
node "Root Broker" as RootBroker 
node "Broker<sub>1</sub>" as Broker1
node "Broker<sub>2</sub>" as Broker2
cloud "..." as BrokerE
node "Broker<sub>N</sub>" as BrokerN
node "Broker<sub>2,1</sub>" as ChildBroker1
node "Broker<sub>2,2</sub>" as ChildBroker2
cloud "..." as ChildBrokerE
node "Broker<sub>2,M</sub>" as ChildBrokerM
node "Client<sub>2,2,1</sub>" as Client1
node "Client<sub>2,2,2</sub>" as Client2
cloud "..." as ClientE
node "Client<sub>2,2,K</sub>" as ClientK

RootBroker <-- Broker1
RootBroker <-- Broker2
RootBroker <-- BrokerE
RootBroker <-- BrokerN
Broker2 <-- ChildBroker1
Broker2 <-- ChildBroker2
Broker2 <-- ChildBrokerE
Broker2 <-- ChildBrokerM
ChildBroker2 <-- Client1
ChildBroker2 <-- Client2
ChildBroker2 <-- ClientE
ChildBroker2 <-- ClientK
@enduml
```

### Signatures and keys

All software packages must be signed, to allow clients to verify that downloaded software packages are complete, and actually from the 
expected manufacturer. What signature algorithm and keys are used to sign the package, is manufacturer specific. The algorithms can be 
chosen from the algorithms supported by [End-to-End Encryption](E2E.md), or they can be others. A client must verify the signature of each 
downloaded package to verify if it is authentic or not. If the signature does not match the downloaded package, the client must discard the 
package, as it is either incomplete, or not generated by the expected manufacturer.

### Versions

Software packages are identified using their local file names. As clients subscribe to software updates based on the file name, this means 
that the file name cannot include version information. Instead, the broker publishes timestamps when the software package was published
on the broker. These timestamps can be used to determine if a software package on the broker is newer than what is currently being executed.
The contents of the software packages is manufacturer-specific. Any further version-information can be encoded into the software package
itself.

### Performing the update

The update procedure is also manufacturer specific. It is recommended however, that the client backup important data before performing
an update. It is up to the application to determine, if an operator needs to confirm the update before performing the update, or if the
update should be automatic.

### Uploading software packages

Uploading the original software packages, is an implementation issue, and not discussed in this specification. There is no standardized
communication interface for uploading software packages.

Getting package information
--------------------------------

To get information about a specific software package, the client sends a `<getPackageInfo/>` element in an `<iq type='get'/>` stanza to
the software update service on the broker. The element specifies the package it wants information about, using the `fileName` attribute.
The service responds with a `<getPackageInfo/>` element with information about the software package, if it exists.

Example:

```xml:Getting package information
<iq type='get'
    from='client@example.org/resource'
    to='software.example.org'
    id='1'>
   <getPackageInfo xmlns='urn:nf:iot:swu:1.0' fileName='Software.package'/>
</iq>

<iq type='result'
    from='software.example.org'
    to='client@example.org/resource'
    id='1'>
   <packageInfo fileName='Software.package' 
                signature='GkFUpT+sCzDck5HcV6M8ueGz3B...' 
                published='2019-08-06T17:35:26.667Z' 
                supersedes='2019-08-06T15:33:47.696Z' 
                created='2019-07-11T14:23:31.479Z' 
                url='https://example.org/Packages/Software.package?s=GkFUpT+...?p=2019-08-06T17:35:26.667Z' 
                bytes='80459904' 
                xmlns='urn:nf:iot:swu:1.0'/>
</iq>
```

Getting available software packages
--------------------------------------

To get a list of available software packages, a client sends a `<getPackages/>` element in an `<iq type='get'/>` stanza to the software
update service on the broker. The broker responds with a `<packages/>` element containing a sequence (possibly empty) of `<packageInfo/>`
elements, each one containing information about a software package available to the client.

```xml:Getting package information
<iq type='get'
    from='client@example.org/resource'
    to='software.example.org'
    id='2'>
   <getPackageInfo xmlns='urn:nf:iot:swu:1.0' fileName='Software.package'/>
</iq>

<iq type='result'
    from='software.example.org'
    to='client@example.org/resource'
    id='2'>
   <packages xmlns='urn:nf:iot:swu:1.0'>
      <packageInfo fileName='Software.package' 
                   signature='GkFUpT+sCzDck5HcV6M8ueGz3B...' 
                   published='2019-08-06T17:35:26.667Z' 
                   supersedes='2019-08-06T15:33:47.696Z' 
                   created='2019-07-11T14:23:31.479Z' 
                   url='https://example.org/Packages/Software.package?s=GkFUpT+...?p=2019-08-06T17:35:26.667Z' 
                   bytes='80459904'/>
      ...
   </packages>
</iq>
```

Subscribing to software updates
----------------------------------

To subscribe to notifications about a software package, a client sends a `<subscribe/>` element in an `<iq type='set'/>` stanza to the
software update service with the filename of the software package file of interest in the `fileName` attribute. The client can choose
to subscribe to notifications about all software packages by subscribing to the filename `*`. The subscription operator is idempotent. 
Subscribing to a package that is already subscribed to, does not increase the number of subscriptions. The service responds with an
empty response, even if the software package does not exist (yet). It might, in the future. Invalid requests, or invalid file names
generate error responses.

```xml:Subscribing to software package events
<iq type='set'
    from='client@example.org/resource'
    to='software.example.org'
    id='3'>
   <subscribe xmlns='urn:nf:iot:swu:1.0' fileName='Software.package'/>
</iq>

<iq type='result'
    from='software.example.org'
    to='client@example.org/resource'
    id='3'/>
```

**Note**: The broker can employ a security mechanism capping the number of subscriptions allowed by a client. If the maximum is reached, new subscriptions return
error responses, until the client unsubscribes from previous subscriptions.

Software package notifications
---------------------------------

A client that is subscribed to updates related to a software package, is notified of updates made to the package, through asynchronous
`<message/>` stanzas containing a `<packageInfo/>` element with the updated information. If the package is deleted from the broker, 
the message will contain a `<packageDeleted/>` element instead, containing the meta-data about the software package that was deleted.
If the client is offline when the change occurred, the message can be stored on the broker until the client connects, and is then sent
to the client, as part of handling off-line messages.

Example:

```xml:Notification
<message to='client@example.org'
         from='software.example.org'>
   <packageInfo fileName='Software.package' 
                signature='GkFUpT+sCzDck5HcV6M8ueGz3B...' 
                published='2019-08-06T17:35:26.667Z' 
                supersedes='2019-08-06T15:33:47.696Z' 
                created='2019-07-11T14:23:31.479Z' 
                url='https://example.org/Packages/Software.package?s=GkFUpT+...?p=2019-08-06T17:35:26.667Z' 
                bytes='80459904' 
                xmlns='urn:nf:iot:swu:1.0'/>
   <delay xmlns='urn:xmpp:delay' from='example.org' stamp='2019-08-06T21:00:24.231'>Offline Storage</delay>
</message> 
```

Unsubscribing from software updates
-------------------------------------

Similarly, a client can unsubscribe from previous subscriptions by sending an `<unsubscribe/>` element in an `<iq type='set'/>` stanza 
to the software update service, specifying the software package using the `fileName` attribute. The service returns an empty response, 
even if a matching subscription does not exist. If the filename is `*`, all subscriptions are removed.

```xml:Unsubscribing from software package events
<iq type='set'
    from='client@example.org/resource'
    to='software.example.org'
    id='4'>
   <unsubscribe xmlns='urn:nf:iot:swu:1.0' fileName='Software.package'/>
</iq>

<iq type='result'
    from='software.example.org'
    to='client@example.org/resource'
    id='4'/>
```

Getting current subscriptions
---------------------------------

A client can get a list of subscriptions from the software update service. It does this, by sending an empty `<getSubscriptions/>` element
in an `<iq type='get'/>` stanza to the service, which responds with a `<subscriptions/>` element. This element contains a sequence (possibly
empty) of `<subscription/>` elements, each one containing a software package file name as a value.

```xml:Getting list of subscriptions
<iq type='get'
    from='client@example.org/resource'
    to='software.example.org'
    id='5'>
   <getSubscriptions xmlns='urn:nf:iot:swu:1.0'/>
</iq>

<iq type='result'
    from='software.example.org'
    to='client@example.org/resource'
    id='5'>
   <subscriptions xmlns='urn:nf:iot:swu:1.0'>
      <subscription>Software.package</subscription>
      ...
   </subscriptions>
</iq>
```
