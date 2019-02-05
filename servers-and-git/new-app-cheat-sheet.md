# New App Cheat Sheet
The following is a summary of the steps you should take when creating/deploying a new application. For complete details, refer to the appropriate note set.

## Step 1. Create the new application directory/repository

### Option A: Github to your computer
Create a new repository on Github.com, initializing it with a README.md file

Clone that repository to your `htdocs` folder.
```bash
$ cd /path/to/htdocs/folder
$ git clone git@github.com:username/hello-world.git
```

### Option B: Your computer to Github
Create the new project directory in your `htdocs` folder and run `git init` to initialize it as a git repository.

Create a new repository on Github.com but *don't* initialize it with a README.md file.

Locally, in your project directory, connect it to it to the repository on Github:
```bash
$ git remote add origin git@github.com:username/hello-world.git
```


## Step 2. Local domain
Edit your hosts file, adding a new local domain (follow the pattern of existing domains)

* Mac: `/private/etc/hosts`
* Windows: `c:/Windows/System32/drivers/etc/hosts`

Then, add a new VirtualHosts block (following the pattern of existing VirtualHost blocks): 

Mac:
```bash
$ nano /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
```

Windows:
```bash
$ nano c:\xampp\apache\conf\extra\httpd-vhosts.conf
```

Stop and restart your local server for these changes to take effect.


## Step 3. Deploy to production
SSH into your DigitalOcean droplet and clone your application to the `/var/www/html` directory:

```bash
$ cd /var/www/html/
$ git clone git@github.com:username/hello-world.git
```

## Step 4. Production domain

Add a new VirtualHost block to `/etc/apache2/sites-enabled/000-default.conf` that points the desired subdomain (e.g. `hello-world.yourdomain.com`) to the desired document root (e.g. `/var/www/html/hello-world`).

(If you're creating a Laravel app, recall it will need to use the `public/` folder as the document root).

Save your changes to `000-default.conf` and then restart Apache:

```bash
$ service apache2 restart
```