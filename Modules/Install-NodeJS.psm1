<#
.SYNOPSIS
Installs or upgrades Node.js using winget.

.DESCRIPTION
This function checks if Node.js is already installed on the system. If it is, it upgrades it to the latest version available in the winget repository. If it is not, it downloads and installs it using winget.

.EXAMPLE
Install-NodeJS

This example installs or upgrades Node.js using winget.

.NOTES
This function requires winget to be installed on the system.


#>


# Define the function
function Install-NodeJS {
  Write-Host "*** Install and/or Update Node.js to the Latest Version ***" -ForegroundColor Blue
  Write-Host "`n"
  Write-Host "Checking if Node.js is already installed..."
  if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Node.js is already installed."
    # Get the current version of Node.js installed
    Write-Host "Getting the current version of Node.js"
    $current_version = node -v
    Write-Host "The current version of Node.js installed is $current_version." -ForegroundColor Yellow
    # Upgrade Node.js to the latest version available in the winget repository
    Write-Host "Upgrading Node.js to the latest version available..."
    winget upgrade OpenJS.NodeJS --accept-package-agreements  --accept-source-agreements > $null
   	Write-Host "Done!" -ForegroundColor Green
  }
  else {
    Write-Host "Node.js is not installed." -ForegroundColor Red
    # Download and install Node.js using winget
    Write-Host "Downloading and installing Node.js using winget..."
    winget install OpenJS.NodeJS --accept-package-agreements  --accept-source-agreements
    Write-Host "Done!" -ForegroundColor Green
	return $True # Set ExitRequired to true
  }

  # Pause and clear the screen
  Start-Sleep -Seconds 2
  Clear-Host
}

