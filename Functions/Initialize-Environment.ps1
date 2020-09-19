Function InitializeEnvironment {
	<#
	$PSCommandPath:
		Direct:    Returns full script file path.
		Function:  Returns full script file path.
	$MyInvocation.PSCommandPath:
		Direct:    Null.
		Function:  Returns full script file path.
	$MyInvocation.ScriptName:
		Direct:    Null.
		Function:  Returns full script file path.
	$MyInvocation.MyCommand.Name:
		Direct:    Returns the script file name (without path).
		Function:  Returns the function name.
	$MyInvocation.MyCommand.Definition:
		Direct:    Returns full script file path.
		Function:  Returns the script block on the current function.
	#>
	[CmdletBinding()]
	param (
		[Parameter(
			Mandatory = $true
		)]
		[string]$callerPSCommandPath,

		[Parameter(
			Mandatory = $true
		)]
		[System.Management.Automation.InvocationInfo]$callerMyInvocation,

		[Parameter(
			Mandatory = $true
		)]
		[string]$callerPSScriptRoot
	)
	if ([string]::IsNullOrWhiteSpace($callerPSCommandPath)) {
		function GetPSCommandPath() { return $callerMyInvocation.PSCommandPath }
		$callerPSCommandPath = GetPSCommandPath
	} #Set $PSCommandPath if it does not exist, used for PowerShell versions before v3.0. In a function in order to work
	$scriptFullFilePath = $callerPSCommandPath
	Write-Console("Script:  {0}." -f $scriptFullFilePath)
	Write-DebugInfo -String "Script Root: $callerPSScriptRoot","Current Folder:  $((Get-Item -Path ".\" -Verbose).FullName)"
	Set-Location $callerPSScriptRoot | Out-Null
	If (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		$arguments = "& '" + $scriptFullFilePath + "'"
		if ($psversiontable.psversion.major -lt 6) {
			Start-Process powershell -Verb runAs -ArgumentList $arguments
		}
		else {
			Start-Process -Filepath pwsh -Verb runAs -ArgumentList $arguments
		}
		Exit
	}
	If ((Get-ExecutionPolicy) -notlike "Bypass") {
		Try {
			Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
		} Catch {
			Write-Console("Error setting execution policy for script`r`nException: {0}" -f $_.Exception.Message)
		}
	}
}