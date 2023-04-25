<#
.SYNOPSIS
A function that gets the Bing Access Token from the user and stores it in the .env file.

.DESCRIPTION
This function opens a webpage for Bing Access Token and asks the user to enter their BINGAI_TOKEN. It then replaces the key with BINGAI_TOKEN in the .env file.

.PARAMETER envfile
The path to the .env file where the BINGAI_TOKEN will be stored.

.EXAMPLE
Get-BingAccessToken -envfile C:\Users\user\Documents\.env

This example gets the Bing Access Token from the user and stores it in the C:\Users\user\Documents\.env file.

.NOTES
This function requires a web browser and an internet connection to access bing.com.
#>

function Get-BingAccessToken {
  param (
    [string]$envfile,
    $final_dir
  )
  Write-Host "*** Setup the BingAI Access Token ***" -ForegroundColor Blue
  Write-Host "`n"
  # Open webpage for Bing Access Token and ask the user to enter their BINGAI_TOKEN
  Write-Host "`n"
  Write-Host "Please follow these instructions to get your Bing Access Token:" -ForegroundColor Red
  Write-Host "`n"
  Write-Host "Method A:" -ForegroundColor DarkCyan
  Write-Host "On bing.com, make certain you are logged in"
  Write-Host "Press F12 or Ctrl+Shift+I to open the DevTools"
  Write-Host "Click on the Application tab in the DevTools window"
  Write-Host "(On certain browsers, you might have to click `>>` on the top of DevTools to find it)"
  Write-Host "In the left sidebar, under Storage, click on the Cookies dropdown menu to expand it"
  Write-Host "Look for the cookie named: _U"
  Write-Host "Click on the _U cookie"
  Write-Host "Its value will fill a box just bellow the list, select the string of characters and copy it"
  Write-Host "`n"
  Write-Host "Method B:" -ForegroundColor DarkCyan
  Write-Host "On bing.com, make certain you are logged in"
  Write-Host "Press F12 or Ctrl+Shift+I to open the DevTools"
  Write-Host "Go to the Console tab"
  Write-Host "(On certain browsers, you might have to click `>>` on the top of DevTools to find it)"
  Write-Host "Type:"
  Write-Host "cookieStore.get("_U").then(result => console.log(result.value))"
  Write-Host "and press Enter"
  Write-Host "Copy the output" 
  Write-Host "`n"
  Write-Host "Alternatively, you can use a third-party tool like EditThisCookie or Cookie-Editor to access your cookies"
  Write-Host "`n"
  Write-Host "Press the (Enter) key to open bing.com or any other key to continue..." -ForegroundColor DarkYellow

  # Wait for the user to press any key before continuing
  $pressedKey = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

  if ($pressedKey.VirtualKeyCode -eq 13) {
    # If the Enter key is pressed, open the webpage and continue with the script
    Start-Process "https://www.bing.com/"
} else {
    # If any other key is pressed, continue with the script
}

# Prompt user for BINGAI_TOKEN
do {
    $BINGAI_TOKEN = Read-Host "Please enter your BINGAI_TOKEN (leave blank to skip)"
    if (-not $BINGAI_TOKEN) {
        # Ask user for confirmation to leave field blank
        do {
            Write-Output "You have chosen to leave the BINGAI_TOKEN field blank. Without it you will not be able to use BingChat or Sydney."
            $confirmSkip = Read-Host "Are you sure? (y/n)"
        } until ($confirmSkip -eq "Y" -or $confirmSkip -eq "N")

        if ($confirmSkip -eq "N") {
            # Set BINGAI_TOKEN to null and re-ask for input
            $BINGAI_TOKEN = $null
        } else {
            # Set BINGAI_TOKEN to user_provided string and proceed with script
            $BINGAI_TOKEN = "user_provided"
        }
    } else {
        # Ask user for confirmation that BINGAI_TOKEN is correct
        do {
            Write-Host "`n" 
			Write-Output "Your BINGAI_TOKEN has been set"
            $confirm = Read-Host "Are you ready to continue? (press n to re-enter your token) (Y/n)"
        } until ($confirm -eq "Y" -or $confirm -eq "N")

        if ($confirm -eq "N") {
            # Set BINGAI_TOKEN to null and re-ask for input
            $BINGAI_TOKEN = $null
        }
    }
} until (-not [string]::IsNullOrEmpty($BINGAI_TOKEN) -or $confirmSkip -eq "Y")

if ($BINGAI_TOKEN) {
    # Replace key with BINGAI_TOKEN in .env file
    $envfile = "$final_dir\api\.env"
    $bingTokenLine = "BINGAI_TOKEN="
    $bingTokenValue = $BINGAI_TOKEN
    if ($envfile) {
        $prefix = "$bingTokenLine"
        $key = "$prefix""$bingTokenValue"""
        # Check if the BINGAI_TOKEN line already exists in the .env file
        $match = Select-String -Path $envfile -Pattern "^$prefix"
        if ($match) {
            # Replace the existing line with the new BINGAI_TOKEN
            (Get-Content -Path $envfile) -replace "^$prefix.*$", $key | Set-Content -Path $envfile
        } else {
            # Add a new line for the BINGAI_TOKEN
            Add-Content -Path $envfile -Value $key
        }
    }
} else {
    # Output message that user has skipped entering BINGAI_TOKEN
    Write-Host "You have chosen to skip entering a BINGAI_TOKEN. You can modify it later by editing the file at $envfile." -ForegroundColor Red
	Start-Sleep -Seconds 3
}

  # Pause and clear the screen
  Write-Host "BingAI Access Token Setup Completed" -ForegroundColor Green
  Start-Sleep -Seconds 2
  Clear-Host
}
