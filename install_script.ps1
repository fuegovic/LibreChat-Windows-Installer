# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    # If not, download and install git from https://git-scm.com/download/win
    Write-Host "Git is not installed. Downloading and installing git..."
    $url = "https://github.com/git-for-windows/git/releases/download/v2.34.1.windows.1/Git-2.34.1-64-bit.exe"
    $output = "$env:TEMP\git-installer.exe"
    Invoke-WebRequest -Uri $url -OutFile $output
    Start-Process -FilePath $output -ArgumentList "/VERYSILENT /NORESTART /NOCANCEL /SP-" -Wait
    Write-Host "Git installed successfully."
}

# Define a function to get a valid directory from the user
function Get-ValidDirectory {
    # Ask the user to enter a new directory
    $new_dest = Read-Host "Please enter a new directory:"
    # Create the directory using the -Force parameter to overwrite any existing contents
    Write-Verbose "Creating the directory $new_dest..."
    New-Item -Path $new_dest -ItemType Directory -Force
    Write-Verbose "Created the directory $new_dest successfully."
    # Return the new directory
    return $new_dest
}

## Function to prompt the user for a valid directory until a valid input is received
function Get-ValidDirectory {
    do {
        # Use the Write-Host cmdlet to prompt the user for input and highlight the default option with color
        Write-Host "Enter a valid directory path:" -ForegroundColor Cyan 
        # Use the Read-Host cmdlet to store the user input in a variable
        $dir = Read-Host 
    } while (-not (Test-Path -Path $dir -PathType Container))

    return $dir
}

Clear-Host
$default_dir = "C:\chatgpt-clone"
Write-Host "The default install directory is" -NoNewline
Write-Host " $default_dir" -ForegroundColor Red
Write-Host "`n"

# Use a do...while loop to keep asking for input until choice is valid
do {
    # Use the Write-Host cmdlet to prompt the user for input and highlight the default option with color
    Write-Host "Do you want to use the default directory?" -ForegroundColor Cyan -NoNewline
    # Use the -Separator parameter to join multiple strings without spaces
    Write-Host " (Y/n or q to quit) : " -ForegroundColor Yellow -NoNewline
    # Use the Read-Host cmdlet to store the user input in a variable
    $choice = Read-Host 
    # Check if choice is empty and set it to Y if it is
    if (-not $choice) {
        $choice = "Y"
    }
} while ($choice -notmatch '^[YNQ]$')

# If yes, use the default directory
if ($choice -eq "Y") {
    $final_dir = $default_dir
}
# If no, call the function to get a valid directory
elseif ($choice -eq "N") {
    try {
        $final_dir = Get-ValidDirectory
    }
    catch {
        Write-Error $_.Exception.Message
        Write-Output $_.Exception.StackTrace | Out-File error.log -Append 
    }    
}
# If user wants to quit, exit the script
else {
	Write-Host "`n"
    Write-Host "Exiting script..." -ForegroundColor Red
    Exit 0
}
Write-Host "The final install directory is : " -NoNewline 
Write-Host "$final_dir" -ForegroundColor Green


# Download chatgpt-clone from github using git clone
Write-Host "Downloading chatgpt-clone from github..."

$repo = "https://github.com/danny-avila/chatgpt-clone.git"

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
            Write-Output $_.Exception.StackTrace | Out-File error.log -Append 
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
    git clone $repo $final_dir -v
    Write-Host "Cloned the repo successfully." -ForegroundColor Green
}
catch {
    Write-Error $_.Exception.Message
    Write-Output $_.Exception.StackTrace | Out-File error.log -Append 
}

# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host

