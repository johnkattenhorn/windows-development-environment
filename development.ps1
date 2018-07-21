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
#refreshenv
# Install Angular CLI
#npm install -g @angular/cli

#--- Visual Studio 2017 ---
choco install -y visualstudio2017enterprise --package-parameters '--allWorkloads --includeRecommended --includeOptional --passive' --execution-timeout=36000

#--- Docker ---
choco install -y docker --execution-timeout=36000
choco install -y docker-for-windows --execution-timeout=36000

# K8
choco install -y minikube --execution-timeout=36000

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

if (Test-PendingReboot) { Invoke-Reboot }

#--- Pinning Things ---

#--- Update Windows ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
