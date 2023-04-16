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
    $default_dir = "C:\chatgpt-clone"
    Clear-Host
	Write-Host "*** Setup the Install Directory ***" -ForegroundColor Blue
    Write-Host "`n"
    Write-Host "The default install directory is $default_dir" -ForegroundColor Red
    Write-Host "`n"
    $use_default = Read-Host "Do you want to use the default directory to install ChatGPT-Clone (Y/n)"
    while ($use_default -notin @("Y","y","N","n","")) {
        Write-Host "Invalid input. Please enter Y or n." -ForegroundColor Yellow
        $use_default = Read-Host "Do you want to use the default directory to install ChatGPT-Clone (Y/n)"
    }
    if ($use_default -in @("Y","y","")) {
        if (Test-Path $default_dir) {
            $overwrite = $null
            while ($overwrite -notin @("Y","y","N","n")) {
                $overwrite = Read-Host "$default_dir is not empty. Do you want to overwrite the content? (y/N)"
                if ($overwrite -eq "") {
                    $overwrite = "N"
                }
            }
            if ($overwrite -in @("Y","y","")) {
                Remove-Item $default_dir\* -Recurse -Force
                return $default_dir
				Write-Host "deleting the content of $default_dir " -NoNewline
				Start-Sleep -Seconds 1
				Write-Host "." -NoNewline
				Start-Sleep -Seconds 1
				Write-Host "." -NoNewline
				Start-Sleep -Seconds 1
				Write-Host "." -NoNewline
            }
        }
        else {
            New-Item $default_dir -ItemType Directory -Force | Out-Null
            return $default_dir
			Write-Host "ChatGPT-Clone installation folder is : $default_dir"

        }
    }
    else {
        $custom_path = Read-Host "Enter the path for the custom installation dir"
        while ($custom_path -ne "" -and !($custom_path -match "^[a-zA-Z]:\\(?:[^\\/:*?`"<>|]+\\)*[^\\/:*?`"<>|]+$")) {
            Write-Host "Invalid path. Please enter a valid path name (example: C:\chatgpt-clone)" -ForegroundColor Yellow
            $custom_path = Read-Host "Enter the path for the custom installation dir"
        }
        if ($custom_path -eq "") {
            Get-InstallDirectory
            return
        }
        if (-not (Test-Path $custom_path)) {
            New-Item $custom_path -ItemType Directory -Force | Out-Null
        }
        elseif ((Get-Item $custom_path).PSIsContainer -eq $false) {
            Write-Host "The path entered is not a directory" -ForegroundColor Red
            return
        }
        if (@(Get-ChildItem -Path $custom_path).Length -gt 0) {
            $overwrite = $null
            while ($overwrite -notin @("Y","y","N","n","")) {
                $overwrite = Read-Host "$custom_path is not empty. Do you want to overwrite the content? (y/N)"
                if ($overwrite -eq "") {
                    $overwrite = "N"
                }
            }
            if ($overwrite -in @("Y","y","")) {
                Remove-Item $custom_path\* -Recurse -Force
				Write-Host "deleting the content of $custom_path " -NoNewline
				Start-Sleep -Seconds 1
				Write-Host "." -NoNewline
				Start-Sleep -Seconds 1
				Write-Host "." -NoNewline
				Start-Sleep -Seconds 1
				Write-Host "." -NoNewline
            }
            else {
                Get-InstallDirectory
                return
            }
        }
        return $custom_path
		Write-Host "ChatGPT-Clone installation folder is : $custom_path"
    }
}

