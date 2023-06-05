function Get-Creds {
    param (
        [string]$envfile,
        $final_dir
    )

    
    Write-Host "*** Generating Secure Crypto Keys ***" -ForegroundColor Blue    # Generate the key and iv using the crypto module
    $key = node -e "'use strict';console.log(crypto.randomBytes(32).toString('hex'));"
    Write-Host "key = $key"
    $iv = node -e "'use strict';console.log(crypto.randomBytes(16).toString('hex'));"
    Write-Host "iv = $iv"

    $envfile = "$final_dir\api\.env"
    Write-Host "$envfile"
    pause
    
    # Read the existing contents of the .env file
    $content = Get-Content -Path "$envfile"
    # Replace the existing CREDS_KEY and CREDS_IV values with the new values
    $content = $content -replace 'CREDS_KEY=.*', "CREDS_KEY=$key"
    $content = $content -replace 'CREDS_IV=.*', "CREDS_IV=$iv"
    pause
    # Write the modified contents to the .env file
    Set-Content -Path "$envfile" -Value $content -Force
    pause
    # Display success message and wait for 2 seconds before clearing the screen
    Write-Host "`n"
    Write-Host "Credentials successfully stored." -ForegroundColor Green
    Start-Sleep -Seconds 2
    Clear-Host
}