# Check if Node.js is already installed
Write-Output "Checking if Node.js is already installed..."
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Node.js is already installed." -ForegroundColor Green
    # Get the current version of Node.js installed
    Write-Host "Getting the current version of Node.js installed..." -ForegroundColor Cyan
    $current_version = node -v
    Write-Host "The current version of Node.js installed is $current_version." -ForegroundColor Cyan
    # Upgrade Node.js to the latest version available in the winget repository
    Write-Output "Upgrading Node.js to the latest version available..."
    winget upgrade OpenJS.NodeJS
    Write-Host "Node.js upgraded successfully." -ForegroundColor Green
}
else {
    Write-Host "Node.js is not installed." -ForegroundColor Red
    # Download and install Node.js using winget
    Write-Host "Downloading and installing Node.js using winget..." -ForegroundColor Cyan
    winget install OpenJS.NodeJS
    Write-Host "Node.js installed successfully." -ForegroundColor Green
}

# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host

# Create the .env file based on a template
Write-Host "Creating the .env file based on a template..." -ForegroundColor Cyan
Write-Host "`n"
$template = "$final_dir\api\.env.example"
$envfile = "$final_dir\api\.env"

if (!(Test-Path $template)) {
    Write-Error "Template file not found." -ForegroundColor Red
}
else {
    # Get the content of the template file
    $content = Get-Content -Path $template

    # Set the content of the .env file
    Set-Content -Path $envfile -Value $content
    Write-Host "Created the .env file successfully." -ForegroundColor Green
}

# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host

# To enable the Conversation search feature, download MeileSearch and copy it to C:\chatgpt-clone
Write-Host "Downloading MeileSearch..."

$url = "https://github.com/meilisearch/meilisearch/releases/download/v1.0.2/meilisearch-windows-amd64.exe"
$output = "$env:TEMP\meilisearch.exe"

try {
    # Create a new BITS transfer job
    $job = Start-BitsTransfer -Source $url -Destination $output -DisplayName "MeiliSearch Download" -Asynchronous

    # Wait for the transfer to complete
    do {
        Write-Host "Transfer in progress... $($job.BytesTransferred / 1MB) MB downloaded" -NoNewline
        Start-Sleep -Seconds 1
        Write-Host "`r" -NoNewline
    } while ($job.JobState -eq "Transferring")

    # Check the status of the transfer
    if ($job.JobState -eq "Error") {
		Clear-Host
        Write-Error "Download failed with error $($job.Error)" -ForegroundColor Red
    }
    else {
		Clear-Host
        Write-Host "Downloaded MeiliSearch successfully." -ForegroundColor Green
    }
}
catch {
    Write-Error $_.Exception.Message
    Write-Output $_.Exception.StackTrace | Out-File error.log -Append 
}

# Copy the executable to the chatgpt-clone directory
Copy-Item -Path $output -Destination "$final_dir\meilisearch.exe" -Force
 
# Generate a random master key using PowerShell commands
$guid = [guid]::NewGuid().ToString("N").ToUpper()
$key = "{0}-{1}_{2}" -f $guid.Substring(0, 4), $guid.Substring(4, 8), $guid.Substring(12, 12)
$master_key = $key

# Save the master key to the .env file without quotation marks
if ($envfile) {
    $prefix = "MEILI_MASTER_KEY="
    $key = "$prefix$master_key"
    # Check if the MEILI_MASTER_KEY line already exists in the .env file
    $match = Select-String -Path $envfile -Pattern "^$prefix"
    if ($match) {
        # Replace the existing line with the new master key
        (Get-Content -Path $envfile) -replace "^$prefix.*$", $key | Set-Content -Path $envfile
    } else {
        # Add a new line for the master key
        Add-Content -Path $envfile -Value $key
    }
    Write-Host "`n"
	Write-Host "Generated and saved the MeiliSearch master key to the .env file successfully." -ForegroundColor Green
}
else {
    Write-Host "`n"
	Write-Error "Environment file path not found." -ForegroundColor Red
}


# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host

# Ask the user to enter their MONGO_URI
Write-Host @"
Please follow these instructions to create a MongoDB database and get your connection string:

