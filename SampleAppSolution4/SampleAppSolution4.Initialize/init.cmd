@echo off

@echo.
echo Configuring your XRM Solutions development machine..
==========================================================

@echo.
echo Setting workspace variable..
==========================================================

if not defined DevAgentTag (
	REM set default value of development agent tag
	set DevAgentTag=true
	echo Development agent tag is not defined - defaulting to true..
)

if not defined TestAgentTag (
	REM set default value of development agent tag
	set TestAgentTag=true
	echo Test agent tag is not defined - defaulting to true..
)




if not defined AltWSRoot (
	REM set default value of alternate workspace root
	set AltWSRoot=
	echo Alternate workspace is not defined..
)

if [%AltWSRoot%]==[] (
	REM configure when there is no alternative workspace root
	set AltWSRoot=%1
)
REM display the value of the workspace root
echo AltWSRoot is %AltWSRoot%


if not defined SolutionPath (
	set SolutionPath=
)

if [%SolutionPath%]==[] (
	set SolutionPath=%1
)
REM display the value of the workspace root
echo SolutionPath is %SolutionPath%

if not defined SolutionName (
	set SolutionName=
)

if [%SolutionName%]==[] (
	set SolutionName=%2
)
echo SolutionName is %SolutionName%

if not defined BuildProjectName (
	set BuildProjectName=
)

if [%BuildProjectName%]==[] (
	set BuildProjectName=%SolutionName%.Initialize
)
echo BuildProjectName is %BuildProjectName%

set BuildProjectRoot=%SolutionPath%%SolutionName%\%BuildProjectName%
echo BuildProjectRoot is %BuildProjectRoot%

set PSScriptRoot=%BuildProjectRoot%
echo PSScriptRoot is %PSScriptRoot%

if not defined WebResourceProjectName (
	set WebResourceProjectName=
)

if [%WebResourceProjectName%]==[] (
	set WebResourceProjectName=%SolutionName%.WebResources
)
echo WebResourceProjectName is %WebResourceProjectName%



echo "Updating solution xml"
powershell -ExecutionPolicy Bypass -Command %BuildProjectRoot%\scripts\init\updateSolutionXml.ps1 %SolutionPath% %SolutionName% 


set XrmSolutionsRoot=%AltWSRoot%
echo XrmSolutionsRoot is %XrmSolutionsRoot%

set WSRoot=%XrmSolutionsRoot%
echo WSRoot is %WSRoot%

set SolutionPackagerRoot=%SolutionPath%%SolutionName%\%BuildProjectName%\Tools\CoreTools
echo SolutionPackagerRoot is %SolutionPackagerRoot%
echo SolutionPackagerRoot is %3

@echo.
echo Restoring nuget packages..
==========================================================

set PATH=%PATH%;%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\;%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\;%ProgramFiles%\Git\usr\bin;%ProgramFiles(x86)%\MSBuild\14.0\Bin\;
powershell -ExecutionPolicy Bypass -Command %BuildProjectRoot%\init.ps1
set PATH=%BuildProjectRoot%\.tools;%BuildProjectRoot%\.tools\VSS.NuGet.AuthHelper;%PATH%

@REM echo Package directory is: %WSRoot%\packages
@REM nuget restore %WSRoot%\build\config\packages.config -ConfigFile %WSRoot%\build\config\nuget.config -PackagesDirectory %WSRoot%\packages

echo Restoring sln nuget packages..
nuget restore %SolutionPath%%SolutionName%.sln


@echo.
echo Restoring NPM packages
powershell -noprofile -ExecutionPolicy Bypass -Command %BuildProjectRoot%\npm.ps1

@echo.
echo Setting user variables..
==========================================================

@REM REM Set environment variables for package PKG_XRMAPP_TOOLS
@REM set "getPackage=%WSRoot%\build\agent\AgentUtilities.exe /command:getpkgfolder /config:%WSRoot%\build\config\packages.config /packageroot:%WSRoot%\packages /package:PKG_XRMAPP_TOOLS"
@REM for /f "tokens=*" %%a in ('%getPackage%') do (set PKG_XRMAPP_TOOLS=%%a)
@REM powershell -ExecutionPolicy Bypass -Command "%PKG_XRMAPP_TOOLS%\build\agent\agent_setProcessVariable.ps1 PKG_XRMAPP_TOOLS %PKG_XRMAPP_TOOLS%
@REM echo PKG_XRMAPP_TOOLS is: %PKG_XRMAPP_TOOLS%


