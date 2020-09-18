function ConvertFrom-UnixTime($Value){
    <#
    .SYNOPSIS
        [Brief description of the function or script.  Only used once in each topic.]
    .DESCRIPTION
        [Detailed description of the function or script.  Only used once in each topic.]
    .PARAMETER [Parameter Name]
        [Parameter Description]
    .PARAMETER [Parameter Name]
        [Parameter Descripton]
    .EXAMPLE
        PS> Verb-PublicFunctionName -Parameter1 'Value' -Parameter2 'Value'
        [Description of the example.]
    .INPUTS
        The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.
    .OUTPUTS
        The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.
    .NOTES
        Copyright Notice
        Name:       [Verb-PublicFunctionName]
        Author:     [First Name] [Last Name]
        Version:    [Major].[Minor]     -      [Alpha|Beta|Release Candidate|Release]
        Date:       [Year]-[Month]-[Day]
        Version History:
            [Major].[Minor].[Patch]-[PreRelease]+[BuildMetaData]     -   [Year]-[Month]-[Day]  -   [Description]
        TODO:
            [List of TODOs]
    .LINK
        https://subdomain.domain.tld/directory/file.ext
    .LINK
        about_Functions
    .LINK
        about_Functions_Advanced
    .LINK
        about_Functions_Advanced_Methods
    .LINK
        about_Functions_Advanced_Parameters
    .LINK
        about_Functions_CmdletBinding_Attribute
    .LINK
        about_Functions_OutputTypeAttribute
    .LINK
        about_Automatic_Variables
    .LINK
        about_Comment_Based_Help
    .LINK
        about_Parameters
    .LINK
        about_Profiles
    .LINK
        about_Scopes
    .LINK
        about_Script_Blocks
    .LINK
        about_Function_provider
    .LINK
        Get-Verb

    .COMPONENT
        The technology or feature that the function or script uses, or to which it is related. This content appears when the Get-Help command includes the Component parameter of Get-Help.
    .FUNCTIONALITY
        [Verb-PublicFunctionName] The intended use of the function. This content appears when the Get-Help command includes the Functionality parameter of Get-Help.
    #>
    return [TimeZoneInfo]::ConvertTimeFromUTC(([DateTime]::UnixEpoch).AddSeconds($Value),(Get-TimeZone))
}
function Format-DateDiff([DateTime]$Date1,[DateTime]$Date2) {
    <#
    .SYNOPSIS
        [Brief description of the function or script.  Only used once in each topic.]
    .DESCRIPTION
        [Detailed description of the function or script.  Only used once in each topic.]
    .PARAMETER [Parameter Name]
        [Parameter Description]
    .PARAMETER [Parameter Name]
        [Parameter Descripton]
    .EXAMPLE
        PS> Verb-PublicFunctionName -Parameter1 'Value' -Parameter2 'Value'
        [Description of the example.]
    .INPUTS
        The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.
    .OUTPUTS
        The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.
    .NOTES
        Copyright Notice
        Name:       [Verb-PublicFunctionName]
        Author:     [First Name] [Last Name]
        Version:    [Major].[Minor]     -      [Alpha|Beta|Release Candidate|Release]
        Date:       [Year]-[Month]-[Day]
        Version History:
            [Major].[Minor].[Patch]-[PreRelease]+[BuildMetaData]     -   [Year]-[Month]-[Day]  -   [Description]
        TODO:
            [List of TODOs]
    .LINK
        https://subdomain.domain.tld/directory/file.ext
    .LINK
        about_Functions
    .LINK
        about_Functions_Advanced
    .LINK
        about_Functions_Advanced_Methods
    .LINK
        about_Functions_Advanced_Parameters
    .LINK
        about_Functions_CmdletBinding_Attribute
    .LINK
        about_Functions_OutputTypeAttribute
    .LINK
        about_Automatic_Variables
    .LINK
        about_Comment_Based_Help
    .LINK
        about_Parameters
    .LINK
        about_Profiles
    .LINK
        about_Scopes
    .LINK
        about_Script_Blocks
    .LINK
        about_Function_provider
    .LINK
        Get-Verb

    .COMPONENT
        The technology or feature that the function or script uses, or to which it is related. This content appears when the Get-Help command includes the Component parameter of Get-Help.
    .FUNCTIONALITY
        [Verb-PublicFunctionName] The intended use of the function. This content appears when the Get-Help command includes the Functionality parameter of Get-Help.
    #>
        $timespan = $Date1 - $Date2
    [int]$days = [Math]::Floor([Math]::Abs($timespan.TotalDays))
    [int]$hours = [Math]::Abs($timespan.Hours)
    [int]$minutes = [Math]::Abs($timespan.Minutes)
    [int]$seconds = [Math]::Abs($timespan.Seconds)
    [string[]]$return = switch ($true) {
        ({$days -gt 0})                         { "$($days)d" }
        ({$days -le 1 -and $hours -gt 0})       { "$($hours)h"}
        ({$days -eq 0 -and $hours -lt 2 -and $minutes -gt 0})   { "$($minutes)m"}
        ({$days -eq 0 -and $hours -eq 0 -and $Minutes -lt 2 -and $seconds -gt 0}) { "$($seconds)s"}
    }
    return $return -join ' '
}
function ExitScript {
    <#
    .SYNOPSIS
        [Brief description of the function or script.  Only used once in each topic.]
    .DESCRIPTION
        [Detailed description of the function or script.  Only used once in each topic.]
    .PARAMETER [Parameter Name]
        [Parameter Description]
    .PARAMETER [Parameter Name]
        [Parameter Descripton]
    .EXAMPLE
        PS> Verb-PublicFunctionName -Parameter1 'Value' -Parameter2 'Value'
        [Description of the example.]
    .INPUTS
        The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.
    .OUTPUTS
        The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.
    .NOTES
        Copyright Notice
        Name:       [Verb-PublicFunctionName]
        Author:     [First Name] [Last Name]
        Version:    [Major].[Minor]     -      [Alpha|Beta|Release Candidate|Release]
        Date:       [Year]-[Month]-[Day]
        Version History:
            [Major].[Minor].[Patch]-[PreRelease]+[BuildMetaData]     -   [Year]-[Month]-[Day]  -   [Description]
        TODO:
            [List of TODOs]
    .LINK
        https://subdomain.domain.tld/directory/file.ext
    .LINK
        about_Functions
    .LINK
        about_Functions_Advanced
    .LINK
        about_Functions_Advanced_Methods
    .LINK
        about_Functions_Advanced_Parameters
    .LINK
        about_Functions_CmdletBinding_Attribute
    .LINK
        about_Functions_OutputTypeAttribute
    .LINK
        about_Automatic_Variables
    .LINK
        about_Comment_Based_Help
    .LINK
        about_Parameters
    .LINK
        about_Profiles
    .LINK
        about_Scopes
    .LINK
        about_Script_Blocks
    .LINK
        about_Function_provider
    .LINK
        Get-Verb

    .COMPONENT
        The technology or feature that the function or script uses, or to which it is related. This content appears when the Get-Help command includes the Component parameter of Get-Help.
    .FUNCTIONALITY
        [Verb-PublicFunctionName] The intended use of the function. This content appears when the Get-Help command includes the Functionality parameter of Get-Help.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)][string]$Path = $null
    )
	Write-Console "Exiting Script..."
    if ($DebugPreference -ne 'SilentlyContinue') { Clear-Host ; Clear-History }
    if (-not [string]::IsNullOrWhiteSpace($Path)) { Set-Location -Path $Path }
	exit
}