#--- Boxstarter options ---
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#--- Configure Windows ---
Disable-UAC

#--- Windows Features ---
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

#--- File Explorer Settings ---
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

Update-ExecutionPolicy Unrestricted

#Install NuGet library and mark it as trusted
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

#Install the Azure Resource Manager and SharePoint PNP Powershell modules
Install-Module AzureRM -AllowClobber
Install-Module SharePointPnPPowerShellOnline -AllowClobber

#--- Windows Subsystems/Features ---
choco install -y Microsoft-Hyper-V-All -source windowsFeatures
choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures

#--- Ubuntu ---
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx

#--- Packages ---
choco install -y cmder -pre
choco install -y hyper

#--- Git ---
choco install -y git -params '"/GitAndUnixToolsOnPath /WindowsTerminal"'
choco install -y --ignorechecksum github

#--- Visual Studio Code
choco install -y visualstudiocode
choco install -y vscode-csharpextensions
choco install -y vscode-docker

#--- Office ---
choco install -y office365business 

# --- OpenSSH ---
#Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#--- Azure ---
choco install -y azure-cli
choco install -y azurepowershell

#--- Basics ---
choco install -y powershell
choco install -y googleChrome
choco install -y firefox
choco install -y postman
choco install -y 7zip.install
choco install -y sysinternals
#choco install -y DotNet3.5

if (Test-PendingReboot) { Invoke-Reboot }

#--- Pinning Things ---
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Mozilla Firefox\firefox.exe"
Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\WindowsPowerShell\v1.0\PowerShell.exe"

#--- Update Windows ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula