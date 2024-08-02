Title: Neuro-Access Login
Description: This page allows you to login using your Neuro-Access app.
Date: 2024-08-01
Author: Peter Waher
Master: Master.md
JavaScript: Login.js
JavaScript: /Events.js
CSS: /QuickLogin.css
Neuron: {{GW:=Waher.IoTGateway.Gateway;Domain:=empty(GW.Domain) ? (x:=Before(After(GW.GetUrl("/"),"://"),"/");if contains(x,":") and exists(number(after(x,":"))) then "localhost:"+after(x,":") else "localhost") : GW.Domain}}

=====================================================================================

Neuro-Access Login
======================

Some features[^features] of the **Content-Only Template** require you to login using *Neuro-Access*. You do this using the 
[*Neuro-Access* App](https://github.com/Trust-Anchor-Group/NeuroAccessMaui)[^app] (or compatible). 
You login by either scanning the code presented below, or, if viewing from the phone with the app, clicking 
on the code directly.

<div id="quickLoginCode" data-mode="image" data-serviceId="{{QuickLoginServiceId(Request)}}" 
data-purpose="To perform a quick login on {{Domain}}, to access protected functions of the Content-Only Service Template. This login request is valid for five (5) minutes."></div>

Do you need to create an account on this server? Install the app, and when you get the option to choose a *Service Provider*, select to change
provider. You will be allowed to scan an *Invitation Code*, in the form of a QR code. You can generate such an *Invitation Code* by clicking 
this link: <a href="/TemplateContent/Invitation.md" target="_blank">Get invitation code</a>.

[^features]:	The following features require you to login:
	
	* Displaying content displaying information available in your Neuro-Access identity.

[^app]:	The *Neuro-Access* app is a smart phone app that can be downloaded for 
[Android](https://play.google.com/store/apps/details?id=com.tag.NeuroAccess) or 
[iOS](https://apps.apple.com/se/app/neuro-access/id6446863270).
By using any of these apps, or any app derived from these, or compatible with these, 
to login, you avoid having to create credentials on each site you visit. This helps 
you protect your credentials and make sure external entities never process your sensitive 
information without your consent.
