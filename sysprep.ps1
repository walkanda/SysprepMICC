Start-Transcript
Set-TimeZone "Eastern Standard Time"
#sets proper tls for adding psgallery to trusted
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#resizes main HDD to max available space
Resize-Partition -DriveLetter C -Size $(Get-PartitionSupportedSize -DriveLetter C).SizeMax
#importing server manager for use
Import-Module ServerManager
#pulling in default roles for MICC server and installing all needed
Import-Csv C:\Roles.csv | foreach{Add-WindowsFeature $_.name  }
#Installing Windows Updates
Function InstallWindowsModules
{
    # Installs NuGet with Forced
    Install-PackageProvider -Name NuGet -Force

    # Trusts Microsofts PSGallery
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    
    # Install PSWindowsUpdate Module
    Install-Module PSWindowsUpdate

    # Sets Progress file to 1, to indicate modules etc. are installed.
    Set-Content C:\AutoUpdates\Progress.txt -Value 1
}

Function InstallWindowsUpdates
{
    # Gets latest Windows updates
    Get-WindowsUpdate | Out-File C:\AutoUpdates\History\Updates_"$((Get-Date).ToString('dd-MM-yyyy_HH.mm.ss'))".txt

    #Installs updates, accepts all automatically and reboots.
    Install-WindowsUpdate -Install -AcceptAll -AutoReboot
}


# Checks if folder "AutoUpdates already exists on the server. If it doesn't it creates it."
$ChkPath = "C:\AutoUpdates"
$PathExists = Test-Path $ChkPath
If ($PathExists -eq $false)
{
    mkdir C:\AutoUpdates
    mkdir C:\AutoUpdates\History
}
else
{
    # Do nothing
}


$ChkFile = "C:\AutoUpdates\Progress.txt"
$FileExists = Test-Path $ChkFile
If ($FileExists -eq $false)
{
    New-Item C:\AutoUpdates\Progress.txt
    Set-Content C:\AutoUpdates\Progress.txt -Value 0
}
else
{
    # Do nothing
}



# Reads the file for status
# This is the logic used to control the installation status of the server.
$Status = Get-Content C:\AutoUpdates\Progress.txt -First 1

If ($Status -eq 0) 
{
    # Installs required modules
    InstallWindowsModules
    InstallWindowsUpdates
}
elseif ($Status -eq 1)
{
    # Installs windows updates
    InstallWindowsUpdates
}
Stop-Transcript
