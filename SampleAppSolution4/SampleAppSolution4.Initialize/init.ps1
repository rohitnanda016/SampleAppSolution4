# . "$PSScriptRoot\scripts\init\Initialize-Environment.ps1" -RepoRoot $PSScriptRoot

$solutionpackagerexeToolPath = $Env:BuildProjectRoot;
$solutionpackagerexePath = "$solutionpackagerexeToolPath\Tools\CoreTools\SolutionPackager.exe"

# Download the NuGet tools if necessary
. "$PSScriptRoot\scripts\init\Initialize-NuGet.ps1" -RepoRoot $PSScriptRoot

if (Test-Path $solutionpackagerexePath) {
	echo "Skipping solutionpackager.ps1 Path: $solutionpackagerexePath"
}
else {
	echo "Executing solutionpackager.ps1 ..."
	. "$PSScriptRoot\scripts\init\solutionpackager.ps1" -RepoRoot $PSScriptRoot
}