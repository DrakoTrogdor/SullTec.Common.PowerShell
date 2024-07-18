function Write-Color {
    <#
    .SYNOPSIS
        Enables support to write multiple color text on a single line.
    .DESCRIPTION
        Users color codes to enable support to write multiple color text on a single line

        ################################################
        # Foreground and Background Codes
        ################################################
        ^f + Color Code = Foreground Color
        ^b + Color Code = Background Color
        ^f?^b? = Foreground and Background Color

        ################################################
        # Color Codes
        ################################################
        k = Black
        b = Blue
        c = Cyan
        e = Gray
        g = Green
        m = Magenta
        r = Red
        w = White
        y = Yellow
        B = DarkBlue
        C = DarkCyan
        E = DarkGray
        G = DarkGreen
        M = DarkMagenta
        R = DarkRed
        Y = DarkYellow [Unsupported in Powershell]
        z = <Default Color>

    .PARAMETER Value
        Line of test to display in the host.
    .PARAMETER NoNewLine
        The string representations of the input objects are concatenated to form the output. No spaces or newlines are inserted between the output strings. No newline is added after the last output string.
    .EXAMPLE
        PS> Write-Color "Hey look ^crThis is red ^cgAnd this is green!"
        Displays "Hey look " in default color, "This is red" in red, and "And this is green!" in green.
    .EXAMPLE
        PS> @('^fmMagenta text,^fB^bE Blue on Dark Gray ^fr Red','This is a^fM Test ^fzof ^fgGreen and ^fG^bYGreen on Dark Yellow') | Write-Color
        Displays multiple lines with different foreground and background colors.
    .INPUTS
        None. You cannot pipe objects to Write-Color.
    .OUTPUTS
        None
            `Write-Color` sends the objects to the host. It does not return any objects. However, the host might display the objects that `Write-Host` sends to it.
    .NOTES
        Copyright Notice
        Name:       Write-Color
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2020-09-11
        Version History:
            1.0.0    -    2017-01-21    -    Initial Release
        Attribution:
                Original Author:  Brian Clark
                Initially found at:  https://www.reddit.com/r/PowerShell/comments/5pdepn/writecolor_multiple_colors_on_a_single_line/

        TODO:
            INPUTS
                System.Object
                    You can pipe objects to be written to the host.
    .LINK
        https://sulltec.com
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
        Custom color output in PowerShell host
#>
 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][string]$Value,
        [Parameter(Mandatory=$false)][switch]$NoNewLine
    )
    begin {
        $colors = New-Object System.Collections.Hashtable
        $colors.b = 'Blue'
        $colors.B = 'DarkBlue'
        $colors.c = 'Cyan'
        $colors.C = 'DarkCyan'
        $colors.e = 'Gray'
        $colors.E = 'DarkGray'
        $colors.g = 'Green'
        $colors.G = 'DarkGreen'
        $colors.k = 'Black'
        $colors.m = 'Magenta'
        $colors.M = 'DarkMagenta'
        $colors.r = 'Red'
        $colors.R = 'DarkRed'
        $colors.w = 'White'
        $colors.y = 'Yellow'
        $colors.Y = 'DarkYellow'
        $colors.z = ''
    }
    process {
        $Value |
            Select-String -Pattern '(?ms)(((?''fg''^?\^f[bBcCeEgGkmMrRwyYz])(?''bg''^?\^b[bBcCeEgGkmMrRwyYz])|(?''bg''^?\^b[bBcCeEgGkmMrRwyYz])(?''fg''^?\^f[bBcCeEgGkmMrRwyYz])|(?''fg''^?\^f[bBcCeEgGkmMrRwyYz])|(?''bg''^?\^b[bBcCeEgGkmMrRwyYz])|^)(?''text''.*?))(?=\^[fb][bBcCeEgGkmMrRwyYz]|\Z)' -AllMatches | 
            ForEach-Object { $_.Matches } |
            ForEach-Object {
                $fg = ($_.Groups | Where-Object {$_.Name -eq 'fg'}).Value -replace '^\^f',''
                $bg = ($_.Groups | Where-Object {$_.Name -eq 'bg'}).Value -replace '^\^b',''
                $text = ($_.Groups | Where-Object {$_.Name -eq 'text'}).Value
                $fgColor = [string]::IsNullOrWhiteSpace($fg) -or $fg -eq 'z' ? $Host.UI.RawUI.ForegroundColor : $colors.$fg
                $bgColor = [string]::IsNullOrWhiteSpace($bg) -or $bg -eq 'z' ? $Host.UI.RawUI.BackgroundColor : $colors.$bg
                Write-Host -Object $text -ForegroundColor $fgColor -BackgroundColor $bgColor -NoNewline
            }
        if (-not $NoNewLine) { Write-Host }
    }
    end {
    }
}
function Write-Log {
    <#
    .SYNOPSIS
        Writes a log message to a specified log file with optional log level.
    .DESCRIPTION
        This function writes a log message to a specified log file. It supports different log levels such as Info, Warning, and Error. If the log file does not exist, it will be created. The function also supports appending to existing log files or preventing overwriting of existing files with the NoClobber parameter.
    .PARAMETER Message
        The log message to write.
    .PARAMETER Path
        The path of the log file. Defaults to 'C:\Logs\Update-RDSCertificate.log'.
    .PARAMETER Level
        The log level for the message. Valid values are 'Error', 'Warn', and 'Info'. Defaults to 'Info'.
    .PARAMETER NoClobber
        Prevents overwriting an existing log file. If the log file exists and NoClobber is specified, the function will not write to the file and will generate an error.
    .EXAMPLE
        PS> Write-Log -Message "This is an information message."
        Writes an information message to the default log file.
    .EXAMPLE
        PS> Write-Log -Message "This is a warning message." -Level "Warn"
        Writes a warning message to the default log file.
    .EXAMPLE
        PS> Write-Log -Message "This is an error message." -Level "Error" -Path "C:\Logs\CustomLog.log"
        Writes an error message to the specified log file.
    .INPUTS
        None. You cannot pipe objects to Write-Log.
    .OUTPUTS
        None. Write-Log writes the log messages to a file but does not produce any output objects.
    .NOTES
        Copyright Notice
        Name:       Write-Log
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Logging
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$true,
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [Alias("LogPath")]
        [string]$Path='C:\Logs\Update-RDSCertificate.log',
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )
    begin {
    }
    process {
        if ((Test-Path $Path) -and $NoClobber) {
            Write-Error "Log file $Path already exists, and NoClobber was specified.  Either delete the file or specify a different name.";
            return;
        }
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path.";
            New-Item $Path -Force -ItemType File;
        }
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
        switch ($Level) {
            'Error' {
                Write-Error $Message;
                $LevelText = 'ERROR:';
            }
            'Warn' {
                Write-Warning $Message;
                $LevelText = 'WARNING:';
            }
            'Info' {
                Write-Verbose $Message;
                $LevelText = 'INFO:';
            }
        }
        "$FormattedDate`t$LevelText`t$Message" | Out-File -FilePath $Path -Append;
    }
    end {
    }
}
function Write-Console {
    <#
    .SYNOPSIS
        Writes a formatted message to the console with a title and optional alignment and indentation.
    .DESCRIPTION
        This function writes a formatted message to the console, making it easier to upgrade from a terminal/console to an application. It allows specifying a title, alignment, and indentation for the message, and supports colored text output.
    .PARAMETER Value
        The message text to display in the console.
    .PARAMETER Title
        The title to display before the message. Defaults to 'Info'.
    .PARAMETER Align
        The number of characters to use for aligning the title and message. Defaults to 12.
    .PARAMETER Indent
        The number of tab characters to use for indenting the message. Defaults to 1.
    .PARAMETER NoNewLine
        If specified, the message will be written without a trailing newline character.
    .EXAMPLE
        PS> Write-Console -Value "This is a test message" -Title "Test"
        Writes "Test: This is a test message" to the console with default alignment and indentation.
    .EXAMPLE
        PS> Write-Console -Value "Another message" -Title "Warning" -Align 15 -Indent 2
        Writes "Warning: Another message" to the console with specified alignment and indentation.
    .INPUTS
        None. You cannot pipe objects to Write-Console.
    .OUTPUTS
        None. Write-Console writes the formatted message to the console but does not produce any output objects.
    .NOTES
        Copyright Notice
        Name:       Write-Console
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Console output formatting
    #>
    # This function exists to make upgrading from terminal/console to an application easier.
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][string]$Value,
        [Parameter(Mandatory=$false)][string]$Title = 'Info',
        [Parameter(Mandatory=$false)][int]$Align = 12,
        [Parameter(Mandatory=$false)][int]$Indent = 1,
        [Parameter(Mandatory=$false)][switch]$NoNewLine
    )
    begin {
        [string]$spaces = "$(' ' * (($Align) - $Title.Length -1))"
    }
    process {
        Write-Color "$("`t" * $Indent)^fy$Title^fz:$spaces$Value"
    }
}
function Write-DebugInfo {
    <#
    .SYNOPSIS
        Writes debugging information to the console.
    .DESCRIPTION
        This function writes debugging information to the console if the global variable $script:ShowDebugInfo is set to $true. It optionally includes headers and footers for better readability. The debugging information is written in dark gray.
    .PARAMETER String
        The strings containing the debugging information to display.
    .PARAMETER NoHeader
        If specified, the function will not display the header.
    .PARAMETER NoFooter
        If specified, the function will not display the footer.
    .EXAMPLE
        PS> Write-DebugInfo -String "This is a debug message"
        Writes the message "This is a debug message" to the console with a header and footer.
    .EXAMPLE
        PS> Write-DebugInfo -String "Message1", "Message2" -NoHeader -NoFooter
        Writes the messages "Message1" and "Message2" to the console without a header and footer.
    .INPUTS
        None. You cannot pipe objects to Write-DebugInfo.
    .OUTPUTS
        None. Write-DebugInfo writes the debugging information to the console but does not produce any output objects.
    .NOTES
        Copyright Notice
        Name:       Write-DebugInfo
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Debugging
    #>
	param (
		[Parameter(Mandatory=$true, Position = 0)][string[]]$String,
		[switch]$NoHeader,
		[switch]$NoFooter
	)
	if ($script:ShowDebugInfo) {
		[int]$dividerLength = 0
		$String | ForEach-Object { if (($_.Length + 8) -gt $dividerLength) { $dividerLength = $_.Length + 8 }}
		if (!$NoHeader) {
			Write-Console ('-' * $dividerLength) -ForegroundColor DarkGray
			Write-Console 'Debugging Information:' -ForegroundColor DarkGray
		}
		$String | ForEach-Object {Write-Console ("`t{0}" -f $_) -ForegroundColor DarkGray }
		if (!$NoFooter) {
			Write-Console ("-" * $dividerLength) -ForegroundColor DarkGray
		}
	}
}
function PressAnyKey {
    <#
    .SYNOPSIS
        Waits for the user to press any key, excluding certain key combinations.
    .DESCRIPTION
        The function displays a message prompting the user to press any key to continue. It excludes certain key combinations such as Shift, Control, Alt, and common clipboard operations to avoid accidental triggers.
    .PARAMETER None
        This function does not accept any parameters.
    .EXAMPLE
        PS> PressAnyKey
        Displays "Press any key to continue ..." and waits for the user to press a valid key.
    .INPUTS
        None. This function does not accept piped input.
    .OUTPUTS
        None. This function does not produce any output objects.
    .NOTES
        Copyright Notice
        Name:       PressAnyKey
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        PowerShell Host Interaction
    .FUNCTIONALITY
        Wait for key press with exclusions
    #>
    Write-Console "Press any key to continue ..." -Title "Action"
    [bool]$anyKey = $false
    do {
        [System.Management.Automation.Host.KeyInfo]$rawKey = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,AllowCtrlC")
        switch ($rawKey.VirtualKeyCode) {
            {$_ -in 16,17,18} { $anyKey = $false } # Shift, Control, Alt
            {$_ -in 45, 46} {
                # Shift+Insert (45) == Paste, Shift+Delete (46) == Cut
                if (
                    $rawKey.ControlKeyState -band [System.Management.Automation.Host.ControlKeyStates]::ShiftPressed -and -not (
                        $rawKey.ControlKeyState -band (
                            [System.Management.Automation.Host.ControlKeyStates]::LeftCtrlPressed -bor 
                            [System.Management.Automation.Host.ControlKeyStates]::RightCtrlPressed -bor 
                            [System.Management.Automation.Host.ControlKeyStates]::LeftAltPressed -bor 
                            [System.Management.Automation.Host.ControlKeyStates]::RightAltPressed
                        )
                    )
                ) { $anyKey = $false}
                # CTRL+Insert (45) == Copy
                elseif (
                    $rawKey.ControlKeyState -band ([System.Management.Automation.Host.ControlKeyStates]::LeftCtrlPressed -bor [System.Management.Automation.Host.ControlKeyStates]::RightCtrlPressed) -and -not (
                         $rawKey.ControlKeyState -band (
                            [System.Management.Automation.Host.ControlKeyStates]::ShiftPressed -bor 
                            [System.Management.Automation.Host.ControlKeyStates]::LeftAltPressed -bor 
                            [System.Management.Automation.Host.ControlKeyStates]::RightAltPressed
                        )
                    )
                ) { $anyKey = $false}
                else { $anyKey = $true}
            }
            {$_ -in 65,67,86,88} {
                # CTRL+A (65) == Select All, CTRL+C (67) == Copy, CTRL+V (86) == Paste, CTRL+X(88) == Cut (with or without Shift)
                if (
                    $rawKey.ControlKeyState -band  ([System.Management.Automation.Host.ControlKeyStates]::LeftCtrlPressed -bor [System.Management.Automation.Host.ControlKeyStates]::RightCtrlPressed) -and -not (
                        $rawKey.ControlKeyState -band (
                            [System.Management.Automation.Host.ControlKeyStates]::LeftAltPressed -bor 
                            [System.Management.Automation.Host.ControlKeyStates]::RightAltPressed
                        )
                    )
                ) { $anyKey = $false}
                else { $anyKey = $true}
            }
            default { $anyKey = $true }
        }
    } while (-not $anyKey)
}
function YesOrNo {
    <#
    .SYNOPSIS
        Prompts the user for a yes or no response.
    .DESCRIPTION
        This function displays a prompt asking the user for a yes or no response. The prompt can be customized, and the function will keep asking until a valid response (y or n) is provided.
    .PARAMETER Prompt
        The message to display to the user. Defaults to "Is the above information correct? [y|n]".
    .EXAMPLE
        PS> YesOrNo -Prompt "Do you want to continue? [y|n]"
        Prompts the user with "Do you want to continue? [y|n]" and waits for a valid response.
    .INPUTS
        None. This function does not accept piped input.
    .OUTPUTS
        System.Boolean. Returns $true if the user responds with 'y', and $false if the user responds with 'n'.
    .NOTES
        Copyright Notice
        Name:       YesOrNo
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Prompting user for confirmation
    #>
	param (
		[Parameter(Mandatory=$false)][string]$Prompt = "Is the above information correct? [y|n]"
	)
	[string]$response = ""
	while ($response -notmatch "[y|n]"){
		$response = Read-Host $Prompt
	}
	if ($response -match "y") { return $true }
	else { return $false }
}
function Show-Choices {
    <#
    .SYNOPSIS
        Displays a list of choices and prompts the user to select one.
    .DESCRIPTION
        This function displays a list of choices to the user and prompts for a selection. The list can be sorted or unsorted and supports various types of objects. The function can also show options to go back or exit. It is useful for creating interactive menus in PowerShell scripts.
    .PARAMETER Title
        The title to display above the list of choices. Defaults to 'Select one of the following:'.
    .PARAMETER Prompt
        The prompt message to display to the user. Defaults to an empty string, which results in a default prompt being generated.
    .PARAMETER List
        The list of choices to display. This parameter is mandatory.
    .PARAMETER ObjectKey
        The property of the objects in the list to display as the choice text. Defaults to 'Name'.
    .PARAMETER ClearScreen
        If specified, the screen will be cleared before displaying the choices.
    .PARAMETER ShowBack
        If specified, an option to go back will be displayed.
    .PARAMETER ShowExit
        If specified, an option to exit will be displayed. Defaults to true.
    .PARAMETER ExitPath
        The path to a script or command to execute when the exit option is selected.
    .PARAMETER ExitScript
        A script block to execute when the exit option is selected.
    .PARAMETER NoSort
        If specified, the list of choices will not be sorted.
    .EXAMPLE
        PS> Show-Choices -List @("Option 1", "Option 2", "Option 3")
        Displays a menu with three options and prompts the user to select one.
    .EXAMPLE
        PS> Show-Choices -Title "Choose an option:" -List @("Option A", "Option B", "Option C") -ShowBack -ShowExit
        Displays a menu with three options, a back option, and an exit option.
    .INPUTS
        None. You cannot pipe objects to Show-Choices.
    .OUTPUTS
        System.Object. Returns the selected object from the list.
    .NOTES
        Copyright Notice
        Name:       Show-Choices
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Interactive menu selection
    #>
	param (
		[Parameter(Mandatory=$false)][string]$Title = 'Select one of the following:',
		[Parameter(Mandatory=$false)][string]$Prompt = '',
		[Parameter(Mandatory=$true)]$List,
		[Parameter(Mandatory=$false)][string]$ObjectKey = '',
		[Parameter(Mandatory=$false)][bool]$ClearScreen = $false,
		[Parameter(Mandatory=$false)][bool]$ShowBack = $false,
        [Parameter(Mandatory=$false)][bool]$ShowExit = $true,
        [Parameter(Mandatory=$false)][string]$ExitPath = $null,
        [Parameter(Mandatory=$false)][ScriptBlock]$ExitScript = $null,
        [Parameter()][switch]$NoSort
	)
	if ([string]::IsNullOrWhiteSpace($ObjectKey)) { $ObjectKey = "Name"}
	if ($List.Count -eq 1) {
		Write-DebugInfo -String 'List Count is 1'
		return $List[0]
	} elseif ($List.Count -le 0) {
		Write-DebugInfo -String 'List Count is less than 1'
		return $null
	} else {
		if ($ClearScreen -and !($script:ShowDebugInfo)) { Clear-Host }
		Write-Console $Title
		[string]$listType = $List.GetType().Fullname
		Write-DebugInfo -String "List Type: $listType","List Count: $($List.Count)"
		[string[]]$MenuItems = @()
		switch ($listType) {
			'System.Collections.Hashtable' {
                if($NoSort){ $MenuItems = ($List.Keys | ForEach-Object ToString) }
				else { $MenuItems = ($List.Keys | ForEach-Object ToString) | Sort-Object }
				break
			}
			'System.Object[]' {
				if($NoSort){
                    $List | ForEach-Object {
                        $MenuItem = $_
                        if ($MenuItem.GetType().FullName -eq 'System.Management.Automation.PSCustomObject') { $MenuItems += $MenuItem.$ObjectKey }
                        else { $MenuItems += $MenuItem }
                    }
                }
                else {
                    $List | Sort-Object | ForEach-Object {
                        $MenuItem = $_
                        if ($MenuItem.GetType().FullName -eq 'System.Management.Automation.PSCustomObject') { $MenuItems += $MenuItem.$ObjectKey }
                        else { $MenuItems += $MenuItem }
                    }
                }
                break
            }
            'SourceSubModule[]' {
                if($NoSort) { foreach ($listItem in $List) { $MenuItems += $listItem.GetFinalName() } }
                else { foreach ($listItem in ($List | Sort-Object -Property @{Expression = {$_.GetFinalName()};Descending = $false})) { $MenuItems += $listItem.GetFinalName() } }
                break
            }
            {$_ -in 'GitRepo[]'} {
                if($NoSort) { foreach ($listItem in $List) { $MenuItems += $listItem.Name } }
                else { foreach ($listItem in ($List | Sort-Object -Property Name)) { $MenuItems += $listItem.Name } }
                break
            }
            {$_ -in 'BuildType[]','BuildTypeJava[]','BuildTypeGradle[]','BuildTypeMaven[]'} {
                if($NoSort) { foreach ($listItem in $List) { $MenuItems += $listItem.Origin } }
                else { foreach ($listItem in ($List | Sort-Object -Property Origin)) { $MenuItems += $listItem.Origin } }
                break
            }
			default {
                if($NoSort) { $MenuItems = $List }
                else { $MenuItems = $List | Sort-Object }
				break
			}
		}
		[int]$counter = 1
		$MenuItems | ForEach-Object {
			Write-Console("`t{0}.  {1}" -f $counter,$_)
			$counter += 1
		}
		[int]$lowerBound = 1
		[int]$upperBound = $MenuItems.Count
		if ($ShowBack) { [string]$showBackString = '|(B)ack' } else { [string]$showBackString = '' }
		if ($ShowExit) { [string]$showExitString = '"|(Q)uit' } else { [string]$showExitString = '' }
		Write-DebugInfo "Lower Bound: $lowerBound","Upper Bound: $upperBound"
		[string]$selectionString = "[{0}-{1}{2}{3}]" -f $lowerBound,$upperBound,$showBackString,$showExitString
		if (([string]::IsNullOrWhiteSpace($Prompt))) { $Prompt = "Enter {0}" -f $selectionString }
		else { $Prompt += " {0}" -f $selectionString }
		[bool]$exitLoop = $false
		do {
			[string]$response = Read-Host $Prompt
			$response = $response.Trim()
            Write-DebugInfo -String "Response: $response" -NoFooter
			switch -regex ( $response ) {
				'[b|back]' {
					$return = $null
					$exitLoop = $true
					break
				}
				'[q|quit|e|exit]' {
                    if ($null -ne $ExitScript) { . $ExitScript }
					ExitScript -Path $ExitPath
					break
				}
				default {
					try {
						[int]$choice = $null
						if ([int32]::TryParse($response, [ref]$choice)) {
							Write-DebugInfo -String "Choice: $choice" -NoHeader
						}
						else {
							$choice = -1
							Write-DebugInfo -String "Choice could not parse: $choice" -NoHeader
						}
					}
					catch { [int]$choice = -1 }
					if (($null -ne $choice) -and ($choice -ge $lowerBound) -and ($choice -le $upperBound)) {
						[int]$choice = $choice - 1
						if ($ClearScreen -and !($script:ShowDebugInfo)) { Clear-Host }
						switch ($listType) {
							'System.Collections.Hashtable' {
								$return = $List.Get_Item($MenuItems[$choice])
								break
							}
							'System.Object[]' {
								$List | ForEach-Object {
									if ($_.GetType().FullName -eq 'System.Management.Automation.PSCustomObject') {
                                        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'return')]
										$return = ($List | Where-Object {$_.$ObjectKey -eq $MenuItems[$choice]} | Select-Object -First 1)
                                    }
                                    else {
										$return = ($List | Where-Object {$_ -eq $MenuItems[$choice]} | Select-Object -First 1)
									}
								}
								break
                            }
                            'SourceSubModule[]' {
                                $return = $List | Where-Object { $_.GetFinalName() -eq $MenuItems[$choice] } | Select-Object -First 1
								break
                            }
                            {$_ -in 'GitRepo[]'} {
                                $return = $List | Where-Object { $_.Name -eq $MenuItems[$choice] } | Select-Object -First 1
								break
                            }
                            {$_ -in 'BuildType[]','BuildTypeJava[]','BuildTypeGradle[]','BuildTypeMaven[]'} {
                                $return = $List | Where-Object { $_.Origin -eq $MenuItems[$choice] } | Select-Object -First 1
                                break
                            }
                            default {
								$return = $MenuItems[$choice]
								break
							}
						}
						Write-Console("Selected:  {0}" -f $MenuItems[$choice])
						$exitLoop = $true
					} else {
						$exitLoop = $false
					}
					break
				}
			}
		} while (!$exitLoop)
		return $return
	}
}
function Show-Menu {
    <#
    .SYNOPSIS
        Displays a menu of choices to the user and executes the selected choice.
    .DESCRIPTION
        This function displays a menu based on a hashtable of choices and prompts the user to select an item. If the selected item is a nested hashtable, it will recursively display the submenu. The function also supports options to show a back button and to pause after executing a choice.
    .PARAMETER HashTable
        The hashtable containing the menu items. The keys are the menu options, and the values are the actions to execute or nested hashtables for submenus.
    .PARAMETER ShowBack
        If specified, a back option will be displayed in the menu to return to the previous menu level. Defaults to false.
    .PARAMETER ShowPause
        If specified, the function will pause and wait for a key press after executing a menu choice. Defaults to true.
    .EXAMPLE
        PS> $menu = @{
                'Option 1' = { Write-Output 'You selected option 1' }
                'Option 2' = @{
                    'Suboption 1' = { Write-Output 'You selected suboption 1' }
                    'Suboption 2' = { Write-Output 'You selected suboption 2' }
                }
                'Exit' = { $null }
            }
        PS> Show-Menu -HashTable $menu
        Displays the menu and executes the selected options.
    .INPUTS
        None. You cannot pipe objects to Show-Menu.
    .OUTPUTS
        None. Show-Menu does not return any objects.
    .NOTES
        Copyright Notice
        Name:       Show-Menu
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Interactive menu
    #>
	param (
		[Parameter(Mandatory=$true)][System.Collections.Hashtable]$HashTable,
        [Parameter(Mandatory=$false)][bool]$ShowBack = $false,
        [Parameter(Mandatory=$false)][bool]$ShowPause = $true
	)
	[bool]$exitLoop = $false
	do {
		$choice = Show-Choices -Title 'Select menu item.' -List $HashTable -ClearScreen $true -ShowBack $ShowBack
		if ([string]::IsNullOrWhiteSpace($choice)) {
			$exitLoop = $true
		} else {
			if ($choice.GetType().FullName -eq 'System.Collections.HashTable') {
				Show-Menu -HashTable $choice -ShowBack $true -ShowPause $ShowPause
			} else {
				&($choice)
				if ($ShowPause) { PressAnyKey }
			}
		}
	} while (-not $exitLoop)
}
function Invoke-CommandLine ($command, $workingDirectory, $timeout) {
    <#
    .SYNOPSIS
        Executes a command line instruction and captures the output and error messages.
    .DESCRIPTION
        This function executes a specified command line instruction within an optional working directory and with an optional timeout period. It captures both the standard output and standard error of the command and returns these along with the exit code.
    .PARAMETER command
        The command line instruction to execute.
    .PARAMETER workingDirectory
        The directory in which to execute the command. Defaults to the current directory if not specified.
    .PARAMETER timeout
        The maximum time, in seconds, to wait for the command to complete. Defaults to 5 seconds if not specified.
    .EXAMPLE
        PS> Invoke-CommandLine -command "ipconfig" -workingDirectory "C:\Windows" -timeout 10
        Executes the "ipconfig" command in the "C:\Windows" directory with a 10-second timeout.
    .INPUTS
        None. You cannot pipe objects to Invoke-CommandLine.
    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Returns an object with the properties: StandardOutput, StandardError, and ExitCode.
    .NOTES
        Copyright Notice
        Name:       Invoke-CommandLine
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        Command line execution
    #>
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $env:ComSpec
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    if ($null -eq $workingDirectory) { $pinfo.WorkingDirectory = (Get-Location).Path }
    else { $pinfo.WorkingDirectory = $workingDirectory }
    $pinfo.Arguments = "/c $command"
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    if ($null -eq $timeout) { $timeout = 5 }
	Wait-Process $p.Id -Timeout $timeout -EA:0
	$stdOutput = $p.StandardOutput.ReadToEnd()
	$stdError  = $p.StandardError.ReadToEnd()
	$exitCode  = $p.ExitCode
    [pscustomobject]@{
        StandardOutput = $stdOutput
        StandardError = $stdError
        ExitCode = $exitCode
    }
}
Function Write-DataToFile {
    <#
    .SYNOPSIS
        Writes data to a specified file in either text or CSV format.
    .DESCRIPTION
        This function writes the provided data to a file at the specified location with the specified name and format. It supports text and CSV file types and includes logic to handle existing files by prompting the user for overwrite confirmation.
    .PARAMETER FilePath
        The directory path where the file will be created. Defaults to the script's root directory.
    .PARAMETER FileName
        The name of the file to be created, without the extension. This parameter is mandatory.
    .PARAMETER FileType
        The type of the file to be created. Valid values are 'txt' and 'csv'. Defaults to 'txt'.
    .PARAMETER FileData
        The data to be written to the file. This parameter is mandatory.
    .EXAMPLE
        PS> Write-DataToFile -FileName "example" -FileData "This is a sample text."
        Creates a text file named "example.txt" in the script's root directory with the provided data.
    .EXAMPLE
        PS> $data = @(
                @{ Name = "John"; Age = 30 }
                @{ Name = "Jane"; Age = 25 }
            )
        PS> Write-DataToFile -FilePath "C:\Data" -FileName "people" -FileType "csv" -FileData $data
        Creates a CSV file named "people.csv" in the "C:\Data" directory with the provided data.
    .INPUTS
        None. You cannot pipe objects to Write-DataToFile.
    .OUTPUTS
        None. Write-DataToFile writes data to a file but does not produce any output objects.
    .NOTES
        Copyright Notice
        Name:       Write-DataToFile
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2024-07-18
        Version History:
            1.0.0    -    2024-07-18    -    Initial Release
        TODO:
            None.
    .LINK
        https://sulltec.com
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
        File writing
    #>
	Param (
		[Parameter(Mandatory=$false)][string]$FilePath = $PSScriptRoot,
		[Parameter(Mandatory=$true)][string]$FileName,
		[Parameter(Mandatory=$false)][ValidateSet('txt','csv')][string]$FileType ="txt",
		[Parameter(Mandatory=$true)]$FileData
	)
	[string]$FilePathAndName = Join-Path -Path $FilePath -ChildPath ($FileName + "." + $FileType)
	[boolean]$writeFile = $true
	If (Test-Path $FilePathAndName) {
		Write-Console("File ""{0}"" already exists." -f $FilePathAndName)
		If (YesOrNo -Prompt "Do you want to overwrite this file? [y|n]") {
			Remove-Item -Path $FilePathAndName -Force
			If (Test-Path $FilePathAndName) { Write-Console "File could not be deleted." ; $writeFile = $false }
			Else { Write-Console "File was successfuly deleted." ; $writeFile = $true }
		}
		Else {
			$writeFile = $false
		}
	} Else {
		$writeFile = $true
	}
	If ($writeFile) {
		Try {
			Switch ($FileType) {
				"txt" { Set-Content $FilePathAndName $FileData ; Break }
				"csv" { $FileData | Export-CSV $FilePathAndName -NoTypeInformation ; Break }
			}
			If (Test-Path $FilePathAndName) {Write-Console("File ""{0}"" successfully created." -f $FilePathAndName)}
			Else {Write-Console("File ""{0}"" not created.  Something must have happened." -f $AESKeyFilePath)}
		} Catch {
			Write-Console("Error creating file ""{0}"".`r`n`tError Message:  {1}" -f $AESKeyFilePath,$_.Exception.Message)
		}
	}
}
function Get-ClickableLink {
    <#
    .SYNOPSIS
        Returns a string with a Windows Terminal clickable link.
    .DESCRIPTION
        Returns a string with a Windows Terminal clickable link. This is done by encapsulating the URL and description with the following escape codes:
            `e]8;;$URL`e\$Caption`e]8;;`e\
    .PARAMETER URL
        The URL that the clickable link will link to. The format should be a string with the following:
            <protocol>://<url>
    .PARAMETER Caption
        The caption to display instead of the URL. If this is ommited the URL will be displayed
    .EXAMPLE
        PS> Get-ClickableLink -URL 'file://C:\Windows\System32\' -Caption 'System32'
        Opens the Windows System32 folder using the appropriate system application (Explorer.exe)
    .INPUTS
        Inputs URL and Caption should be strings.
    .OUTPUTS
        Returns a formatted string for use in other methods.
    .NOTES
        Copyright Notice
        Name:       Get-ClickableLink
        Author:     Casey J. Sullivan
        Version:    1.0.0    -     Release
        Date:       2022-12-02
        Version History:
            1.0.0    -    2022-12-02    -    Initial Release
        Attribution:
            Thank you Dani Llewllyn for the code. https://diddledani.com/powershell-clickable-hyperlinks/
        TODO:
            None.
    .LINK
        https://sulltec.com
    .LINK
        https://diddledani.com/powershell-clickable-hyperlinks/
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
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $URL,

        [Parameter(Mandatory=$false, Position = 1)]
        [string]$Caption
    )
    begin {
        $pathRegEx='\A(?:(?<drive>(?>[a-z]:|[\\/]{2}[a-z0-9%._~-]{1,63}[\\/][a-z0-9$%._~-]{1,80})[\\/])(?<folder>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F][\\/])*)(?<file>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F])?)|(?<relative>(?>\.{0,2}[\\/]))(?<folder>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F][\\/])*)(?<file>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F])?)|(?<relativefolder>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F][\\/])+)(?<file>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F])?)|(?<relativefile>(?>[^\\/:*?"<>|\x00-\x1F]{0,254}[^.\\/:*?"<>|\x00-\x1F])))\z'
    }
    process {
        [string]$return = ''
        $nullCaption = [string]::IsNullOrWhiteSpace($Caption)
        if (($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) -and -not $Env:WT_SESSION) {
            # Fallback for Windows users not inside Windows Terminal
            $return = $nullCaption ? "$Uri" : "$Caption ($Uri)"
        }
        else {
            if ($nullCaption) { $Caption = "$URL" }
            if ($URL -match $pathRegEx)         {
                if (-not [string]::IsNullOrWhiteSpace($Matches.relative)      ) {
                    $tempURL = Resolve-Path -Path $URL -ErrorAction SilentlyContinue -ErrorVariable _rpError
                    if ([string]::IsNullOrWhiteSpace($tempURL)) {
                        $tempURL = $_rpError[0].TargetObject
                    }
                    $URL = "file://$tempURL"
                }
                elseif (-not [string]::IsNullOrWhiteSpace($Matches.relativefile)  ) {
                    $URL = "file://$( Join-Path -Path (Get-Location).Path -ChildPath $URL)"
                }
                elseif (-not [string]::IsNullOrWhiteSpace($Matches.relativefolder)) {
                    $URL = "file://$( Join-Path -Path (Get-Location).Path -ChildPath $URL)"
                }
                else {
                    $URL = "file://$URL"
                }
            }
            if ($Caption.StartsWith("file://")) { $Caption = $Caption -replace 'file://', '' }
            $return = "`e]8;;$URL`e\$Caption`e]8;;`e\"
        }
        if ($nullCaption) { $Caption = $null }
        return $return
    }
}