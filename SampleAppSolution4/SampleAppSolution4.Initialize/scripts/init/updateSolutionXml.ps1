[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$solutionPath=$args[0];
$solutionName=$args[1];

function popUp($text,$title) {
    $a = new-object -comobject wscript.shell
    $b = $a.popup($text,0,$title,32+4)
    if($b -eq 6){
        ((Get-Content -path "$solutionPath$solutionName\$solutionName.WebResources\Other\Solution.xml" -Raw) -replace 'specifiedsolutionname',$solutionName) | Set-Content -Path "$solutionPath$solutionName\$solutionName.WebResources\Other\Solution.xml"
        ((Get-Content -path "$solutionPath$solutionName\$solutionName.PDPackage\PkgFolder\ImportConfig.xml" -Raw) -replace 'specifiedsolutionname',$solutionName) | Set-Content -Path "$solutionPath$solutionName\$solutionName.PDPackage\PkgFolder\ImportConfig.xml"
    }
}


$SolutionNameInSolutionXML = Select-String -Path "$solutionPath$solutionName\$solutionName.WebResources\Other\Solution.xml" -Pattern "specifiedsolutionname"
$SolutionNameInImportConfig = Select-String -Path "$solutionPath$solutionName\$solutionName.PDPackage\PkgFolder\ImportConfig.xml" -Pattern "specifiedsolutionname"


if ($null -ne $SolutionNameInSolutionXML -or $null -ne $SolutionNameInImportConfig){
    popUp "We will be updating the Solution.Xml file of your solution. Please confirm?" "User Consent"
}



