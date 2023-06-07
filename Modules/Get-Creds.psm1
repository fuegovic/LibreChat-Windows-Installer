function Get-Creds {
    param (
        [string]$envfile,
        $final_dir
    )

    # Generate the key and iv using the crypto module
    Write-Host "*** Generating Secure Crypto Keys ***" -ForegroundColor Blue
    $key = node -e "'use strict';console.log(crypto.randomBytes(32).toString('hex'));"
    Write-Host "CREDS_KEY= $key"
    $iv = node -e "'use strict';console.log(crypto.randomBytes(16).toString('hex'));"
    Write-Host "CREDS_IV= $iv"
    
    # Generate a new 32-byte random string for JWT_SECRET
    $jwt_secret = node -e "'use strict';console.log(crypto.randomBytes(32).toString('hex'));"
    Write-Host "JWT_SECRET= $jwt_secret"

    # Read the existing contents of the .env file
    $content = Get-Content -Path "$envfile"

    # Replace the existing CREDS_KEY, CREDS_IV, and JWT_SECRET values with the new values
    $content = $content -replace 'CREDS_KEY=.*', "CREDS_KEY=$key"
    $content = $content -replace 'CREDS_IV=.*', "CREDS_IV=$iv"
    $content = $content -replace 'JWT_SECRET=.*', "JWT_SECRET=$jwt_secret"

    # Write the modified contents to the .env file
    Set-Content -Path "$envfile" -Value $content -Force

    # Display success message and wait for 2 seconds before clearing the screen
    Write-Host "`n"
    Write-Host "Credentials successfully stored." -ForegroundColor Green
    Start-Sleep -Seconds 2
    Clear-Host
}
