## Command line primer

Now that you're set up, fire up Terminal or Cmder and let's do some Command Line practice.

In the following notes, you'll follow along with a series of commands. In all the notes, each command is prefixed with a `$` to signify that the line is being run in command line. You don't have to actually type in the `$`.


## Navigating around directories

One of the things you'll do most in CL is work with files on your computer and navigate around directories.

When you first open Terminal/Cmder you should be in your home directory, and you can confirm this by typing in the command `pwd` which is short for *present working directory*, i.e. *where am I?*

In my case, on a Mac I see this as a result of `pwd`:

```bash
$ pwd
/Users/Susan
```

On Windows, I see this:

```bash
$ pwd
c:\Users\Susan
```

Next, type in the command `ls` (list) which will show you everything in your home directory.

One of the directories you should see listed is your Desktop.

Move to your Desktop folder using the `cd` (change directory command).

```bash
$ cd Desktop
```

Use the `ls` (list) command again to see the contents of your Desktop:

```bash
$ ls
```

On the desktop let's create a new, empty directory using the `mkdir` command. We'll call the directory `practice`.

```bash
$ mkdir practice
```

Now, move into this new directory:

```bash
$ cd practice
```

You can use the `pwd` command again to confirm you're in the `practice` folder.

```bash
$ pwd
/Users/Susan/Desktop/practice
```

## Creating text files

In our new practice directory, let's create a new file called `example.txt` with the `touch` command:

```bash
$ touch example.txt
```

Use the `ls` command again to see that the file was created:

```bash
$ ls
example.txt
```

Now let's edit this file...

## Editing text files with nano

To edit text files directly from the command line, you can use the simple CL text editor called nano. Nano is installed by default on Mac and is built into the Cmder program we're using in this class.

```bash
$ nano example.txt
```

Enter the text `This is just a test` into the file.
Then, here are the steps to save your changes in nano:

1. Hit `ctrl` + `x` to save your changes.
2. Nano will ask you to type in the letter `y` to confirm your save.
3. After typing in `y`, hit Enter.

To confirm your changes were made, you can use the `cat` (concatenate) command which will output the contents of any text file directly in the console:

```bash
$ cat example.txt
This is just a test
```

Try opening `example.txt` in nano again, making some edit to the text and saving again. Use `cat` to confirm your save worked.


## Deleting text files

We've created a file, we've edited it, now let's delete it by running this command:

```bash
$ rm -i example.txt
remove example.text? (type 'y' for yes and hit Enter)
```

Note the addition of the `-i`... this is a **flag** which is how you send extra instructions when using commands.

In this case the `i` flag is short for `interactive`, meaning it'll ask you before deleting files. It's a good habit to use the `i` flag when working with `rm` so you don't accidentally delete anything you didn't mean to.


## Using man pages

__Mac users__: To learn more about any of the commands so far, you can type `man` followed by the command name. This will tell you how to use the command and all the flag options you have. These &ldquo;manuals&rdquo; are called &ldquo;man pages&rdquo; and they exist for almost all command line programs.

```bash
$ man rm
```

The output from the `man` command will often span multiple screens. Use the `Enter` key to page through the output, or hit `ctrl` + `z` to exit.

__Windows/Cmder users__: Unfortunately `man` does not work in Cmder, but you can learn more about common commands by typing them in at [ExplainShell](http://explainshell.com/).


## Cleaning up
Before we wrap up, let's clean up the `practice` directory we created.

First, run the following command to move up one directory (i.e., out of the `practice` directory):

```bash
$ cd ../
```

Confirm you're back on your Desktop:

```bash
$ pwd
/Users/Susan/Desktop
```

And now remove `practice`:

```bash
$ rm -ir practice
```

Note the addition of the `r` flag, which is needed for recursively removing directories and their contents.


## Aliases
In the notes on Windows Cmder and Mac Terminal, I touched on aliases which allow you to create shortcuts for commands.

For example, a command you'll see me using in lecture is `ll`. This is just an alias for the command `ls -laFG` (`ls` with flags that make the output optimal for reading).

This is a common alias many system administrators use. Given that, I built it into the course version of the Cmder app and the instructions for configuring Mac Terminal.

## In conclusion...
There is a lot more you can do in CL besides working with files and directories. The above exercise was just to get you familiar with working with commands and some basic directory navigation.

See [Common Commands](/command-line/common-commands.md) for a quick cheat sheet on all the commands used above.
