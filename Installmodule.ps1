# Install PSGallery
Set-PSrepository PSGallery

# Install ImportExcel package
Install-Module -Name ImportExcel 3>$null

# List Module installed
Get-InstalledModule
