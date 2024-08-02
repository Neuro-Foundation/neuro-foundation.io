Title: Invitation
Description: This page provides the user with an invitation to create an account on the server.
Date: 2024-08-01
Author: Peter Waher
Master: Master.md

=====================================================================================

Invitation Code
===================

Below is an invitation code that you can scan if you want to create a [*Neuro-Access*](https://github.com/Trust-Anchor-Group/NeuroAccessMaui)[^app]
account on this server. You don't need an account on this server to access the service, as the underlying network is *federated*. This means you
can choose to have your account on any valid server, and still interact with this site. But if you choose to create an account
on this server, you can do so. Install the app, and before you provide the name of your new account, select to choose a custom *Service Provider*.
You will be allowed to scan the below *Invitation Code*, in the form of a QR code. Once the code is scanned in the app, it will be directed to this 
server. When your account has been successfully created, you can continue with the normal [login](/TemplateContent/Login.md).

{{
GW:=Waher.IoTGateway.Gateway;
ApiKey:=select top 1 * from ApiKeys where Owner="TemplateContent";
if !exists(ApiKey) then
(
	ApiKey:=Create(Waher.Service.IoTBroker.DataStorage.ApiKey);
	do
	(
		ApiKey.Key:=Waher.Security.Hashes.BinaryToString(GW.NextBytes(32));
		Prev:=select top 1 * from ApiKeys where Key=ApiKey.Key;
	) 
	while exists(Prev);

	ApiKey.Secret:=Waher.Security.Hashes.BinaryToString(GW.NextBytes(32));
	ApiKey.Owner:="TemplateContent";
	ApiKey.Created:=Now;
	ApiKey.MaxAccounts:=5000;

	SaveNewObject(ApiKey);

	GW.SendNotification("Content-Only Package Template API Key generated.");
);

try
(
	Data:=<ApiKey xmlns="http://waher.se/schema/Onboarding/v1.xsd"
					key=ApiKey.Key
					secret=ApiKey.Secret
					domain=GW.Domain />;
	Data:=Utf8Encode(str(Data));
	Key:=RandomBytes(16);
	IV:=RandomBytes(16);
	Data:=Aes256Encrypt(Data,Key,IV);
	Req:=<Info xmlns="http://waher.se/schema/Onboarding/v1.xsd" 
				base64=Base64Encode(Data)
				once=true 
				expires=Now.AddDays(1).ToUniversalTime() />;
	Info:=GW.XmppClient.IqSet("onboarding.id.tagroot.io",str(Req),10000);
	Code:=select /default:Code/@code from Xml(Info.InnerXml);
	URL:="obinfo:id.tagroot.io:"+Code+":"+Base64Encode(Key)+":"+Base64Encode(IV);

	]]<img src="/QR/((UrlEncode(URL) ))" alt="Invitation Code" width="400" height="400"/>

```
((URL))
```

[[;

	Data:=null;
	Key:=null;
	IV:=null;
	URL:=null;
)
catch
(
	]]<p class="error">((Exception.Message))</p>[[
)
}}

[^app]:	The *Neuro-Access* app is a smart phone app that can be downloaded for 
[Android](https://play.google.com/store/apps/details?id=com.tag.NeuroAccess) or 
[iOS](https://apps.apple.com/se/app/neuro-access/id6446863270).
By using any of these apps, or any app derived from these, or compatible with these, 
to login, you avoid having to create credentials on each site you visit. This helps 
you protect your credentials and make sure external entities never process your sensitive 
information without your consent.
