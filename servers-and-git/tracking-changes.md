## Tracking changes
With your local repository set up and connected to your remote repository at Github.com, you're ready to start tracking changes to your project.

Everything we have done to this point has been setup steps that you only do once when starting a new project. Everything that follows reflects the kind of Git work you'll do on a day-to-day basis.

Within your `hello-world` directory, run `git status`:

```xml 
$ git status
```

At this point, there should not be any changes of note, as you haven't made any modifications to the `hello-world` repository.

Example output:
```xml
/Applications/MAMP/htdocs/hello-world $ git status
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
```

Let's make a change to demonstrate how git works.

Make an edit to the `README.md` file, amending the title to read:

```xml
# Practice repository for DWA
```

With that change saved, run `git status` again, and it should pick up on the change:

Example:
```xml
/Applications/MAMP/htdocs/hello-world $ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

Let's imagine this was some important change to the code base, and we'd like to check those changes into our version control history.

To do this, we'll **stage** (aka `add`) this new file with the following command:

```bash
$ git add README.md
```

Now, run `git status` again, and you should see you have a file waiting to be committed:

```bash
$ git status
```

Example output:
```xml
/Applications/MAMP/htdocs/hello-world $ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   README.md
```

Next, **commit** this change using the `commit` command, plus the `-m` flag which indicates we'll also be including a commit message:

```bash
$ git commit -m "Modified title in README file."
```

Example output:
```xml
/Applications/MAMP/htdocs/hello-world $ git commit -m "Modified title in README file."
[master 1cb73b6] Modified title in README file.
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Finally, push this commit to Github.com with the following command:

```bash
$ git push
```

Example output:
```xml
/Applications/MAMP/htdocs/hello-world $ git push
Counting objects: 3, done.
Writing objects: 100% (3/3), 290 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To github.com:susanBuck/hello-world.git
   e646ab3..1cb73b6  master -> master
```

Double check this change made it to Github.com by refreshing your repository's page.


## Practice
Let's run through that procedure again, but this time we'll make three changes:

First, edit your `README.md` file again adding the URL for this course below your title:

```md
# Practice repository for DWA
<https://dwa15.com>
```

Second, find an image (any image will do) and save it in a new directory called `/hello-world/images/`. You'll see with this example how git can track changes to files other than code/text, such as images.

Finally, create a new file called `index.php` and include the following code, replacing the `src` and `alt` attributes with your own image details:

```html
<h1>Hello World!</h1>
<img src='/images/kitten.jpeg' alt='Adorable kitten'>
```

(Don't worry about viewing this HTML code in the browser yet; we'll address that in the next note set).

After making these three changes, run `git status` to see the results.

Now let's track these changes in Github.

You can stage the files one at a time:

```xml
$ git add README.md
$ git add images/kitten.jpeg
$ git add index.php
```

Or you can use this command to stage any changed or new files:

```xml
$ git add --all
```

Once your changes are staged, commit:

```xml
$ git commit -m "Update README file; added index file with an image."
```

And finally, push your commit:

```bash
$ git push
```

Check your repository in Github.com to make sure the commit is there.


## Recap
From [gitref.org](http://gitref.org/basic):

>> &ldquo;Git is all about composing and saving snapshots of your project and then working with and comparing those snapshots.

>> An important concept here is that Git has an *index*, which acts as sort of a __staging area__ for your snapshot. This allows you to build up a series of well composed snapshots from changed files in your working directory, rather than having to commit all of the file changes at once.

>> In a nutshell, you will use `git add` to start tracking new files and also to stage changes to already tracked files, then `git status` and `git diff` to see what has been modified and staged and finally `git commit` to record your snapshot into your history. This will be the basic workflow that you use most of the time.&rdquo;


## Vocabulary review

From: <https://help.github.com/articles/github-glossary>:

### Git
Git is an open source program for tracking changes in text files. It was written by the author of the Linux operating system, and is the core technology that GitHub.com [...] is built on top of.


### Stage aka *add*
In Git, you have to add file contents to your staging area before you can commit them. If the file is new, you can run `git add` to initially add the file to your staging area, but even if the file is already &ldquo;tracked&rdquo; - i.e., it was in a previous commit - you still need to invoke git add to add new modifications to your staging area.


### Commit
A commit, or "revision", is an individual change to a file (or set of files). It's like when you save a file, except with Git, every time you save it creates a unique ID (a.k.a. the "SHA" or "hash") that allows you to keep record of what changes were made when and by who. Commits usually contain a commit message which is a brief description of what changes were made.

### Push
Pushing refers to sending your committed changes to a remote repository such as GitHub.com. For instance, if you change something locally, you'd want to then push those changes so that others may access them.


### Pull
Pull refers to when you are fetching in changes and merging them. For instance, if someone has edited the remote file you're both working on, you'll want to pull in those changes to your local copy so that it's up to date.


## Tips
* If you get a message about `src refspec master does not match any.` after trying to push&mdash; it means you have not yet created a commit.

* `git status` is a command you should take advantage of frequently; it will give you a sense of what's going on in your repository: what has changed, if any files are untracked, etc.

* `git diff` is another useful command to show what changes have been made. You can see all changes with just `git diff` or see just the changes on a particular file with `git diff <file>`.

* If you want to undo changes made to a file that haven't yet been staged, you can use the command `git checkout <file>`.

* If you stage a file but decide you want to unstage it, run this command: `git reset HEAD <file>`. This won't revert any changes to that file (that's what `checkout` does), it will just remove it from staging.

* If you delete a file from a project, you'll use the `git rm <file>` command instead of `git add <file>`.
