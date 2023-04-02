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
    # Check if the directory exists or not
    if (Test-Path -Path $new_dest -PathType Container) {
        # If yes, ask the user if they want to overwrite or choose another directory
        Write-Host "The directory $new_dest already exists."
        # Check if the directory is empty or not
        $dir_content = Get-ChildItem -Path $new_dest -Force -ErrorAction SilentlyContinue
        if ($dir_content) {
            Write-Host "The directory $new_dest is not empty."
            $new_option = Read-Host "Do you want to overwrite its contents or choose another directory? (o/c)" -Default "o"
            # If overwrite, return the new directory
            if ($new_option -eq "o") {
                return $new_dest
            }
            # If choose another directory, call the function recursively
            elseif ($new_option -eq "c") {
                Write-Host "Please choose another directory."
                Get-ValidDirectory
            }
        }
        else {
            Write-Host "The directory $new_dest is empty."
            return $new_dest
        }
    }
    # If no, create the directory and return it
    else {
        # Create the directory
        Write-Host "The directory $new_dest does not exist. Creating it..."
        New-Item -Path $new_dest -ItemType Directory
        Write-Host "Created the directory $new_dest successfully."
        # Return the new directory
        return $new_dest
    }
}

# Ask the user the default install dir and if they want to change it
$default_dir = "C:\chatgpt-clone"
Write-Host "The default install directory is $default_dir."
$choice = Read-Host "Do you want to change it? (y/n)" -Default "n"

# If yes, ask the user to enter a new directory
if ($choice -eq "y") {
    $custom_dir = Read-Host "Please enter a new directory:"
    # Check if the directory exists or not
    if (Test-Path -Path $custom_dir -PathType Container) {
        # If yes, ask the user if they want to overwrite or choose another directory
        Write-Host "The directory $custom_dir already exists."
        # Check if the directory is empty or not
        $dir_content = Get-ChildItem -Path $custom_dir -Force -ErrorAction SilentlyContinue
        if ($dir_content) {
            Write-Host "The directory $custom_dir is not empty."
            $option = Read-Host "Do you want to overwrite its contents or choose another directory? (o/c)" -Default "o"
            # If overwrite, proceed with cloning using -Force parameter
            if ($option -eq "o") {
                Write-Host "Proceeding with cloning and overwriting..."
                # Store the destination directory in a variable
                $final_dir = $custom_dir
            }
            # If choose another directory, call the function to get a valid directory
            elseif ($option -eq "c") {
                Write-Host "Please choose another directory."
                $final_dir = Get-ValidDirectory
            }
        }
        else {
            Write-Host "The directory $custom_dir is empty."
            $final_dir = $custom_dir
        }
    }
    # If no, call the function to get a valid directory
    else {
        Write-Host "The directory $custom_dir does not exist."
        $final_dir = Get-ValidDirectory
    }
}
# If no, use the default install dir and proceed with cloning
else {
    Write-Host "Using the default install directory..."
    $final_dir = $default_dir
}

# Download chatgpt-clone from github using git clone
Write-Host "Downloading chatgpt-clone from github..."
$repo = "https://github.com/danny-avila/chatgpt-clone.git"

