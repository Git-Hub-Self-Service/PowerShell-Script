PARAM
(
	[Parameter(Mandatory = $False, Position = 0)]
    [String] $RepositoryName='CreateFromActions',
    [String] $Org='Git-Hub-Self-Service'
 )

# authentication header

$username = "Username";
$token = "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";
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$token)));
$authHeader = @{"Authorization"="Basic $base64AuthInfo"};

# create repository
$body = @{
	name = $RepositoryName;
	auto_init = $true;
} | ConvertTo-Json -Compress;

if($Org) 
{
	$creationUri = 'https://api.github.com/orgs/{0}/repos' -f $Org;
}
else 
{
	$creationUri = 'https://api.github.com/user/repos';
}
#$repoCreationResult = Invoke-RestMethod -Uri $creationUri -Headers $authHeader -Method Post -Body $body;
Write-Host ("Repository '{0}' created" -f $RepositoryName) -foregroundcolor "green";

Start-Sleep -Seconds 3;
