# Local domain

So far, you've created a new application called `hello-world` that exists as a copy on Github.com and also your local machine. Now let's look at how you'll actually run/preview this application via your local server.

In Week 1, we accessed our local server by visiting `http://localhost` which loaded the contents of our `htdocs` folder since that's what the document root was configured to.

We could switch between working on different applications by changing the document root to point to whatever project we're working on, but that would get tedious. Instead, we want to create unique local URLs we can use to access each application we build.

For example, we want to start with a URL `http://hello-world.loc` that points to `htdocs/hello-world` as its document root.

Likewise, you'll do the same thing for each of the 4 unique applications you build for the projects in this course (`http://p1.loc` => `htdocs/p1`, `http://p2.loc` => `htdocs/p2`, etc.)

In order to do this, we'll configure our Apache web servers to run multiple applications via [Virtual Hosts](https://httpd.apache.org/docs/2.4/vhosts/). 


## Step 1. Tell Apache to use the virtual hosts file

First, locate and open `httpd.conf`, your local server's Apache configuration file:

* Mac: `/Applications/MAMP/conf/apache/httpd.conf`
* Windows: `c:\xampp\apache\conf\httpd.conf`

In the `httpd.conf` file, make sure the line including `httpd-vhosts.conf` is *not* commented out by removing the pound sign from the start of the `Include` (if there is one):

Mac:
```xml
# Virtual hosts
Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
```

Windows:
```xml
# Virtual hosts
Include conf/extra/httpd-vhosts.conf
```


## Step 2. Virtual Host entry

Next, tell Apache on your local server how to handle requests to `http://hello-world.loc` via a Virtual Host entry.

This is done via Apache's `httpd-vhosts.conf` config file which can be found at the following locations:

* Mac: `/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf`
* Windows: `c:\xampp\apache\conf\extra\httpd-vhosts.conf`

At the __bottom__ of this file, add your own VirtualHost block:

Mac/MAMP users, yours will look like this:
```xml
<VirtualHost *:80>
    ServerName hello-world.loc
    DocumentRoot /Applications/MAMP/htdocs/hello-world
    <Directory /Applications/MAMP/htdocs/hello-world>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
```

Windows/XAMPP users, yours will look like this. (The details of this example are different from the example VirtualHosts you'll see commented-out in xampp's httpd-vhosts.conf; that's okay.)

```xml
<VirtualHost *:80>
    ServerName hello-world.loc
    DocumentRoot C:/xampp/htdocs/hello-world
    <Directory C:/xampp/htdocs/hello-world>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
```

A breakdown of the key parts of the above VirtualHost blocks:
1. `ServerName` (use `.loc` to distinguish it from the live TLD)
2. `DocumentRoot` (Points to the root of the application/project)
3. `Directory` (same as `DocumentRoot`)

Note, the above VirtualHost blocks assumes you're running on Port 80 (`*:80`). If you're running your local Apache on a different port, make that edit.


## Step 3. Create a new host

Next, we need to edit your computer's `hosts` file which can be used to route domains to an IP address of your choice.

* Mac: `/private/etc/hosts`
* Windows: `c:/Windows/System32/drivers/etc/hosts`

(Note, there's no extension on this file, it's simply called `hosts`)

The hosts file is protected, so you'll need to open it with administrator privileges. This can be done with *nano* via the admin command `sudo` on Mac, or `elevate` on Windows.

Mac:
```bash
$ sudo nano /private/etc/hosts
```

Windows:
```bash
$ elevate nano c:\Windows\System32\drivers\etc\hosts
```

At the bottom of your hosts file, add a new host:

```xml
127.0.0.1 hello-world.loc
```

This is telling your computer that whenever you access `http://hello-world.loc` from your computer, it should map to the ip address `127.0.0.1` (the IP address of your local server).




## Test it 
**Restart your local server** and test out your local URL.

Make sure you explicitly type in `http://hello-world.loc` with `http://` at the beginning. If you don't, your browser may try and do a web search for `hello-world.loc` because it does not recognize `.loc` as a domain extension.


## Fixing `http://localhost`
After you make the above change you'll notice that `http://localhost` no longer works as expected&mdash; instead of pointing the document root you configure in MAMP/XAMPP, it will start pointing to the first VirtualHost block in your `httpd-vhosts.conf` file.

To fix this, you can add a VirtualHost block specifically for `http://localhost`. I recommend having localhost just point to your htdocs folder.

For Mac/MAMP users:
```xml
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /Applications/MAMP/htdocs
    <Directory /Applications/MAMP/htdocs>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
```

For Win/XAMPP users:
```xml
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot c:\xampp\htdocs
    <Directory c:\xampp\htdocs>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
```

Don't forget to restart your server after making these changes.


## Summary
To be repeated every time you want to add a new app:

+ Add a new `<VirtualHost>` record block in MAMP/Apache's `httpd-vhosts.conf` file.
+ Add a new local URL in your computer's `host` file.


Note how it's only Steps 2 and 3 above that need to be repeated for any new apps. Step 1 is a one time deal to get Virtual Hosts working.


## Troubleshooting
If you run into problems, check your Apache error log for clues:

+ Mac/MAMP: `/Applications/MAMP/logs/apache_error_log`
+ Windows/XAMPP: `c:\xampp\apache\logs\error.log`
