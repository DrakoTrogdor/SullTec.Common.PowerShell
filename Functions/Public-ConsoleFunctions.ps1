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
        PS> Verb-PublicFunctionName -Parameter1 'Value' -Parameter2 'Value'
        [Description of the example.]
    .INPUTS
        None
            This functionality is forecoming.
    .OUTPUTS
        None
            `Write-Color` sends the objects to the host. It does not return any objects. However, the host might display the objects that `Write-Host` sends to it.
    .NOTES
        Copyright Notice
        Name:       Write-Color
        Author:     Casey J Sullivan
        Version:    2.0.0
        Date:       2020-09-11
        Version History:
            1.0.0    -    2017-01-21
                Original Author:  Brian Clark
                Initially found at:  https://www.reddit.com/r/PowerShell/comments/5pdepn/writecolor_multiple_colors_on_a_single_line/

        TODO:
            INPUTS
                System.Object
                    You can pipe objects to be written to the host.
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
    <#
  .EXAMPLE
    A normal usage example:
        Write-Color "Hey look ^crThis is red ^cgAnd this is green!"
    An example using a piped array:
        @('^fmMagenta text,^fB^bE Blue on Dark Gray ^fr Red','This is a^fM Test ^fzof ^fgGreen and ^fG^bYGreen on Dark Yellow')|Write-Color
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
    Write-Console "Press any key to continue ..." -Title "Action"
    [bool]$anyKey = $false
    do {
        [System.Management.Automation.Host.KeyInfo]$rawKey = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,AllowCtrlC")
        switch ($rawKey.VirtualKeyCode) {
            {$_ -in 16,17,18} { $anyKey = $false; break; } # Shift, Control, Alt
            {$_ -in 45, 46} {
                # Shift Insert (45)  or Delete (46) - Paste or Cut
                if ($rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::ShiftPressed) { $anyKey = $false}
                # CTRL Insert (45) - Copy
                elseif ($rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::LeftCtrlPressed -or $rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::RightCtrlPressed) { $anyKey = $false}
                else { $anyKey = $true}
                break
            }
            {$_ -in 65,67,86,88} {
                # CTRL A (65), C (67), V (86), or X(88) - Select all, Copy, Paste, or Cut
                if ($rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::LeftCtrlPressed -or $rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::RightCtrlPressed) { $anyKey = $false}
                # CTRL A (65), C (67), V (86), or X(88) - Select all, Copy, Paste, or Cut
                elseif ($rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::LeftAltPressed -or $rawKey.ControlKeyState -eq [System.Management.Automation.Host.ControlKeyStates]::RightAltPressed) { $anyKey = $false}
                else { $anyKey = $true}
                break
            }
            default { $anyKey = $true }
        }
    } while (-not $anyKey)
}
function YesOrNo {
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