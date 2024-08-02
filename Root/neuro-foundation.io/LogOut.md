Title: Neuro-Access Logout
Description: This page logs you out from Neuro-Access on this site.
Date: 2024-08-01
Author: Peter Waher
Master: Master.md

=====================================================================================

Neuro-Access Logout
======================

{{If exists(QuickLoginUser) then
(
	Destroy(QuickLoginUser);
	]]You have successfully logged out of the system.[[
)
else
	]]You're not logged into the system.[[
}}

[Click here to go back to the main page.](Index.md)

