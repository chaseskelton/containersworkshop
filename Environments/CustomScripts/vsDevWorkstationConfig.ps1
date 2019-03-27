## Dev Workstation Configuration Script
Param (
	[string]$repoUri
)

# Install Nuget, needed to install DSC modules via PowerShellGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

## Clone Repo
mkdir 'c:\Source'
Set-Location 'c:\Source'
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


# Install Chocolatey and packages
Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 

#  Add startup bat to install additional packages on sign in
$choco_exe = "C:\ProgramData\chocolatey\bin\choco.exe"

# Install Hyper-V
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

# Loading Docker Desktop prior to login so user isn't asked to logout and login to use
C:\ProgramData\chocolatey\bin\choco.exe install docker-desktop -y

##NOTE: some items you can install without a user session.... moving to user session so can easily reinstall if there is an issue
# C:\ProgramData\chocolatey\bin\choco.exe install docker-desktop -y
# C:\ProgramData\chocolatey\bin\choco.exe install azure-cli -y
# C:\ProgramData\chocolatey\bin\choco.exe install kubernetes-cli -y
# C:\ProgramData\chocolatey\bin\choco.exe install kubernetes-helm -y

$install_packages_bat = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\install_packages.bat"
$Move_bat_to = "C:\Users\Public\Desktop\Setup_Tools.bat"

##Build script file to install tools and launch Docker Desktop
if (!(Test-Path $install_packages_bat)) {
	Set-Content -Path $install_packages_bat -Value "$choco_exe install postman -y"
	Add-Content -Path $install_packages_bat -Value "$choco_exe install googlechrome -y"
	# Add-Content -Path $install_packages_bat -Value "$choco_exe install docker-desktop -y"
	Add-Content -path $install_packages_bat -Value "$choco_exe install azure-cli -y"
	Add-Content -path $install_packages_bat -Value "$choco_exe install kubernetes-cli -y"
	Add-Content -path $install_packages_bat -Value "$choco_exe install kubernetes-helm -y"
	Add-Content -Path $install_packages_bat -Value "$choco_exe install vscode -y"
	Add-Content -Path $install_packages_bat -Value "powershell.exe -Command code --install-extension PeterJausovec.vscode-docker --force"
	Add-Content -Path $install_packages_bat -Value "powershell.exe -Command code --install-extension ms-kubernetes-tools.vscode-kubernetestools --force"
	Add-Content -Path $install_packages_bat -Value "powershell.exe -Command code --install-extension ms-vscode.vscode-node-azure-pack --force"

	Add-Content -Path $install_packages_bat -Value "powershell.exe start-process 'C:\Program Files\Docker\Docker\Docker for Windows.exe'"

	Add-Content -Path $install_packages_bat -Value "powershell.exe move-item -path '$install_packages_bat' -destination '$move_bat_to'"

	Add-Content -Path $install_packages_bat -Value  "set /p Dummy=Hit ENTER to exit... Script placed on desktop in case you need to rerun"

	Add-Content -Path $install_packages_bat -Value "exit"
}

# install user into docker user group
net localgroup docker-users sysadmin /add

Restart-Computer
