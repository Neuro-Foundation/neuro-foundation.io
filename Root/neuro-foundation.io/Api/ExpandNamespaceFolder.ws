FileFolderImg:=MarkdownToHtml(":file_folder:");
OpenFileFolderImg:=MarkdownToHtml(":open_file_folder:");
PageImg:=MarkdownToHtml(":page_with_curl:");

TreeNode(Uri,Expand,Description):=
(
	if !empty(Description) then Description:=" - " + Description;

	{
		"id":Uri, 
		"expand": "Api/" + Expand, 
		"html": "<code>"+Uri+"</code>" + Description,
		"collapsedImg": FileFolderImg,
		"expandedImg": OpenFileFolderImg
	}
);

TreeLeafNode(Uri,Link,Description):=
(
	if !empty(Description) then Description:=" - " + Description;

	{
		"id":Uri, 
		"expand": null, 
		"html": "<a href=\"" + Link + "\" target=\"_blank\"><code>"+Uri+"</code></a>" + Description,
		"collapsedImg": PageImg,
		"expandedImg": PageImg
	}
);

if Posted matches
{
	"id": "urn:nfi"
} then
(
	[TreeNode("urn:nfi:iot", "ExpandNamespaceFolder.ws", "IoT Harmonization")]
)
else if Posted matches
{
	"id": "urn:nfi:iot"
} then
(
	[
		TreeLeafNode("urn:nfi:iot:concentrator:1.0", "Schemas/Concentrator.xsd", "Concentrators"),
		TreeLeafNode("urn:nfi:iot:ctr:1.0", "Schemas/Control.xsd", "Actuator Control"),
		TreeLeafNode("urn:nfi:iot:disco:1.0", "Schemas/Discovery.xsd", "Discovery"),
		TreeLeafNode("urn:nfi:iot:e2e:1.0", "Schemas/E2E.xsd", "End-to-End Encryption"),
		TreeLeafNode("urn:nfi:iot:events:1.0", "Schemas/EventSubscription.xsd", "Event subscription"),
		TreeLeafNode("urn:nfi:iot:geo:1.0", "Schemas/Geo.xsd", "Geo-spatial information"),
		TreeLeafNode("urn:nfi:iot:hi:1.0", "Schemas/HarmonizedInterfaces.xsd", "Harmonized Interfaces"),
		TreeNode("urn:nfi:iot:hi", "ExpandNamespaceFolder.ws", "Harmonized Interfaces"),
		TreeNode("urn:nfi:iot:hia", "ExpandNamespaceFolder.ws", "Harmonized Aggregate Interfaces"),
		TreeNode("urn:nfi:iot:hie", "ExpandNamespaceFolder.ws", "Harmonized Enumerations"),
		TreeLeafNode("urn:nfi:iot:leg:id:1.0", "Schemas/LegalIdentities.xsd", "Legal identities"),
		TreeLeafNode("urn:nfi:iot:leg:sc:1.0", "Schemas/SmartContracts.xsd", "Smart Contracts"),
		TreeLeafNode("urn:nfi:iot:p2p:1.0", "Schemas/P2P.xsd", "Peer-to-Peer Connectivity"),
		TreeLeafNode("urn:nfi:iot:prov:d:1.0", "Schemas/ProvisioningDevice.xsd", "Provisioning for Devices"),
		TreeLeafNode("urn:nfi:iot:prov:o:1.0", "Schemas/ProvisioningOwner.xsd", "Provisioning for Owners"),
		TreeLeafNode("urn:nfi:iot:prov:t:1.0", "Schemas/ProvisioningTokens.xsd", "Provisioning Tokens"),
		TreeLeafNode("urn:nfi:iot:sd:1.0", "Schemas/SensorData.xsd", "Sensor Data"),
		TreeLeafNode("urn:nfi:iot:swu:1.0", "Schemas/SoftwareUpdates.xsd", "Software Updates"),
		TreeLeafNode("urn:nfi:iot:synchronization:1.0", "Schemas/Synchronization.xsd", "Synchronization")
	]
)
else if Posted matches
{
	"id": "urn:nfi:iot:hi"
} then
(
	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedInterfaces",false,FolderName);
	InterfaceFolders:=System.IO.Directory.GetDirectories(FolderName);

	[foreach InterfaceFolder in Sort(InterfaceFolders) do
	(
		RelFolderName:=InterfaceFolder.Substring(len(FolderName));
		InterfaceUri:="urn:nfi:iot:hi" + RelFolderName.Replace("\\",":");
		TreeNode(InterfaceUri, "ExpandNamespaceFolder.ws", "")
	)]
)
else if Posted matches
{
	"id": Required(Str(PId) like "urn\:nfi\:iot\:hi\:.+")
} then
(
	PId:=PId.Replace("/","\\");

	if PId.Contains("..") or PId.Contains("\\\\") or PId.Contains("?") or PId.Contains("::") then
		Forbidden("Illegal characters.");

	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedInterfaces",false,FolderName);
	SubFolderName:=FolderName+PId.Substring(14).Replace(":","\\");

	if !System.IO.Directory.Exists(SubFolderName) then
		NotFound("Folder not found.");

	SubFolders:=System.IO.Directory.GetDirectories(SubFolderName);
	FileNames:=System.IO.Directory.GetFiles(SubFolderName,"*.xml");

	join
	(
		[foreach SubFolder in Sort(SubFolders) do 
			(
				RelFolderName:=SubFolder.Substring(len(FolderName));
				InterfaceUri:="urn:nfi:iot:hi" + RelFolderName.Replace("\\",":");
				TreeNode(InterfaceUri, "ExpandNamespaceFolder.ws", "")
			)
		],
		[foreach FileName in Sort(FileNames) do 
			(
				RelFileName:=FileName.Substring(len(FolderName));
				RelUrl:=RelFileName.Replace("\\","/");
				InterfaceUri:="urn:nfi:iot:hi" + RelFileName.Replace("\\",":").Replace("-",":").Replace(".xml","");
				TreeLeafNode(InterfaceUri, "HarmonizedInterfaces"+RelUrl, "")
			)
		]
	);
)
else if Posted matches
{
	"id": "urn:nfi:iot:hia"
} then
(
	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedAggregateInterfaces",false,FolderName);
	InterfaceFolders:=System.IO.Directory.GetDirectories(FolderName);

	[foreach InterfaceFolder in Sort(InterfaceFolders) do
	(
		RelFolderName:=InterfaceFolder.Substring(len(FolderName));
		InterfaceUri:="urn:nfi:iot:hia" + RelFolderName.Replace("\\",":");
		TreeNode(InterfaceUri, "ExpandNamespaceFolder.ws", "")
	)]
)
else if Posted matches
{
	"id": Required(Str(PId) like "urn\:nfi\:iot\:hia\:.+")
} then
(
	PId:=PId.Replace("/","\\");

	if PId.Contains("..") or PId.Contains("\\\\") or PId.Contains("?") or PId.Contains("::") then
		Forbidden("Illegal characters.");

	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedAggregateInterfaces",false,FolderName);
	SubFolderName:=FolderName+PId.Substring(15).Replace(":","\\");

	if !System.IO.Directory.Exists(SubFolderName) then
		NotFound("Folder not found.");

	SubFolders:=System.IO.Directory.GetDirectories(SubFolderName);
	FileNames:=System.IO.Directory.GetFiles(SubFolderName,"*.xml");

	join
	(
		[foreach SubFolder in Sort(SubFolders) do 
			(
				RelFolderName:=SubFolder.Substring(len(FolderName));
				InterfaceUri:="urn:nfi:iot:hia" + RelFolderName.Replace("\\",":");
				TreeNode(InterfaceUri, "ExpandNamespaceFolder.ws", "")
			)
		],
		[foreach FileName in Sort(FileNames) do 
			(
				RelFileName:=FileName.Substring(len(FolderName));
				RelUrl:=RelFileName.Replace("\\","/");
				InterfaceUri:="urn:nfi:iot:hia" + RelFileName.Replace("\\",":").Replace("-",":").Replace(".xml","");
				TreeLeafNode(InterfaceUri, "HarmonizedAggregateInterfaces"+RelUrl, "")
			)
		]
	);
)
else if Posted matches
{
	"id": "urn:nfi:iot:hie"
} then
(
	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedEnumerations",false,FolderName);
	InterfaceFolders:=System.IO.Directory.GetDirectories(FolderName);

	[foreach InterfaceFolder in Sort(InterfaceFolders) do
	(
		RelFolderName:=InterfaceFolder.Substring(len(FolderName));
		InterfaceUri:="urn:nfi:iot:hie" + RelFolderName.Replace("\\",":");
		TreeNode(InterfaceUri, "ExpandNamespaceFolder.ws", "")
	)]
)
else if Posted matches
{
	"id": Required(Str(PId) like "urn\:nfi\:iot\:hie\:.+")
} then
(
	PId:=PId.Replace("/","\\");

	if PId.Contains("..") or PId.Contains("\\\\") or PId.Contains("?") or PId.Contains("::") then
		Forbidden("Illegal characters.");

	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedEnumerations",false,FolderName);
	SubFolderName:=FolderName+PId.Substring(15).Replace(":","\\");

	if !System.IO.Directory.Exists(SubFolderName) then
		NotFound("Folder not found.");

	SubFolders:=System.IO.Directory.GetDirectories(SubFolderName);
	FileNames:=System.IO.Directory.GetFiles(SubFolderName,"*.xml");

	join
	(
		[foreach SubFolder in Sort(SubFolders) do 
			(
				RelFolderName:=SubFolder.Substring(len(FolderName));
				InterfaceUri:="urn:nfi:iot:hie" + RelFolderName.Replace("\\",":");
				TreeNode(InterfaceUri, "ExpandNamespaceFolder.ws", "")
			)
		],
		[foreach FileName in Sort(FileNames) do 
			(
				RelFileName:=FileName.Substring(len(FolderName));
				RelUrl:=RelFileName.Replace("\\","/");
				InterfaceUri:="urn:nfi:iot:hie" + RelFileName.Replace("\\",":").Replace("-",":").Replace(".xml","");
				TreeLeafNode(InterfaceUri, "HarmonizedEnumerations"+RelUrl, "")
			)
		]
	);
)
else
	BadRequest("Invalid request");