REM Restore build variables from available artifacts if they exist
echo TestAgentTag is %TestAgentTag%
echo BuildVariables path is %BuildProjectRoot%\target\buildVariables.txt

@REM if [%TestAgentTag%] == [true] if exist %WSRoot%\target\buildVariables.txt (
@REM 	echo Enabling existing build variables..
	
@REM 	for /f %%a in (%WSRoot%\target\buildVariables.txt) do (
@REM 		set "%%a"
@REM 		echo %%a has been set
		
@REM 		for /f "delims== tokens=1,2" %%G IN ("%%a") do echo powershell -ExecutionPolicy Bypass -Command "%PKG_XRMAPP_TOOLS%\build\agent\agent_setProcessVariable.ps1 %%G %%H
@REM 	)
@REM )


@echo.
REM Set Build Configuration environment variable
set BuildConfigurationDefault=debug
if not [%1] == [] (
	set BuildConfiguration=%1
)

if not defined BuildConfiguration (
	set BuildConfiguration=%BuildConfigurationDefault%
)

if [%BuildConfiguration%]==[] (
	set BuildConfiguration=%BuildConfigurationDefault%
)

echo BuildConfiguration=%BuildConfiguration%

REM Set Build Platform environment variable
set BuildPlatformDefault=amd64
if not [%2] == [] (
	set BuildPlatform=%2
)

if not defined BuildPlatform (
	set BuildPlatform=%BuildPlatformDefault%
)

if [%BuildPlatform%]==[] (
	set BuildPlatform=%BuildPlatformDefault%
)

echo BuildPlatform=%BuildPlatform%

REM Set DropInConfigurationFolder
set DropInConfigurationFolderDefault=true

if not defined DropInConfigurationFolder (
	set DropInConfigurationFolder=%DropInConfigurationFolderDefault%
)

if ("%DropInConfigurationFolder%"=="") (
	set DropInConfigurationFolder=%DropInConfigurationFolderDefault%
)

echo DropInConfigurationFolder=%DropInConfigurationFolderDefault%

@REM REM Set environment variables for remainder of packages
@REM mkdir %WSRoot%\target\%BuildConfiguration%\%BuildPlatform%
@REM %PKG_XRMAPP_TOOLS%\build\agent\AgentUtilities.exe /command:listpkgvars /config:%WSRoot%\build\config\packages.config /output:%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\processVariables.txt /packageroot:%WSRoot%\packages
@REM for /f %%a in (%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\processVariables.txt) do (
@REM 	set "%%a"
@REM 	echo %%a has been set
@REM )

@REM REM Set environment variables for remainder of packages
@REM mkdir %WSRoot%\target\%BuildConfiguration%\%BuildPlatform%
@REM %PKG_XRMAPP_TOOLS%\build\agent\AgentUtilities.exe /command:listpkgvars /config:%WSRoot%\solutions\CIFramework\Microsoft.OmniChannel.Test\packages.config /output:%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\OCEnvVariables.txt /packageroot:%WSRoot%\packages
@REM for /f %%a in (%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\OCEnvVariables.txt) do (
@REM 	set "%%a"
@REM 	echo %%a has been set
@REM )

@REM REM Set environment variables for remainder of packages
@REM mkdir %WSRoot%\target\%BuildConfiguration%\%BuildPlatform%
@REM %PKG_XRMAPP_TOOLS%\build\agent\AgentUtilities.exe /command:listpkgvars /config:%WSRoot%\solutions\CIFramework\CRM.Solutions.ChannelApiFramework.Test\packages.config /output:%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\channelApiVariables.txt /packageroot:%WSRoot%\packages
@REM for /f %%a in (%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\channelApiVariables.txt) do (
@REM 	set "%%a"
@REM 	echo %%a has been set
@REM )

REM Set Build Architecture environment variable
if [%BuildPlatform%] == [amd64] (
	set XSBuildArchitecture=x64
)

if not [%BuildPlatform%] == [amd64] (
	set XSBuildArchitecture=x86
)

echo XSBuildArchitecture is %XSBuildArchitecture%

@REM powershell -ExecutionPolicy Bypass -Command "%PKG_XRMAPP_TOOLS%\build\agent\agent_setProcessVariable.ps1 XSBuildArchitecture %XSBuildArchitecture%"


