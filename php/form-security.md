# Form security (XSS)
When your application contains a form that accepts text input, you need to be on the lookout for ways in which the text a visitor enters can create unexpected or even ill-intentioned results.

Consider our simple [foobooks0](http://foobooks0.dwa15.me) search feature, which accepts a search term that is processed and displayed on the page.

The majority of the time, a visitor is going to enter something you would expect - a string of text, containing a mixture of letters and the occasional symbol:

+ `Harry Potter`
+ `Basic Fishing: A Beginner's Guide`
+ `Oh, The Places You'll Go!`

But what happens if the visitor enters something like the following:

+ `<script>alert('hi!')</script>`
+ `<style>body { background-color:red }</style>`

Because the above two &ldquo;search terms&rdquo; contain client-side code, they could produce an undesirable outcome (a JavaScript alert and the page will turn red) when they're echo'd as part of the results.

<img src='https://s3.amazonaws.com/making-the-internet/php-xss-example-in-foobooks0.png' style='max-width:985px;' alt=''>

In the case of foobooks0, this is not a huge concern, because the visitor who enters such a search term would only be impacting their own experiencing with using the site.

Where things start to get dangerous, though, is when we save user-entered information to a database, and then retrieve and display that information for other users.

Consider this example:

VisitorA is shown a form where they can update the description of a book.

When filling out the form, instead of entering a valid description, they enter this nefarious JavaScript code:

```xml
<script>
    alert('Attention; your password has been compromised, visit http://shady.com to secure your account.')
</script>
```

Upon submission, the server (hypothetically) saves this data to a database.

Later, VisitorB views the page for that specific book, and the description is fetched from the database and displayed on the page, resulting in an ominous alert message...

<img src='http://making-the-internet.s3.amazonaws.com/php-shady-alert@2x.png' style='max-width:422px;' alt=''>

Eep!

This scenario is called a **Cross-site scripting (XSS)** attack, and it occurs when a malicious visitor attempts to inject client-side scripts into web pages viewed by other visitors.

To avoid an attack like this, any data that originates from a visitor should always be &ldquo;sanitized&rdquo; before it's displayed on the page by converting HTML special characters to their equivalent HTML entities.

E.g. if the user entered this: `<script>` we should render it as `&lt;script&gt;` so that no scripts are actually executed on display.

This sanitization can be accomplished using PHP's built-in [htmlentities](http://php.net/manual/en/function.htmlentities.php) function, e.g.:

```php
<?= htmlentities($description, ENT_QUOTES, "UTF-8") ?>
```

Which would output the following harmless string:

```
&lt;script&gt;alert(&#039;Attention; your password has been compromised, visit http://shady.com to secure your account.&#039;)&lt;/script&gt;gt;
```

Alternatively, you can use a short-cut for htmlentities via the `sanitize` function provided in [`helpers.php`](https://github.com/susanBuck/dwa15-php/blob/master/helpers.php):

```php
<?= sanitize($description) ?>
```

## Sanitize on display
It's common/best practice to "sanitize on display". In other words, you would not invoke `sanitize` or `htmlentities` in your logic file, but in your display file as you echo the data.

You do this because not all data that creates unexpected consequences is necessarily ill-intentioned. For all we know, `<script>alert('hi!')</script>` could actually be the name of a book, so when we're doing our search, we want to work with the data the user actually entered, not the "sanitized" version of what they entered. 

## Built-in browser protection against XSS
Some browsers will prevent XSS, regardless of whether you sanitize the data or not. For example, Safari produces the following error when the example at the top of the page is run:

```
The XSS Auditor refused to execute a script in 'http://foobooks0.dwa15.me/index.php' because its source code was found within the request. The auditor was enabled because the server did not send an 'X-XSS-Protection' header.
```

However, because our visitors will use a variety of browser types, we can't rely on this protection and must make sure we're applying our own XSS sanitization.


## Summary
Any text-based form input data should be sanitized before being displayed/rendered on the page.



## Looking ahead
Other form-related security issues we'll discuss this semester include:

+ SQL Injection Attacks
+ CSRF (Cross Site Request Forgery)
