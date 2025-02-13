Copyright: /Copyright.md
CSS: {{Theme.CSSX}}
CSS: /NeuroFoundationStyles.cssx
Javascript: /AlertPopup.md.js
Javascript: /ConfirmPopup.md.js
Javascript: /PromptPopup.md.js
Javascript: /Master.js
Icon: /favicon.ico
Viewport: width=device-width,initial-scale=1

<header id="native-header">
<nav>
<div>
<button id="toggle-nav" onClick="nativeHeader.ToggleNav()">
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-list" viewBox="0 0 16 16">
<path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5m0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5"/>
</svg>
</button>
<p id="small-pagpage-name">
**[%Title]**
</p>
</div>

* &#9776;
* [Home](/Index.md)
* [Interfaces](#)
	* [Overview](/Overview.md)
	* [Representation](#)
		* [Sensor Data](/SensorData.md)
		* [Control Parameters](/ControlParameters.md)
	* [Communication Patterns](#)
		* [Sensor Data Request/Response communication pattern](/SensorDataRequestResponse.md)
		* [Sensor Data Event Subscription communication pattern](/SensorDataEventSubscription.md)
		* [Sensor Data Publish/Subscribe communication pattern](/SensorDataPublishSubscribe.md)
		* [Simple Control Actions](/ControlSimpleActions.md)
		* [Data Form Control Actions](/ControlDataForm.md)
		* [Queues](#)
		* [Quality of Service](#)
	* [Data Protection](#)
		* [Identities](/Identities.md)
		* [Authentication](/Authentication.md)
		* [Basic Authorization](/Authorization.md)
		* [Binding](/Binding.md)
		* [Transport Encryption](/TransportEncryption.md)
		* [Federation](/Federation.md)
		* [Tokens for distributed transactions](/Tokens.md)
		* [Decision Support for devices](/DecisionSupport.md)
		* [Provisioning for owners](/Provisioning.md)
		* [Peer-to-Peer communication](/P2P.md)
		* [End-to-End encryption](/E2E.md)
	* [Operation](#)
		* [Concentrators ("Things of Things")](/Concentrator.md)
		* [Discovery](/Discovery.md)
		* [Clock & Event Synchronization](/ClockSynchronization.md)
		* [Software Updates](/SoftwareUpdates.md)
	* [Agreements](#)
		* [Legal Identities](/LegalIdentities.md)
		* [Smart Contracts](/SmartContracts.md)
		* [Automatic provisioning using smart contracts](#)
	* [Schemas](#)
		* [Concentrator.xsd](/Schemas/Concentrator.xsd)
		* [Control.xsd](/Schemas/Control.xsd)
		* [Discovery.xsd](/Schemas/Discovery.xsd)
		* [E2E.xsd](/Schemas/E2E.xsd)
		* [EventSubscription.xsd](/Schemas/EventSubscription.xsd)
		* [LegalIdentities.xsd](/Schemas/LegalIdentities.xsd)
		* [P2P.xsd](/Schemas/P2P.xsd)
		* [ProvisioningDevice.xsd](/Schemas/ProvisioningDevice.xsd)
		* [ProvisioningOwner.xsd](/Schemas/ProvisioningOwner.xsd)
		* [ProvisioningTokens.xsd](/Schemas/ProvisioningTokens.xsd)
		* [SensorData.xsd](/Schemas/SensorData.xsd)
		* [SmartContracts.xsd](/Schemas/SmartContracts.xsd)
		* [SoftwareUpdates.xsd](/Schemas/SoftwareUpdates.xsd)
		* [Synchronization.xsd](/Schemas/Synchronization.xsd)
	* [Agent API](/Documentation/Neuron/Agent.md)
	* [Software](/Implementations.md)
*
* <p id="large-pagpage-name">[%Title]</p>
* [Neuro-Foundation](#)
	* [\.com](https://neuro-foundation.com/)
	* [\.io](https://neuro-foundation.io/)
	* [\.net](https://neuro-foundation.net/)
	* [\.org](https://neuro-foundation.org/)
* [Partners](#)
	* [Trust Anchor Group](/Partners/TAG/Introduction.md)
	* [Creturner](https://www.creturner.com/)
	* [LynxNode](/Partners/LynxNode/Introduction.md)
	* [ABC4.IO](https://abc4.io/)
* [More Information](#)
	* [Papers](#)
		* [IoT Harmonization using XMPP](/Papers/IoT%20Harmonization%20using%20XMPP.pdf)
		* [Biotic - Executive Summary](/Papers/Biotic%20-%20Executive%20Summary.pdf)
		* [Identity Architecture for Smart Societies](/Papers/Identity%20Architecture%20for%20Smart%20Societies.pdf)
		* [Neuro-Ledger, Executive Summary](/Papers/Neuro-Ledger,%20Executive%20Summary.pdf)
		* [Neuro-Ledger and Sustainability](/Papers/Neuro-Ledger%20and%20Sustainability.pdf)
		* [Neuro-Features, Executive Summary](/Papers/Neuro-Features,%20Executive%20Summary.pdf)
		* [Tokenization of sustainable real estate in Smart Cities](/Papers/Tokenization%20of%20sustainable%20real%20estate%20in%20Smart%20Cities.pdf)
		* [Smart Agriculture, Executive Summary](/Papers/Smart%20Agriculture,%20Executive%20Summary.pdf)
		* [Neuro-Payment architecture](/Papers/Neuro-Payment%20architecture.pdf)
		* [Open Threat Intelligence using Neuro-Ledger](/Papers/Open%20Threat%20Intelligence%20using%20Neuro-Ledger.pdf)
		* [Interoperability of Medical Records on the Neuro-Ledger](/Papers/Interoperability%20of%20Medical%20Records%20on%20the%20Neuro-Ledger.pdf)
		* [Federated Clock Synchronization in IIoT](/Papers/Federated%20Clock%20Synchronization%20in%20IIoT.pdf)
	* [Books](#)
		* [Mastering Internet of Things](https://www.packtpub.com/en-us/product/mastering-internet-of-things-9781788397483)
		* [Learning Internet of Things](https://www.amazon.com/Learning-Internet-Things-Peter-Waher/dp/1783553537/)
	* [GitHub](https://github.com/Neuro-Foundation)
		* [IoT Gateway](https://github.com/Neuro-Foundation/IoTGateway)
		* [Mastering Internet of Things](https://github.com/Neuro-Foundation/MIoT)
		* [Neuro-Ledger](#)
		* [Neuron (IoT Broker)](#)
		* [Neuro-Access (Maui)](https://github.com/Trust-Anchor-Group/NeuroAccessMaui)
		* [Neuro-Access (React Native)](https://github.com/Trust-Anchor-Group/NeuroAccessReactNative)
		* [LegalLab](https://github.com/Trust-Anchor-Group/LegalLab)
		* [ComSim](https://github.com/Trust-Anchor-Group/ComSim)
		* [Templates](#)
			* [Payment Service](https://github.com/Trust-Anchor-Group/TemplatePaymentService)
			* [Content-Only Service](https://github.com/Trust-Anchor-Group/TemplateContentOnlyPackage)
	* [On the Web](#)
		* [Documentation](https://lab.tagroot.io/Documentation/Index.md)
		* [Community](https://lab.tagroot.io/Community/Index.md)
		* [Markdown](/Markdown.md)
		* [Script](/Script.md)
		* [XMPP](https://xmpp.org/)
	* [Contact](/Feedback.md)

</nav>
</header>
<main>

[%Details]

</main>

<dialog id ="native-popup-container"></dialog>