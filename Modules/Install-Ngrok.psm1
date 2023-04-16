<#
.SYNOPSIS
Installs and sets up ngrok on Windows using PowerShell.

.DESCRIPTION
This function downloads ngrok from a URL, extracts it to a specified directory, and prompts the user to create an Auth token with ngrok. It also validates the user input and checks if ngrok.exe exists in the directory.

.PARAMETER final_dir
The directory where ngrok will be installed.

.EXAMPLE
Install-Ngrok -final_dir C:\ngrok

This example installs ngrok in C:\ngrok and prompts the user to create an Auth token with ngrok.

.NOTES
This function requires PowerShell 5.1 or higher and an internet connection.
#>

function Install-Ngrok($final_dir) {
    Write-Host "*** Install and Setup ngrok ***" -ForegroundColor Blue
    Write-Host "`n"

    # create temp folder if it doesn't exist
    if (-not (Test-Path "$final_dir\temp")) {
        New-Item -ItemType Directory -Path "$final_dir\temp" | Out-Null
    }

    # download ngrok file
    try {
        Invoke-WebRequest "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3.0.1-windows-amd64.zip" -OutFile "$final_dir\temp\ngrok.zip"
    } catch {
        # display warning message
        Write-Host "Error: Could not download ngrok file. Please make sure the URL is valid and accessible." -ForegroundColor Red
        Write-Host "You can manually download and unzip ngrok.exe to $final_dir and run the script again." -ForegroundColor Yellow
        # exit the function
        return
    }

    # extract ngrok to the final directory
    Expand-Archive "$final_dir\temp\ngrok.zip" -DestinationPath $final_dir -Force

    # remove the temp folder
    Remove-Item "$final_dir\temp" -Recurse -Force

    # prompt the user to create an Auth token with ngrok
    $auth_token = ''
    
    do {
        Write-Host "ngrok enables you to easily distribute your own instance of chatgpt-clone on the internet, "
		Write-Host "so you can share it or access it from another device, like your phone."
		Write-Host "`n"
		Write-Host "To use ngrok you need to setup your Auth Token"
		Write-Host "If you do not want to do it at the moment or have already done it,  press (N) to skip this step"
		Write-Host "If it is your first time setting up ngrok, press (Y) and you will be guided through the process"
		Write-Host "`n"
		$response = Read-Host "Do you need to create an Auth token with ngrok (Y/n)?"
    } while ($response -ne "y" -and $response -ne "n" -and $response -ne "")

    if ($response -eq "y" -or $response -eq "") {
        # create Auth token command
        Write-Host "Follow these instructions to create an Auth token:"
        Write-Host "Step 1: Sign up or log in to your ngrok account at https://dashboard.ngrok.com/get-started/setup"
        Write-Host "Step 2: Copy and paste the full command presented in the second step (Connect your account)"
        Write-Host "Press any key to open the webpage..." -ForegroundColor DarkYellow
        # wait for user input
        $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Start-Process "https://dashboard.ngrok.com/get-started/setup"

		do {
			$auth_token_command = Read-Host "Enter the command containing your auth token here (leave blank to skip)"
			
			if ($auth_token_command -eq '') {
				# ask the user to confirm skipping
				$skip = Read-Host "Are you sure you want to skip this step? (y/N)"
				if ($skip -eq "y") {
					Write-Host "Auth token not added."
					return
				}
			} else {
				# Remove the 'ngrok' and 'config' commands from the input
				$match_result = [regex]::Matches($auth_token_command, '(^ngrok\s+config\s+add-authtoken\s+|^)(\w{32})')
				$auth_token = $auth_token_command.Split()[-1]

				if ($match_result) {
					# check if ngrok.exe exists in $final_dir
					if (Test-Path "$final_dir\ngrok.exe") {
						# run the command to add auth token
						$full_command = Join-Path $final_dir ngrok.exe
						$full_command += " config add-authtoken $auth_token"
						Invoke-Expression $full_command
						# Write-Host "full command = $full_command"
						break # exit the loop
					} else {
						# display error message
						Write-Host "Error: ngrok.exe not found in $final_dir. Please make sure it is downloaded and unzipped correctly." -ForegroundColor Red
						break # exit the loop
					}
				} else {
					Write-Host "Error: Invalid command entered. Please enter the full command with your auth token."
				}
			}
		} while ($true)

    }

    # confirm output with user
    Write-Host "ngrok has been installed in $final_dir" -ForegroundColor Green
	# Pause and clear the screen
	Start-Sleep -Seconds 2
	Clear-Host
}