- Sign In or Create an account at https://www.mongodb.com/
- Create a new project
- Build a Database using the free plan and name the cluster (example: chatgpt-clone)
- Use the 'Username and Password' method for authentication
- Add your current IP to the access list
- Then in the Database Deployment tab click on Connect
- In 'Choose a connection method' select 'Connect your application'
- Driver = Node.js / Version = 4.1 or later
- Copy the connection string

Press any key to open the webpage...
"@ -ForegroundColor Cyan


# Wait for the user to press any key before continuing
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


# Write the webpage URL for MongoDB database
Write-Output "Please visit this webpage to setup your MongoDB database: https://www.mongodb.com/"
Start-Process "https://www.mongodb.com/"
# Declare a variable to store the input

# Step 1: Ask user for MONGO_URI
$mongoUri = Read-Host "Please enter your MongoDB connection string:"

# Step 2: Check for <password>
if ($mongoUri.Contains("<password>")) {
    Write-Host "Please replace <password> with your own password."
    
    # Prompt user to re-enter MONGO_URI
    $mongoUri = ""
    while (-not ($mongoUri -notmatch "<password>")) {
        $mongoUri = Read-Host "Please enter your MongoDB connection string:"
        if ($mongoUri.Contains("<password>")) {
            Write-Host "Please replace <password> with your own password."
        }
    }
}

# Debug
Write-Host "MongoDB Connection String: $mongoUri"
Write-Host "Contains Password: $($mongoUri.Contains('<password>'))"

# Step 3: (optional) Check for invalid URI
if (-not ($mongoUri.StartsWith("mongodb://") -or $mongoUri.StartsWith("mongodb+srv://"))) {
    Write-Host "Invalid URI. Please enter a valid MongoDB connection string."
    $mongoUri = Read-Host "Please enter your MongoDB connection string:"
}

while ($true) {
    # Step 4: Confirm connection string
    do {
        Write-Host "Your MongoDB connection string is: $mongoUri"
        $confirm = Read-Host "Is this correct? (Y/N)"
    } until ($confirm -eq "Y" -or $confirm -eq "N")

    # Step 5: Check confirmation answer
    if ($confirm -eq "N") {
        $mongoUri = Read-Host "Please enter your MongoDB connection string:"
        continue
    } elseif ($confirm -eq "Y") {
        break
    }
}

# Step 7: Store MONGO_URI
$MONGO_URI = $mongoUri

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

# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


# Open webpage for OpenAI API key and ask the user to enter their OPENAI_KEY
Write-Output @"
Please follow these instructions to get your OpenAI API key:

- Sign In or Create an account at https://platform.openai.com/account/api-keys
- Go to 'API Keys' tab
- Copy your secret key (sk-) or create a new one if you don't have one

Press any key to open the webpage...
"@


# Wait for the user to press any key before opening the webpage
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


# Open webpage for OpenAI API key
Write-Output "Opening OpenAI's website..."
Start-Process "https://platform.openai.com/account/api-keys"

# Prompt user for OPENAI_KEY
do {
    $OPENAI_KEY = Read-Host "Please enter your OPENAI_KEY (leave blank to skip):"
} until (-not $OPENAI_KEY -or $OPENAI_KEY)

if (-not $OPENAI_KEY) {
    # Ask user for confirmation to leave field blank
    do {
        Write-Output "You have chosen to skip entering an OPENAI_KEY. You will not be able to use ChatGPT."
		$confirm = Read-Host "Are you sure? (Y/N)"
    } until ($confirm -eq "Y" -or $confirm -eq "N")
    
    if ($confirm -eq "N") {
        # Reprompt user for OPENAI_KEY
        do {
            $OPENAI_KEY = Read-Host "Please enter your OPENAI_KEY (leave blank to skip):"
        } until (-not $OPENAI_KEY -or $OPENAI_KEY)
    }
}

