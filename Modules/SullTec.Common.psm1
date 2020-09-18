# Import-Module and the '#requires' statement only import the module functions, aliases, and variables,
# as defined by the module. Classes are not imported. The using module statement imports the classes
# defined in the module. If the module isn't loaded in the current session, the using statement fails.
# Above needs to remain the first line to import Classes remove the comment # when using the class
Microsoft.PowerShell.Utility\Import-LocalizedData LocalizedData -FileName SullTec.Common.psd1 -ErrorAction SilentlyContinue

#requires -Version 2
# Get the function definition files.
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

# Before using this as a module make sure the relative paths have been corrected. i.e. if this module has been moved to ./Modules, then replace '..\..\' with '..\'