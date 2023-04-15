<#
.SYNOPSIS
A function that gets the install directory from the user or uses the default one.

.DESCRIPTION
This function prompts the user to choose between using the default install directory or entering a custom one. It then validates the user input and returns the final install directory. It also enables debug output for this module if the $Debug variable is set to $true.

.EXAMPLE
Get-InstallDirectory

This example gets the install directory from the user or uses the default one.

.NOTES
This function requires the Get-ValidDirectory function to validate the user input.
#>

function Get-InstallDirectory {

    # Set the default directory
	$default_dir = "C:\chatgpt-clone"
    Clear-Host
	Write-Host "*** Setup the Install Directory ***" -ForegroundColor Blue
    Write-Host "`n"
	Write-Host "The default install directory is" -NoNewline
    Write-Host " $default_dir" -ForegroundColor Red
    Write-Host "`n"

    # Ask the user if they want to use the default directory
    $use_default = Read-Host "Do you want to use the default directory to install ChatGPT-Clone (Y/n)"
    
    # Loop until the user enters a valid input
    while ($use_default -notin @("Y","y","N","n","")) {
        Write-Host "Invalid input. Please enter Y or n." -ForegroundColor Yellow
        $use_default = Read-Host "Do you want to use the default directory to install ChatGPT-Clone (Y/n)"
    }

    # If the user chooses the default directory or nothing
    if ($use_default -in @("Y","y","")) {
        # Check if the default directory is empty
        if (Test-Path $default_dir) {
            # Ask the user if they want to overwrite the content
			$overwrite = Read-Host "$default_dir is not empty. Do you want to overwrite the content? (y/N)"
			# Set the default value to N
			if ($overwrite -eq "") {
				$overwrite = "N"
			}
            # Loop until the user enters a valid input
			while ($overwrite -notin @("Y","y","N","n")) {
				Write-Host "Invalid input. Please enter y or N." -ForegroundColor Yellow
				$overwrite = Read-Host "$default_dir is not empty. Do you want to overwrite the content? (y/N)"
				# Set the default value to N
				if ($overwrite -eq "") {
					$overwrite = "N"
				}
			}
            # If the user chooses to overwrite or nothing
            if ($overwrite -in @("Y","y","")) {
                # Erase the content of the default directory
                Remove-Item $default_dir\* -Recurse -Force
                # Set the final directory as the default directory
                $final_dir = $default_dir
            }
            # If the user chooses not to overwrite
            else {
                # Go back to the first question
                Get-InstallDirectory
                return
            }
        }
        # If the default directory is empty
        else {
            # Create the default directory
            New-Item $default_dir -ItemType Directory -Force | Out-Null
            # Set the final directory as the default directory
            $final_dir = $default_dir
        }
    }
    # If the user chooses not to use the default directory
    else {
        # Ask the user to enter a custom path for installation
        $custom_path = Read-Host "Enter the path for the custom installation dir"
        
        # Loop until the user enters a valid path name or nothing
        while ((Test-Path $custom_path) -eq $false) {
            Write-Host "Invalid path. Please enter a valid path name (or leave blank to go back)" -ForegroundColor Yellow
            $custom_path = Read-Host "Enter the path for the custom installation dir"
        }

        # If the user enters nothing, go back to the first question
        if ($custom_path -eq "") {
            Get-InstallDirectory
            return
        }
        # If the user enters a valid path name
        else {
            # Check if the custom path is empty
            if (Test-Path $custom_path) {
                # Ask the user if they want to overwrite the content
                $overwrite = Read-Host "$custom_path is not empty. Do you want to overwrite the content? (y/N)" #here?
                # Set the default value to N
				if ($overwrite -eq "") {
					$overwrite = "N"
				}
				# Loop until the user enters a valid input
                while ($overwrite -notin @("Y","y","N","n","")) {
                    Write-Host "Invalid input. Please enter y or N." -ForegroundColor Yellow
                    $overwrite = Read-Host "$custom_path is not empty. Do you want to overwrite the content? (y/N)"
					# Set the default value to N
					if ($overwrite -eq "") {
						$overwrite = "N"
					}
				}
                # If the user chooses to overwrite or nothing
                if ($overwrite -in @("Y","y","")) {
                    # Erase the content of the custom path
                    Remove-Item $custom_path\* -Recurse -Force
                    # Set the final directory as the custom path
                    $final_dir = $custom_path
                }
                # If the user chooses not to overwrite
                else {
                    # Go back to the first question
                    Get-InstallDirectory
                    return
                }
            }
            # If the custom path is empty
            else {
                # Create the custom path
                New-Item $custom_path -ItemType Directory -Force | Out-Null
                # Set the final directory as the custom path
                $final_dir = $custom_path
            }
        }
    }

    Write-Host "The final install directory is : " -NoNewline 
    Write-Host "$final_dir" -ForegroundColor Green

    # Return the final directory as output from the function
    return $final_dir
  
  # Pause and clear the screen
  Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  Clear-Host
}
