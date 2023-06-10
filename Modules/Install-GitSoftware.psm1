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
 	Write-Host "Done!" -ForegroundColor Green
	
  }
  else {
    Write-Host "Git is not installed." -ForegroundColor Red
    # Download and install Git using winget
    Write-Host "Downloading and installing Git using winget..."
    winget install Git.Git --accept-package-agreements  --accept-source-agreements
    return $True # Set ExitRequired to true
	Write-Host "Done!" -ForegroundColor Green
	
  }
  # Pause and clear the screen
  Start-Sleep -Seconds 2
  Clear-Host
}


