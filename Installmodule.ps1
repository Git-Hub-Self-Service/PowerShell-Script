# Install PSGallery
#Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install ImportExcel package
#Install-Module -Name ImportExcel

# List Module installed
#Get-InstalledModule

Function Read-Excel   {


#$Excelfile = "https://intel-my.sharepoint.com/:x:/r/personal/diomendesx_todesco_intel_com/_layouts/15/Doc.aspx?sourcedoc=%7BBE481FE1-E9D8-463C-8353-C0C430011FA6%7D&file=RepoGitHUb.xlsx&action=default&mobileredirect=true&clickparams=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyNy8yMjA5MDQwMDcxMiIsIkhhc0ZlZGVyYXRlZFVzZXIiOmZhbHNlfQ%3D%3D&cid=c2281e22-e63a-44ac-a46c-b4be14b5ba09"
$Excelfile = "https://intel-my.sharepoint.com/:x:/r/personal/diomendesx_todesco_intel_com/_layouts/15/Doc.aspx?sourcedoc=%7BBE481FE1-E9D8-463C-8353-C0C430011FA6%7D&file=RepoGitHUb.xlsx"

#$Excelfile = "C:\Users\dtodescx\OneDrive - Intel Corporation\RepoGitHUb.xlsx"

	
	
	
	$data = Import-Excel $Excelfile
	$totalNoOfRecords = $data.count
	
	
	
	
	Write-Host $totalNoOfRecords -ForegroundColor White
	
	Write-Host $data -ForegroundColor Yellow
	Write-Host $data.RepositoryName[0] -ForegroundColor Cyan
	Write-Host $data.Description[0] -ForegroundColor Cyan
	Write-Host $data.AGS[0] -ForegroundColor Cyan
	
	Write-Host $data.RepositoryName[1] -ForegroundColor Magenta
	Write-Host $data.Description[1] -ForegroundColor Magenta
	Write-Host $data.AGS[1] -ForegroundColor Magenta



}
	
	Read-Excel
	Exit
