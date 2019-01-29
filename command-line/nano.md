# Nano

Nano was briefly covered in the Primer section, but let's take a closer look at why you would want to use nano, and instructions on how to use nano as an administrator.

## Why use a command line text editor?

There are many ways you can edit text files on your computer. You can use your favorite code editor, or a plain text editor like TextEdit (Mac) or Notepad (PC). Alternatively, you can use a command line based text editor such as nano, vim, or vi.

Some developers love command line editors, others prefer GUI (graphical user interface) text editors. If you're in the latter category, there will still be times when you need to use a command line text editor because a GUI editor will have limitations. For example:

1. Some files are locked and need administrator privileges to alter; your GUI editor may let you open the file, but it won't let you save.

2. You can't find the file you need to edit because it's hidden or in a hard-to-locate system path.

3. You're SSH'd into a live server where you can't open files directly in your GUI.

Given this, it's important to feel comfortable with a command line text editor. For our purposes, we'll use **nano**. It's not the most powerful command line text editor, but it'll get the job done and it's the simplest to work with.

If you are already an experienced command line user with a favorite text editor, there's no reason you have to switch to nano; stick with what you're comfortable with.

But if you're new to this, my examples will use nano, so below are instructions you'll want to get comfortable with.


## Opening files
You can initiate editing a file like this:

```bash
$ nano example.txt
```

In this example, we're working with a file called `example.txt` that has the contents `Hello World!` in it.

Once you initiate nano on this file, you should see this:

<img src='https://s3.amazonaws.com/making-the-internet/sysadmin-nano-example-txt@2x.png' class='' style='max-width:989px; width:100%' alt=''>

Once your file is open in nano you can start making edits. Use the arrow keys on your keyboard to navigate around the file.




## Saving
Nano uses keyboard shortcuts that all start with the *ctrl* key. In documentation, the shortcuts are always prefixed with a `^` character.

For example, if you see `^X` it means hit `ctrl` + `X`; this command allows you to exit the file you're currently editing.

After hitting `^X` it will ask you if you want to save. Type the letter `y` for yes and then hit *Enter*.

<img src='http://making-the-internet.s3.amazonaws.com/sysadmin-nano-edit@2x.png' class='' style='max-width:989px; width:100%' alt=''>




## Other commands
For a reference list of all available commands use `^G` (Help). You can also refer to the [nano documentation](https://www.nano-editor.org).

Here are some commands I find I use most frequently:

+ `^K` Cut/delete a line
+ `^A` Go to the start of a line
+ `^E` Go to the end of a line


## Edit as admin
Some files require administrator privileges to edit. You can examine the permissions of a file to find out if it does need admin privileges, or you'll simply find out when you go to edit a file as a regular user and you're told you don't have access.

On Mac/Unix environments, you can prefix your `nano` command with [sudo](http://ss64.com/osx/sudo.html) to run the command as a *super user*:

```bash
$ sudo nano example.txt
```

In Windows/Cmder, you can use the [elevate](http://code.kliu.org/misc/elevate/) command:

```bash
$ elevate nano example.txt
```
