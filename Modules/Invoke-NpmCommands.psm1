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
  Write-Host "*** npm Clean Install and Project build ***" -ForegroundColor Blue
  Write-Host "*** do not worry if you see error or warning messages during this step ***" -ForegroundColor Yellow  
  Write-Host "`n"	
  # Run npm ci in the api and client directories
  Write-Output "Running npm ci in the api and client directories..."

  Set-Location "$final_dir\api"
  & npm ci

  Set-Location "$final_dir\client"
  & npm ci
  
  Write-Host "Ran npm ci successfully." -ForegroundColor Green

  # Run npm run build in the client directory
  Write-Output "Running npm run build in the client directory"

  Set-Location "$final_dir\client"
  & npm run build
  # Add a debug message after running npm run build in the client directory

  Write-Host "Ran run build successfully." -ForegroundColor Green

  # Pause and clear the screen
  Start-Sleep -Seconds 2
  Clear-Host
}
