[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
set-executionpolicy unrestricted
Resize-Partition -DriveLetter C -Size $(Get-PartitionSupportedSize -DriveLetter C).SizeMax
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Import-Module ServerManager
Import-Csv Roles.csv | foreach{Add-WindowsFeature $_.name  }
Install-Module PSWindowsUpdate
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
