#--- Boxstarter options ---
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#--- Configure Windows ---
Disable-UAC

# --- Gitversion ---
choco install -y gitversion.portable

#--- Node, npm
choco install -y nodejs # Node.js Current, Latest features
refreshenv
npm install -g npm-windows-upgrade

#-- Angular Development ---
#nvm install 9.5.0
#nvm use 9.5.0
#RefreshEnv.cmd
# Install Angular CLI
#npm install -g @angular/cli

#-- Docker for Windows
choco install -y docker-for-windows

#--- Visual Studio 2017 ---
choco install -y --allow-empty-checksums visualstudio2017enterprise
choco install -y --allow-empty-checksums visualstudio2017-workload-azure
choco install -y --allow-empty-checksums visualstudio2017-workload-data
choco install -y --allow-empty-checksums visualstudio2017-workload-manageddesktop
choco install -y --allow-empty-checksums visualstudio2017-workload-netcoretools
choco install -y --allow-empty-checksums visualstudio2017-workload-netweb
choco install -y --allow-empty-checksums visualstudio2017-workload-office
choco install -y --allow-empty-checksums visualstudio2017-workload-managedgame
choco install -y --allow-empty-checksums visualstudio2017-workload-nativecrossplat
choco install -y --allow-empty-checksums visualstudio2017-workload-nativedesktop
choco install -y --allow-empty-checksums visualstudio2017-workload-netcrossplat

choco install -y --allow-empty-checksums visualstudio2017-workload-node
choco install -y --allow-empty-checksums visualstudio2017-workload-universal
choco install -y --allow-empty-checksums visualstudio2017-workload-webcrossplat

#--- JetBrains Resharper 2018.1 ---
choco install -y resharper-platform

#--- SQL Server 2017 Express ---
#choco install -y sql-server-express 

#--- SQL Server 2017 Developer Edition ---
choco install -y sql-server-2017

#--- SQL Server 2017 Management Studio ---
choco install -y sql-server-management-studio

#--- SQL Operations Studio ---
choco install -y sql-operations-studio 

#--- Microsoft SQL Server Data Tools ---
choco install -y ssdt17

#--- Service Fabric Tools ---


if (Test-PendingReboot) { Invoke-Reboot }

#--- Pinning Things ---

#--- Update Windows ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
