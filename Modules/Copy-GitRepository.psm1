# Define the function
function Copy-GitRepository ($final_dir) {

  # Download chatgpt-clone from github using git clone
  # Pause and clear the screen
  Clear-Host
  Write-Host "*** Download ChatGPT-Clone from GitHub ***" -ForegroundColor Blue
  Write-Host "`n"
  Write-Host "The install directory is: " -NoNewline
  Write-Host "$final_dir" -ForegroundColor Green
  # Define the URL of the Git repository
  $repo = "https://github.com/danny-avila/LibreChat.git"

  # Check if the destination directory exists and is empty
  $dir_content = Get-ChildItem -Path $final_dir -Force -ErrorAction SilentlyContinue
  if ($dir_content) {
    Write-Host "`n"
    Write-Host "***THE DIRECTORY $final_dir IS NOT EMPTY***" -ForegroundColor Red
    Write-Host "`n"
    do {
      # Use the Write-Host cmdlet to prompt the user for input and highlight the default option with color
      Write-Host "Do you want to overwrite its contents?" -ForegroundColor Red -NoNewline 
      # Use the -Separator parameter to join multiple strings without spaces
      Write-Host " (Y or q to quit) : " -ForegroundColor Yellow -NoNewline -Separator ""
      # Use the Read-Host cmdlet to store the user input in a variable
      $option = Read-Host
      if (-not $option) {
        $option = "Y"
      }
    } while ($option -notmatch '^[YQ]$')

    # If overwrite, delete the contents of the directory
    if ($option -eq "Y") {
      Write-Host "Deleting the contents of the directory"
      try {
        Remove-Item -Path $final_dir\* -Recurse -Force -ErrorAction Stop
        Write-Host "Deleted the contents of the directory successfully."
      }
      catch {
        Write-Error $_.Exception.Message
      }    
    }
    # If exit, stop the script
    elseif ($option -eq "Q") {
      Write-Host "`n"
      Write-Host "Exiting the script..." -ForegroundColor Red
      Exit 0
    }
  }

  # Clone the repo using git clone
  try {
    git clone $repo $final_dir
    Write-Host "Cloned the repo successfully." -ForegroundColor Green
  }
  catch {
    Write-Error $_.Exception.Message
  }

  # Pause and clear the screen
  Start-Sleep -Seconds 3
  Clear-Host
}
