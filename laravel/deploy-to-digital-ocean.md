# Deploy Laravel app to DigitalOcean

The following steps outline the procedure for deploying a new Laravel application to our DigitalOcean Droplets:

Summary:

1. On your server, clone your Laravel app from Github
2. Build the `vendor/` directory via `composer install --no-dev`
3. Set permissions
4. Set up `.env` file
5. Configure subdomain


## Clone your Laravel app
While SSH'd into your Droplet, navigate into your document root at `/var/www/html`:

```xml
$ cd /var/www/html
```

Now use Git to clone your project from Github. Edit as necessary with your username and app name.

```xml
$ git clone git@github.com:username/foobooks.git
```

Navigate into the resulting directory (in this case, it's `foobooks`) and use a list command to confirm all your files are there.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-fresh-install-on-do@2x.png' style='max-width:644px;' alt=''>

## Build vendor/ directory
If you compare the contents of your local application files to your production application files on your Droplet, you'll notice the Droplet version is missing a `vendor/` directory.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-foobooks-on-droplet-no-vendor-directory@2x.png' style='max-width:1026px; width:100%'>

This is because vendors are managed by Composer and are *not* version controlled. This is configured via `.gitignore` which lists `vendor/` as a directory to ignore:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-vendor-in-gitignore@2x.png' style='max-width:650px; width:100%'>

Given this, you need to have Composer build your vendor's directory with this command:

```xml
$ composer install --no-dev
```

Notes:
+ Running this command may take a few minutes
+ The `--no-dev` flag is added to indicate we only want packages intended for use on production; it will exclude packages used for local development/testing.
+ Don't worry about the lines regarding suggested packages you should install; we can always add the suggested components later as needed.


Example output from the above command:
```xml
root@lamp-512mb-nyc3-01:/var/www/html/foobooks# composer install --no-dev
Do not run Composer as root/super user! See https://getcomposer.org/root for details
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Package operations: 68 installs, 0 updates, 0 removals
  - Installing doctrine/inflector (v1.2.0): Downloading (100%)

[...ADDITIONAL INSTALLING LINES REDACTED FOR BREVITY...]

symfony/var-dumper suggests installing ext-symfony_debug ()

[...ADDITIONAL SUGGESTION LINES REDACTED FOR BREVITY...]

Generating optimized autoload files
> Illuminate\Foundation\ComposerScripts::postAutoloadDump
> @php artisan package:discover
Discovered Package: fideloper/proxy
Discovered Package: laravel/tinker
Package manifest generated successfully.
```

When Composer is complete, if you list the contents of your project you should now see a `vendor/` directory:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-vendor-on-do@2x.png' style='max-width:617px;' alt='Vendor directory now on DigitalOcean server'>



## Permissions
As discussed when we were setting up Laravel on your local server, Laravel/the Apache web server needs write access to the `storage` and `bootstrap/cache` directories.

This was a step we could skip locally because of how your local servers are configured, but it can't be skipped on your live servers. On your DigitalOcean server we need to make sure Apache has write access to these folders.

To do this, we first identified that on DigitalOcean servers, Apache runs under a user called `www-data`.

Given that, make the user `www-data` own the `storage` directory and everything in it (`-R`):

```xml
$ chown -R www-data storage
```

And now make the same change for the `bootstrap/cache` directory:
```xml
$ chown -R www-data bootstrap/cache
```

Ref:
+ [SuperUser: Setting correct permissions for uploading files](http://superuser.com/a/581259/84723)
+ [Command Line : Extras : Permissions](/command-line/permissions.md)


## Set up .env file on production
Like the `vendors/` folder, the `.env` file is also listed in `.gitignore` so it's also excluded from version control. Because of this, you need to manually create a `.env` file on your live server in order for your application to work there.

This can be done by copying the provided `.env.example` file to `.env`

```xml
$ cp .env.example .env
```

Next, you need to generate a app key:

```xml
$ php artisan key:generate
```

(If you're curious, you can `cat .env` to see the new key that was generated)

Later we'll discuss environments in full details and explain what exactly `.env` is doing and how it works. For now, just know that we need that `.env` file in order for Laravel to work.



## Configure subdomain
To access your Laravel application from the web, you'll want to set up a subdomain that points to it. For this you will follow [the same procedure](/servers-and-git/production-domain.md) you did to create `http://helloworld.yourdomain.com` and `http://p1.yourdomain.com`.

Continuing with the foobooks example, I set up `http://foobooks.dwa15.me`

Summary of steps:
1. Add a new VirtualHost block to `/etc/apache2/sites-enabled/000-default.conf` (see notes below)
2. Restart Apache with the command `service apache2 restart`

Reminder when creating your VirtualHost block that the document root for your Laravel projects should point to the `public` directory within your project.

Example:

```html
<VirtualHost *:80>
	ServerName foobooks.dwa15.me
	DocumentRoot "/var/www/html/foobooks/public"
	<Directory "/var/www/html/foobooks/public">
		AllowOverride All
	 </Directory>
</VirtualHost>
```


## Test it out
After setting up your subdomain you should now be able to access your new app on your DigialOcean server:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-foobooks-on-droplet@2x.png' style='max-width:722px; width:100%'>




## Moving forward
The above steps were a one-time-process for deploying a new Laravel application.

Moving forward, your deployment process will look like this:

1. From local `add`, `commit`, and `push` changes.
2. SSH into your DigitalOcean droplet and navigate into your app folder, then run `git pull`.
2. Also while SSH'd in to your app folder, run `composer install --no-dev`.

It's important to always run `composer install --no-dev` when deploying code changes. This command will make sure your code base has the latest versions of all dependencies and it will also refresh your application's classmap with the latest details.


## Troubleshooting

__Issue: Composer memory issue__

You attempt to run a Composer command but get an error about `lack of memory or swap, or not having swap configured` and/or `Cannot allocate memory`.

To fix, follow the instructions for setting up a __swap file__ in the note set [*Prep DigitalOcean for Laravel*](/laravel/prep-digital-ocean-for-laravel.md).

__Log files__

+ Apache: `/var/log/apache2/error.log`
+ Laravel: `/path/to/your/app/storage/logs/laravel.log`


__Common issues__

1. Lack of a `.env` file.
2. Forgetting to build the `vendors` directory via `composer install`.
3. Forgetting to set the necessary write permissions on `storage` and `bootstrap/cache`
