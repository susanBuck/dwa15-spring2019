# Forms
All of the examples thus far have excluded a necessary ingredient of a web application: __input from the user__.

The most common way you'll get input from your user is via HTML forms that will submit to your server.

(If you're not comfortable with HTML form elements, take the time now to skim through this article: [MDN Forms](https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms/My_first_HTML_form))

To understand how form processing works, it's important to understand that the web works via this two-step process:

+ __Request:__ A client (web browser) sends a request to a server (in our case, Apache) via the HTTP protocol.
+ __Response:__ The server responds to the request (also via HTTP)

<img src='https://s3.amazonaws.com/making-the-internet/php-request-response@2x.png' style='max-width:521px;' alt=''>

A request will include essential data such as...

+ What is the address of the request?
+ Is there any cookie data with the request?
+ What is the IP address from which the request is coming from?
+ What client type (i.e. browser) is the request coming from?

In addition to these details, input data from the user can also be sent as part of the request.

How the data is sent depends on what request type is being used&mdash; HTTP protocol supports two types: GET and POST.

+ When you visit a web page (either by typing in the URL or via a link), the GET method is used.
+ When you submit a form to a web page, either the GET or POST method can be used.


## GET Example
This semester, many of our demos will revolve around an example called **foobooks**, which will be a simple application for organizing a collection of books. 

With that in mind, let's build a super basic iteration of foobooks to demonstrate processing a form with the GET method.

Create a new file called `foobooks.php` with this code:
```php
<form method='GET' action='search.php'>

    <label>Search for a book:
        <input type='text' name='searchTerm'>
    </label>

    <input type='submit' value='Search'>

</form>
```

And a second new file called `search.php` with this code:
```php
<?php
var_dump($_GET);
echo 'You searched for '.$_GET['searchTerm'];
```

Observations about `foobooks.php`:
+ The form element has a `method` attribute set to `GET`
+ The form element has an `action` attribute, specifying where this form should be submitted to (`search.php`).
+ The single input in the form has a `name` attribute, which will be used to identify that data

Run the above example and submit with the search term &ldquo;fiction&rdquo;.

<img src='https://s3.amazonaws.com/making-the-internet/php-foobooks-search-with-get@2x.png' style='max-width:724px;' alt='Foobooks search using GET'>

Looking closely at the brower's URL bar, you'll note that the form data is being sent with the request via the URL:

<img src='https://s3.amazonaws.com/making-the-internet/php-get-data-in-url@2x.png' style='max-width:547px;' alt='GET data in the URL'>

In this example the URL is:
```xml
http://localhost/search.php?searchTerm=fiction
```

What follows the question mark is the __query string__:
```xml
searchTerm=foobar
```

A query string contains one or more key value pairs of data sent with the request. In this case, the key `searchTerm` was set to the value `fiction`.

If you had multiple form inputs, they'd be added to the query string, separated by a ampersand, e.g.:

```xml
http://localhost/search.php?searchTerm=fiction&minPublishedDate=1950
```

On the receiving end of things (i.e. `search.php`), data from the query string is available via an array, [`$_GET`](http://php.net/manual/en/reserved.variables.get.php).

`$_GET` is a PHP [superglobal](http://php.net/manual/en/language.variables.superglobals.php)&mdash; a built-in variable that's automatically created by PHP.

__GET Summary:__ Submit a form via the GET method and all the data from that form will be a) viewable in the URL bar and b) accessible in your script via the $_GET superglobal.


## POST Example
Update the above example with the following changes:

+ In `foobooks.php`, change the form method to POST
+ In `search.php`, change both occurances of `$_GET` to `$_POST`

Refresh `foobooks.php` and submit the form again.

The output should be the same, but this time the data is not appended to the URL; instead it's attached to the request &ldquo;behind the scenes&rdquo;.

<img src='http://making-the-internet.s3.amazonaws.com/php-form-post-results@2x.png' style='max-width:547px;' alt=''>

Note what happens when you refresh the page&mdash; it asks you if you want to re-submit the form data.

<img src='http://making-the-internet.s3.amazonaws.com/php-confirm-form-resubmission.png' style='max-width:547px;' alt=''>


## GET vs. POST
GET...
+ GET Requests can be bookmarked, since the data is part of the URL.
+ GET Requests can only handle a limited amount of data; roughly 2k characters (give or take, depends on the browser).
+ GET Requests can only handle ASCII characters.
+ GET Requests should never be used for sensitive data (you don't want things like passwords revealed in the browser URL bar).
+ GET Requests should only ever be used to retrieve data (i.e. *show me this book*, not *save this book*)

POST...
+ POST Requests can not be bookmarked; the lifecycle of the data only exists when the request is made.
+ POST has much larger data limits relative to GET, and the limits can be configured on your server.
+ POST Requests can handle binary file data in addition to ASCII characters (i.e. it can be used to upload files)
+ POST Requests should be used in cases where the data is effecting some change on the server. I.e. if a visitor is submitting a form to add a new book, that data will be saved to a database.



## Form design flow
There are different ways you can design your form flow&mdash; the following describes three different designs.


### Design A
In the example shown above, we used a design that involves 2 files/pages, like this:
<img src='https://s3.amazonaws.com/making-the-internet/php-form-designA@2x.png' style='max-width:532px;' alt='Form design Version A'>

__Example: [demo](http://php.dwa15.com/form-flow/version-a/foobooks.php) | [code](https://github.com/susanBuck/dwa15-php/tree/master/form-flow/version-a)__

In this design, the visitor can refresh the `search.php` page and re-submit the form data, which might not be ideal if, for example, the purpose of the form is to add a new entry to a database. Given this, this design is best reserved for forms submitted via GET.




### Design B
Another flow to consider, especially when working with POST, is the following:
<img src='https://s3.amazonaws.com/making-the-internet/php-form-designB@2x.png' style='max-width:752px;' alt='Form design Version B'>
__Example: [demo](http://php.dwa15.com/form-flow/version-b/foobooks.php) | [code](https://github.com/susanBuck/dwa15-php/tree/master/form-flow/version-b)__

In this design, `foobooks.php` submits to `search.php` to process the form data, which then redirects the visitor to a confirmation page (`done.php`).

This design is ideal for POST forms because the visitor can refresh the confirmation page and not risk re-submitting their data which could result in unintended consequences (like repeat rows in a database table).

In order for this flow to work, we need a mechanism to pass data from the `search.php` page to the `done.php` page so the results can be shown. One way to do this is via [PHP sessions](http://php.net/manual/en/session.examples.basic.php), which are covered in this note set: [Cookies and sessions](/php/cookies-and-sessions.md).




### Design C
The final form flow we'll study submits a form to a processing file (`search.php`) which then redirects the visitor *back* to `foobooks.php`, sending with it the results of the processing, also using PHP sessions (similar to Version B).

<img src='http://making-the-internet.s3.amazonaws.com/php-form-designC@2x.png' style='max-width:622px;' alt='Form design Version C'>

__Example: [demo](http://php.dwa15.com/form-flow/version-c/foobooks.php) | [code](https://github.com/susanBuck/dwa15-php/tree/master/form-flow/version-c)__

This flow can be ideal for actions like editing data (e.g. info about a book), where it's often desirable to display the form again after the changes are saved.



## More form input type examples
Beyond text inputs (shown in the examples above), your project may also require checkboxes, radios, or dropdown selects. Examples of each can be seen at the following urls.

+ Examples: <http://php.dwa15.com/forms-inputs/>
+ Code for examples: <https://github.com/susanBuck/dwa15-php/tree/master/forms-inputs>
