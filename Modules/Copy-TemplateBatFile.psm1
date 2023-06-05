function Copy-TemplateBatFile {
param (
    [string]$original_location,
    [string]$final_dir, 
    [string]$envfile
)
Write-Host "***  Create LibreChat.bat, used to Start and Update the project ***" -ForegroundColor Blue
Write-Host "`n"

# Set the paths to the template batch file and the destination for the copied batch file
$template_file = "$original_location/Dependencies/template.bat"
$copied_file = "$final_dir\LibreChat.bat"

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

Copy-Item "$original_location\Dependencies\LibreChat.ico" "$final_dir\LibreChat.ico"

$OneDrive = "$env:USERPROFILE\OneDrive\Desktop"
$UserDesktop = "$env:HOMEPATH\Desktop"

if (Test-Path $OneDrive -PathType Container) {
    if (Test-Path $UserDesktop -PathType Container) {
        do {
            Write-Host "Which directory would you like to copy the shortcut to?"
			$Location = Read-Host "(1) for $OneDrive // (2) for $UserDesktop"
            if ($Location -ne "1" -and $Location -ne "2") {
                Write-Host "Invalid input. Please enter 1 or 2." -ForegroundColor Red
            }
        } until ($Location -eq "1" -or $Location -eq "2")
    }
    else {
        $Location = "1"
    }
}
elseif (Test-Path $UserDesktop -PathType Container) {
    $Location = "2"
}
else {
    $shortcutLocation = "$final_dir"
}

if ($Location -eq "1") {
    $shortcutLocation = "$OneDrive"
}
elseif ($Location -eq "2") {
    $shortcutLocation = "$UserDesktop"
}

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$shortcutLocation\LibreChat.lnk")
$Shortcut.TargetPath = "$final_dir\LibreChat.bat"
$Shortcut.IconLocation = "$final_dir\LibreChat.ico"
$Shortcut.WorkingDirectory = "$final_dir"

$Shortcut.Save()
Write-Host "The shortcut to LibreChat is : $shortcutLocation\LibreChat.lnk" -ForegroundColor Cyan

# Pause and clear the screen
Start-Sleep -Seconds 4
Clear-Host

return $shortcutLocation
}
