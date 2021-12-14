param(
    [Parameter(Mandatory=$True)]
    [System.Management.Automation.PSCredential]$Credential,
    
    #[Parameter(Mandatory=$True)]
    #string]$Newcustomer,
	
	[Parameter(Mandatory=$True)]
    [string]$orgvdcsName,
	
	[Parameter(Mandatory=$True)]
    [string]$server,
	
	[Parameter(Mandatory=$True)]
    [string]$org,
	
	[Parameter(Mandatory=$True)]
    [string]$vappname,
	
	[Parameter(Mandatory=$True)]
    [string]$vmname,
	
	[Parameter(Mandatory=$True)]
    [string]$templateVM
	
	
	
	
)
#Connect to the virtual datacenter.
Connect-CIServer -server $server -Credential $Credential -Org $org

#Create new vApp and deploy to the proper organization
#New-CIVApp -Name $Newcustomer -OrgVdc $orgvdcsName -RuntimeLease $null -Server $server -StorageLease $null -Confirm:$true
#Creates new CIVM inside VApp
Get-CIVApp  -Name $Vappname | New-CIVM -Name $vmname -VMTemplate $templateVM -Confirm:$false
#Get-CIVApp -Name "999999999 - MNS - GFE Test Lab" | Get-CIVM -Name Lab.backupserver.gfe.Windows2019server | Update-CIVMDiskSize -BusType paravirtual -BusId 0 -UnitID 0 -NewdiskSize 100000


#Start the vApp
#Get-CIVApp -Name $Newcustomer|Start-CIVApp

#Disconnect your session.
Disconnect-CIServer -Server * -Confirm:$false
