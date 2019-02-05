# Git tips and troubleshooting

## Tip: Hard Resetting - &ldquo;Pull in case of emergencies&rdquo;
If you ever find yourself backed into a corner with lots of merges and conflicts you're having a hard time resolving, there's a solution which will update your working repository to match your repository on Github.

**Warning: this will overwrite any changes you might have had in your working repository.** Given this, you only want to do this in situations where you're okay with losing any changes in your working repository.

The most common scenario for this is when your know your Github repository has the code exactly as you want it, but your local or live repository got messed up with changes you don't actually want to make.

Warning aside, on to the commands:

```bash
$ git fetch --all
$ git reset --hard origin/master
```

(replace `origin` with the name of your remote)

`git fetch` downloads the latest from remote without trying to merge.

`git reset` resets the master branch to what you just fetched.

Read more: [How to undo (almost) anything with Git](https://github.com/blog/2019-how-to-undo-almost-anything-with-git)


## Tip: Ignore a file that's already being tracked in a repository
```bash
$ git update-index --assume-unchanged name_of_file.txt
```


## Tip: You're told your branch is ahead by x commits
Example:

```bash
# On branch master
# Your branch is ahead of 'origin/master' by 5 commits.
#
nothing to commit (working directory clean)
```

This isn't indicative of any major problem but can be cleared up with the following command:

```bash
$ git fetch origin
```

Fetch seems to update the local representation of the remote branch, which doesn't necessarily happen when you do the git pulls.

Note, this only happens when you do `git pull` not `git pull`

Reference:
[1](http://stackoverflow.com/questions/14835515/local-git-clone-is-ahead-of-origin-even-though-no-local-changes-were-made) |
[2](http://stackoverflow.com/questions/2432579/git-your-branch-is-ahead-by-x-commits)


## Tip: Is this directory a repo?
You can tell if a directory has been set up as a repo because it will have a `.git` folder in it.

Use the `ls -la` command to see the contents of a directory, including hidden files (which the `.git` folder is).

Alternatively, you can run the `git status` command and it will let you know if the current directory is or isn't a repo.


## Troubleshooting: (Mac) When you try to use any git command, you're told git is not installed

Symptoms look like this:

```bash
$ git
-bash: git: command not found
```

First thing to try: Double check you completely closed and re-opened Terminal window after installing Git.

If that doesn't fix it...

This issue has only turned up on Macs so far, so the following instructions apply to Mac users:

See if the files for Git exist on your machine. The common git installation location on a Mac is in the `/usr/local/dir` directory. See if you can move into that directory:

```bash
cd /usr/local/git/
```

Either it will work, or it will tell you that directory does not exist:

```bash
-bash: cd: /usr/local/git/: No such file or directory
```

If it does not exist it's possible you may have missed the step of installing git. Confirm you visited [the git download page](http://git-scm.com/downloads) and downloaded Git.

If it does exist, the problem could be that your computer doesn't know the path to Git. Let's fix that.

Run this command to edit your `~/.bashrc` file using nano:

```bash
sudo nano ~/.bashrc
```

At the end of the `~/.bashrc` file, add this line:

```bash
export PATH=$PATH:/usr/local/git/bin/
```

Save and close your file, then run this command to refresh the `~/.bashrc` file:

```bash
source ~/.bashrc
```

Now, try running a git command again.

<small>
Source: ([mountain-lion-git-command-not-found-2-min-fix](http://dwainm.wordpress.com/2012/12/19/mountain-lion-git-command-not-found-2-min-fix/))
</small>



