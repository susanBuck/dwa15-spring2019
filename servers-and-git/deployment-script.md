# Deployment script
Note: Setting up a deployment script for your projects in this course is __optional__. If you don't wish to dig into shell scripting, you can continue to deploy using the manual procedures covered in Weeks 1 and 2.

## Preface
When we're ready to deploy changes to our production servers, we start by locally adding and committing all files we wish to deploy, for example:

```bash
$ git add --all
$ git commit -m "Added form validation"
```

Then, we run the following 5 commands to deploy these changes on our production servers.

1. Push changes to our master repository in Github:
```bash
$ git push
```

2. SSH into the production server:
```bash
$ ssh root@ip.address
```

3. Move into the project directory (Laravel project `foobooks` used here as an example):
```bash
$ cd /var/www/html/foobooks
```

4. Pull the latest changes:
```bash
$ git pull
```

5. Update packages (if a Laravel-based project):
```bash
$ composer install --no-dev
```

Running these 5 commands can be streamlined into a single command via a __deployment script__.

A deployment script is a [shell script](https://www.panix.com/~elflord/unix/bash-tute.html) (i.e. a command line script) that lets you group together a series of commands you want to run when deploying changes to your application on production.

Our deploy script, when run, will produce output similar to this:

```xml
/Applications/MAMP/htdocs/foobooks $ git deploy
Detected location: local

Running git status -------------------
On branch master
Your branch is up-to-date with 'origin/master'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)

    test.txt

nothing added to commit but untracked files present (use "git add" to track)
--------------------------------------

How would you like to proceed?
 (1) Push and deploy any pending commits.
 (2) Stage and commit all changed files, then push and deploy any pending commits.
 (3) Exit
Enter your choice:
```

Note that this script accounts for two scenarios:

__Scenario 1)__ You want to commit some but not all of the changed files in your repo. If this were the case, you'd manually `git add` the files you did want to deploy, then make a commit. *Then* you'd run the deploy script and choose option #1.

__Scenario 2)__ You want to commit and deploy *all* the changed files in your repo. Simply run the deploy script and choose option #2. The script will stage the files for you and prompt for a commit message.


## Setup
### Step 1) Local setup
Copy the contents [of this file](/servers-and-git/deploy.sh) and save it locally in your project as `bash/deploy.sh` (you'll need to create the subdirectory `bash`).

At the top of this file are two configuration variables you need to customize:

```
docRoot="/var/www/html/foobooks"
usernameServer="root@server.ip.address"
```

+ Change `docRoot` to the document root for the applicable project on your production server.
+ Change `usernameServer` to match the combination you typically use to SSH into your server.

(Do not add any spaces before/after the equal sign)

While you have this file open, skim through its contents to understand what it does. The file is written using a shell scripting language, but aside from syntax differences, the basic flow should be broadly understandable.

Next, give the deploy script executable [permissions](/command-line/permissions.md) (`+x`) on your local machine:
```
$ chmod +x bash/deploy.sh
```

Add, commit, and push this new file:
```
$ git add bash/deploy.sh
$ git commit -m "Added deploy script"
$ git push
```


### Step 2) Server setup
SSH into your server to pull the latest changes (including this new script).

```xml
$ ssh root@server.ip.address
$ cd /var/www/html/foobooks
$ git pull
```

With the deploy script now on your server, give it executable [permissions](/command-line/permissions.md) (`+x`)

```xml
$ chmod +x /var/www/html/foobooks/bash/deploy.sh
```


### Step 3) Setup alias locally
At this point, you could invoke your deploy script by running the following command from the local root of your project:
```
$ ! ./bash/deploy.sh
```

To make this more convenient, though, let's create a [git alias](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases).

This is done by editing `.git/config` and adding an alias to the bottom like so:
```
[alias]
    deploy="! ./bash/deploy.sh"
```

After you save your changes to `.git/config`, test out your new alias by running the following from the root of your project:
```
$ git deploy
```

You should see output like the following:
```xml
Detected location: local

Running git status -------------------
On branch master
Your branch is up-to-date with 'origin/master'.

nothing to commit, working tree clean
--------------------------------------

How would you like to proceed?
 (1) Push and deploy any pending commits.
 (2) Stage and commit all changed files, then push and deploy any pending commits.
 (3) Exit
Enter your choice:
```

If you choose option 1, the script will push any pending commits, then ssh into your server to run `git pull` followed by `composer install --no-dev`.

If you choose option 2, the script will `git add --all` to stage all changed files, then it will prompt you to enter a commit message for these changes. After you enter the commit message, the script will ssh into your server to run `git pull` followed by `composer install --no-dev`.


## Common problems and tips

### Problem: deploy.sh: Permission denied
If you receive the following message when trying to run your deploy script...
```bash
-bash: ./bash/deploy.sh: Permission denied#
```

...make sure you gave the script executable permissions (on both your local *and* server copy):

```bash
chmod +x bash/deploy.sh
```

When running `ls -l` your permissions for the deployment script should be set to `-rw-r--r--`. Example:

```xml
$ cd bash
$ ls -l
total 8
-rw-r--r--   1 Susan  admin  1314 Oct  9 16:36 deploy.sh
```

## Customize
`git pull` and `composer install --no-dev` are the two main deployment commands we need to run on our servers, but deployment scripts can be customized to run more commands based on your application/team needs.

For example, Laravel has an artisan command to combine all configuration files into one flat file, making the loading of configurations quicker. It'd be logical to run this command with each deployment to regenerate that flat file, so the following command might be added to the `deploy` function in the `deploy.sh` script:

```bash
php artisan config:cache
```


## More about shell scripting
Shell scripts use their own syntax language. Looking at the provided `deploy.sh` you can see the syntax for basic programming paradigms such as variables, functions, and switch statements. [You can learn more about the basics of writing shell scripts here...](https://www.panix.com/~elflord/unix/bash-tute.html)
