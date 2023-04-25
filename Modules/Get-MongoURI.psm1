<#
.SYNOPSIS
A function that gets the MongoDB connection string from the user and stores it in the .env file.

.DESCRIPTION
This function opens a webpage for MongoDB database and asks the user to create a database and get their connection string. It then validates the user input and replaces the key with MONGO_URI in the .env file.

.PARAMETER envfile
The path to the .env file where the MONGO_URI will be stored.

.EXAMPLE
Get-MongoURI -envfile C:\Users\user\Documents\.env

This example gets the MongoDB connection string from the user and stores it in the C:\Users\user\Documents\.env file.

.NOTES
This function requires a web browser and an internet connection to access mongodb.com.
#>

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
Write-Host "- Build a Database using the free plan and name the cluster (example: chatgpt-clone)"
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

# Step 2: Check for <password>
if ($mongoUri.Contains("<password>")) {
    Write-Host "Please replace <password> with your own password." -ForegroundColor Red
    
    # Prompt user to re-enter MONGO_URI
    $mongoUri = ""
    while (-not ($mongoUri -notmatch "<password>")) {
        $mongoUri = Read-Host "Please enter your MongoDB connection string" -ForegroundColor Red
        if ($mongoUri.Contains("<password>")) {
            Write-Host "Please replace <password> with your own password." -ForegroundColor Red
        }
    }
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
$envfile = "$final_dir\api\.env"
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
