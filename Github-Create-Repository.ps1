Function Read-Excel   {


#$Excelfile = "https://intel-my.sharepoint.com/:x:/r/personal/diomendesx_todesco_intel_com/_layouts/15/Doc.aspx?sourcedoc=%7BBE481FE1-E9D8-463C-8353-C0C430011FA6%7D&file=RepoGitHUb.xlsx&action=default&mobileredirect=true&clickparams=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyNy8yMjA5MDQwMDcxMiIsIkhhc0ZlZGVyYXRlZFVzZXIiOmZhbHNlfQ%3D%3D&cid=c2281e22-e63a-44ac-a46c-b4be14b5ba09"
$Excelfile = "https://intel-my.sharepoint.com/:x:/r/personal/diomendesx_todesco_intel_com/_layouts/15/Doc.aspx?sourcedoc=%7BBE481FE1-E9D8-463C-8353-C0C430011FA6%7D&file=RepoGitHUb.xlsx"

#$Excelfile = "C:\Users\mseamste\Desktop\RepoGitHUb.xlsx"

	
	
	
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




# Reads YML file and deserializes it
Function Get-Yml {
    Param (
        $fileName
    )
	
    [String[]] $fileContent = Get-Content $fileName
    $content = ''
	Foreach($line in $fileContent)   {
		$content = $content + "`n" + $line
	}
	
	$global:yml = ConvertFrom-YAML $content

	Write-Host $content -ForegroundColor Yellow

}

# Writes the YML content to a file
Function Update-Yml {
    Param (
        $fileName,
        $content
    )

	$result = ConvertTo-YAML $content
    Set-Content -Path $fileName -Value $result
}

# Gets the values from Excel spreadsheet
Function Get-Values   {
    Param (
		$yml
    )
	
	
	Write-Host $global:yml.name -ForegroundColor Cyan
	Write-Host $global:yml.guid -ForegroundColor Magenta
	Write-Host $global:yml.description -ForegroundColor Cyan
	Write-Host $global:yml.owners -ForegroundColor Magenta
	Write-Host $global:yml.topics -ForegroundColor Cyan
	
	Write-Host $global:yml.permissions.admin -ForegroundColor Yellow
	Write-Host $global:yml.permissions.write -ForegroundColor Yellow
	Write-Host $global:yml.permissions.maintain -ForegroundColor Yellow
	Write-Host $global:yml.permissions.read -ForegroundColor Yellow
		
		
# outputs data listed under branch-protection-rules
	Write-Host "branch-protection-rules" -ForegroundColor White
	
	Write-Host $global:yml.'branch-protection-rules'.patterns -ForegroundColor Cyan
	Write-Host $global:yml.'branch-protection-rules'.'requires-approving-reviews' -ForegroundColor Cyan
	Write-Host $global:yml.'branch-protection-rules'.'required-approving-review-count' -ForegroundColor Cyan
	Write-Host $global:yml.'branch-protection-rules'.'bypass-pull-request-allowed-teams' -ForegroundColor Cyan

	Write-Host $global:yml.'branch-protection-rules'.'restricts-pushes'.enabled -ForegroundColor Cyan
	Write-Host $global:yml.'branch-protection-rules'.'restricts-pushes'.'allowed-teams' -ForegroundColor Cyan
	
	

<#	
	$global:yml.variables.QA = '"' + $qa + '"' 
	$global:yml.variables.UAT = '"' + $uat + '"' 
	$global:yml.variables.VALIDATION = '"' + $validation + '"' 
	$global:yml.variables.CQ_CHECKS = '"' + $checks + '"' 
	
	
	$global:yml.variables.XMLA_FILE = '"' + $file + '"' 
	$global:yml.variables.FOLDER = '"' + $folder + '"' 
	$global:yml.variables.MODEL = '"' + $model + '"' 
	$global:yml.variables.DEPLOY_TYPE = '"' + $type + '"' 
	
	
	
	
	$global:yml.variables.SQUAWK  = '"' + $squawk + '"' 
	$global:yml.variables.IAP = '"' + $iap + '"' 
	$global:yml.variables.TWC = '"' + $twc + '"' 
#>

}



#EndRegion Functions


#Region Main Processing
	
	
	Check-Module
	
	
	Read-Excel
	Exit




