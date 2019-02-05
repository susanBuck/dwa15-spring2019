## Repository setup
To recap what we've done so far:
+ Git is installed and confirmed working on your computer
+ You have an account at Github.com and you are able to SSH into it

Next, we want to create our first application, set it up as a Git repository, and connect it to Github.com.

We'll start by creating a practice application called `Hello World` ([reference](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program)), within your `htdocs` folder.

To do this, first navigate into the `htdocs`  folder:

__Mac__ users:
```bash
$ cd /Applications/MAMP/htdocs/
```

__Windows__ users:
```bash
$ cd c:\xampp\htdocs
```

Then, create a new directory called `hello-world` and navigate into it

```bash
$ mkdir hello-world
$ cd hello-world 
```

Next, before we add anything else to this application, we want to set it up as a git-tracked directory, so run the command `git init`:

```bash
/Applications/MAMP/htdocs/hello-world   $ git init
Initialized empty Git repository in /Applications/MAMP/htdocs/hello-world/.git/
```

Once you've done this, if you view the contents of the directory (including hidden files), you should see a new subdirectory called `.git`:

```bash
/Applications/MAMP/htdocs/hello-world   $ ls -la
total 8
drwxr-xr-x   4 Susan  admin  128 Feb  4 18:43 .
drwxrwxr-x   9 Susan  admin  288 Feb  4 18:42 ..
drwxr-xr-x  10 Susan  admin  320 Feb  4 18:43 .git
```

You don't have to do anything with this new directory, just understand that that is where Git will store all of the files it uses to track changes to your repository. (Given this, if you ever wanted to "de-git" a directory, you would just delete that `.git` directory).

Moving forward, let's add some content to this new application by creating a few file called `index.php`, with the following HTML code: 

```
<!DOCTYPE html>
<html lang='en'>
<head>

    <title>Hello World</title>
    <meta charset='utf-8'>

</head>
<body>
    <h1>My Hello World Application</h1>
</body>
</html>
```

Once this file is created, run the command `git status` and git will tell you what changes it detects in your directory. You should see something like the following:

```
/Applications/MAMP/htdocs/hello-world   $ git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	index.php

nothing added to commit but untracked files present (use "git add" to track)
```

As you can see, git detects the addition of our new file. We want git to track changes to this file, so we'll use the git command [`add`](https://git-scm.com/docs/git-add) to *stage* the file:

```bash
git add index.php
```

Next, run `git status` again to see that the `index.php` file is now being tracked, and is ready to be committed.

```
/Applications/MAMP/htdocs/hello-world   $ git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   index.php
```

In git terms, when we make a `commit` we're saving a snapshot of the project's currently staged changes.

A metaphor I like to use:
+ Adding/staging files is like when we put items in our shopping cart in a store
+ Comitting is when we go through the checkout with those items 

Make your first commit with the following command:

```bash
git commit -m "Created an index file"
```

Every commit you make needs a message that describes what change is happening to your codebase in that commit. Here we include that message as part of the commit by using the `-m` (message) flag, and the message we're assigning to this commit is `"Created an index file"`.

After you do your commit, do another `git status` and note how it no longer recognizes any changes to your repository, because they have now been committed.

```bash
/Applications/MAMP/htdocs/hello-world   $ git commit -m 'Added index file'
[master (root-commit) 227f666] Added index file
 1 file changed, 12 insertions(+)
 create mode 100644 index.php
/Applications/MAMP/htdocs/hello-world (master)  $ git status
On branch master
nothing to commit, working directory clean
```


## Connect local repository to repository on Github.com
At this point, the next setup task we want to take care of is connecting our local repositories to a repository on Github.

To do this, start by [creating a new repository](https://github.com/new) in Github.com.

Name the repository `hello-world`, leave all the other options as-is, and click *Create repository*.

<img src='https://s3.amazonaws.com/making-the-internet/vc-hello-world-repository-on-github.png' style='max-width:400px;' alt='Creating a new repository on Github.com'>

Once this repository exists on Github.com, you'll see that the SSH path to this repository is something like `git@github.com:yourUsername/hello-world.git`.

<img src='https://s3.amazonaws.com/making-the-internet/vc-note-ssh-path.png' style='max-width:549px;' alt='Finding the repository SSH path in Github'>


With this address copied, turn back to your `htdocs/hello-world` directory on your local machine and run the following command:

```bash
git remote add origin git@github.com:yourUsername/hello-world.git
```

This adds a new git [`remote`](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) called `origin` that points to the address of your repository on Github.com (`git@github.com:yourUsername/hello-world.git`). 

In git terms, a `remote` repository is a version of your project that is hosted on the Internet or some network.

We called this remote `origin`, which is a common naming convention for the primary remote of a project.

Next, run this git [`push`](https://git-scm.com/docs/git-push) command:

```
git push -u origin master
```

In this command, we're *pushing* the current state of our `master` branch to our remote `origin`.

(In git, you can create different [branches](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell) of your code, but in this course we'll always work with just a single branch which is called `master` by default.) 

By including the flag `-u`, it will make it so that in future pushes, it will default to the remote `origin` and the branch `master`. This means, that for any future *pushes*, we can simplify this command to `git push`.

At this point, the commit you made locally should now be sync'd up with your remote repository on Github.com. You can confirm this by refreshing your repository there, where you should now see your index.php file and the record of *1 commit*

<img src='https://s3.amazonaws.com/making-the-internet/vc-first-commit-on-github.png' style='max-width:556px;' alt='First commit on github.com'>


## Summary
`mkdir hello-world` Create the application, starting with an empty directory
`cd hello-world` Move into the directory
`git init` Initialize the directory as a git repository
`nano index.php` Create your first file, paste in code, save
`git add index.php` Stage index.php file
`git commit -m "Created an index file"` Create a new commit
`git push -u origin master` Push the new commit to the origin remote from the master branch.
 


## Tip
If something went wrong with with the above steps and you want to start over:

1. Follow the steps under the *Delete* section in your repo's settings on Github.
2. Remove the `hello-world` directory on your computer from your document root folder.

