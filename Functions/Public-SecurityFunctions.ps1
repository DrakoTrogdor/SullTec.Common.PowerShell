function Get-AesKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$KeyString
    )
    begin {
        $shaHasher = [System.Security.Cryptography.SHA256Managed]::new()
    }
    process {
        [byte[]]$AESKeyStringBytes  = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
        Write-Output $shaHasher.ComputeHash($AESKeyStringBytes)
    }
}
function ConvertTo-AesString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'From String', ValueFromPipeline = $false)]
        [string]$KeyString,

        [Parameter(Mandatory = $true, ParameterSetName = 'From Bytes', ValueFromPipeline = $false)]
        [byte[]]$KeyBytes,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Value
    )
    begin {
        [byte[]]$AESKey = switch ($PSCmdlet.ParameterSetName) {
            'From String' {
                [byte[]]$AESKeyStringBytes  = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
                $shaHasher = [System.Security.Cryptography.SHA256Managed]::new()
                Write-Output $shaHasher.ComputeHash($AESKeyStringBytes)
            }
            'From Bytes'  {
                Write-Output $KeyBytes
            }
            default       { New-Object Byte[] 32 }
        }
    }
    process {
        [System.Security.SecureString]$secureString = ConvertTo-SecureString -String $Value -AsPlainText -Force
        [string]$aesString = ConvertFrom-SecureString -SecureString $secureString -Key $AESKey
        return $aesString
    }
}
function ConvertFrom-AesString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'From String', ValueFromPipeline = $false)]
        [string]$KeyString,

        [Parameter(Mandatory = $true, ParameterSetName = 'From Bytes', ValueFromPipeline = $false)]
        [byte[]]$KeyBytes,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Value
    )
    begin {
        [byte[]]$AESKey = switch ($PSCmdlet.ParameterSetName) {
            'From String' {
                [byte[]]$AESKeyStringBytes  = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
                $shaHasher = [System.Security.Cryptography.SHA256Managed]::new()
                Write-Output $shaHasher.ComputeHash($AESKeyStringBytes)
            }
            'From Bytes'  {
                Write-Output $KeyBytes
            }
            default       { New-Object Byte[] 32 }
        }
    }
    process {
        [System.Security.SecureString]$secureString = ConvertTo-SecureString -String $Value -Key $AESKey
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
        $plainTextString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        return $plainTextString
    }
}
function Convert-AesStringToSecureString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'From String', ValueFromPipeline = $false)]
        [string]$KeyString,

        [Parameter(Mandatory = $true, ParameterSetName = 'From Bytes', ValueFromPipeline = $false)]
        [byte[]]$KeyBytes,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Value
    )
    begin {
        [byte[]]$AESKey = switch ($PSCmdlet.ParameterSetName) {
            'From String' {
                [byte[]]$AESKeyStringBytes  = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
                $shaHasher = [System.Security.Cryptography.SHA256Managed]::new()
                Write-Output $shaHasher.ComputeHash($AESKeyStringBytes)
            }
            'From Bytes'  {
                Write-Output $KeyBytes
            }
            default       { New-Object Byte[] 32 }
        }
    }
    process {
        [System.Security.SecureString]$secureString = ConvertTo-SecureString -String $Value -Key $AESKey
        return $secureString
    }
}
function Convert-SecureStringToAesString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'From String', ValueFromPipeline = $false)]
        [string]$KeyString,

        [Parameter(Mandatory = $true, ParameterSetName = 'From Bytes', ValueFromPipeline = $false)]
        [byte[]]$KeyBytes,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Security.SecureString]$Value
    )
    begin {
        [byte[]]$AESKey = switch ($PSCmdlet.ParameterSetName) {
            'From String' {
                [byte[]]$AESKeyStringBytes  = [System.Text.Encoding]::UTF8.GetBytes($KeyString)
                $shaHasher = [System.Security.Cryptography.SHA256Managed]::new()
                Write-Output $shaHasher.ComputeHash($AESKeyStringBytes)
            }
            'From Bytes'  {
                Write-Output $KeyBytes
            }
            default       { New-Object Byte[] 32 }
        }
    }
    process {
        [string]$aesString = ConvertFrom-SecureString -SecureString $Value -Key $AESKey
        return $aesString
    }
}
function Compare-AESSecureString {
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'From String', ValueFromPipeline = $false)]
        [string]$KeyString,

        [Parameter(Mandatory = $true, ParameterSetName = 'From Bytes', ValueFromPipeline = $false)]
        [byte[]]$KeyBytes,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$Value1,

        [Parameter(Mandatory = $true, ValueFromPipeline = $false)]
        [string]$Value2
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'From String' {
                [string]$plainValue1 = ConvertFrom-AESSecureString -KeyString $KeyString -Value $Value1
                [string]$plainValue2 = ConvertFrom-AESSecureString -KeyString $KeyString -Value $Value2
                return ($plainValue1 -eq $plainValue2)
                break
            }
            'From Bytes' {
                [string]$plainValue1 = ConvertFrom-AESSecureString -KeyBytes $KeyBytes -Value $Value1
                [string]$plainValue2 = ConvertFrom-AESSecureString -KeyBytes $KeyBytes -Value $Value2
                return ($plainValue1 -eq $plainValue2)
                break
            }
            default { return $false }
        }
    }
}