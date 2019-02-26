# New Laravel application
We're going to create a new Laravel application using Composer.

Change directories into your local *Document Root* where your new app will live.

Mac:
```bash
$ cd /Applications/MAMP/htdocs
```

Windows:
```bash
$ cd c:\xampp\htdocs
```

Next, use the following `composer` command to generate a new Laravel project, swapping in `foobooks` with whatever you want your application name to be.

Note: This command may take a minute or few to complete as it downloads all the necessary Laravel files.

```bash
$ composer create-project laravel/laravel foobooks "5.7.*" --prefer-dist
```

If you see warnings or errors after running this command, scroll down to see if your issue is listed in the __Troubleshooting__ section.

When Composer is done working, move into the newly created project directory:

```
$ cd foobooks
```

Once in this directory, run a list command to see all the Laravel related files.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-fresh-install@2x.png' style='max-width:732px; width:100%' alt='Laravel fresh install'>


## Permissions
At this point in the installation procedure, some Laravel tutorials would have you run specific commands to make the `storage` and `bootstrap/cache` directories writable.

When using Laravel, the Apache web server needs *write* access for the `storage` and `bootstrap/cache` directories because Laravel will write data to these directories. For example, errors will be written to `storage/logs/laravel.log`, and cached configurations to speed up your app will be written to `bootstrap/cache`.

But for __Windows/XAMPP users__, you shouldn't need to adjust permissions because Apache already has all the permissions it needs since it runs under Window's LocalSystem account  which has extensive read/write access to local paths.

Likewise, most __Mac/MAMP users__ shouldn't need to adjust any permissions because MAMP's Apache is running as the user who launched it, i.e. you, and as owner of all the files and directories in your project, you already have write access.

The only instance where this might not work is if you're using a different local server setup that does *not* have the correct permission configuration. If that were the cause, you'd want to configure `storage` and `bootstrap/cache` to be writable by your web server.

We'll talk specifically about setting permissions on DigitalOcean when we get to deployment in the next note set.



## Point local server to your new app
The initial setup for your app is complete so the next step is to configure a local domain so you can access this app in the browser.

You'll recall from [the notes on creating local domains](/servers-and-git/local-domain.md) that this is a 2 step process:

__Step 1. Create a new local domain mapping in your computer's hosts file__

```xml
127.0.0.1 foobooks.loc
```

__Step 2. Create a new VirtualHost block__ in your server's `httpd-vhosts.conf` file.
Here's an example VirtualHost block (example shown using Windows paths; Mac users adjust the path as needed, e.g. `/Applications/MAMP/htdocs/foobooks/public`):

```xml
<VirtualHost *:80>
    ServerName foobooks.loc
    DocumentRoot C:/xampp/htdocs/foobooks/public
    <Directory C:/xampp/htdocs/foobooks/public>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
```

Note how the DocumentRoot/Directory is set not just to `[...]/foobooks/`, but `[...]/foobooks/public`. This is important! While your server will be able to access any/all files in `[...]/foobooks/`, this setting makes it so a visitor's browser can only access the contents of `foobooks/public`, which is ideal for security purposes. 

Files that the browser does need access to (such as images, .css/.js files, etc.) will be stored in `public/`

__After saving your changes and restarting your server__, you should be able to load your application in the browser and see Laravel's default welcome page.

<img src='https://s3.amazonaws.com/making-the-internet/laravel-app-setup-success@2x.png' style='max-width:394px'>


## Create a README.md file
```
# Practice work
+ By: *your first and last name*
+ Production URL: <http://foobooks.yourdomain.com>
```


## Version Control your new app
In this course, you've created three applications so far:

1. The `hello-world` example
2. Your Project 1 application
3. Your Project 2 application

In all three of these cases, you started with a blank slate (i.e. no files), so the process setting up git looked like this:

1. Create a new, empty repository in Github
2. Clone this repository to your local machine

With this new Laravel application we've just created, though, we are not starting with a blank slate- we have all the skeleton Laravel code. Our process, then, for setting up version control for this app will be a little different:

1. Initiate git in the application's folder on your local machine
2. Create a new, empty repository on Github.com
3. Connect your local repository to the new repository on Github.com.

Here are the steps to do that...

In your application directory, initiate a new Git repository using the command `git init`

```bash
$ cd /path/to/foobooks
$ git init
```

Then, on Github.com, create a new repository. When doing this, do *not* initialize the repository with a `README.md` file because you'll be working with a repository that has already been initialized.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-foobook-repo@2x.png' class='' style='max-width:735px; width:100%' alt='Foobooks repo setup in Github'>

Note the Github SSH URL, for example, `git@github.com:username/foobooks`

Back in your application directory, add a new remote connection called `origin`, that is set to the Github SSH path:

```bash
$ git remote add origin git@github.com:username/foobooks.git
```

You now have a git tracked application that is connected to a repository on Github.



### First commit
Run git status to see all your untracked files:

```bash
$ git status
```

Add all your files for committing:

```bash
$ git add --all
```

Commit these changes:

```bash
$ git commit -m "First commit"
```

Push your project to Github; note we're adding the flag `--set-upstream origin master` which makes it so that the `origin` remote and `master` branch will be used by default when pushing to this repository. Any future commits made to this project will only need to use `git push`.

```bash
$ git push --set-upstream origin master
```

When you visit your repository on Github you should see all your changes there.

Your app is now set up locally and ready for development. In the next section, we'll cover the procedure for deploying your app to a live server.


## Troubleshooting
If your new app won't run, check for clues in `storage/logs/laravel.log` first, as that's where Laravel outputs errors.

The following are some common problems and solutions students have faced.

### Composer installs an older version of Laravel
If Composer is downloading an older version of Laravel than you're expecting, it could be because your PHP in command line is out of date and as a result, Composer is getting the latest version of Laravel supported by that version.

Confirm by running `php --version`

It should report back >= 7.2.x.

If it's less than this, you may get an older version of Laravel. Revisit the Composer setup notes ([Mac](/laravel/composer-mac.md)/[Windows](/laravel/composer-windows.md) where it talks about checking/setting your PHP version in Command Line.


### Cache permission error when creating a new Laravel project with Composer
If you see the following warning when installing Laravel via Composer...

```xml
Cannot create cache directory [your home directory].composer/cache/repo/https---packagist.org/, or directory is not writable. Proceeding without cache.
```

...it means that Composer lacks the appropriate permissions to write cache files to the `.composer/cache` directory. Despite this warning, the `create-project` command should still execute succesfully and no further action is necessary.

However, it's useful to address the warning so that future invocations of Composer commands can take advantage of the cache making processes run faster. This appears to be an issue isolated to Mac users, and can be fixed by running the following command:

```
$ sudo chown -R $USER $HOME/.composer
```

Run this command exactly as is, you do not need to edit it, as `$USER` and `$HOME` are dynamic variables that will fill in with your computer's username and home directory.

This command will recursively (`-R`) set you (`$USER`) as the owner of the `.composer` directory. That way when you run commands as Composer, it will have the appropriate permissions needed to write files to its cache directory.


### No supported encryptor found
If you see the error `No supported encryptor found.` chances are it means a constant called `APP_KEY` is not set in your application's environment file (`/.env`)

This should not happen on a new installation, as generating the app key is something the Laravel installer does. However, if for some reason your app key is not set, you can fix it with this command:


```php
$ php artisan key:generate
```
