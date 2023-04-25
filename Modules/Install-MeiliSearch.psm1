<#
.SYNOPSIS
This PowerShell module contains a function called "Install-MeiliSearch" that installs the MeiliSearch software on a Windows machine, generates a random 44-bit master key, and updates the .env file with the MeiliSearch master key and search variable set to true.

.DESCRIPTION
This PowerShell module is used to install the MeiliSearch software on a Windows machine and customize the .env file with a random MeiliSearch master key and setting the search variable to true. MeiliSearch is an open-source search engine that provides fast and relevant search results.

.PARAMETER
final_dir: The path of the directory where the MeiliSearch .exe file will be download and installed.

envfile: The path to the file to update with the MeiliSearch master key and search variable set to true. The file is assumed to be in the following format:
"MEILI_MASTER_KEY=<master_key_string>"
"SEARCH=<search_boolean>"

.EXAMPLE
Install-MeiliSearch -final_dir "C:\location" -envfile "D:\configuration\.env"

This command installs the latest version of MeiliSearch software from GitHub to the directory located at "C:\location", generates a random 44-bit master key, sets the .env file present in "D:\configuration" with the MeiliSearch master key and setting the search variable to true.

.NOTES
This PowerShell module does not require administrative permissions to be executed.
#>
function Install-MeiliSearch ($final_dir, $envfile) {
	Write-Host "*** Download the latest version of MeiliSearch ***" -ForegroundColor Blue
	Write-Host "`n"
    # Ask the user if they want to use the search feature
    $SEARCH = Read-Host "Do you want to enable the search feature? (Y/n)"

    if ($SEARCH -eq "" -or $SEARCH -eq "Y") {
        # If the user presses 'Enter' key without any input or inputs "Y", set $SEARCH = TRUE and continue with the script.
        $SEARCH = "TRUE"
        # Download the latest MeiliSearch release from Github.
        $meilisearchReleases = Invoke-WebRequest https://api.github.com/repos/meilisearch/meilisearch/releases -UseBasicParsing
        $amd64Asset = ($meilisearchReleases | ConvertFrom-Json)[0].assets | Where-Object { $_.name -eq "meilisearch-windows-amd64.exe" }
        $filepath = Join-Path $final_dir "meilisearch.exe"
        if (Test-Path $filepath) {
            Remove-Item $filepath
        }
        Write-Output "Downloading MeiliSearch software from Github..."
        $ProgressPreference = 'SilentlyContinue'
        $downloadURL = $amd64Asset.browser_download_url
        Invoke-WebRequest $downloadURL -OutFile $filepath
        
        # Generate a new 44-bit long random string of characters to serve as the key to encrypt data.
        $meili_master_key = New-RandomKey
    
        # Update the contents of the .env file for the application.
        $newMEILI_MASTER_KEY = "MEILI_MASTER_KEY=$meili_master_key" # since removing dollar sign separated placeholder
        $newSEARCH = "SEARCH=$SEARCH"
        $file = (Get-Content $envfile) -replace "(^|(?<=\r\n))MEILI_MASTER_KEY=.*", "$($newMEILI_MASTER_KEY)"
        $file = $file -replace "(^|(?<=\r\n))SEARCH=.*", "$($newSEARCH)"
    
        $file | Set-Content $envfile -Force -Encoding utf8
    
        # Display completion messages to the user.
        Write-Host "Installation and configuration complete." -ForegroundColor Green
        # Pause and clear the screen
        Start-Sleep -Seconds 2
        Clear-Host
    } elseif ($SEARCH -eq "N") {
        # If the user inputs "N", set $SEARCH = FALSE, skip downloading, and skip key creation.
        $SEARCH = "FALSE"
    
        # Update the contents of the .env file for the application.
        $newSEARCH = "SEARCH=$SEARCH"
        $file = (Get-Content $envfile) -replace "(^|(?<=\r\n))SEARCH=.*", "$($newSEARCH)"
    
        $file | Set-Content $envfile -Force -Encoding utf8
    
        # Display completion messages to the user.
        Write-Host "Done!" -ForegroundColor Green
        # Pause and clear the screen
        Start-Sleep -Seconds 2
        Clear-Host
    } else {
        # If the user inputs any other value, prompt them again.
        Write-Output "`"$SEARCH`" is not a valid input. Please enter 'Y' or 'N'."
        Install-MeiliSearch $final_dir $envfile
    }
}

function New-RandomKey {
  $charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  $keyLength = 44
  $key = ""
  for ($i = 1; $i -le $keyLength; $i++) {
    $randomIndex = Get-Random -Minimum 0 -Maximum $charSet.Length
    $key += $charSet[$randomIndex]
  }
  return $key
}
