<#
.SYNOPSIS
A function that installs git software if it is not already installed.

.DESCRIPTION
This function checks if Git is already installed on the system. If it is, it upgrades it to the latest version available in the winget repository. If it is not, it downloads and installs it using winget.

.EXAMPLE
Install-GitSoftware

This example installs git software if it is not already installed.

.NOTES
This function requires winget to be installed on the system.
#>

function Install-GitSoftware {
  Clear-Host
  Write-Host "*** Install and/or Update Git to the Latest Version ***" -ForegroundColor Blue
  Write-Host "`n"
  # Check if Git is already installed
  Write-Host "Checking if Git is already installed..."
  $git_command = Get-Command git -ErrorAction SilentlyContinue
  if ($git_command) {
    Write-Host "Git is already installed."
    # Get the current version of Git installed
    Write-Host "Getting the current version of Git"
    $current_version = (git --version).Trim()
    Write-Host "The current version of Git installed is $current_version." -ForegroundColor Yellow
    # Upgrade Git to the latest version available in the winget repository
    Write-Host "Upgrading Git to the latest version available..."
    winget upgrade Git.Git --accept-package-agreements  --accept-source-agreements > $null
 	Write-Host "Git upgraded successfully." -ForegroundColor Green
	
  }
  else {
    Write-Host "Git is not installed." -ForegroundColor Red
    # Download and install Git using winget
    Write-Host "Downloading and installing Git using winget..."
    winget install Git.Git --accept-package-agreements  --accept-source-agreements
    return $True # Set ExitRequired to true
	Write-Host "Git installed successfully." -ForegroundColor Green
	
  }
  # Pause and clear the screen
  Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  Clear-Host
}


