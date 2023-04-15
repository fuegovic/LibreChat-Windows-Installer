<#
.SYNOPSIS
Displays a congratulatory message and some instructions for using chatgpt-clone.

.DESCRIPTION
This function displays a congratulatory message and some instructions for using chatgpt-clone. It takes no parameters.

.EXAMPLE
Show-InstallationConclusion

This example displays a congratulatory message and some instructions for using chatgpt-clone.

.NOTES
This function requires chatgpt-clone to be installed on the system.

#>
function Show-InstallationConclusion ($final_dir, $shortcutLocation) {

  # Display the message using a here-string
  Write-Host "*** Conclusion ***" -ForegroundColor Blue
  Write-Host "`n"
  Write-Host "Congratulations!"-ForegroundColor Green
  Write-Host "You have successfully installed chatgpt-clone on your system." -ForegroundColor DarkYellow
  Write-Host "If you have trouble starting it, double-check the value set in the .env file located here:" -ForegroundColor DarkYellow 
  Write-Host "$final_dir\api\.env" -ForegroundColor Yellow
  Write-Host "`n"
  Write-Host "To start or update the project, double-click on" -ForegroundColor Red
  Write-Host "the ChatGPT-Clone shortcut located here : $shortcutLocation\ChatGPT-Clone.lnk" -ForegroundColor Red
  Write-Host "This will launch everything needed to run or update ChatGPT-Clone." -ForegroundColor Red
  Write-Host "`n"
  Write-Host "If you want to learn more about ChatGPT-Clone, you can visit its GitHub repository at:"-ForegroundColor DarkYellow
  Write-Host "https://github.com/dannya/chatgpt-clone" -ForegroundColor DarkCyan
  Write-Host "`n"
  Write-Host "If you want to join the ChatGPT-Clone community, you can join its Discord server at:"-ForegroundColor DarkYellow
  Write-Host "https://discord.gg/CEe6vDg9Ky" -ForegroundColor DarkCyan
  Write-Host "`n"
  Write-Host "Enjoy using ChatGPT-Clone!" -ForegroundColor Magenta
  Write-Host "`n"
  
  # Display the message
  Write-Host "Install completed." -ForegroundColor Yellow
  
  # Write a debug message with the current time
  Write-Host "Current time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
  
  #Exit and Clear screen
  Write-Host "`nPress any key to Exit..." -ForegroundColor Green
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  Clear-Host
}
