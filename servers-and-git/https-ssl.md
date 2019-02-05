**Preface: The following notes are FYI only; it's not required nor expected that you use HTTP/SSL for projects in this course**

# HTTPS/SSL
All semester, we've been accessing our production apps via urls starting with `http://`, which indicates the requested page is being loaded over an un-encrypted *HTTP (Hypertext Transport Protocol)* connection.

This is in contrast to if we were using a url like `https://` where the added `s` indicates **secure**.

When you use an non-encrypted connection (`http://`), the data passed between your visitor's browser (i.e. the client) and the server is passed as plain text, which makes it vulnerable if it were intercepted by a hacker.

This is not a concern for projects in this course because we're not dealing with real data or real users, so even if the data were to be compromised, it would not be an issue.

**However, for real-world production applications, you should enable `https://` for security purposes.**

It used to be the case that only &ldquo;sensitive&rdquo; requests needed to be loaded over `https://`&mdash; for example, a login request or payment processing request that transferred credit card data. 

More recently though, best practices have moved towards running all traffic via https. Google has even indicated that they show preference in their search results for sites that are using https. 

So how do you load your site via https?

## First, you need an SSL certificate

In order to load your site via https you should first have an SSL certificate installed on your server.

**An SSL (Secure Sockets Layer) certificate is used to verify the ownership of a site, and a valid SSL cert is needed in order to have a valid https connection.**

(If you've ever accessed a site via https:// and noticed a red/broken lock icon in the URL bar, it means there's some problem with the SSL cert of that site).

Once you have a SSL certificate installed, you can then enable https on your server, and begin to use urls like `https://yourdomain.com`.


## Where to get an SSL certificate

### Option 1: *Let's Encrypt*
[Let's Encrypt](https://letsencrypt.org) is a project that was designed to make obtaining and installing SSL certificates easier. The motivation behind this project is to make the web a more secure place. (If SSL certs are easier to obtain/install, more sites will use them, and the web will be more secure).  

To learn how to use *Let's Encrypt* on your Digital Ocean production server, follow the instructions in this article: 
[How To Secure Apache with Let's Encrypt on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-14-04).

### Option 2: Purchase and install a SSL certificate
SSL certificates can be purchased from certificate authorities (e.g. [Comodo](https://ssl.comodo.com)). It's also common for domain and/or hosting providers to sell certificates on behalf of these authorities. 

Like most web-related services, there are different levels of features and pricing that coincide with what type of SSL certificate you purchase. 

For example, some authorities offer features like *Extended Validation (EV)* which involves extra steps to validate your domain and/or company. When a site is loaded with an EV SSL, you'll see the company name in green in the URL bar, which offers an extra level of assurance to the visitor that the site they're visiting is authentic. (For an example, visit <https://www.bankofamerica.com> and look at the URL bar.) 

After you purchase an SSL certificate, it has to be installed on your server and then you can configure your server to enable HTTPS connections. Because *Let's Encrypt* is sufficient for students choosing to explore HTTPS/SSL in this course, I won't go into full details on manually setting up a purchased SSL cert, but there are plenty tutorials online explaining the process if you're curious.


## Which should you use?
*Let's Encrypt* is great for personal projects and some small businesses with a low volume of online transactions.

Larger businesses, especially those with a high volume of online transactions, however, should consider purchasing SSL certificates with higher levels of authenticity checking to ensure your visitors that their data is secure.






