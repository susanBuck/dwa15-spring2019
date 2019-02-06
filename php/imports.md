# Imports
PHP files can import other PHP files using an `include` or `require` statement:

+ [include](http://php.net/manual/en/function.include.php)
+ [require](http://php.net/manual/en/function.require.php)

A common use case for importing files, in any language, is to import a set of common helper functions.

As an example, create a new file called `helpers.php` in the document root from which you're working.

[Fill this file with the code found here...](https://github.com/susanBuck/dwa15-php/blob/master/includes/helpers.php)

This code includes 2 helper functions:

1. `dump` - Used to quickly output variables, arrays, etc. in a readable fashion
2. `sanitize` - Used to remove HTML characters from an array or string; will be used later when we get to forms.

To test the helpers out, create a *second* file called `helpers-demo.php` that has this code:

```php
<?php
# Import the helper functions
require 'helpers.php';

# Then test them out:
dump('hi');
dump(['apples', 'oranges', 'pears']);
dump(sanitize('<script>alert("Hi!")</script>'));
```

This produces results like the following:

<img src='http://making-the-internet.s3.amazonaws.com/php-toolsDemo@2x.png' style='max-width:704px;' alt='Demonstrating helpers.php'>

If you run this test and get an error that `helpers.php` can't be found, be sure both `helpers.php` and `helpers-demo.php` are in the same location. If they're not, you need to adjust the path in the require statement.

Moving forward in the notes, if you see the `dump` function being used in examples, you can assume the `helpers.php` file has been/should be imported.


## include vs. require
The difference between include and require is that include will not throw an error if the file is not found.

To demonstrate, imagine you're trying to open a file called `foobar.php` but, for whatever reason, it does not exist.

This would cause an error:
```php
require 'foobar.php';
```

This would cause a warning rather than an error:
```php
include 'foobar.php';
```

