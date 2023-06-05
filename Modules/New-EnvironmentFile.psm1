<#
.SYNOPSIS
Creates a .env file based on a template and parameters.

.DESCRIPTION
This function creates a .env file based on a template file and parameters that are passed to the function. It replaces the placeholders in the template file with the actual values of the parameters. The parameters are OpenAIKey, BingToken, and mongoUri.

.PARAMETER 
template
The path to the template file.

envfile
The path to the .env file.

OpenAIKey
The OpenAI API key.

BingToken
The Bing access token.

mongoUri
The MongoDB connection string.

.EXAMPLE
New-EnvironmentFile -template ".\template.env" -envfile ".\.env" -OpenAIKey "sk-1234567890" -BingAIToken "abcdefg" -mongoUri "mongodb://user:pass@host:port/db"

This example creates a .env file based on the template.env file and the given parameters.

.NOTES
This function requires a valid template file with placeholders for the parameters.
#>


# Define the function# Define the function
function New-EnvironmentFile ($template, $envfile, $OpenAIKey, $BingAIToken, $mongoUri) {
  # Create the .env file based on a template

  Write-Host "*** Create a New .env File Based on the Template ***" -ForegroundColor Blue
  Write-Host "`n"
  if (!(Test-Path $template)) {
    Write-Error "Template file not found."
  }
  else {
    # Get the content of the template file
    $content = Get-Content -Path $template
    # Set the content of the .env file
    Set-Content -Path $envfile -Value $content

    # Replace the placeholders with the parameters
    $content = $content -replace 'OPENAI_KEY=.*', "OPENAI_KEY=$OpenAIKey"
    $content = $content -replace 'MONGO_URI=.*', "MONGO_URI=$mongoUri"
    $content = $content -replace 'BINGAI_TOKEN=.*', 'BINGAI_TOKEN="user_provided"'
    $content = $content -replace '# PALM_KEY=.*', 'PALM_KEY="user_provided"'

    # Save the changes to the .env file
    Set-Content -Path $envfile -Value $content

    # Change the working directory and copy the .env.example file
    $parentDir = Split-Path -Parent $envfile
    Set-Location $parentDir\..
    Copy-Item .\client\.env.example .\client\.env

    Write-Host "Created the .env files successfully." -ForegroundColor Green
  }

  # Pause and clear the screen
  Start-Sleep -Seconds 2
  Clear-Host
}
