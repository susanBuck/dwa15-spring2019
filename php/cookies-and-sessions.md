# Cookies and sessions

## Application memory
In a traditional desktop or stand-alone application, there's a memory system in place that is used to store and retrieve data as long as the application is running.

With web applications, however, our applications are cycled every time the page loads, so we need some mechanism to store data between runs, i.e. between requests.

Example use case: remembering logged in users as they browse different pages on your application.

Retaining data between requests can be accomplished with cookies and sessions.

__Cookies__ 
+ Small text payloads made up of a key,value pair that is stored in a visitor's browser
+ Servers can both set and retrieve cookies
+ Cookies are domain specific&mdash; a server/site can only access cookies that it created.

__Sessions__ 
+ Also small text payloads made up of key,value pairs, but instead of being stored on the user's browser, they're stored on the server
+ Sessions can be stored in a variety of ways on the server, such as in plain text files, or in a database

Cookies and sessions are used, in combination, to recall information as a visitor uses your site. Example:

Visitor logs in...
+ a *session* is created on the server; it contains the user's id (used to query all the info about that user from the database)
+ A *cookie* is also set that contains the name of the session that was just created

Visitor visits the site again...
+ PHP looks for the user cookie, and upon finding it, extracts the name of the session to look for
+ Session is loaded, and from it the user id is extracted and used to query the database for info about that user.


## Cookie example
For a more tangible example, we could use cookies to recall what the visitor's most recent search was.

### Setting cookies
Cookies can be set with PHP's [`setcookie`](http://php.net/manual/en/function.setcookie.php) function, e.g.:

```php
# Create a cookie with they key 'recentSearch' that holds the POST value for 'searchTerm' 
setcookie('recentSearch', $_POST['searchTerm']);
```

Because cookies are set as part of a request's header, you can not have *any* output to the page before setcookie is invoked.

E.g.

This would cause an error:
```php
echo 'hi!';
setcookie('recentSearch', $_POST['searchTerm']);
```

This would not
```php
setcookie('recentSearch', $_POST['searchTerm']);
echo 'hi!';
```


### Getting cookies
Cookies can be retrieved using PHP's [`$_COOKIE`](http://php.net/manual/en/reserved.variables.cookies.php) superglobal.

```php
dump($_COOKIE['recentSearch']);
```


### Example
Here's an example code showing how we could utilize cookies in Foobooks0 to retain a visitor's search term: 

```php
<?php
require('helpers.php');

if(isset($_COOKIE['recentSearch'])) {
    $recentSearch = $_COOKIE['recentSearch'];
}
else {
    $recentSearch = '';
}

if(isset($_POST['searchTerm'])) {
    setcookie('recentSearch', $_POST['searchTerm']);
}

dump('You recently searched for: '.$recentSearch);
dump('You just searched for: '.$_POST['searchTerm']);
```


## Session example
To uses PHP sessions, you first need to invoke the following function on any script that will use sessions. (This invokation is typically placed at the top of the script)

```php
session_start();
```

Once sessions are started, you can get/set them using the PHP superglobal `$_SESSION`:

Example setting a session:
```php
$_SESSION['searchTerm'] = $_POST['searchTerm'];
```

Example getting a session:
```php
$searchTerm = $_SESSION['searchTerm'];
```

You can clear individual sessions like this:
```php
$_SESSION['searchTerm'] = null;
```

Or invoke this function:
```php
session_unset();
```

For a more complete example of sessions, see the [Form flow version C example](https://github.com/susanBuck/dwa15-php/tree/master/form-flow/version-c).

