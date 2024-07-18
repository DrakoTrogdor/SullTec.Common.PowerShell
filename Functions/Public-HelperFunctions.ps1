function ConvertFrom-UnixTime($Value){
    <#
    .SYNOPSIS
        Converts a Unix timestamp to a local DateTime object.
    .DESCRIPTION
        This function takes a Unix timestamp (the number of seconds since January 1, 1970) and converts it to a local DateTime object. The conversion accounts for the local time zone.
    .PARAMETER Value
        The Unix timestamp to convert. This should be the number of seconds since January 1, 1970.
    .EXAMPLE
        PS> ConvertFrom-UnixTime -Value 1625097600
        Wednesday, June 30, 2021 8:00:00 PM
        Converts the Unix timestamp 1625097600 to the local DateTime equivalent.
    .INPUTS
        System.Int32
            You can pipe an integer representing a Unix timestamp to this function.
    .OUTPUTS
        System.DateTime
            The function returns a DateTime object representing the local time equivalent of the Unix timestamp.
    .NOTES
        Copyright Notice
        Name:       ConvertFrom-UnixTime
        Author:     Casey J. Sullivan
        Version:    1.0.0    -    Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial release.
        TODO:
            None.
    .LINK
        https://www.sulltec.com
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
        PowerShell Core
    .FUNCTIONALITY
        Converts Unix timestamp to local DateTime
    #>
    return [TimeZoneInfo]::ConvertTimeFromUTC(([DateTime]::UnixEpoch).AddSeconds($Value),(Get-TimeZone))
}
function Format-DateDiff([DateTime]$Date1,[DateTime]$Date2) {
    <#
    .SYNOPSIS
        Calculates the difference between two dates and formats it as a human-readable string.
    .DESCRIPTION
        This function calculates the difference between two DateTime objects and returns the difference as a formatted string. The output will show the most significant unit of time (days, hours, minutes, or seconds) based on the difference.
    .PARAMETER Date1
        The first DateTime object.
    .PARAMETER Date2
        The second DateTime object.
    .EXAMPLE
        PS> Format-DateDiff -Date1 (Get-Date) -Date2 (Get-Date).AddDays(-1)
        1d
        Calculates the difference between the current date and the previous day, returning "1d".
    .EXAMPLE
        PS> Format-DateDiff -Date1 (Get-Date) -Date2 (Get-Date).AddHours(-5)
        5h
        Calculates the difference between the current time and five hours ago, returning "5h".
    .INPUTS
        System.DateTime
            You can pipe DateTime objects to the Date1 and Date2 parameters.
    .OUTPUTS
        System.String
            Returns a string representing the formatted date difference.
    .NOTES
        Copyright Notice
        Name:       Format-DateDiff
        Author:     Casey J. Sullivan
        Version:    1.0.0    -    Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial release.
        TODO:
            None.
    .LINK
        https://www.sulltec.com
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
        PowerShell Core
    .FUNCTIONALITY
        Date difference formatting
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
        Exits the current PowerShell script with optional cleanup and directory change.
    .DESCRIPTION
        This function exits the current PowerShell script after performing optional cleanup actions such as clearing the console and history. It can also change the working directory to a specified path before exiting.
    .PARAMETER Path
        The directory path to change to before exiting the script. If not specified, the current directory remains unchanged.
    .EXAMPLE
        PS> ExitScript
        Exits the script and performs cleanup.
    .EXAMPLE
        PS> ExitScript -Path "C:\"
        Changes the working directory to "C:\" and exits the script.
    .INPUTS
        None. You cannot pipe objects to ExitScript.
    .OUTPUTS
        None. ExitScript does not return any objects.
    .NOTES
        Copyright Notice
        Name:       ExitScript
        Author:     Casey J. Sullivan
        Version:    1.0.0    -    Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial release.
        TODO:
            None.
    .LINK
        https://www.sulltec.com
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
        PowerShell Core
    .FUNCTIONALITY
        Script exit with cleanup
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