# Check if the destination directory exists and is empty
$dir_content = Get-ChildItem -Path $final_dir -Force -ErrorAction SilentlyContinue
if ($dir_content) {
    Write-Host "The directory $final_dir is not empty."
    $option = Read-Host "Do you want to overwrite its contents or exit? (o/e)" -Default "e"
    # If overwrite, delete the contents of the directory
    if ($option -eq "o") {
        Write-Host "Deleting the contents of the directory"

# Download and install Node.js from https://nodejs.org/en/download
Write-Host "Downloading and installing Node.js..."
$url = "https://nodejs.org/dist/v16.13.1/node-v16.13.1-x64.msi"
$output = "$env:TEMP\node-installer.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -ArgumentList "/quiet /norestart" -Wait
Write-Host "Node.js installed successfully."

# Create the .env file based on a template
Write-Host "Creating the .env file based on a template..."
$template = "$dest\api\.env.example"
$envfile = "$dest\api\.env"
Copy-Item -Path $template -Destination $envfile -Force

# Generate a random master key using PowerShell commands
$master_key = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | % {[char]$_})

# To enable the Conversation search feature, download MeileSearch and copy it to C:\chatgpt-clone
Write-Host "Downloading MeileSearch..."
$url = "https://github.com/meilisearch/MeiliSearch/releases/download/v0.24.0/meilisearch-windows-amd64.exe"
$output = "$env:TEMP\meilisearch.exe"
Invoke-WebRequest -Uri $url -OutFile $output
Copy-Item -Path $output -Destination "$dest\meilisearch.exe" -Force
Write-Host "Downloaded MeileSearch successfully."
 
# Save the master key to the .env file without quotation marks
(Get-Content -Path $envfile) -notmatch "MEILI_MASTER_KEY=" | Set-Content -Path $envfile
(Get-Content -Path $envfile) -replace "MEILI_MASTER_KEY=", "MEILI_MASTER_KEY=$master_key" | Set-Content -Path $envfile
Write-Host "Saved the master key to the .env file successfully."

# Check for Edge on the system and set a browser variable with Edge if present
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (Test-Path -Path $edge) {
    # If Edge exists, use it as the browser
    $browser = $edge
}
else {
    # If Edge does not exist, use the default browser
    $browser = "https://www.bing.com/"
}

Clear-Host
# Ask the user to enter their MONGO_URI
Write-Host "Please follow these instructions to create a MongoDB database and get your connection string:"
Write-Host "- Sign In or Create an account at https://www.mongodb.com/"
Write-Host "- Create a new project"
Write-Host "- Build a Database using the free plan and name the cluster (example: chatgpt-clone)"
Write-Host "- Use the 'Username and Password' method for authentication"
Write-Host "- Add your current IP to the access list"
Write-Host "- Then in the Database Deployment tab click on Connect"
Write-Host "- In 'Choose a connection method' select 'Connect your application'"
Write-Host "- Driver = Node.js / Version = 4.1 or later"
Write-Host "- Copy the connection string"
# Wait for the user to press any key before opening the webpage
Write-Host "Press any key to open the webpage..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
# Open webpage for MongoDB database
Write-Host "Opening webpage for MongoDB database..."
Start-Process -FilePath $browser -ArgumentList "https://www.mongodb.com/"
$MONGO_URI = Read-Host "MONGO_URI="
# Add quotation marks around the value
$MONGO_URI = $MONGO_URI -replace '^', '"' -replace '$', '"'
# Remove the part &w=majority from the value if present
$MONGO_URI = $MONGO_URI -replace '&w=majority', ''
# Save it to the .env file
(Get-Content -Path $envfile) -notmatch "MONGO_URI=", "MONGO_URI=$MONGO_URI" | Set-Content -Path $envfile
(Get-Content -Path $envfile) -replace "MONGO_URI=", "MONGO_URI=$MONGO_URI" | Set-Content -Path $envfile -Force

Clear-Host
# Open webpage for OpenAI API key and ask the user to enter their OPENAI_KEY
Write-Host "Please follow these instructions to get your OpenAI API key..."
Write-Host "- Sign In or Create an account"
Write-Host "- Go to 'API Keys' tab"
Write-Host "- Copy your secret key (sk-) or create a new one if you don't have one"
# Wait for the user to press any key before opening the webpage
Write-Host "Press any key to open the webpage..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host "Opening OpenAI's website..."
Start-Process -FilePath $browser -ArgumentList "https://platform.openai.com/account/api-keys"
$OPENAI_KEY = Read-Host "OPENAI_KEY="
# Save it to the .env file
(Get-Content -Path $envfile) -replace "OPENAI_KEY=", "OPENAI_KEY=$OPENAI_KEY" | Set-Content -Path $envfile

Clear-Host
# Open webpage for Bing Access Token and ask the user to enter their BING_TOKEN
Write-Host "Please follow these instructions to get your Bing Access Token..."
Write-Host "- Using MS Edge, navigate to bing.com"
Write-Host "- Make sure you are logged in"
Write-Host "- Open the DevTools by pressing F12 on your keyboard"
Write-Host "- Click on the tab 'Application' (On the left of the DevTools)"
Write-Host "- Expand the 'Cookies' (Under 'Storage')"
Write-Host "- You need to copy the string of the '_U' cookie"
# Wait for the user to press any key before opening the webpage
Write-Host "Press any key to open the webpage..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host "Opening Bing's website..."
Start-Process -FilePath $browser -ArgumentList "https://www.bing.com/"
$BING_TOKEN = Read-Host "BING_TOKEN="
# Save it to the .env file
(Get-Content -Path $envfile) -replace "BING_TOKEN=", "BING_TOKEN=$BING_TOKEN" | Set-Content -Path $envfile

# Set SEARCH to true by default
$SEARCH = "true"
(Get-Content -Path $envfile) -replace "SEARCH=", "SEARCH=$SEARCH" | Set-Content -Path $envfile

# Confirm that the credentials are saved
Write-Host "Saved your credentials in the .env file."

Clear-Host
# Ask the user if they want the ngrok features
Write-Host "Do you want to use ngrok to create a public link for your chatgpt-clone project? (y/n)"
$choice = Read-Host -Default "n"
# If yes, download ngrok in the project root folder
if ($choice -eq "y") {
    Write-Host "Downloading ngrok..."
    $url = "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip"
    $output = "$env:TEMP\ngrok.zip"
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive -Path $output -DestinationPath "$dest\ngrok"
    Write-Host "Downloaded ngrok successfully."
}
# If no, skip it
else {
    Write-Host "Skipping ngrok."
}
Clear-Host
# Run npm ci in the api and client directories
Write-Host "Running npm ci in the api and client directories..."
Push-Location "$dest\api"
npm ci
Pop-Location
Push-Location "$dest\client"
npm ci
Pop-Location
Write-Host "Ran npm ci successfully."

# Run npm run build in the client directory
Write-Host "Running npm run build in the client directory"
Push-Location "$dest\client"
npm run build
Write-Host "Ran run build successfully."

Clear-Host
#RUN BATCH FILE CREATION
# Create a new batch file in the install folder
Write-Host "Creating a new batch file in the install folder..."
$batfile = "$dest\run-opengpt-clone.bat"
New-Item -Path $batfile -ItemType File -Force
Write-Host "Created a new batch file successfully."

# Write the commands to the batch file
Write-Host "Writing the commands to the batch file..."
# Get the previously entered master key from the .env file
$MEILI_MASTER_KEY = (Get-Content -Path $envfile) -match "MEILI_MASTER_KEY=" | ForEach-Object {$_ -replace 'MEILI_MASTER_KEY=', ''}
# Write the command to start MeiliSearch with the master key and memory limit
Set-Content -Path $batfile -Value "start `"MeiliSearch`" cmd /k `"meilisearch --master-key $MEILI_MASTER_KEY --max-indexing-memory 4096`""
# Write the command to start ChatGPT-Clone with npm
Add-Content -Path $batfile -Value "start `"ChatGPT-Clone`" cmd /k `"cd api && npm start`""
# Write the command to start MS Edge with the app mode
Add-Content -Path $batfile -Value "start msedge --app=http://localhost:3080"
# Check if the user chose to use ngrok
if ($choice -eq "y") {
    # If yes, write the command to ask the user if they want to create a public link for this session and run ngrok or not
    Add-Content -Path $batfile -Value "@echo off"
    Add-Content -Path $batfile -Value "rem Ask the user if they want to create a public link for this session and run ngrok or not"
    Add-Content -Path $batfile -Value "choice /c yn /m `"Do you want to create a public link for this session and run ngrok? (y/n)`""
    Add-Content -Path $batfile -Value "rem Check the user input"
    Add-Content -Path $batfile -Value "if %errorlevel% equ 1 ("
    Add-Content -Path $batfile -Value "    rem If yes, start ngrok with port 3080"
    Add-Content -Path $batfile -Value "    start `"ngrok`" cmd /k `"cd ngrok && ngrok http 3080`""
    Add-Content -Path $batfile -Value ") else ("
    Add-Content -Path $batfile -Value "    rem If no, do nothing"
    Add-Content -Path $batfile -Value "    echo Skipping ngrok."
    Add-Content -Path $batfile -Value ")"
}
Write-Host "Wrote the commands to the batch file successfully."

Clear-Host
#UPDATE BATCH FILE CREATION
# Write the commands to the batch file
Write-Host "Wrote the commands to the batch file successfully."
# Create a new batch file in the install folder
Write-Host "Creating a new batch file in the install folder..."
$batfile = "$dest\update-chatgpt-clone.bat"
New-Item -Path $batfile -ItemType File -Force
Write-Host "Created a new batch file successfully."

# Write the commands to the batch file
Write-Host "Writing the commands to the batch file..."
# Write the command to pull the latest changes from the main branch
Set-Content -Path $batfile -Value "start `"Git Pull`" cmd /k `"git pull origin main & echo. & echo Press Ctrl+Shift+R or Ctrl+F5 to clear cache files after an update`""
# Write the command to install the dependencies and build the client
Add-Content -Path $batfile -Value "start `"Update Client`" cmd /k `"cd client && npm ci && npm run build`""
# Write the command to install the dependencies for the API
Add-Content -Path $batfile -Value "start `"Update API`" cmd /k `"cd api && npm ci`""
Write-Host "Wrote the commands to the batch file successfully."

Clear-Host
#CONCLUSION
Write-Host "Congratulations! You have successfully installed chatgpt-clone on your system."
Write-Host "To start the project, double-click on the run-chatgpt-clone.bat file in the install folder. This will launch MeiliSearch, ChatGPT-Clone and MS Edge in app mode."
Write-Host "To update the project to the latest version, double-click on the update-chatgpt-clone.bat file in the install folder. This will pull the latest changes from GitHub and install the dependencies for the client and the API."
Write-Host "Enjoy using chatgpt-clone!"

# Display the message
Write-Host "Install completed, press any key to close this window."
# Wait for the user input
Read-Host