#sets proper tls for adding psgallery to trusted
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#prevents being asked to say yes or no to agree
set-executionpolicy unrestricted
#resizes main HDD to max available space
Resize-Partition -DriveLetter C -Size $(Get-PartitionSupportedSize -DriveLetter C).SizeMax
#trusting repo for modules
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
#importing server manager for use
Import-Module ServerManager
#pulling in default roles for MICC server and installing all needed
Import-Csv Roles.csv | foreach{Add-WindowsFeature $_.name  }
#Installing UPdate module
Install-Module PSWindowsUpdate
#install all updates and reboot once done
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
