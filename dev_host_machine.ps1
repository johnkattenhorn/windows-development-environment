#--- Boxstarter options ---
$Boxstarter.RebootOk=$false # Allow reboots?
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
choco install -y github
choco install -y gitversion.portable

#--- Node, npm
choco install -y nodejs # Node.js Current, Latest features
#npm install -g npm-windows-upgrade

#--- Visual Studio Code
choco install -y visualstudiocode
choco install -y vscode-csharpextensions
choco install -y vscode-docker

#--- Office ---
choco install -y office365business 

#--- Visual Studio 2017 ---
choco install -y visualstudio2017enterprise --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
if (Test-PendingReboot) { Invoke-Reboot }

#--- JetBrains Resharper 2018.1 ---
choco install -y resharper-platform

#--- SQL Server 2017 Express ---
#choco install -y sql-server-express 

#--- SQL Server 2017 Developer Edition ---
choco install -y sql-server-2017

#--- SQL Server 2017 Management Studio ---
choco install -y sql-server-management-studio

#--- Microsoft SQL Server Data Tools ---
choco install -y ssdt17

# --- OpenSSH ---
#Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#--- Azure ---
choco install -y azure-cli

#--- Basics ---
choco install -y GoogleChrome
choco install -y firefox
choco install -y 7zip.install
choco install -y sysinternals
choco install -y DotNet3.5

if (Test-PendingReboot) { Invoke-Reboot }

#--- Pinning Things ---
Install-ChocolateyPinnedTaskBarItem "$env:programfiles\Google\Chrome\Application\chrome.exe"

#--- Update Windows ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula