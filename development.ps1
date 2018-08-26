#--- Boxstarter options ---
$Boxstarter.RebootOk=$false # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#--- Configure Windows ---
Disable-UAC
Set-ExplorerOptions -showFileExtensions

#--- Set up choco as a packageprovider too ---

Write-Host "Bootstrapping Chocolatey provider" -ForegroundColor Yellow
Get-PackageProvider -Name Chocolatey -ForceBootstrap | Out-Null
Write-Host "Trusting Chocolatey provider" -ForegroundColor Yellow
Set-PackageSource -Name chocolatey -Trusted -Force

#--- Host Only Configuration ---
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
#dism.exe /online /add-capability /capabilityname:Language.Basic~~~nl-NL~0.0.1.0
#dism.exe /online /add-capability /capabilityname:Tools.DeveloperMode.Core~~~~0.0.1.0
#choco install -y spotify
#choco install -y itunes

#--- Gitversion ---
choco install -y gitversion.portable

#--- Node, npm
choco install -y nodejs # Node.js Current, Latest features
choco install -y nodejs.install # Node.js Current, Latest features
refreshenv
npm install -g npm-windows-upgrade

#--- Install Apps ---
choco install -y googlechrome
choco install -y 7zip.install
choco install -y sysinternals
choco install -y visualstudiocode
choco install -y filezilla
choco install -y fiddler4
choco install -y putty.install
choco install -y firefox
choco install -y microsoft-teams
choco install -y git
choco install -y git.install
choco install -y github-desktop
choco install -y adobereader
choco install -y jre8

choco install -y vcredist2008 
choco install -y vcredist2010 
choco install -y vcredist2012
choco install -y vcredist2013 

choco install -y whatsapp

#--- Azure and MSFT Development
choco install -y powerbi
choco install -y microsoftazurestorageexplorer
choco install -y wawsdeploy
choco install -y microsoft-r-open
choco install -y armclient
choco install -y azure-cli

#-- Angular Development ---
#nvm install 9.5.0
#nvm use 9.5.0
#refreshenv
# Install Angular CLI
#npm install -g @angular/cli

#--- Visual Studio 2017 ---
choco install -y visualstudio2017enterprise --package-parameters '--allWorkloads --includeRecommended --includeOptional --passive --locale en-US' --execution-timeout=36000

#--- Docker ---
choco install -y docker --execution-timeout=36000
choco install -y docker-for-windows --execution-timeout=36000
choco install -y kubernetes-cli

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

#--- Pinning Things ---

#--- Uninstall things ---

$apps = @(
    # default Windows 10 apps
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    #"Microsoft.MicrosoftStickyNotes"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    #"Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    #"Microsoft.WindowsCamera"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    #"Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "microsoft.windowscommunicationsapps"
    "Microsoft.MinecraftUWP"
    #"Microsoft.NetworkSpeedTest"
  

    # Threshold 2 apps

    "Microsoft.Messaging"
    #"Microsoft.WindowsFeedbackHub"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingTravel"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.WindowsReadingList"

    # non-Microsoft
    "9E2F88E3.Twitter"
    "PandoraMediaInc.29680B314EFC2"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "king.com.*"
    "ClearChannelRadioDigital.iHeartRadio"
    "4DF9E0F8.Netflix"
    "6Wunderkinder.Wunderlist"
    "Drawboard.DrawboardPDF"
    "2FE3CB00.PicsArt-PhotoStudio"
    "D52A8D61.FarmVille2CountryEscape"
    "TuneIn.TuneInRadio"
    "GAMELOFTSA.Asphalt8Airborne"
    "TheNewYorkTimes.NYTCrossword"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "Facebook.Facebook"
    "flaregamesGmbH.RoyalRevolt2"
    "Playtika.CaesarsSlotsFreeCasino"
    "A278AB0D.MarchofEmpires"
    "KeeperSecurityInc.Keeper"
    "ThumbmunkeysLtd.PhototasticCollage"
    "XINGAG.XING"
    "89006A2E.AutodeskSketchBook"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "46928bounde.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
    "DolbyLaboratories.DolbyAccess"
    "SpotifyAB.SpotifyMusic"
    "A278AB0D.DisneyMagicKingdoms"
    "WinZipComputing.WinZipUniversal"
    
    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"
)

foreach ($app in $apps) {
    Write-Output "Trying to remove $app"
    Get-AppxPackage -Name $app | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online |
        Where-Object DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online
}

#--- Update Windows ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
Update-Help

#--- Reboot ---
if (Test-PendingReboot) { Invoke-Reboot } 
