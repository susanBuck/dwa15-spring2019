# Error reporting
Before digging further into the PHP language, it's useful to configure your server's error reporting settings so that you're provided feedback when there are problems in your code.

PHP's error reporting threshold and display method can be configured via your server's PHP configuration file, `php.ini`.

Because there are often multiple `php.ini` files on a system, we want to make sure we edit the one that our local server is actually using. To determine this, create a new file in your document root called `info.php` and paste in the following code:

```php
<?php
phpinfo();
?>
```

When run, this built-in `phpinfo` function will display all the PHP configuration information your server is using.

<img src='https://s3.amazonaws.com/making-the-internet/php-local-phpinfo@2x.png' style='max-width:852px;' alt='Results of PHP info'>

In this table of info, we're interested in the following 3 values:

1) The location of your `php.ini` file as indicated by the value for **Loaded Configuration File**

<img src='https://s3.amazonaws.com/making-the-internet/php-php-info-ini-location@2x.png' style='max-width:1004px;' alt='Location of php.ini'>

* MAMP on Mac: `/Applications/MAMP/bin/php/php7.2.x/conf/php.ini` (The specific version number may vary, but it should be something >= 7.2)
* XAMPP on PC: `C:\xampp\php\php.ini`


2) What your `display_errors` configuration is set to. By default, it's likely `off` and we'll change it to `on`.

<img src='https://s3.amazonaws.com/making-the-internet/php-php-info-display_errors@2x.png' style='max-width:700px;' alt=''>

3) What your `error_reporting` configuration is set to (it'll be a numerical value)

<img src='https://s3.amazonaws.com/making-the-internet/php-php-info-error_reporting@2x.png' style='max-width:700px;' alt=''>


## Update your settings
To adjust these settings, open the `php.ini` file from the path found in the above steps, and set...

+ `display_errors` to **on**
+ `error_reporting` to **E_ALL**

**To make your changes take effect, restart your server**.

Confirm the changes by refreshing your `info.php` page and confirming `display_errors` = `on` and `error_reporting` = `32767`. (This value, 32767, is the numerical equivalent of E_ALL)

These two settings will make it so that all levels of PHP errors will be displayed on the page when they occur.

On our production servers we'll configure it so that errors are only written to log files (to avoid accidentally displaying errors to our visitors.)

With errors now accessible, let's learn about the different error types you may see...

## Error types
The following are the most common error types you'll encounter when working with PHP:

### E_ERROR
Fatal run-time errors that will prevent the execution of your script from completing execution.

Example, try to import a file that does not exist:
```php
require 'this-file-is-bogus.php';
```

Produces:
```xml
Fatal error: require(): Failed opening required 'this-file-is-bogus.php' (include_path='.:/Applications/MAMP/bin/php/php7.1.0/lib/php') in /Applications/MAMP/htdocs/hello-world/errorExamples.php on line 3
```

### E_PARSE
Fatal compile errors that will prevent your script from executing.

Example, missing semi-colon:
```
echo "Hello"
echo "World"
```

Produces:
```
Parse error: syntax error, unexpected 'echo' (T_ECHO), expecting ',' or ';' in /Applications/MAMP/htdocs/errorExamples.php on line 4
```


### E_WARNING
A warning is a non-fatal error that means something went wrong, but it will not stop the execution of your script.

Example, improper use of a built-in function:
```php
echo rand(5);
```

Produces:
```xml
Warning: rand() expects exactly 2 parameters, 1 given in /Applications/MAMP/htdocs/hello-world/errorExamples.php on line 3
```


### E_NOTICE
A notice indicates you're doing something that is not exactly an error, but could be problematic. Notices will not stop the execution of your script.

Example, trying to use a variable that has not yet been defined:
```php
echo $foo;
```

Produces:
```xml
Notice: Undefined variable: foo in /Applications/MAMP/htdocs/hello-world/errorExamples.php on line 3
```

While notices won't prevent your scripts from running, they should always be resolved as they are usually an indication of poorly written code.
