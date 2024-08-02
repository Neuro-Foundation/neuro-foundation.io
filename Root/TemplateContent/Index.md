Title: Main Page
Description: Main page of Content-Only Package Template.
Date: 2024-08-01
Author: Peter Waher
Master: Master.md

=============================================

Welcome
----------

Welcome to the Content-Only service template. The package contains content files that show how to publish content of different types and
security levels, as well as how to create a content package and distribute it on a TAG Neuron(R) network.

Content Pages
---------------

Following content pages are available in the content template:

| Pages displaying content                                                                                                                                                          ||
|:--------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|
| [`ContentAdmin.md`](ContentAdmin.md)              | Shows content requiring authentication using the administrative interface.                                                     |
| [`ContentAnonymous.md`](ContentAnonymous.md)      | Shows content without user authentication (i.e. allows anonymous acces; anyone with access to the Neurno(R) can see this page) |
| [`ContentNeuroAccess.md`](ContentNeuroAccess.md)  | Shows content requiring authentication using Neuro-Acces (or similar digital identity).                                        |
| [`Index.md`](Index.md)                            | This page.                                                                                                                     |
| [`Invitation.md`](Invitation.md)                  | Allows a new user of *Neuro-Access*[^app] (or compatible) to create a new account on the server hosting this service.          |
| [`Login.md`](Login.md)                            | Allows you to login to the page using *Neuro-Access* (or compatible).                                                          |
| [`Logout.md`](Logout.md)                          | Allows you to logout from the page to which you had previously logged into using *Neuro-Access*.                               |

The following files are used by the above content files to provide structure to the information:

| Structual content and application logic files                                                                                                                                                      ||
|:----------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Login.js`            | Contains Javascript handling logging in using *Neuro-Access*.                                                                                                               |
| `Master.md`           | Is the master file, and provides a consisten look and feel, as well as a menu, to all content files (which are displayed as detail information in the master-detail setup). |
| `TemplateStyles.cssx` | Adds style definitions to the content files that are not available in the selected theme.                                                                                   |


Reference Pages
------------------

Following is a list of links to reference information that can be useful:

* [Back-end server script](/Script.md)
* [Markdown syntax](/Script.md)
* [TAG Documentation](https://lab.tagroot.io/Documentation/Index.md)
* [TAG Community](https://lab.tagroot.io/Community/Index.md)
* [TAG on GitHub](https://github.com/Trust-Anchor-Group)
* [This repository](https://github.com/Trust-Anchor-Group/TemplateContentOnlyPackage)

[^app]:	The *Neuro-Access* app is a smart phone app that can be downloaded for 
[Android](https://play.google.com/store/apps/details?id=com.tag.NeuroAccess) or 
[iOS](https://apps.apple.com/se/app/neuro-access/id6446863270).
By using any of these apps, or any app derived from these, or compatible with these, 
to login, you avoid having to create credentials on each site you visit. This helps 
you protect your credentials and make sure external entities never process your sensitive 
information without your consent.
