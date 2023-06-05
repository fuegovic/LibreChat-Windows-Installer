<# 
This script automates the local installation of LibreChat for Windows. 

LibreChat is a web app that lets you use ChatGPT and Bing with custom parameters.
The Github link is https://github.com/danny-avila/LibreChat

You can provide a config.json file with the following keys:
MONGO_URI: The connection string for MongoDB
OPENAI_KEY: The API key for OpenAI
BINGAI_TOKEN: The access token for Bing

Alternatively, you can pass the same values as named parameters when running the script.
For example: .\main.ps1 -mongo_uri "mongodb://localhost:27017" -openai_key "sk-123456789" -bingai_token "abcdefg"

The use of either the config file or the parameters is optional.

This script was made by Fuegovic (https://github.com/fuegovic), a amateur developer and a musician/producer. You can check out his music on Bandcamp (https://fuegovic.bandcamp.com) or Spotify (https://open.spotify.com/artist/3ZfaxdODbE1NrfQYsGO92R)
#>
# Init
# Define the parameters
Param (
  [switch]$Debug,
  [string]$mongo_uri,
  [string]$openai_key
)

# Clear all Variables, Modules, and the console window
Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; 
$error.Clear(); 
Clear-Host

if ($Debug) {
  # Enable debug output for this module
  $DebugPreference = 'Continue'
}

# Get the current location and assign it to a variable
$original_location = Get-Location

# Start Parameters Check
# Check if the user provided all the parameters or some of them or none of them
if ($PSBoundParameters.Count -eq 3) {
  # Use all the parameters
} elseif ($PSBoundParameters.Count -gt 0) {
  
  # Use some of the parameters and ask for the rest
  if ($PSBoundParameters.ContainsKey("mongo_uri")) {
  }
  if ($PSBoundParameters.ContainsKey("openai_key")) {
  }
  if ($PSBoundParameters.ContainsKey("bingai_token")) {
  }
}

# Import all the modules
Import-Module .\Modules\Show-InstallationIntroduction.psm1
Import-Module .\Modules\Get-IniContent.psm1
Import-Module .\Modules\Get-InstallDirectory.psm1
Import-Module .\Modules\Install-GitSoftware.psm1
Import-Module .\Modules\Copy-GitRepository.psm1
Import-Module .\Modules\Install-NodeJS.psm1
Import-Module .\Modules\New-EnvironmentFile.psm1
Import-Module .\Modules\Install-MeiliSearch.psm1
Import-Module .\Modules\Get-MongoURI.psm1
Import-Module .\Modules\Get-OpenAIAPIKey.psm1
Import-Module .\Modules\Get-Creds.psm1
Import-Module .\Modules\Install-Ngrok.psm1
Import-Module .\Modules\Invoke-NpmCommands.psm1
Import-Module .\Modules\Copy-TemplateBatFile.psm1
Import-Module .\Modules\Show-InstallationConclusion.psm1

# Check if there is a config.ini file and read it
if (Test-Path .\config.ini) {
  $config = Get-IniContent -Path .\config.ini
  # Check if the parameters are missing or invalid and use the values from the config file
  if (-not $PSBoundParameters.ContainsKey("mongo_uri") -or -not $mongo_uri) {
    $mongo_uri = $config.Database.mongo_uri
  }
  if (-not $PSBoundParameters.ContainsKey("openai_key") -or -not $openai_key) {
    $openai_key = $config.API.openai_key
  }
  if (-not $PSBoundParameters.ContainsKey("bingai_token") -or -not $bingai_token) {
    $bingai_token = $config.API.bingai_token
  }
}

# Show Intro
Show-InstallationIntroduction

# Install requirements (Git and Node.js)
# Install Git
$gitExitRequired = [bool] (Install-GitSoftware)

# Install Node.js
$nodeExitRequired = [bool] (Install-NodeJS)


if ($gitExitRequired -or $nodeExitRequired -eq $true){
  Write-Host "Some requirements have just been installed, you will have to restart the install for them to take effects."  -ForegroundColor Red
  Write-Host "Please press any key to exit..." -ForegroundColor Red
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')	
  Exit
}

$InformationPreference = 'Continue'

# Install Directory, Copy Repository, Create .env File
# Run Get-InstallDirectory
$final_dir = Get-InstallDirectory

# Run Copy-GitRepository with the final directory as an argument
Copy-GitRepository $final_dir

# Create a New .env File
$template = "$final_dir\.env.example"
$envfile = "$final_dir\.env"
Invoke-Command -ScriptBlock {New-EnvironmentFile $template $envfile $openai_key $bingai_token $mongo_uri}

# Soft Requirements (MeiliSearch and ngrok)
# Downloading Meilisearch
Install-MeiliSearch -final_dir $final_dir -envfile $envfile

# Run Install-Ngrok
Install-Ngrok $final_dir 

# Instruction for MongoDB, OpenAI, Bing and ngrok
# If the mongo_uri parameter is missing or invalid, run Get-MongoURI
if (-not $mongo_uri) {
  Get-MongoURI $envfile $final_dir
}

# If the openai_key parameter is missing or invalid, run Get-OpenAIAPIKey
if (-not $openai_key) {
  Get-OpenAIAPIKey $envfile $final_dir
}

# Set Cred and Cred IV in the env file
Get-Creds $envfile $final_dir

# Run Get-IniContent
Import-Module .\Modules\Get-IniContent.psm1

# Build Project, Create .bat File, Conclusion
# Run Invoke-NpmCommands
Invoke-NpmCommands $final_dir

# Run Copy-TemplateBatFile

$shortcutLocation = Copy-TemplateBatFile $original_location $final_dir $envfile

# Run Show-InstallationConclusion
Show-InstallationConclusion $final_dir $shortcutLocation

# Clean Up and Exit
# Clear all Variables, Modules, and the console window
Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; 
$error.Clear(); 
Clear-Host

# Exit the script with a success code
Exit 0
