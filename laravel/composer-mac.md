# Composer setup on Mac

These instructions are for Mac users; [for Windows instructions on setting up Composer, go here...](/laravel/composer-windows.md)

## Summary
1. PHP from command line check
2. Installing Composer
3. Common problems (and solutions)


## PHP from command line check
In addition to running PHP on a server, you can also run PHP from command line. Composer uses PHP from command line, so we want to first get on the same page with *which* installation of PHP command line is using in order to understand what version of PHP we're using, what modules we have available, etc.

You can see info about which php executable command line is using by running the following commands:

```xml
$ which php
/Applications/MAMP/bin/php/php7.2.x/bin/php
```

```xml
$ php --version
PHP 7.2.x (cli)
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
```

```xml
$ php --ini
Configuration File (php.ini) Path: /Applications/MAMP/bin/php/php7.2.x/conf
Loaded Configuration File:         /Library/Application Support/appsolute/MAMP PRO/conf/php7.2.x.ini
Scan for additional .ini files in: (none)
Additional .ini files parsed:      (none)
```

This info should reflect an installation of PHP found in `/Applications/MAMP/bin/php/` and at version >= 7.2. 

**If the output you see reflects something different [follow these instructions to update your 
PATH variable](/command-line/path.md)**

Before continuing confirm that:

1. You can run `php` from the command line.
2. The command `php` is using the latest PHP executable that comes installed with MAMP.



## Installing Composer on Mac
Move into your `/usr/local/bin` directory. This is a common location to put command line executable programs, so we'll install Composer here.

```xml
$ cd /usr/local/bin
```

Note: On some versions of OSX the `/usr` directory does not exist by default. If you receive the error */usr/local/bin: No such file or directory* then you must create the directory manually using this command
```bash
sudo mkdir -p /usr/local/bin
```

Once in `/usr/local/bin`, download and install `composer.phar`:

```bash
$ curl -sS https://getcomposer.org/installer | sudo php
```

What a .phar file is:
>> *The phar extension provides a way to put entire PHP applications into a single file called a &ldquo;phar&rdquo; (PHP Archive) for easy distribution and installation.* -[source](http://php.net/manual/en/intro.phar.php)

After running the above command to download/install `composer.phar` you should see a message saying that Composer was successfully installed.

```
$ curl -sS https://getcomposer.org/installer | sudo php
Password:
All settings correct for using Composer
Downloading...

Composer successfully installed to: /usr/local/bin/composer.phar
Use it: php composer.phar
```

Once install is complete, to make calling Composer easier, rename `composer.phar` to `composer` using the `mv` (move) command:

```bash
$ sudo mv composer.phar composer
```

Test it works:

```bash
$ composer
```

You should see something similar to this output (except the version # will reflect whatever the current version of Composer is):
<img src='http://making-the-internet.s3.amazonaws.com/laravel-mac-composer-success@2x.png' style='max-width:627px; width:100%' alt=''>


## Common problems

### Issue: SSL Certificate problem

__Symptoms:__ When downloading Composer (via the `curl -sS https://getcomposer.org/installer | php` command), you receive an error regarding SSL certificates:

```xml
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: http://curl.haxx.se/docs/sslcerts.html
curl performs SSL certificate verification by default, using a "bundle"
 of Certificate Authority (CA) public keys (CA certs). If the default
 bundle file isn't adequate, you can specify an alternate file
 using the --cacert option.
If this HTTPS server uses a certificate signed by a CA represented in
 the bundle, the certificate verification probably failed due to a
 problem with the certificate (it might be expired, or the name might
 not match the domain name in the URL).
If you'd like to turn off curl's verification of the certificate, use
 the -k (or --insecure) option.
```

__Solution__:
Run the curl command somewhere outside of `/usr/local/bin` (for example, in your Documents folder) and when it's done, move the resulting `composer.phar` into `/usr/local/bin`.

```xml
$ cd ~/Documents
$ curl -sS https://getcomposer.org/installer | php
$ mv composer.phar /usr/local/bin/composer.phar
```
