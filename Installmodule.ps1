<# 
	.SYNOPSIS
    	Creates a GitLab project within a specified location.  And also protects the release branch so only
			Maintainers have access to create.
	.Description
		This script will create a GitLab repository within a specific location.  The script creates a new repository (cube)
			within a specified location (project) as well as protects the release branch.
	.PARAMETER Cube
		The funcitonal definition of which cube to create repository for.
	.PARAMETER Project
		The funcitonal definition of which project location to create the cube repository.
	.INPUTS
		None. You cannot pipe objects to -cube Create_GitLab_Project.ps1.
	.OUTPUTS
		Console and log file
	.NOTES
		Author: Marcellus Seamster Jr
	.EXAMPLE
		Create_GitLab_Project.ps1 -project projectName -cube cubeName 
    .EXAMPLE
		
		.\Update-ReposYML.ps1 -file "C:\Users\mseamste\Desktop\repo-template.yml"
#>


Param (
	[String[]] $file
<# 
	[Parameter(Position=0)][ValidateSet('Y','N')][String[]] $process,
	[Parameter(Position=1)][ValidateSet('Y','N')][String[]]	$qa,
	[Parameter(Position=2)][ValidateSet('Y','N')][String[]]	$uat,
	[Parameter(Position=3)][ValidateSet('Y','N')][String[]]	$validation,
	[Parameter(Position=4)][ValidateSet('Y','N')][String[]]	$checks,
	[Parameter(Position=5)][String[]] $file,
	[Parameter(Position=6)][String[]] $folder,
	[Parameter(Position=7)][String[]] $model,
	[Parameter(Position=8)][String[]] $type,
	[Parameter(Position=9)][ValidateSet('Y','N')][String[]] $squawk,
	[Parameter(Position=10)][String[]] $iap,
	[Parameter(Position=11)][String[]] $twc
#>

)



#Region Get control of powershell UI
    $a = (Get-Host).UI.RawUI
    $a.WindowTitle = "Create GitHub Project"
    $a.BackgroundColor = "Black"
    $a.ForegroundColor = "White"
    cls
	
	$ElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()
	
#EndRegion Get control of powershell UI


#Region Variable declartion

	$WarningColor = (Get-Host).PrivateData
	$WarningColor.WarningBackgroundColor = "yellow"
	$WarningColor.WarningForegroundColor = "blue"

	#Global variables
	$global:logdate = $null					# Date log file created on
	$global:logpath = $null					# Path of where to store log file
	$global:logfile = $null					# Name of the log file	
	$global:scriptStart = $null				# Start time of the script
	$global:file = $null					# Yml filename
	$global:yml = $null						# Yml file values

#EndRegion Variable declartion


<#
#Region Verify input file exists
	if(Test-Path $inputCSVP){
		Split-Path $inputCSVp -Leaf | Out-Null
		$fileName = Split-Path $inputCSVp -Leaf
		$StoreCode = $fileName.Substring(0,3)
	}else{
		Write-Warning "Input CSV not found.  Verify path then retry."
		Write-Warning "Exiting Script"
		Exit
	}
#EndRegion Verify input file exists
#>

#Region Set startup variables

	$Line = "============================================================================================================================"

	#logging variables
	$global:logdate = "{0:MMddyyyy}" -f (Get-Date)
	$global:logpath = "C:\Users\mseamste\Desktop\Cellus\Scripts\PowerShell\GitHub\Logs\"
	$global:scriptStart = "{0:MM/dd/yyyy HH:mm:ss}" -f (Get-Date)
	
	$global:logfile = $logpath + "YML_Updater_" + $logdate + ".log"
	
	#$global:file = "C:\Users\mseamste\Desktop\Cellus\Scripts\PowerShell\GitHub\gitlab-ci.yml"
	$global:outputFile = "C:\Users\mseamste\Desktop\repo-template-output.yml"

#EndRegion Set startup variables


#Region Functions


