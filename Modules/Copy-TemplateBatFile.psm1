<#
.SYNOPSIS
This PowerShell module contains a function called "Copy-TemplateBatFile" that copies a template batch file from one location to another, replaces certain variables within the batch file with the correct values, and saves the updated batch file.

.DESCRIPTION
This PowerShell module is used for creating a batch file based on a template. It includes a function called "Copy-TemplateBatFile" that copies a batch file template from one location to another location and customizes certain variables within the batch file.

.PARAMETER
original_location: The path of the directory containing the template batch file to be copied.

final_dir: The path of the directory where the copied batch file will be saved.

envfile: The path of the file that contains variables that should be replaced in the final batch file. Specifically, this file contains the value for the MEILI_MASTER_KEY variable.
#>

function Copy-TemplateBatFile {
param (
    [string]$original_location,
    [string]$final_dir, 
    [string]$envfile
)
Write-Host "***  Create ChatGPT-Clone.bat, used to Start and Update the project ***" -ForegroundColor Blue
Write-Host "`n"

# Set the paths to the template batch file and the destination for the copied batch file
$template_file = "$original_location/Dependencies/template.bat"
$copied_file = "$final_dir\ChatGPT-Clone.bat"

# Copy the template batch file to the destination directory
Copy-Item $template_file $copied_file

# Read in the contents of the copied batch file
$batch_contents = Get-Content $copied_file

# Replace the $final_dir and $MEILI_MASTER_KEY variables with the correct values
$batch_contents = $batch_contents -replace '\$final_dir', $final_dir
$MEILI_MASTER_KEY = (Get-Content -Path $envfile) -notmatch "^#" -match "MEILI_MASTER_KEY=" | ForEach-Object {$_ -replace 'MEILI_MASTER_KEY=', ''}
$batch_contents = $batch_contents -replace '\$MEILI_MASTER_KEY', $MEILI_MASTER_KEY

# Save the updated contents to the copied batch file
Set-Content $copied_file $batch_contents

Copy-Item "$original_location\Dependencies\ChatGPT-Clone.ico" "$final_dir\ChatGPT-Clone.ico"
# Set the shortcut location and other parameters
$shortcutTargetPath = "$final_dir\ChatGPT-Clone.bat"
$shortcutIconLocation = "$final_dir\ChatGPT-Clone.ico"
$shortcutWorkingDirectory = "$final_dir"

# Define the two possible locations for the shortcut
$shortcutLocation1 = "$HOME\Desktop\ChatGPT Clone.lnk"
$shortcutLocation2 = "$HOME\OneDrive\Desktop\ChatGPT Clone.lnk"

# Set a variable to store the selected location
$selectedShortcutLocation = ""

# Check if both locations exist
if (Test-Path -Path $shortcutLocation1) -and (Test-Path -Path $shortcutLocation2) {
    # Prompt the user to choose a location
    $selectedShortcutLocation = Read-Host "Both desktop and OneDrive desktop exist. Type '1' to save on desktop or '2' to save on OneDrive desktop."
    
    if ($selectedShortcutLocation -eq "1") {
        # Save the shortcut on the first location
        $shortcutLocation = $shortcutLocation1
    } elseif ($selectedShortcutLocation -eq "2") {
        # Save the shortcut on the second location
        $shortcutLocation = $shortcutLocation2
    } else {
        # The user did not select a valid option
        Write-Host "Invalid option selected."
        return
    }
} elseif (Test-Path -Path $shortcutLocation1) {
    # Save the shortcut on the first location
    $shortcutLocation = $shortcutLocation1
} elseif (Test-Path -Path $shortcutLocation2) {
    # Save the shortcut on the second location
    $shortcutLocation = $shortcutLocation2
} else {
    # None of the locations exist, set the shortcut location to $final_dir
    $shortcutLocation = "$final_dir\ChatGPT Clone.lnk"
    Write-Host "No desktop locations found. Saving shortcut to $shortcutLocation."
}

# Create and save the shortcut
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutLocation)
$shortcut.TargetPath = $shortcutTargetPath
$shortcut.IconLocation = $shortcutIconLocation
$shortcut.WorkingDirectory = $shortcutWorkingDirectory
$shortcut.Save()

Write-Host "Your shortcut is located here : $shortcutLocation."

# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host
}
