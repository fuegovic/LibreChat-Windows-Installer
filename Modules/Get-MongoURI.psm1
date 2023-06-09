# Define the function
function Get-MongoURI ($envfile, $final_dir) {
Write-Host "*** Setup the MongoDB Database ***" -ForegroundColor Blue
Write-Host "`n"
# Ask the user to enter their MONGO_URI
Write-Host "`n"
Write-Host "Please follow these instructions to create a MongoDB database and get your connection string:" -ForegroundColor Red
Write-Host "`n"
Write-Host "- Sign In or Create an account at : " -NoNewline
Write-Host "https://www.mongodb.com/"  -ForegroundColor Cyan
Write-Host "- Create a new project"
Write-Host "- Build a Database using the free plan and name the cluster (example: LibreChat)"
Write-Host "- Use the 'Username and Password' method for authentication"
Write-Host "- Add your current IP to the access list"
Write-Host "- Then in the Database Deployment tab click on Connect"
Write-Host "- In 'Choose a connection method' select 'Connect your application'"
Write-Host "- Driver = Node.js / Version = 4.1 or later"
Write-Host "- Copy the connection string"
Write-Host "`n"
Write-Host "Press the (Enter) key to open the webpage or any other key to continue..." -ForegroundColor DarkYellow

# Wait for the user to press any key before continuing
$pressedKey = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

if ($pressedKey.VirtualKeyCode -eq 13) {
    # If the Enter key is pressed, open the webpage and continue with the script
    Start-Process "https://www.mongodb.com/"
} else {
    # If any other key is pressed, continue with the script
}

# Step 1: Ask user for MONGO_URI
$mongoUri = Read-Host "Please enter your MongoDB connection string"

# Step 2: Check for '<' and '>' characters around password
while ($mongoUri.Contains("<") -or $mongoUri.Contains(">")) {
    Write-Host "Please remove the '<' and '>' characters from your MongoDB connection string." -ForegroundColor Red
    
    # Prompt user to re-enter MONGO_URI
    $mongoUri = Read-Host "Please enter your MongoDB connection string"
}

# Step 3: (optional) Check for invalid URI
if (-not ($mongoUri.StartsWith("mongodb://") -or $mongoUri.StartsWith("mongodb+srv://"))) {
    Write-Host "Invalid URI. Please enter a valid MongoDB connection string." -ForegroundColor Red
    $mongoUri = Read-Host "Please enter your MongoDB connection string"
}

while ($true) {
    # Step 4: Confirm connection string
    do {
        Write-Host "Your MongoDB connection string is: $mongoUri"
        $confirm = Read-Host "Is this correct? (y/n)"
    } until ($confirm -eq "Y" -or $confirm -eq "N")

    # Step 5: Check confirmation answer
    if ($confirm -eq "N") {
        $mongoUri = Read-Host "Please enter your MongoDB connection string"
        continue
    } elseif ($confirm -eq "Y") {
        break
    }
}

# Step 8: Add $MONGO_URI to .env file
$mongoUriLine = "MONGO_URI="
$mongoUriValue = ($mongoUri -replace '&w=majority$', '')
if ($envfile) {
    $prefix = "$mongoUriLine"
    $key = "$prefix""$mongoUriValue"""
    # Check if the MONGO_URI line already exists in the .env file
    $match = Select-String -Path $envfile -Pattern "^$prefix"
    if ($match) {
        # Replace the existing line with the new MONGO_URI
        (Get-Content -Path $envfile) -replace "^$prefix.*$", $key | Set-Content -Path $envfile
    } else {
        # Add a new line for the MONGO_URI
        Add-Content -Path $envfile -Value $key
    }
}
Write-Host "MongoDB setup completed" -ForegroundColor Green
# Pause and clear the screen
Start-Sleep -Seconds 2
Clear-Host
}
