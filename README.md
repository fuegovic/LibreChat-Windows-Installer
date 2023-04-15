# ChatGPT-Clone Install Script

This script automates the local Windows 64 bits installation of :

[GitHub - danny-avila/chatgpt-clone](https://github.com/danny-avila/chatgpt-clone)

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Disclaimers](#disclaimers)
- [License](#license)
- [Credits](#credits)

## Requirements

This script requires Windows 10 64 bits, version 21H1 or higher.

## Installation

**TL;DR**

* Download the zip file ⤴️

* Extract the zip file

* Double click on install.bat and follow the on-screen instructions

* Use the `ChatGPT Clone` shortcut on your desktop to start or update the project

* Profit!

**Details**

Download the .zip file and extract anywhere on your computer or use git to clone this project on your computer.

Run the install.bat file and follow the on-screen prompts. This script will:

* Install [Git](https://git-scm.com/download/win) (if needed)
* Update [Node.js](https://nodejs.org/en) (if needed)
* Clone the [ChatGPT-Clone](https://github.com/danny-avila/chatgpt-clone) repository from GitHub
* Install [MeiliSearch](https://www.meilisearch.com)
* Install [Ngrok](https://ngrok.com)
* Guide you through the process of acquiring the required [MongoDB URI](https://www.mongodb.com), [OpenAI API key](https://platform.openai.com/account/api-keys), and [BingAI Access Token](https://www.bing.com/)
* Provide a bat file to run and update ChatGPT-Clone

**Warning :** You will have to press a key to continue multiple times during the process



**If you already have your MongoDB URI, OpenAI API key, or BingAI Access Token you can fill the `config.ini` file to skip these steps during the installation**

```ini
[Database]
;mongo_uri = <your connection string>

[API]
;openai_key = <your OpenAI key>
;bingai_token = <your Bing token>
```

Alternatively, you can pass the same values as named parameters when running the script from a powershell terminal. For example:

```powershell
.\main.ps1 -mongo_uri "mongodb://127.0.0.1:27017/chatgpt-clone" -openai_key "sk-123456789...321" -bingai_token "a1b2c3d4e5...f6g7"
```

The use of either the config file or the parameters is optional. If you don't provide them, the script will ask you to enter them manually.

## Note

If you just want an easy way to start and update [ChatGPT-Clone](https://github.com/danny-avila/chatgpt-clone) you can use `template.bat` in the dependencies directory and modify it to fit your needs.

By default the max indexing memory is set to 8Gb, you can set it to any value you want or removing altogether by editing the bat file. (template.bat before install or ChatGPT-Clone.bat in the install directory. search for the 2 lines with `--max-indexing-memory 8192` )

## Usage

When you are done you should have a working installation of [ChatGPT-Clone](https://github.com/danny-avila/chatgpt-clone).

Go to your desktop and use the shortcut `ChatGPT Clone` to start and/or update the project

**On the first screen**

- **1** Start the local server, accessible at [http://localhost:3080](http://localhost:3080)

- **2** Start the local server and the ngrok tunnel giving you a public url that you can share or use to connect from another device

- **3** Update the chatgpt-clone project to the latest version

- **4** Close everything for you

<img title="" src="file:///C:/Users/fueg/Desktop/install/Images/Menu1.jpg" alt="Menu1.jpg" width="680" data-align="inline">

**On the second screen**

- In blue you have the URL(s) where you can access ChatGPT-Clone

- **1** Open a local web-app version of ChatGPT-Clone

- **2** Close everything for you

<img title="" src="file:///C:/Users/fueg/Desktop/install/Images/Menu2.jpg" alt="Menu2.jpg" width="635">

**Warning :** The exit procedure is pretty aggressive and will close all instance of node.exe and kill cmd.exe. If you don't know what that means, it's probably ok. If you want to change that behavior, you can edit the ChatGPT-Clone.bat in the installation folder.

## Disclaimers

This is only an installation script for ChatGPT-Clone, a project created by @danny-avila. A huge thanks to him and the other contributors for their constant updates on the project!

If you want to contribute to ChatGPT-Clone or report any issues about the main project, you can visit the GitHub repository at [danny-avila/chatgpt-clone](https://github.com/danny-avila/chatgpt-clone) or join the community on [discord](https://discord.gg/NGaa9RPCft).

For manual installation instructions or to use another method of installation visit the [main project page](https://github.com/danny-avila/chatgpt-clone).

If you have issues with this specific installation script you contact me directly on the main project's [discord server](https://discord.gg/NGaa9RPCft).

## Credits

This script was created by [Fuegovic](https://github.com/fuegovic), an amateur developer and a musician/producer. You can check out his music on [Bandcamp](https://fuegovic.bandcamp.com/) or [Spotify](https://open.spotify.com/artist/3ZfaxdODbE1NrfQYsGO92R).

This install script and the resulting install of [ChatGPT-Clone](https://github.com/danny-avila/chatgpt-clone) uses [ChatGPT](https://chat.openai.com/) and [Bing](https://www.bing.com/) APIs, as well as [MeiliSearch](https://www.meilisearch.com), [MongoDB](https://www.mongodb.com), [Ngrok](https://ngrok.com/), and other open source libraries. All rights reserved to their respective owners.

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

<small>[Requirements](#requirements)
[Installation](#installation)
[Usage](#usage)
[Disclaimers](#disclaimers)
[License](#License)
[Credits](#credits)</small>

<small>[ChatGPT-Clone](https://github.com/danny-avila/chatgpt-clone)
[ChatGPT-Clone's discord server](https://discord.gg/NGaa9RPCft)
[Fuegovic' Github](https://github.com/fuegovic)
[Fuegovis's Bandcamp](https://fuegovic.bandcamp.com)
[Fuegovic's Spotify](https://open.spotify.com/artist/3ZfaxdODbE1NrfQYsGO92R)
[ChatGPT](https://chat.openai.com/)
[Bing](https://www.bing.com)
[MeiliSearch]([https://www.meilisearch.com](https://www.meilisearch.com)
[MongoDB]([https://www.mongodb.com](https://www.mongodb.com)
[Ngrok](https://ngrok.com)</small>