if ($OPENAI_KEY) {
    # Replace key with OPENAI_KEY in .env file
    $env = Get-Content -Path $envfile
    $env | ForEach-Object {
        if ($_ -match "^OPENAI_KEY=") {
            $_ = "OPENAI_KEY=$OPENAI_KEY"
        }
        $_
    } | Set-Content -Path $envfile
} else {
    # Output message that user has skipped entering OPENAI_KEY
    Write-Output "You have chosen to skip entering an OPENAI_KEY. You can modify it later by editing the file at $envfile."
}


# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


# Open webpage for Bing Access Token and ask the user to enter their BING_TOKEN
Write-Output @"
You will have to follow these instructions to get your Bing Access Token:

On bing.com, make certain you are logged in
Press F12 or Ctrl+Shift+I to open the DevTools
Click on the Application tab in the DevTools window
In the left sidebar, under Storage, click on the Cookies dropdown menu to expand it
Look for the cookie named: _U
Right click on the _U cookie Value and select Edit Value
Right click again on the _U cookie Value and select copy

Alternatively, you can use a third-party tool like EditThisCookie or Cookie-Editor to access your cookies

Press any key to open bing.com...
"@


# Wait for the user to press any key before opening the webpage
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


# Open webpage for Bing Access Token
Write-Output "Opening Bing's website..."
Start-Process "https://www.bing.com/"

# Prompt user for BING_TOKEN
do {
    $BING_TOKEN = Read-Host "Please enter your BING_TOKEN (leave blank to skip):"
} until (-not $BING_TOKEN -or $BING_TOKEN)

if (-not $BING_TOKEN) {
    # Ask user for confirmation to leave field blank
    do {
        Write-Output "You have chosen to not enter a Bing Access Token. Without it you will not be able to use BingChat or Sydney."
		$confirm = Read-Host "Are you sure? (Y/N)"
    } until ($confirm -eq "Y" -or $confirm -eq "N")
    
    if ($confirm -eq "N") {
        # Reprompt user for BING_TOKEN
        do {
            $BING_TOKEN = Read-Host "Please enter your Bing Access Token (leave blank to skip):"
        } until (-not $BING_TOKEN -or $BING_TOKEN)
    }
}

if ($BING_TOKEN) {
    # Replace key with BING_TOKEN in .env file
    $env = Get-Content -Path $envfile
    $env | ForEach-Object {
        if ($_ -match "^BING_TOKEN=") {
            $_ = "BING_TOKEN=$BING_TOKEN"
        }
        $_
    } | Set-Content -Path $envfile
} else {
    # Output message that user has skipped entering BING_TOKEN
    Write-Output "You have chosen to skip entering a BING_TOKEN. You can modify it later by editing the file at $envfile."
}



# Set SEARCH to true by default
$SEARCH = "true"
# Replace key with SEARCH in .env file
Replace-FileString -Path $envfile -Pattern "SEARCH=.*" -Replacement "SEARCH=$SEARCH" -Overwrite


# Confirm that the credentials are saved
Write-Output "Your credentials are now saved in the .env file." -ForegroundColor Green


# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


# Prompt user for ngrok feature choice
do {
    $choice = Read-Host "Do you want to use ngrok to create a public link for your chatgpt-clone project? (Y/N)"
} until ($choice -eq "Y" -or $choice -eq "N")

# If yes, download and unzip ngrok in the project root folder
if ($choice -eq "Y") {
    Write-Output "Downloading ngrok..."
    $url = "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip"
    $output = "$env:TEMP\ngrok.zip"
    # Use BITS Transfer cmdlets to download ngrok
    Start-BitsTransfer -Source $url -Destination $output
    Wait-BitsTransfer -AllUsers
    Write-Output "Downloaded ngrok successfully."
    # Use Compress-Archive and Expand-Archive cmdlets to unzip ngrok
    Expand-Archive -Path $output -DestinationPath "$final_dir\ngrok" -Force
    Write-Output "Unzipped ngrok successfully."
}
# If no, skip it
else {
    Write-Output "Skipping ngrok."
}


# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


