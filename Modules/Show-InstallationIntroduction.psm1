function Show-InstallationIntroduction {

# Display the Intro Message
Clear-Host
Write-Host "*** Introduction ***" -ForegroundColor Blue
Write-Host "`n"
Write-Host "***WARNING***"-ForegroundColor Red
Write-Host "If you already have either of those: " -ForegroundColor Red
Write-Host "- OpenAI API Key (OPENAI_KEY)" -ForegroundColor Yellow 
Write-Host "- MongoDB Connection string (MONGODB_URI)" -ForegroundColor Yellow 
Write-Host "Stop the installer now!" -ForegroundColor Red
Write-Host "And enter them in the `config.ini` file (located in the installer folder)." -ForegroundColor Yellow
Write-Host "This will make the process way faster." -ForegroundColor Yellow
Write-Host "`n"
Write-Host "If you don't already have these keys, don't worry!" -ForegroundColor Cyan
Write-Host "This installer will guide you in the process of acquiring them." -ForegroundColor Cyan 
#Exit and Clear screen
Write-Host "`nPress any key to Start..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host
}
