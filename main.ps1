<#
.SYNOPSIS
    This script is used to install the latest version of a PowerShell module.

.DESCRIPTION
    The Install-LatestModuleVersion function checks if a module is already installed and if there is a newer version available. If a newer version is found, it installs the latest version of the module. If the module is not installed, it installs the module.

.PARAMETER moduleName
    Specifies the name of the module to install or update.

.EXAMPLE
    Install-LatestModuleVersion -moduleName "MyModule"

    This example installs or updates the "MyModule" module to the latest version.

.NOTES
    Author: Julien ANDROGE
    Date:   2024-04-04
#>

#requires -version 7.0

Import-Module "$PSScriptRoot\utils.psm1" -Force

'PSFramework' | Install-LatestModuleVersion

Import-Module PSFramework

Add-Type -AssemblyName System.Windows.Forms


Update-ScriptFromGitHub -RepositoryUrl 'https://github.com/jnage2/pwsh_tools' -LocalScriptPath 'main.ps1' -LocalHashPath "$PSScriptRoot\hash" -DeployKeyPath "$PSScriptRoot\deploy_key" -Force

$dictionary = New-Object -TypeName "System.Collections.Generic.Dictionary[string, string]"
$dictionary.Add("Key1", "Value1")
$dictionary.Add("Key2", "Value2")

Write-Host "Dictionary keys: $($dictionary.Keys -join ', ')"
Write-Host "Dictionary values: $($dictionary.Values -join ', ')"
Write-Host "Dictionary count: $($dictionary.Count)"
Write-Host "Dictionary contains key 'Key1': $($dictionary.ContainsKey('Key1'))"
Write-Host "Dictionary contains value 'Value1': $($dictionary.ContainsValue('Value1'))"
Write-Host "Dictionary item with key 'Key1': $($dictionary['Key1'])"
Write-Host "Dictionary item with key 'Key2': $($dictionary['Key2'])"

$dictionary.Remove('Key1')