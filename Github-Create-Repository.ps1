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
$repoCreationResult = Invoke-RestMethod -Uri $creationUri -Headers $authHeader -Method Post -Body $body;
Write-Host ("Repository '{0}' created" -f $RepositoryName) -foregroundcolor "green";

Start-Sleep -Seconds 3;
