Title: Neuro-Access
Description: This page displays the contents of the Neuro-Access ID used to login.
Date: 2024-08-01
Author: Peter Waher
Master: Master.md
UserVariable: QuickLoginUser
Login: Login.md

=============================================

Neuro-Access
---------------

This page can be viewed by users who authenticate themselves using Neuro-Access (or similar digital identity).
Below, you will find what information is found in the ID you used to login to the service.

| General Information                               ||
|:----------------|:---------------------------------|
| Id              | `{{QuickLoginUser.Id}}`          |
| Provider        | `{{QuickLoginUser.Provider}}`    |
| State           | `{{QuickLoginUser.State}}`       |
| User Name       | `{{QuickLoginUser.UserName}}`    |
| Full Address    | `{{QuickLoginUser.FullAddress}}` |
| Network Address | `{{QuickLoginUser.Jid}}`         |
| Created         | `{{QuickLoginUser.Created}}`     |
| Updated         | `{{QuickLoginUser.Updated}}`     |
| From            | `{{QuickLoginUser.From}}`        |
| To              | `{{QuickLoginUser.To}}`          |

| Encoded Properties                             ||
|:-------------------------|:---------------------|
{{foreach Property in QuickLoginUser.Properties do
	]]| `((Property.Key))` | `((Property.Value))` |
[[}}

| Cryptographic Information                                  ||
|:---------------------|:-------------------------------------|
| Client Key Algorithm | `{{QuickLoginUser.ClientKeyName}}`   |
| Client Public Key    | `{{QuickLoginUser.ClientPubKey}}`    |
| Server Signature     | `{{QuickLoginUser.ServerSignature}}` |

{{
AttachmentIndex:=0;
foreach Attachment in QuickLoginUser.Attachments do
(
	]]

| Attachment ((++AttachmentIndex))           ||
|:-------------|:-----------------------------|
| Id           | `((Attachment.Id))`          |
| Content-Type | `((Attachment.ContentType))` |
| File Name    | `((Attachment.FileName))`    |
| Signature    | `((Attachment.Signature))`   |
| Timestamp    | `((Attachment.Timestamp))`   |
| URL          | `((Attachment.Url))`         |
[[;

	if StartsWith(Attachment.ContentType,"image/") then
		]]|>> <img src="((Attachment.BackEndUrl))" class="ImageAttachment"/> <<||
[[
)
}}



