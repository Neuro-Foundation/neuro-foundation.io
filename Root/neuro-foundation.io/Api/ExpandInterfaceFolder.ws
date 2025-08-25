if Posted matches 
{
	"id": PId
} then
(
	PId:=PId.Replace("/","\\");

	if PId.Contains("..") or PId.Contains("\\\\") or PId.Contains("?") or PId.Contains(":") then
		Forbidden("Illegal characters.");

	FolderName:=null;
	Waher.IoTGateway.Gateway.HttpServer.TryGetFileName("/neuro-foundation.io/HarmonizedInterfaces",false,FolderName);
	SubFolderName:=FolderName+PId;

	if !System.IO.Directory.Exists(SubFolderName) then
		NotFound("Folder not found.");

	SubFolders:=System.IO.Directory.GetDirectories(SubFolderName);
	FileNames:=System.IO.Directory.GetFiles(SubFolderName,"*.xml");

	FileFolderImg:=MarkdownToHtml(":file_folder:");
	OpenFileFolderImg:=MarkdownToHtml(":open_file_folder:");
	PageImg:=MarkdownToHtml(":page_with_curl:");

	join
	(
		[foreach SubFolder in Sort(SubFolders) do 
			(
				RelFolderName:=SubFolder.Substring(len(FolderName));
				InterfaceUri:="urn:nfi:iot:hi" + RelFolderName.Replace("\\",":");

				{
					"id":RelFolderName, 
					"expand": "Api/ExpandInterfaceFolder.ws", 
					"html": "<code>"+InterfaceUri+"</code>",
					"collapsedImg": FileFolderImg,
					"expandedImg": OpenFileFolderImg
				}
			)
		],
		[foreach FileName in Sort(FileNames) do 
			(
				RelFileName:=FileName.Substring(len(FolderName));
				RelUrl:=RelFileName.Replace("\\","/");
				InterfaceUri:="urn:nfi:iot:hi" + RelFileName.Replace("\\",":").Replace("-",":").Replace(".xml","");

				{
					"id":RelFileName, 
					"expand": null, 
					"html": "<a href=\"HarmonizedInterfaces"+RelUrl+"\" target=\"_blank\"><code>"+InterfaceUri+"</code></a>",
					"collapsedImg": PageImg,
					"expandedImg": PageImg
				}
			)
		]
	);
)
else
	BadRequest("Invalid request");
