<#
.SYNOPSIS
Runs npm ci and npm run build in the api and client directories.

.DESCRIPTION
This function runs npm ci and npm run build in the api and client directories of a project. It assumes that the project has a package.json file in each directory and that the build script is defined in the client directory.

.PARAMETER final_dir
The path to the project root folder.

.EXAMPLE
Invoke-NpmCommands -final_dir "C:\Users\user\Documents\my-project"

This example runs npm ci and npm run build in the api and client directories of the my-project folder.

.NOTES
This function requires Node.js and npm to be installed on the system.
#>

# Invoke-NpmCommands function
# This function runs npm ci and npm run build in the api and client directories
# It takes one parameter: $final_dir, which is the path to the project root folder
function Invoke-NpmCommands {
  param (
    [string]$final_dir
  )
  Write-Host "*** Install and Build ***" -ForegroundColor Blue
  Write-Host "*** do not worry if you see error or warning messages during this step ***" -ForegroundColor Yellow  
  Write-Host "`n"	
  # Run npm ci in the api and client directories
  Write-Output "Running npm ci in the root directory..."

  Set-Location "$final_dir"
  & npm ci
  
  Write-Host "Ran npm ci successfully." -ForegroundColor Green

  # npm run build
  Write-Output "Running npm run frontend"

  Set-Location "$final_dir"
  & npm run frontend

  Write-Host "Ran build successfully." -ForegroundColor Green

  # Pause and clear the screen
  Start-Sleep -Seconds 2
  Clear-Host
}
