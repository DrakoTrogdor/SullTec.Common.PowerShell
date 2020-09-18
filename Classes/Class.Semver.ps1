class Symver {
	[int]   $Major
	[int]   $Minor
	[int]   $Patch
	[string]$PreRelease
	[string]$BuildMetadata
	[string] static hidden $VersionMatch = '^([vV]([eE][rR])?\.?)?(?<major>0|[1-9]\d*)(\.(?<minor>0|[1-9]\d*)(\.(?<patch>0|[1-9]\d*))?)?(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?'
	[void] hidden Init(
		[int]   $Major,
		[int]   $Minor,
		[int]   $Patch,
		[string]$PreRelease,
		[string]$BuildMetadata
	){
		$this.Major         = $Major
		$this.Minor         = $Minor
		$this.Patch         = $Patch
		$this.PreRelease    = $PreRelease
		$this.BuildMetadata = $BuildMetadata
	}

	Symver(){ $this.Init(0, 0, 0, '', '') }
	Symver(
		[int]   $Major,
		[int]   $Minor,
		[int]   $Patch,
		[string]$PreRelease,
		[string]$BuildMetadata
	){ $this.Init($Major, $Minor, $Patch, $PreRelease, $BuildMetadata) }

	[bool]HasPreRelease(){ return ![string]::IsNullOrWhiteSpace($this.PreRelease) }
	[bool]HasBuildMetadata(){ return ![string]::IsNullOrWhiteSpace($this.BuildMetadata) }

	[Symver] static ConvertTo ([string]$Value) {
		if ($Value -match [Symver]::VersionMatch) {
			return [Symver]::new(
				$Matches.major,
				$Matches.minor,
				$Matches.patch,
				$Matches.prerelease,
				$Matches.buildmetadata
			)
		}
		else { return [Symver]::new() }
	}
	[bool] static Compare([Symver]$Value1,[Symver]$Value2){
		if ($Value1.Major -gt $Value2.Major) { return $true }
		elseif ($Value1.Major -eq $Value2.Major) {
			if ($Value1.Minor -gt $Value2.Minor) { return $true }
			elseif ($Value1.Minor -eq $Value2.Minor) {
				if ($Value1.Patch -gt $Value2.Patch) { return $true }
				elseif ($Value1.Patch -eq $Value2.Patch) {
					if ($value1.HasPreRelease() -and $Value2.HasPreRelease()) {
						[string[]]$val1Pre = $Value1.PreRelease -split '\.'
						[string[]]$val2Pre = $Value2.PreRelease -split '\.'
						[int]$longestSet = $val1Pre.Count -ge $val2Pre.Count ? $val1Pre.Count : $val2Pre.Count
						for([int]$counter = 0; $counter -lt $longestSet; $counter++){
							[string]$strVal1 = $val1Pre[$counter]
							[string]$strVal2 = $val2Pre[$counter]
							[Int64] $intVal1 = 0
							[Int64] $intVal2 = 0
							if([Int64]::TryParse($strVal1,[ref]$intVal1) -and [Int64]::TryParse($strVal2,[ref]$intVal2)) {
								if     ($intVal1 -gt $intVal2) { return $true  }
								elseif ($intVal1 -lt $intVal2) { return $false }
								# If they are equal continue to the next check
							}
							else {
								if     ($strVal1 -gt $strVal2) { return $true }
								elseif ($strVal1 -lt $strVal2) { return $false }
							}
						}
						return $false # They are completely equal, therefore Value1 is not greater than Value 2
					}
					elseif ($value1.HasPreRelease() -and !$value2.HasPreRelease()) { return $true }
					else { return $false }
				}
				else { return $false }
			}
			else { return $false }
		}
		else { return $false }
	}
}