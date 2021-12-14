set-executionpolicy unrestricted
Import-Csv Roles.csv | foreach{Add-WindowsFeature $_.name  }
