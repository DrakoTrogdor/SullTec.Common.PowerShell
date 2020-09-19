#requires -Version 2
# Get the function definition files.

Add-Type -AssemblyName '.\Assemblies\SullTec.Common.PowerShell.SemVer.dll'
Export-ModuleMember -Cmdlet 'Get-SemVer'

$functionFiles = @( Get-ChildItem -Path $PSScriptRoot\..\Functions\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
Foreach ($importFile in $functionFiles) {
    Try {
        . $importFile.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($importFile.fullname): $_"
    }
}

# Get the loaded functions and export any that are not private
$functionsLoaded = Get-ChildItem Function: | Where-Object {$_.Source -eq 'SullTec.Common'}
foreach ($function in $functionsLoaded) {
    if (-not ($function.Options -band [System.Management.Automation.ScopedItemOptions]::Private)) {
        Export-ModuleMember -Function $function.Name
    }
}