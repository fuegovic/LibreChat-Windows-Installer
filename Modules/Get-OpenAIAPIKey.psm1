<#
.SYNOPSIS
A function that gets the OpenAI API key from the user and stores it in the .env file.

.DESCRIPTION
This function opens a webpage for OpenAI API key and asks the user to enter their OPENAI_KEY. It then replaces the key with OPENAI_KEY in the .env file.

.PARAMETER envfile
The path to the .env file where the OPENAI_KEY will be stored.

.EXAMPLE
Get-OpenAIAPIKey -envfile C:\Users\user\Documents\.env

This example gets the OpenAI API key from the user and stores it in the C:\Users\user\Documents\.env file.

.NOTES
This function requires a web browser and an internet connection to access platform.openai.com.
#>

# Define the function
function Get-OpenAIAPIKey ($envfile, $final_dir) {
  Write-Host "*** Setup the OpenAI API Key ***" -ForegroundColor Blue
  # Open webpage for OpenAI API key and ask the user to enter their OPENAI_KEY
  Write-Host "`n"
  Write-Host "Please follow these instructions to get your OpenAI API key:" -ForegroundColor Red
  Write-Host "`n"
  Write-Host "- Sign In or Create an account at : " -NoNewline
  Write-Host "https://platform.openai.com/account/api-keys" -ForegroundColor Cyan
  Write-Host "- Go to 'API Keys' tab"
  Write-Host "- Copy your secret key (sk-xxxxxxxxxxxxxxxxxxxx) or create a new one if you don't have one"
  Write-Host "`n"
  Write-Host "Press any key to open the webpage..." -ForegroundColor DarkYellow

  # Wait for the user to press any key before opening the webpage
  $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

  # Write the webpage URL for OpenAI API key
  Write-Output "Please visit this webpage to setup your OpenAI API key: https://platform.openai.com/account/api-keys"
  Start-Process "https://platform.openai.com/account/api-keys"

	# Prompt user for OPENAI_KEY
	$OPENAI_KEY = Read-Host "Please enter your OPENAI_KEY (leave blank to skip)"
	$ConfirmationMessage = "Your OpenAI API Key is: $OPENAI_KEY`nIs this correct? (Y/n)"
	$Confirmation = Read-Host $ConfirmationMessage

	while ( $Confirmation.ToLower() -eq "n" ) {
	  # Reprompt user for OPENAI_KEY
	  $OPENAI_KEY = Read-Host "Please enter your OPENAI_KEY (leave blank to skip)"
	  $ConfirmationMessage = "Your OpenAI API Key is: $OPENAI_KEY`nIs this correct? (Y/n)"
	  $Confirmation = Read-Host $ConfirmationMessage
	}

	if (-not $OPENAI_KEY) {
	  # Ask user for confirmation to leave field blank
	  do {
		Write-Output "You have chosen to skip entering an OPENAI_KEY. You will not be able to use ChatGPT."
		$confirm = Read-Host "Are you sure? (y/n)"
	  } until ($confirm -eq "Y" -or $confirm -eq "N")
	  
	  if ($confirm -eq "N") {
		# Reprompt user for OPENAI_KEY
		do {
		  $OPENAI_KEY = Read-Host "Please enter your OPENAI_KEY (leave blank to skip)"
		} until (-not $OPENAI_KEY -or $OPENAI_KEY)
	  }
	}

	if ($OPENAI_KEY) {
	# Replace key with OPENAI_KEY in .env file
	$envfile = "$final_dir\api\.env"
	$openaiKeyLine = "OPENAI_KEY="
	$openaiKeyValue = $OPENAI_KEY
	if ($envfile) {
		$prefix = "$openaiKeyLine"
		$key = "$prefix""$openaiKeyValue"""
		# Check if the OPENAI_KEY line already exists in the .env file
		$match = Select-String -Path $envfile -Pattern "^$prefix"
		if ($match) {
			# Replace the existing line with the new OPENAI_KEY
			(Get-Content -Path $envfile) -replace "^$prefix.*$", $key | Set-Content -Path $envfile
		} else {
			# Add a new line for the OPENAI_KEY
			Add-Content -Path $envfile -Value $key
		}
	}

	} else {
		# Output message that user has skipped entering OPENAI_KEY
		Write-Host "You have chosen to skip entering an OPENAI_KEY. You can modify it later by editing the file at $envfile." -ForegroundColor Red
		Start-Sleep -Seconds 3
	}

	Write-Host "OpenAI API Key Setup Completed" -ForegroundColor Green
	# Pause and clear the screen
	Start-Sleep -Seconds 2
	Clear-Host
}
