# USE THE RECOMMENDED DOCKER INSTALL METHOD INSTEAD, THIS IS NOT MAINTAINED ANYMORE
https://docs.librechat.ai/install/installation/windows_install.html


<p align="center">
  <a href="https://discord.gg/NGaa9RPCft">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://github.com/fuegovic/LibreChat-Windows-Installer/assets/32828263/4b5401b6-b21c-4fd1-9782-ca4046c16a60">
      <img src="https://github.com/fuegovic/LibreChat-Windows-Installer/assets/32828263/4b5401b6-b21c-4fd1-9782-ca4046c16a60" height="172">
    </picture>
  </a>
</p>

<p align="center">
  <a href="https://discord.gg/NGaa9RPCft"> 
    <img src="https://img.shields.io/discord/1086345563026489514?label=&logo=discord&style=for-the-badge&logoWidth=20&labelColor=000000&color=blueviolet">
  </a>
  <a aria-label="LibreChat" href="https://librechat.ai">
    <img alt="" src="https://img.shields.io/badge/LIBRECHAT-0366d6.svg?style=for-the-badge&labelColor=000000&logoWidth=20&logo=github">
  </a>
</p>

# LibreChat Install Script

**Using docker is the recommended method to install LibreChat:**
[https://docs.librechat.ai/install/windows_install.html](https://docs.librechat.ai/install/windows_install.html)

If for one reason or another you don't want to use docker, you can continue with this method.

This script automates the local Windows 64 bits installation of :

[GitHub - danny-avila/LibreChat](https://github.com/danny-avila/LibreChat)

I you have an issue with the installer you can contact me here
or ping me on [discord](https://discord.gg/mvaZ3f5b) (@fuegovic)

---

## ⚠️Creating a MongoDB database is not easy, so please follow these instructions carefully⚠️
### [https://docs.librechat.ai/install/mongodb.html](https://docs.librechat.ai/install/mongodb.html)

---

## Table of Contents

- [LibreChat Install Script](#librechat-install-script)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Note](#note)
    - [Updating the launch script (For existing users)](#how-to-update-the-launch-script)
  - [Usage](#usage)
  - [Disclaimers](#disclaimers)
  - [Credits](#credits)
  - [License](#license)

## Requirements

This script requires Windows 10 64 bits, version 21H1 or higher.

## Installation

**TL;DR**

* Download the [latest release](https://github.com/fuegovic/LibreChat-Windows-Installer/releases/)
  
  - or  download the zip file (click on code - select download zip) ⤴️
  - or clone the repo with `git clone https://github.com/fuegovic/LibreChat-Windows-Installer.git`

* Extract the files (if you downloaded the zip file)

* Double click on install.bat and follow the on-screen instructions

* Use the `LibreChat` shortcut on your desktop to start or update the project

* Profit!

**Warning**

Microsoft Defender SmartScreen will prevent it to start

First press on `More info` , then select `Run anyway`

<img src="/Images/WindowsDefender.png" title="" alt="WindowsDefender.png" height="256" >  

**Details**

Download the .zip file and extract anywhere on your computer or use git to clone this project on your computer.

Run the install.bat file and follow the on-screen prompts. This script will:

* Install [Git](https://git-scm.com/download/win) (if needed)
* Update [Node.js](https://nodejs.org/en) (if needed)
* Clone the [LibreChat](https://github.com/danny-avila/LibreChat) repository from GitHub
* Install [MeiliSearch](https://www.meilisearch.com)
* Install [Ngrok](https://ngrok.com)
* Guide you through the process of acquiring the required [MongoDB URI](https://www.mongodb.com) and [OpenAI API key](https://platform.openai.com/account/api-keys)
* Provide a bat file to run and update LibreChat

**If you already have your MongoDB URI, OpenAI API key, or BingAI Access Token you can fill the `config.ini` file to skip these steps during the installation**

```ini
[Database]
;mongo_uri = <your connection string>

[API]
;openai_key = <your OpenAI key>
```

Alternatively, you can pass the same values as named parameters when running the script from a powershell terminal. For example:

```powershell
.\main.ps1 -mongo_uri "mongodb://127.0.0.1:27017/LibreChat" -openai_key "sk-123456789...321" -bingai_token "a1b2c3d4e5...f6g7"
```

The use of either the config file or the parameters is optional. If you don't provide them, the script will ask you to enter them manually.

## Note

If you just want an easy way to start and update [LibreChat](https://github.com/danny-avila/LibreChat) you can use `template.bat` in the dependencies directory and modify it to fit your needs.

By default the max indexing memory is set to 8Gb, you can set it to any value you want or removing altogether by editing the bat file. (template.bat before install or LibreChat.bat in the install directory. search for the 2 lines with `--max-indexing-memory 8192` )

### How to Update the launch script
If you already have LibreChat installed and you want to get the latest version of the launch script, just follow these easy steps:
- Open your current LibreChat.bat file in a text editor like Notepad
- Copy the values of `_finaldir` and `_MEILIMASTERKEY` somewhere safe:
  
  ![image](https://github.com/fuegovic/LibreChat-Windows-Installer/assets/32828263/128ba8c8-50b5-4ae6-8f11-8fad33ec188b)

- Download the new [template.bat](https://github.com/fuegovic/LibreChat-Windows-Installer/blob/main/Dependencies/template.bat) file from GitHub

  ![image](https://github.com/fuegovic/LibreChat-Windows-Installer/assets/32828263/11e6e2d3-c7e1-4c82-8bd1-da50540653c4)

- Open the new file in a text editor and paste the values of `_finaldir` and `_MEILIMASTERKEY` that you copied earlier
- Save the new file as `LibreChat.bat` in the same folder where you installed LibreChat (usually `C:\LibreChat`)
  - You can also rename the old `LibreChat.bat` instead of overwriting it if you want to backup it 
- Voila! You're done!

## Usage

When you are done you should have a working installation of [LibreChat](https://github.com/danny-avila/LibreChat).

Go to your desktop and use the shortcut `LibreChat` to start and/or update the project

**On the first screen**

- **1** Start the local server, accessible at [http://localhost:3080](http://localhost:3080)

- **2** Start the local server and the ngrok tunnel giving you a public url that you can share or use to connect from another device

- **3** Update the LibreChat project to the latest version

- **4** Close everything for you

<img title="" src="/Images/Menu1.jpg" alt="Menu1.jpg" width="680" data-align="inline">

**On the second screen**

- In blue you have the URL(s) where you can access LibreChat

- **1** Open a local web-app version of LibreChat

- **2** Close everything for you

<img title="" src="/Images/Menu2.jpg" alt="Menu2.jpg" width="635">

**Warning :** The exit procedure is pretty aggressive and will close all instance of node.exe and kill cmd.exe. If you don't know what that means, it's probably ok. If you want to change that behavior, you can edit the LibreChat.bat in the installation folder.

## Disclaimers

*This script installs third-party software. By using this script you certify that you have read and agree with the license agreements and restrictions of any software installed by this script.*

This is only an installation script for LibreChat. A project created by @danny-avila. A huge thanks to him and the other contributors for their constant updates on the project!

If you want to contribute to LibreChat or report any issues about the main project, you can visit the GitHub repository at [danny-avila/LibreChat](https://github.com/danny-avila/LibreChat) or join the community on [discord](https://discord.gg/NGaa9RPCft).

For manual installation instructions or to use another method of installation visit the [main project page](https://github.com/danny-avila/LibreChat).

If you have issues with this specific installation script you contact me directly on the main project's [discord server](https://discord.gg/NGaa9RPCft).

## Credits

This script was created by [Fuegovic](https://github.com/fuegovic), an amateur developer and a musician/producer. You can check out his music on [Bandcamp](https://fuegovic.bandcamp.com/) or [Spotify](https://open.spotify.com/artist/3ZfaxdODbE1NrfQYsGO92R).

This install script and the resulting install of [LibreChat](https://github.com/danny-avila/LibreChat) uses [ChatGPT](https://chat.openai.com/) APIs, as well as [MeiliSearch](https://www.meilisearch.com), [MongoDB](https://www.mongodb.com), [Ngrok](https://ngrok.com/), and other open source libraries. All rights reserved to their respective owners.

## License

MIT License

Copyright (c) 2023 Fuegovic

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
