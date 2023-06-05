function Get-InstallDirectory {
    $default_dir = "C:\LibreChat"
    Clear-Host
	Write-Host "*** Setup the Install Directory ***" -ForegroundColor Blue
    Write-Host "`n"
    Write-Host "The default install directory is $default_dir" -ForegroundColor Red
    Write-Host "`n"
    $use_default = Read-Host "Do you want to use the default directory to install LibreChat (Y/n)"
    while ($use_default -notin @("Y","y","N","n","")) {
        Write-Host "Invalid input. Please enter Y or n." -ForegroundColor Yellow
        $use_default = Read-Host "Do you want to use the default directory to install LibreChat (Y/n)"
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
				Write-Host "deleting the content of $default_dir ..."
                Remove-Item $default_dir\* -Recurse -Force
                return $default_dir
            }
        }
        else {
            New-Item $default_dir -ItemType Directory -Force | Out-Null
            return $default_dir
			Write-Host "LibreChat installation folder is : $default_dir"

        }
    }
    else {
        $custom_path = Read-Host "Enter the path for the custom installation dir"
        while ($custom_path -ne "" -and !($custom_path -match "^[a-zA-Z]:\\(?:[^\\/:*?`"<>|]+\\)*[^\\/:*?`"<>|]+$")) {
            Write-Host "Invalid path. Please enter a valid path name (example: C:\LibreChat)" -ForegroundColor Yellow
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
				Write-Host "deleting the content of $custom_path ..."
                Remove-Item $custom_path\* -Recurse -Force
            }
            else {
                Get-InstallDirectory
                return
            }
        }
        return $custom_path
		Write-Host "LibreChat installation folder is : $custom_path"
    }
}

