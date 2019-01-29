## Dev Workstation Configuration Script
Param (
	[string]$repoUri
)

## Clone Repo
mkdir 'c:\Source'
cd 'c:\Source'
git clone $repoUri

## Build and Package App
$vs_path = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise"
if (!(Test-Path $vs_path)) {
	$vs_path = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community"
}

#Set Path Variables for build
$env:Path += ";$vs_path\VC\Tools\MSVC\14.12.25827\bin\HostX86\x86"
$env:Path += ";$vs_path\Common7\IDE\VC\VCPackages"
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\TypeScript\2.5"
$env:Path += ";$vs_path\Common7\IDE\CommonExtensions\Microsoft\TestWindow"
$env:Path += ";$vs_path\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer"
$env:Path += ";$vs_path\MSBuild\15.0\bin\Roslyn"
$env:Path += ";$vs_path\Team Tools\Performance Tools"
$env:Path += ";C:\Program Files (x86)\Microsoft Visual Studio\Shared\Common\VSPerfCollectionTools\"
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\"
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0\"
$env:Path += ";C:\Program Files (x86)\Windows Kits\10\bin\x86"
$env:Path += ";C:\Program Files (x86)\Windows Kits\10\bin\10.0.16299.0\x86"
$env:Path += ";$vs_path\\MSBuild\15.0\bin"
$env:Path += ";C:\Windows\Microsoft.NET\Framework\v4.0.30319"
$env:Path += ";$vs_path\Common7\IDE\"
$env:Path += ";$vs_path\Common7\Tools\"
$env:Path += ";C:\Program Files\Microsoft MPI\Bin\;C:\Windows\system32;C:\Windows"
$env:Path += ";C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\"
$env:Path += ";C:\Program Files\dotnet\"
$env:Path += ";C:\Program Files\Microsoft SQL Server\130\Tools\Binn\"
$env:Path += ";C:\Program Files\Git\cmd"

## Install Chocolatey and packages
Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 

## Add startup bat to install additional packages on sign in
$choco_exe = "C:\ProgramData\chocolatey\bin\choco.exe"

$install_packages_bat = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\install_packages.bat"

#if (!(Test-Path $install_packages_bat)) {
#	Set-Content -Path $install_packages_bat -Value "$choco_exe install postman googlechrome -y"
#}

$dockerPath = "$env:ProgramFiles\docker"
if (!(Test-Path $dockerPath)) {
	Set-Content -Path dockerPath -Value "$choco_exe install docker-desktop -y"
}

<#
if (!(Test-Path $dockerPath)) {

	$wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
	$wshell.Popup("Installing Hyper-V & Docker",0,"Note",0)

	# Install Hyper-V
	Install-WindowsFeature -Name Hyper-V -ComputerName $Env:COMPUTERNAME -IncludeManagementTools  

	# Install Docker Modules
	Install-Module DockerMsftProvider -Force
	Install-Package Docker -ProviderName DockerMsftProvider -Force

	# Optionally, modify PATH to persist across sessions.
	$newPath = "$env:ProgramFiles\docker;" +
	[Environment]::GetEnvironmentVariable("PATH",
	[EnvironmentVariableTarget]::Machine)

	[Environment]::SetEnvironmentVariable("PATH", $newPath,
	[EnvironmentVariableTarget]::Machine)

	$wshell.Popup("Now Rebooting",0,"Note",0)
	Restart-Computer
}
#>