# Install PSGallery
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install ImportExcel package
Install-Module -Name ImportExcel

# List Module installed
Get-InstalledModule