@REM REM Set EnableSigning environment variable
@REM if [%DevAgentTag%] == [true] (
@REM 	set EnableSigning=false
@REM 	if "%BuildConfiguration%"=="debug" if "%SignDebugBuilds%"=="true" (
@REM 			set EnableSigning=true
@REM 			powershell -ExecutionPolicy Bypass -Command "%PKG_XRMAPP_TOOLS%\build\agent\agent_setProcessVariable.ps1 EnableSigning true"
@REM 	)
@REM )

@REM if [%DevAgentTag%] == [true] if [%BuildConfiguration%]==[retail] if [%SignRetailBuilds%]==[true] (
@REM 		set EnableSigning=true
@REM 		powershell -ExecutionPolicy Bypass -Command "%PKG_XRMAPP_TOOLS%\build\agent\agent_setProcessVariable.ps1 EnableSigning true"
@REM )

echo Assembly signing is: %EnableSigning%


@REM :initializeEnvironmentPath
@REM @echo.
@REM echo Initializing environment path variable..
@REM ==========================================================

@REM :printExistingPath
@REM set listPath=%PATH%
@REM set listItemCount=0
@REM @echo.
@REM echo List of existing PATH entries:

@REM :nextExistingPathItem
@REM if "%listPath%" == "" (
@REM 	echo Existing PATH entries count: %listItemCount%
@REM 	goto setNewPath
@REM )

@REM set /a listItemCount+=1
@REM for /f "tokens=1* delims=;" %%a in ("%listPath%") do (
@REM 	echo %%a
@REM 	set "listPath=%%b"
@REM )
@REM goto nextExistingPathItem
	
@REM :setNewPath
@REM set "getCleanedPathCommand=powershell -ExecutionPolicy Unrestricted -Command "%PKG_XRMAPP_TOOLS%\build\agent\AgentUtilities.exe /command:cleanpath /path:'%PATH%' /excludefile:%WSRoot%\build\config\pathExclude.txt""
@REM for /f "delims=" %%I in ('%getCleanedPathCommand%') do set "PATH=%%I;%PKG_XRMAPP_TOOLS%\tools\commands;%PKG_XRMAPP_TOOLS%\tools\ImportSolution"
@REM set getCleanedPathCommand=

@REM :printNewPath
@REM set listPath=%PATH%
@REM set listItemCount=0
@REM @echo.
@REM echo List of new PATH entries:

@REM :nextNewPathItem
@REM if "%listPath%" == "" (
@REM 	echo New PATH entries count: %listItemCount%
@REM 	goto initializeTAConfig
@REM )

@REM set /a listItemCount+=1
@REM for /f "tokens=1* delims=;" %%a in ("%listPath%") do (
@REM 	echo %%a
@REM 	set "listPath=%%b"
@REM )
@REM goto nextNewPathItem


@REM :initializeTAConfig
@REM @echo.
@REM echo Initializing test agent configuration..
@REM ==========================================================

@REM set config_path=%WSRoot%\target\%BuildConfiguration%\%BuildPlatform%\TAConfig.config
@REM echo CONFIG_PATH=%config_path%


:initializeBuildCommand
@echo.
echo Initializing build command..
==========================================================

doskey root=cd %WSRoot%
doskey build=msbuild $*

@echo.
echo Generating environment configuration..
==========================================================

set buildVariables=%WSRoot%\target\buildVariables.txt
if exist %buildVariables% (
	del %buildVariables%
)

@REM if [%DevAgentTag%] == [true] (
@REM 	%PKG_XRMAPP_TOOLS%\tools\GenerateEnvironmentConfiguration\GenerateEnvironmentConfiguration.exe %WSRoot% %WSRoot%\build\include %BuildConfiguration% %BuildPlatform%
	
@REM 	echo Flushing build variables for post build operations..
@REM 	echo BuildConfiguration=%BuildConfiguration% >> %buildVariables%
@REM 	echo BuildPlatform=%BuildPlatform% >> %buildVariables%
@REM )

@REM ==========================================================

@REM echo Checking For node js
@REM ==================================================
@REM powershell -ExecutionPolicy Bypass -Command %WSRoot%\scripts\init\Initialize-DownloadNodejs.ps1 %WSRoot%

:eof

echo WSRoot is %WSRoot%
echo XrmSolutionsRoot is %XrmSolutionsRoot%
echo PKG_XRMAPP_TOOLS is %PKG_XRMAPP_TOOLS%
echo SolutionPackagerRoot is %SolutionPackagerRoot%

echo Done!
@echo on