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
   	$content = $content -replace 'DOMAIN_CLIENT=.*', 'DOMAIN_CLIENT=http://localhost:3080'

    # Save the changes to the .env file
    Set-Content -Path $envfile -Value $content

    Write-Host "Created the .env files successfully." -ForegroundColor Green
  }

  # Pause and clear the screen
  Start-Sleep -Seconds 2
  Clear-Host
}
