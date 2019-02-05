## Git via the command line
Git is a command line tool, but there are many applications that allow you to locally execute Git commands via a graphical interface.

<img src='https://s3.amazonaws.com/making-the-internet/vc-git-app-vs-command-line@2x.png' style='max-width:1030px;' alt=''>

In this course, we'll use the command line to operate Git; reasoning:

+ Using git via command line is operating system independent; after setup, it's the same on Mac, Windows, Linux.
+ We can't use a graphical interface on our production servers, so we might as well get comfortable with command line git on local.


## See if Git is installed
First, see if your computer already has Git installed by running the `git` command:

```bash
$ git
```

If you see output similar to the following screenshot, it means Git is installed and you're good to go; skip down to the section titled *Initial Git Configuration*.

*Git is installed:*

<img src='https://s3.amazonaws.com/making-the-internet/vc-git-success@2x.png' style='max-width:589px; width:100%'>

If, however, you see an error telling you the command `git` is not recognized or not found, you'll need to install Git, as described in the next section.

Windows Users: The course build of Cmder that I provided comes bundled with Git, so it should be installed already.


## Download and install Git
If Git is *not* yet installed on your computer, visit the [download page](http://git-scm.com/downloads) and choose your operating system. Download the appropriate program and run through installation.

**Once installation is complete, close and re-open your command line program.**

Now, try the `git` command again. Do you see a bunch of instructions and commands related to Git? Good, you're all set!

If you don't&mdash; are you sure you completely closed and re-opened your command line program?

If you're running an **older operating system** and the latest Git build doesn't work, you may have to try an older version of git. [You can find older builds of Git here.](https://sourceforge.net/projects/git-osx-installer/files/?source=navbar)

__Tips:__

Find out what version of git you're running:
```bash
$ git --version
```

Find out where git is installed on Mac:

```bash
$ which git
```

Find out where git is installed on Windows/Cmder:

```bash
$ where.exe git
```


## Initial Git configuration
Once you've confirmed Git is installed, you need to do some initial setup.

Run the following commands to set a user name and email key to be associated with any Git actions taken from your computer. Replace the name and email with your own details. The details you enter here does not have to match the credentials you use on Github, but it's okay if they do.

```bash
$ git config --global user.name "Sam Seaborn"
$ git config --global user.email sam@gmail.com
```

Next, run the following command to make Git output color coded (i.e. easier to read):
```bash
$ git config --global color.ui true
```

Next, run this command so that Git will ignore filemode (permission) changes:
```bash
$ git config --global core.filemode false
```


Next, tell Git to use *nano* as the default command line text editor. If you have another favorite CL text editor, you can use that instead.
```bash
$ git config --global core.editor nano
```


Finally, we want to configure how Git handles line endings in files. For this, we'll follow the [github.com's recommendations](https://help.github.com/articles/dealing-with-line-endings)....

Mac/Linux users should run this command:
```bash
git config --global core.autocrlf input
```

And Windows users should run this command:
```
git config --global core.autocrlf true
```



### Config tips
If you want to see what one of your git configs are set to, use `git config` followed by the particular configuration you want to read. For example, to double check your user.name, run:

```bash
$ git config user.name
```

You can also see *all* your configs with this command:

```bash
$ git config --list
```


## Summary
Git should now be installed on your computer.

This is a one-time setup, so once it's working you shouldn't have to worry about these procedures again this semester.

## Reference
+ [help.github.com/Dealing with line endings](https://help.github.com/articles/dealing-with-line-endings)
+ [Getting Started - First-Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
+ [Mind the end of your line](http://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line)