# Run npm ci in the api and client directories
Write-Output "Running npm ci in the api and client directories..."
Set-Location "$final_dir\api"
& npm ci
Set-Location "$final_dir\client"
& npm ci
Write-Output "Ran npm ci successfully."


# Run npm run build in the client directory
Write-Output "Running npm run build in the client directory"
Set-Location "$final_dir\client"
& npm run build
Write-Output "Ran run build successfully."



# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


#RUN BATCH FILE CREATION
# Create a new batch file in the install folder
Write-Output "Creating a new batch file in the install folder..."
$batfile = "$final_dir\run-opengpt-clone.bat"
New-Item -Path $batfile -ItemType File -Force
Write-Output "Created a new batch file successfully."

# Write the commands to the batch file
Write-Output "Writing the commands to the batch file..."
# Get the previously entered master key from the .env file
$MEILI_MASTER_KEY = (Get-Content -Path $envfile) -match "MEILI_MASTER_KEY=" | ForEach-Object {$_ -replace 'MEILI_MASTER_KEY=', ''}
# Write the commands to the batch file using a here-string
Set-Content -Path $batfile -Value @"
rem Start MeiliSearch with the master key and memory limit
start "MeiliSearch" cmd /k "meilisearch --master-key $MEILI_MASTER_KEY --max-indexing-memory 4096"

rem Start ChatGPT-Clone with npm
start "ChatGPT-Clone" cmd /k "cd api && npm start"

rem Start MS Edge with the app mode
start msedge --app=http://localhost:3080

rem Check if the user chose to use ngrok
if "$choice" equ "y" (
    rem If yes, ask the user if they want to create a public link for this session and run ngrok or not
    choice /c yn /m "Do you want to create a public link for this session and run ngrok? (y/n)"
    rem Check the user input
    if %errorlevel% equ 1 (
        rem If yes, start ngrok with port 3080
        start "ngrok" cmd /k "cd ngrok && ngrok http 3080"
    ) else (
        rem If no, do nothing
        echo Skipping ngrok.
    )
)
"@
Write-Output "Wrote the commands to the batch file successfully."


# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


#UPDATE BATCH FILE CREATION
# Write the commands to the batch file
Write-Output "Wrote the commands to the batch file successfully."
# Create a new batch file in the install folder
Write-Output "Creating a new batch file in the install folder..."
$batfile = "$final_dir\update-chatgpt-clone.bat"
New-Item -Path $batfile -ItemType File -Force
Write-Output "Created a new batch file successfully."

# Write the commands to the batch file using a here-string
Write-Output "Writing the commands to the batch file..."
Set-Content -Path $batfile -Value @"
rem Pull the latest changes from the main branch
start "Git Pull" cmd /k "git pull origin main & echo. & echo Press Ctrl+Shift+R or Ctrl+F5 to clear cache files after an update"

rem Install the dependencies and build the client
start "Update Client" cmd /k "cd client && npm ci && npm run build"

rem Install the dependencies for the API
start "Update API" cmd /k "cd api && npm ci"
"@
Write-Output "Wrote the commands to the batch file successfully."


# Pause and clear the screen
Write-Host "`nPress any key to continue..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
Clear-Host


#CONCLUSION
Write-Output @"
Congratulations! You have successfully installed chatgpt-clone on your system.
If you have trouble starting it, double-check the value set in the .env file located in the api folder.

To start the project, double-click on the run-chatgpt-clone.bat file in the install folder. This will launch everything needed for ChatGPT-Clone.

To update the project to the latest version, double-click on the update-chatgpt-clone.bat file in the install folder. This will pull the latest changes from GitHub and install the dependencies for the client and the API.

If you want to learn more about chatgpt-clone, you can visit its GitHub repository at https://github.com/dannya/chatgpt-clone.
If you want to join the chatgpt-clone community, you can join its Discord server at https://discord.gg/CEe6vDg9Ky.

Enjoy using chatgpt-clone!
"@


# Display the message
Write-Output "Install completed."
# Wait for the user input
Pause
