# Production domains
Our next step is to set up a real-world domain we can use to access our applications on our production servers.

We'll use one single domain for all the work in this course, but we'll be able to access our unique applications by configuring unique subdomains for each application, e.g.

+ `http://hello-world.yourdomain.com`
+ `http://p1.yourdomain.com`
+ `http://p2.yourdomain.com`
+ etc.

In order to do this, you first need a domain. I recommend creating your domain via **[Namecheap](http://www.namecheap.com/?aff=61057)**. As of this writing, Namecheap is offering free domain names for students (with a `.edu` email address) via <https://nc.me>.

If you're already comfortable with another domain provider you can use that but my examples will use Namecheap.

Also, if you already own a domain you'd like to use, I only recommend doing so if you're comfortable configuring DNS settings&mdash; I don't want your practice in this course to interfere with any existing real-world sites.
 
After you create your domain, find your **DNS settings** within your domain company's control panel. In Namecheap, these settings are located by finding the domain you'd like to configure in your **Domain List** and then clicking **Manage**. Then, find the tab for **Advanced DNS**.

There are two separate records you'll want to configure in your DNS settings. The following is a screenshot of what you're aiming for, with explanation below.

<img src='https://s3.amazonaws.com/making-the-internet/version-control-namecheap-dns@2x.png' style='max-width:1000px;' alt='DNS settings in Namecheap'>

## Record 1 - Main domain
+ __Type:__ A Record
    + Short for *Address Record*; points a domain to an IP address
+ __Host:__ @
    + Short for "apex"; represents the main domain, e.g. yourdomain.com
+ __Value:__ Your DigitalOcean droplet IP address
+ __TTL:__ 1 min
    + Time-to-live; indicates how long it will take for Namecheap's DNS servers to refresh their records regarding this entry.


## Record 2 - Sub-domain
+ __Type:__ CNAME
    + Short for [canonical name record](https://en.wikipedia.org/wiki/CNAME_record); this is an alias used to point to your main (canonical) domain.
+ __Host:__ *
    + The asterisk is a wildcard, meaning any subdomain will point to your primary domain. You could create individual CNAME records for every app/subdomain you create, but for simplicity sake we're using the wildcard.
+ __Value:__ yourdomain.com
+ __TTL:__ 1 min
    + Same as Record 1


## Test it out
When you're done, click **Save all Changes**.

Give the above settings a few minutes to take effect, then try accessing your main domain (e.g. `http://yourdomain.com`) and also any subdomain (e.g. `http://hello-world.yourdomain.com`).

Currently, both of these URLs should load DigitalOcean's default index page for new LAMP servers which feature a happy shark.

<img src='https://s3.amazonaws.com/making-the-internet/version-control-both-domain-records-working@2x.png' style='max-width:1000px;' alt='Both domain records working'>

This page you're seeing exists on your server at the default document root, `/var/www/html/index.php`. 

If you don't see this page, read on...

### DNS Cache
If your domain is not working yet, it could be because the changes have not propagated on Namecheap's DNS yet, in which case you just have to wait it out. I've had the changes propagate within minutes, and other times its taken an hour or more.

A non-functioning domain after making DNS changes could also be related to caching on your own computer, so the following actions might be helpful.

+ Run `ping yourdomain.com` in command line to see what IP address your domain is pointing to. If it returns the correct DigitalOcean IP address, it could just be that your browser or computer is caching the wrong settings, so try the following.
+ Clear your browser cache and/or try a different browser.
+ Your computer may be caching old DNS settings; these caches can be cleared:
    + [Mac instructions](https://support.apple.com/en-us/HT202516)
    + Windows/Cmder run this command: `ipconfig /flushdns`
+ Try accessing your URLs via [this proxy](http://megaproxy.com/freesurf)
+ Ask a friend on a different computer/network to test your URLs, or test it on your phone with wifi off (to force a different network)

If all of those tricks fail to show the domain is working, double check all your steps, and then continue to wait it out. If after an hour or so it's still not working, post a thread in the Issues forum describing the problem with a screenshot of your DNS settings.


## VirtualHost/Subdomain setup
At this point, your subdomain should be working in that it's pointing to your primary domain, which is pointing to your DigitalOcean server and the default document root for that server (`/var/www/html`).

However, we want to configure things so that a subdomain can point to a different document root, allowing you to run multiple unique applications on the same server, but under different subdomains. 

To do this, we need to tell the server how to handle incoming traffic to a given subdomain. This is done via a VirtualHost configuration, similar to the configurations we saw on our local servers. 

On DigitalOcean, we'll do this via the config file `/etc/apache2/sites-enabled/000-default.conf`, which you can open in nano with the following command:
```bash
$ nano /etc/apache2/sites-enabled/000-default.conf
```

At the end of this file, paste in the following VirtualHost block then edit it to reflect your ServerName (instead of mine, `dwa15.me`):

```bash
<VirtualHost *:80>
  ServerName hello-world.dwa15.me
  DocumentRoot "/var/www/html/hello-world"
  <Directory "/var/www/html/hello-world">
    AllowOverride All
  </Directory>
</VirtualHost>
```

In plain English, this VirtualBlock block code says: *when traffic comes in via `hello-world.dwa15.me`, point to the `/var/www/html/hello-world` directory*.

<img src='https://s3.amazonaws.com/making-the-internet/vc-pasting-virtual-host-block@2x.png' style='max-width:1152px'>

Tip for Cmder users: If you try and paste multiple lines into Cmder using keyboard shortcuts, it will paste just the first line. To get it to paste *all* the lines, right click the top bar in Cmder and choose `Edit` -> `Paste` ([screencast demo](http://screencast.com/t/u43zTSEx4GKl)).

When you're done editing the new VirtualHost block, save your changes to `000-default.conf` (`ctrl` + `x`, then `y`, then *Enter*).

(If for some reason you make a mistake in `000-default.conf`, [here's a copy of the original](https://gist.github.com/susanBuck/790ea5a0d1ad7d02e586).)

To make your VirtualHost changes take effect, restart Apache with this command:

```bash
$ service apache2 restart
```

Once the restart is complete, test out your subdomain `http://hello-world.yourdomain.com`. You should see the same version of your *hello-world* application that you saw when testing it locally.

When building your projects, you'll add new VirtualHost blocks following the above template, editing the `ServerName`, `DocumentRoot`, and `Directory` to match the appropriate values for that project.

## Aside
__DNS management in DigitalOcean:__ It's possible to configure your domain so that it uses DigitalOcean's nameservers rather than your domain provider's nameservers, but that is not the setup we use in this course. Given this, there's nothing you need to do in  *DigitalOcean* > *Networking* > *Domains*. I recommend using different providers for domain management and server management so that if one fails, you still have access to the other.