# Creates log
Function Write-Log {
	#region Parameters
		[cmdletbinding()]
		Param(
			[Parameter(ValueFromPipeline=$true,Mandatory=$true)] [ValidateNotNullOrEmpty()]
			[string] $Message,
			[Parameter()] [ValidateSet("Error", "Warn", "Info")]
			[string] $Level = "Info",
			[Parameter()]
			[Switch] $NoConsoleOut,
			[Parameter()]
			[String] $ConsoleForeground = 'Black',
			[Parameter()] [ValidateRange(1,30)]
			[Int16] $Indent = 0,
			[Parameter()]
			[IO.FileInfo] $Path = "$env:temp\PowerShellLog.txt",
			[Parameter()]
			[Switch] $Clobber,
			[Parameter()]
			[String] $EventLogName,
			[Parameter()]
			[String] $EventSource,
			[Parameter()]
			[Int32] $EventID = 1,
			[Parameter()]
			[String] $LogEncoding = "ASCII"
		) #end Parameters
	#endregion

	Begin {}
	Process {
		try {			
			$msg = '{0}{1} : {2} : {3}' -f (" " * $Indent), (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level.ToUpper(), $Message
			if ($NoConsoleOut -eq $false) {
				switch ($Level) {
					'Error' { Write-Error $Message }
					'Warn' { Write-Warning $Message }
					'Info' { Write-Host ('{0}{1}' -f (" " * $Indent), $Message) -ForegroundColor $ConsoleForeground}
				}
			}
			if (-not $Path.Exists) {
				New-Item -Path $Path.FullName -ItemType File -Force | Out-Null
			}
			if ($Clobber) {
				$msg | Out-File -FilePath $Path -Encoding $LogEncoding -Force
			} else {
				$msg | Out-File -FilePath $Path -Encoding $LogEncoding -Append
			}
			if ($EventLogName) {
				if (-not $EventSource) {
					$EventSource = ([IO.FileInfo] $MyInvocation.ScriptName).Name
				}
				If (-not [Diagnostics.EventLog]::SourceExists($EventSource)) { 
					[Diagnostics.EventLog]::CreateEventSource($EventSource, $EventLogName) 
		        } 
				$log = New-Object System.Diagnostics.EventLog  
			    $log.set_log($EventLogName)  
			    $log.set_source($EventSource) 
				switch ($Level) {
					"Error" { $log.WriteEntry($Message, 'Error', $EventID) }
					"Warn"  { $log.WriteEntry($Message, 'Warning', $EventID) }
					"Info"  { $log.WriteEntry($Message, 'Information', $EventID) }
				}
			}
		} catch {
			throw "Failed to create log entry in: â€˜$Pathâ€™. The error was: â€˜$_â€™."
		}
	} #End Process

	End {}
	<#
		.SYNOPSIS
			Writes logging information to screen and log file simultaneously.
		.DESCRIPTION
			Writes logging information to screen and log file simultaneously. Supports multiple log levels.
		.PARAMETER Message
			The message to be logged.
		.PARAMETER Level
			The type of message to be logged.
		.PARAMETER NoConsoleOut
			Specifies to not display the message to the console.
		.PARAMETER ConsoleForeground
			Specifies what color the text should be be displayed on the console. Ignored when switch 'NoConsoleOut' is specified.
		.PARAMETER Indent
			The number of spaces to indent the line in the log file.
		.PARAMETER Path
			The log file path.	
		.PARAMETER Clobber
			Existing log file is deleted when this is specified.
		.PARAMETER EventLogName
			The name of the system event log, e.g. 'Application'.
		.PARAMETER EventSource
			The name to appear as the source attribute for the system event log entry. This is ignored unless 'EventLogName' is specified.
		.PARAMETER EventID
			The ID to appear as the event ID attribute for the system event log entry. This is ignored unless 'EventLogName' is specified.
		.PARAMETER LogEncoding
			The text encoding for the log file. Default is ASCII.
		.EXAMPLE
			PS C:\> Write-Log -Message "It's all good!" -Path C:\MyLog.log -Clobber -EventLogName 'Application'
		.EXAMPLE
			PS C:\> Write-Log -Message "Oops, not so good!" -Level Error -EventID 3 -Indent 2 -EventLogName 'Application' -EventSource "My Script"
		.INPUTS
			System.String
		.OUTPUTS
			No output.
		.NOTES
			Revision History:
				2011-03-10 : Andy Arismendi - Created.
				2011-07-23 : Will Steele - Updated.
				2011-07-23 : Andy Arismendi 
					- Added missing comma in param block. 
					- Added support for creating missing directories in log file path.
	#>
}

# Write header output to screen
Function Write-Header   {

	Write-Host $Line -ForegroundColor Green
	Write-log -Message "============================================"  -Path $logfile -NoConsoleOut
	Write-Host "`t`t`tScript Started at " -NoNewline
	Write-Host $(get-date) -ForegroundColor Cyan
	$Message = "YML update script Started at $(get-date)"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	Write-Host
	
	Write-Host "`t`t`t`t`tScript Parameters:" -ForegroundColor Yellow
	$Message = "Script Parameters:"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	Write-Host

	Write-Host "`t`t`tFull Process:" -NoNewline
	Write-Host "`t`t$process" -ForegroundColor Cyan
	$Message = "`tFull Process: $process"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tQA:" -NoNewline
	Write-Host "`t`t`t$qa" -ForegroundColor Cyan
	$Message = "`tQA: $qa"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
		
	Write-Host "`t`t`tUAT:" -NoNewline
	Write-Host "`t`t`tUAT" -ForegroundColor Cyan
	$Message = "`tUAT: $uat"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
		
	Write-Host "`t`t`tValidation:" -NoNewline
	Write-Host "`t`t$validation" -ForegroundColor Cyan
	$Message = "`tValidation: $validation"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tCQ Checks:" -NoNewline
	Write-Host "`t`t$checks" -ForegroundColor Cyan
	$Message = "`tCQ Checks: $checks"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tXMLA File:" -NoNewline
	Write-Host "`t`t$file" -ForegroundColor Cyan
	$Message = "`tXMLA File: $file"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tFolder:" -NoNewline
	Write-Host "`t`t`t$folder" -ForegroundColor Cyan
	$Message = "`tFolder: $folder"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tModel:" -NoNewline
	Write-Host "`t`t`t$model" -ForegroundColor Cyan
	$Message = "`tModel: $model"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tDeploy Type:" -NoNewline
	Write-Host "`t`t$type" -ForegroundColor Cyan
	$Message = "`tDeploy Type: $type"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut

	Write-Host "`t`t`tSquawk:" -NoNewline
	Write-Host "`t`t`t$squawk" -ForegroundColor Cyan
	$Message = "`tSquawk: $squawk"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
	
	Write-Host "`t`t`tIAP:" -NoNewline
	Write-Host "`t`t`t$iap" -ForegroundColor Cyan
	$Message = "`tIAP: $iap"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut
		
	Write-Host "`t`t`tTWC:" -NoNewline
	Write-Host "`t`t`t$twc" -ForegroundColor Cyan
	$Message = "`tTWC: $twc"
	Write-Log -Message $Message -Path $logfile -NoConsoleOut	

	Write-Host $Line -ForegroundColor Green
	Write-Log -Message "============================================"  -Path $logfile -NoConsoleOut
	Write-Log -Message " "  -Path $logfile -NoConsoleOut
	Write-Host
}



# Check if PowerShell module is installed
Function Check-Module   {

	If($count -lt 2)   {
		If(Get-Module -ListAvailable -Name ImportExcel)   {
			Write-Host "`tImportExcel Module exists" -ForegroundColor Green
			$Message = "`tImportExcel Module exists"
			Write-Log -Message $Message -Path $logfile -NoConsoleOut
			Write-Host 
			Write-log -Message " "  -Path $logfile -NoConsoleOut
		}
		Else   {
			Write-Host "`tImportExcel Module doesn't exist ..... installing" -ForegroundColor Yellow
			$Message = "`tImportExcel Module doesn't exist ..... installing"
			Write-Log -Message $Message -Path $logfile -NoConsoleOut

			Install-Module -Name ImportExcel -Force -Scope CurrentUser
			Import-Module ImportExcel
			
			Sleep-Host 15
			$count++
			Check-Module
		}
	}
	Else   {
		Write-Host "`tUnable to install ImportExcel Module" -ForegroundColor Red
		$Message = "`tUnable to install ImportExcel Module"
		Write-Log -Message $Message -Path $logfile -NoConsoleOut
		Write-Host "`tContact support for further assistance" -ForegroundColor Red
		$Message = "`tContact support for further assistance"
		Write-Log -Message $Message -Path $logfile -NoConsoleOut
		Sleep-Host 30
		Exit
	}
}


Function Sleep-Host   {



}




Function Read-Excel   {


#$Excelfile = "https://intel-my.sharepoint.com/:x:/r/personal/diomendesx_todesco_intel_com/_layouts/15/Doc.aspx?sourcedoc=%7BBE481FE1-E9D8-463C-8353-C0C430011FA6%7D&file=RepoGitHUb.xlsx&action=default&mobileredirect=true&clickparams=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyNy8yMjA5MDQwMDcxMiIsIkhhc0ZlZGVyYXRlZFVzZXIiOmZhbHNlfQ%3D%3D&cid=c2281e22-e63a-44ac-a46c-b4be14b5ba09"
#$Excelfile = "https://intel-my.sharepoint.com/:x:/r/personal/diomendesx_todesco_intel_com/_layouts/15/Doc.aspx?sourcedoc=%7BBE481FE1-E9D8-463C-8353-C0C430011FA6%7D&file=RepoGitHUb.xlsx"

$Excelfile = "C:\Users\mseamste\Desktop\RepoGitHUb.xlsx"

	
	
	
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
	
	$global:file = $file
#	Write-Header
	Get-Yml $global:file
	Get-Values $global:yml
#	Update-Yml $global:file $global:yml
	
	Update-Yml $global:outputFile $global:yml
	
#	Get-Yml $file
#	Get-Values $global:yml

#EndRegion Main Processing
