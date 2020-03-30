#--- Boxstarter options ---
$Boxstarter.RebootOk=$false # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#--- Configure Windows ---
Disable-UAC
#Set-ExplorerOptions -showFileExtensions

#--- Windows Features ---
#Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

Update-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

#--- Install NuGet library and mark it as trusted ---
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

#--- Set up choco as a packageprovider too ---
Write-Host "Bootstrapping Chocolatey provider" -ForegroundColor Yellow
Get-PackageProvider -Name Chocolatey -ForceBootstrap | Out-Null
Write-Host "Trusting Chocolatey provider" -ForegroundColor Yellow
Set-PackageSource -Name chocolatey -Trusted -Force

#--- Host Only Configuration ---
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
dism.exe /online /add-capability /capabilityname:Language.Basic~~~nl-NL~0.0.1.0
dism.exe /online /add-capability /capabilityname:Tools.DeveloperMode.Core~~~~0.0.1.0

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

#--- Ubuntu ---
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx

RefreshEnv
Ubuntu1804 install --root
Ubuntu1804 run apt update
Ubuntu1804 run apt upgrade -y

write-host "Installing tools inside the WSL distro..."
Ubuntu1804 run apt install python2.7 python-pip -y 
Ubuntu1804 run apt install python-numpy python-scipy -y
Ubuntu1804 run pip install pandas

write-host "Finished installing tools inside the WSL distro"

# Make `refreshenv` available right away, by defining the $env:ChocolateyInstall variable
# and importing the Chocolatey profile module.
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# refreshenv is now an alias for Update-SessionEnvironment
# (rather than invoking refreshenv.cmd, the *batch file* for use with cmd.exe)
refreshenv

#--- Node ---
choco install -y nodejs # Node.js Current, Latest features
refreshenv

#--- NPM ---
npm install -g npm-windows-upgrade
npm-windows-upgrade --npm-version latest

#--- Browsers ---
#choco install -y googlechrome
choco install -y firefox
choco install -y microsoft-edge

#-- Common Dev Tools
choco install -y vscode
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y python
choco install -y 7zip.install
choco install -y sysinternals
choco install -y microsoft-windows-terminal
choco install -y filezilla
choco install -y fiddler
choco install -y putty.install
choco install -y github-desktop
choco install -y jre8
choco install -y postman
choco install -y gitversion.portable

#--- Install Apps ---
#choco install -y microsoft-teams
choco install -y powerbi --ignore-checksums
#choco install -y adobereader

#--- Azure and MSFT Development

choco install -y wawsdeploy
choco install -y microsoft-r-open
choco install -y armclient
choco install -y powershell-core
choco install -y azure-cli
Install-Module -Force Az
Install-Module -Force AzureRM -AllowClobber
choco install -y microsoftazurestorageexplorer
choco install -y terraform

# Install tools in WSL instance
write-host "Installing tools inside the WSL distro..."
Ubuntu1804 run apt install ansible -y
write-host "Finished installing tools inside the WSL distro"

#--- Angular Development ---
choco install -y nvm
refreshenv

nvm install 10.13.0
nvm use 10.13.0
refreshenv

#--- Install Angular CLI ---
npm install -g @angular/cli

#--- Visual Studio 2019 ---
choco install -y visualstudio2019enterprise --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US" --execution-timeout 36500

refreshenv

#--- Web Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge
choco install -y python

#--- Microsoft WebDriver ---
choco install -y microsoftwebdriver

#--- Docker ---
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
refreshenv
choco install -y docker-for-windows
choco install -y vscode-docker

# K8
choco install -y minikube
choco install -y kubernetes-cli

#--- JetBrains Resharper 2018.1 ---
#choco install -y resharper-ultimate-all

#--- SQL Server 2017 Express ---
#choco install -y sql-server-express 

#--- SQL Server 2017 Developer Edition ---
choco install -y sql-server-2017 --execution-timeout 36500

#--- SQL Server 2017 Management Studio ---
choco install -y sql-server-management-studio

#--- SQL Operations Studio ---
choco install -y sql-operations-studio 

#--- Microsoft SQL Server Data Tools ---
choco install -y ssdt17

#--- Pinning Things ---

#--- Uninstall unnecessary applications that come with Windows out of the box ---
Write-Host "Uninstall some applications that come with Windows out of the box" -ForegroundColor "Yellow"

#Referenced to build script
# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

function removeApp {
	Param ([string]$appName)
	Write-Output "Trying to remove $appName"
	Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where DisplayName -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
	"Microsoft.BingFinance"
	"Microsoft.3DBuilder"
	"Microsoft.BingFinance"
	"Microsoft.BingNews"
	"Microsoft.BingSports"
	"Microsoft.BingWeather"
	"Microsoft.CommsPhone"
	"Microsoft.Getstarted"
	"Microsoft.WindowsMaps"
	"*MarchofEmpires*"
	"Microsoft.GetHelp"
	"Microsoft.Messaging"
	"*Minecraft*"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.OneConnect"
	"Microsoft.WindowsPhone"
	"Microsoft.WindowsSoundRecorder"
	"*Solitaire*"
	"Microsoft.XboxApp"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"Microsoft.NetworkSpeedTest"
	"Microsoft.FreshPaint"
	"Microsoft.Print3D"
	"*Autodesk*"
	"*BubbleWitch*"
    "king.com*"
    "G5*"
	"*Keeper*"
	"*Plex*"
	"*.Duolingo-LearnLanguagesforFree"
	"*.EclipseManager"
	"ActiproSoftwareLLC.562882FEEB491" # Code Writer
	"*.AdobePhotoshopExpress"
);

#foreach ($app in $applicationList) {
#    removeApp $app
#}

#--- Update Windows ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
Update-Help

#--- Reboot ---
if (Test-PendingReboot) { Invoke-Reboot } 
