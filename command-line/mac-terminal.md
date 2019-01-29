# Mac - Terminal
On Macs, Command Line is accessed via an included application called **Terminal**.

Find it in `/Users/ComputerName/Applications/Utilities/` or just type `Terminal` into Spotlight.

The following instructions show some customizations you can do with Terminal. Implementing these changes are not required for this course, but doing so will teach you some neat tricks, and give you practice interacting with CL.

## Customizing
There are customizations you can make to your Command Line program that will make your day-to-day use easier.

For example, you can configure...

+ your prompt (i.e., the line you see where you enter commands)
+ the message you see when you first open Terminal
+ aliases you can use to make long commands shorter
+ your PATH variable

Configurations can be made via the system file `~/.bashrc`.

To get started, copy the contents of this [.bashrc template](https://gist.github.com/susanBuck/ee3a0a53d72198c1a244).

Next, open `~/.bashrc` with *nano* (a basic Command Line text editor), prefixing the command with `sudo` so that the file is opened with administrator priveleges: 

```bash
$ sudo nano ~/.bashrc
```

At this point, you'll see the contents of your `~/.bashrc` file which may or may not be empty. If it's empty, paste in the contents of the above-linked template. If it's not empty, paste in the template contents *after* what is already there.

Save your changes in nano by hitting `ctrl` + `x`.

Nano will ask you if you want to *Save modified buffer*. Type the letter `y` to confirm that you do.

Nano will confirm what filename the changes will be saved to&mdash; in this case `.bashrc`. Hit enter to confirm the save.

Next, edit a system file called `~/.bash_profile` and tell it to load `~/.bashrc`.

Open `~/.bash_profile` in nano:

```bash
$ sudo nano ~/.bash_profile
```

Paste in this code:

```bash
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
```

Hit `ctrl` + `x` to save and exit.
Type the letter `y` to confirm you want to save.

__Close and re-open Terminal for the changes to take effect.__

If everything works, you should see something like this when you open Terminal:

<img src='https://s3.amazonaws.com/making-the-internet/sysadmin-after-bashrc@2x.png' style='max-width:526px; width:100%' alt='After adding .bashrc script'>

Read through the template file, as it's commented and explains everything it does.

That being said, below are some highlights. You don't need to do anything - as everything described is already set up for you in the given `.bashrc` template.






## Aliases
Aliases provide shortcuts to commonly used commands.

For example, in the template there's an alias called `ll` that calls the list command (`ls`) with commonly used flags (shows file types, colors the output, etc.):

```bash
alias ll="ls -laFG"
```

You can create aliases for commonly used commands, like SSH'ing into a server:

```bash
# Example alias for SSH'ing into a server
alias myserver="ssh user@111.111.111.111"
```

...Or getting to a frequently accessed directory:

```bash
# Example alias for quickly getting to a commonly used directory
alias htdocs='cd /Applications/MAMP/htdocs'
```

See the section under *Aliases* in the `.bashrc` file for full details.




## Prompt

The prompt is the line you see whenever CL is waiting for a command. In the template `.bashrc`, the prompt is configured to show you your current directory, plus, if you're in a directory that is a Git repository, it'll show you which branch you're on and if there are any changes to that branch.

<img src='https://s3.amazonaws.com/making-the-internet/sysadmin-prompt-customizations@2x.png' style='max-width:802px; width:100%;'>
