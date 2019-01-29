## Windows - Cmder

<img src='http://making-the-internet.s3.amazonaws.com/sysadmin-cmder@2x.png' style='max-width:920px; width:100%'>

*Cmder* is a Windows front-end for the standard Windows Command Shell (aka `cmd.exe`).

In this course, we'll use a special build of Cmder that has the following benefits/customizations:

+ Uses a version of Cmder that is tested across multiple systems
+ Includes [`elevate`](http://code.kliu.org/misc/elevate/) to easily run commands as an admin
+ Includes [`nano`](https://en.wikipedia.org/wiki/GNU_nano), a simple command line text editor

<strong style='background-color:yellow; display:block; padding:5px;'>
Download the dwa15 build of Cmder:<br> <a href='https://github.com/susanBuck/cmder/archive/master.zip'>https://github.com/susanBuck/cmder/archive/master.zip
</a>
</strong>


## Installing
Cmder is designed as a "stand-alone" application, meaning it can be run from any directory on your computer. While most applications in Windows would live in your `C:\Program Files`, this is not a good location for Cmder since that directory requires administrative access, which will prevent Cmder from performing certain actions.

Knowing that, my recommendation is to place Cmder in your `C:\` directory for simplicity.

To do this, right click the downloaded `cmder-master.zip` file and choose *Extract all*...

<img src='https://s3.amazonaws.com/making-the-internet/command-line-cmder-extract-all@2x.png' alt='Extracting Cmder'>

Then set the destination to `C:\`

<img src='https://s3.amazonaws.com/making-the-internet/command-line-cmder-destination@2x.png' alt='Where to extract Cmder'>

Extraction may take several minutes.

Within the resulting extracted folder `C:\cmder-master\`, you'll see the Cmder executable `Cmder.exe` which can be double clicked to launch the program.

<img src='https://s3.amazonaws.com/making-the-internet/cmder-in-destination@2x.png' alt='Launching Cmder'>

(I recommend pinning `cmder.exe` to your start and/or task bar to make it easily accessible.)

That's all you need to do to get Cmder rolling. The rest of this doc includes some notes about how Cmder is customized, but requires no action on your part.


## Basic settings
Basic Cmder interface settings are done via (`Win + Alt + P`) the *Settings* menu found via the menu icon on the bottom right.


## Aliases
Aliases are stored in `/config/user-aliases.cmd`.

Run `alias name=full command` to create an alias, or edit `/config/user-aliases.cmd`.


## Creating your own commands
Create new commands via text files with the `.bat` extension inside `bin/`.

For an example, see the `alias.bat` file that creates the `alias` command.
