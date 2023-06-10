function Show-InstallationConclusion ($final_dir, $shortcutLocation) {

  # Display the message using a here-string
  Write-Host "*** Conclusion ***" -ForegroundColor Blue
  Write-Host "`n"
  Write-Host "Congratulations!"-ForegroundColor Green
  Write-Host "You have successfully installed LibreChat on your system." -ForegroundColor DarkYellow
  Write-Host "If you have trouble starting it, double-check the value set in the .env file located here:" -ForegroundColor DarkYellow 
  Write-Host "$final_dir\.env" -ForegroundColor Yellow
  Write-Host "`n"
  Write-Host "To start or update the project, double-click on" -ForegroundColor Red
  Write-Host "the LibreChat shortcut located here : $shortcutLocation\LibreChat.lnk" -ForegroundColor Red
  Write-Host "This will launch everything needed to run or update LibreChat." -ForegroundColor Red
  Write-Host "`n"
  Write-Host "If you want to learn more about LibreChat, you can visit its GitHub repository at:"-ForegroundColor DarkYellow
  Write-Host "https://github.com/dannya/LibreChat" -ForegroundColor DarkCyan
  Write-Host "`n"
  Write-Host "If you want to join the LibreChat community, you can join its Discord server at:"-ForegroundColor DarkYellow
  Write-Host "https://discord.gg/CEe6vDg9Ky" -ForegroundColor DarkCyan
  Write-Host "`n"
  Write-Host "Enjoy using LibreChat!" -ForegroundColor Magenta
  Write-Host "`n"
  
  # Display the message
  Write-Host "Installation completed." -ForegroundColor Yellow
  
  # Write a debug message with the current time
  Write-Host "Current time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
  
  #Exit and Clear screen
  Write-Host "`nPress any key to Exit..." -ForegroundColor Green
  $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  Clear-Host
}
