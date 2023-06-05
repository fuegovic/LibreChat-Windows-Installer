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
	# Open webpage for OpenAI API key and ask the user to enter their OPENAI_API_KEY
	Write-Host "`n"
	Write-Host "Please follow these instructions to get your OpenAI API key:" -ForegroundColor Red
	Write-Host "`n"
	Write-Host "- Sign In or Create an account at : " -NoNewline
	Write-Host "https://platform.openai.com/account/api-keys" -ForegroundColor Cyan
	Write-Host "- Go to 'API Keys' tab"
	Write-Host "- Copy your secret key (sk-xxxxxxxxxxxxxxxxxxxx) or create a new one if you don't have one"
	Write-Host "`n"
	Write-Host "Press the (Enter) key to open the webpage or any other key to continue..." -ForegroundColor DarkYellow

	# Wait for the user to press any key before continuing
	$pressedKey = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

	if ($pressedKey.VirtualKeyCode -eq 13) {
	  # If the Enter key is pressed, open the webpage and continue with the script
	  Start-Process "https://platform.openai.com/account/api-keys"
  } else {
	  # If any other key is pressed, continue with the script
  }
  
	  # Prompt user for OPENAI_API_KEY
	  $OPENAI_API_KEY = Read-Host "Please enter your OPENAI_API_KEY (leave blank to skip)"
	  $ConfirmationMessage = "Your OpenAI API Key is: $OPENAI_API_KEY`nIs this correct? (Y/n)"
	  $Confirmation = Read-Host $ConfirmationMessage
  
	  while ( $Confirmation.ToLower() -eq "n" ) {
		# Reprompt user for OPENAI_API_KEY
		$OPENAI_API_KEY = Read-Host "Please enter your OPENAI_API_KEY (leave blank to skip)"
		$ConfirmationMessage = "Your OpenAI API Key is: $OPENAI_API_KEY`nIs this correct? (Y/n)"
		$Confirmation = Read-Host $ConfirmationMessage
	  }
  
	  if (-not $OPENAI_API_KEY) {
		# Ask user for confirmation to leave field blank
		do {
		  Write-Output "You have chosen to skip entering an OPENAI_API_KEY. (You will be able to enter it later from the UI.)"
		  $confirm = Read-Host "Are you sure? (y/n)"
		} until ($confirm -eq "Y" -or $confirm -eq "N")
		
		if ($confirm -eq "N") {
		  # Reprompt user for OPENAI_API_KEY
		  do {
			$OPENAI_API_KEY = Read-Host "Please enter your OPENAI_API_KEY (leave blank to skip)"
		  } until (-not $OPENAI_API_KEY -or $OPENAI_API_KEY)
		} else {
		  # Set default value of OPENAI_API_KEY to "user_provided"
		  $OPENAI_API_KEY = "user_provided"
		}
	  }
  
	  if ($OPENAI_API_KEY) {
	  # Replace key with OPENAI_API_KEY in .env file
	  $envfile = "$final_dir\api\.env"
	  $openaiKeyLine = "OPENAI_API_KEY="
	  $openaiKeyValue = $OPENAI_API_KEY
	  if ($envfile) {
		  $prefix = "$openaiKeyLine"
		  $key = "$prefix""$openaiKeyValue"""
		  # Check if the OPENAI_API_KEY line already exists in the .env file
		  $match = Select-String -Path $envfile -Pattern "^$prefix"
		  if ($match) {
			  # Replace the existing line with the new OPENAI_API_KEY
			  (Get-Content -Path $envfile) -replace "^$prefix.*$", $key | Set-Content -Path $envfile
		  } else {
			  # Add a new line for the OPENAI_API_KEY
			  Add-Content -Path $envfile -Value $key
		  }
	  }
  
	  } else {
		  # Output message that user has skipped entering OPENAI_API_KEY
		  Write-Host "You have chosen to skip entering an OPENAI_API_KEY. You can add one later from the UI or by editing the file at $envfile." -ForegroundColor Red
		  Start-Sleep -Seconds 3
	  }
  
	  Write-Host "OpenAI API Key Setup Completed" -ForegroundColor Green
	  # Pause and clear the screen
	  Start-Sleep -Seconds 2
	  Clear-Host
  }  
