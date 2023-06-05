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
