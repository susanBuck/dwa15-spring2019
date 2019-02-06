# Data types
PHP supports 8 [data types](http://php.net/manual/en/language.types.php):

* Strings
* Integers
* Floating point numbers
* Booleans
* Arrays
* Objects
* Resource
* NULL

In other programming languages, when declaring a variable you often have to specify the data type of that variable. For example in Java you might declare a variable `temperature` as an integer like so:

```
int temperature;
```

In PHP you don't have to declare a variable's data type; instead, the processor will determine the type based on the value used:

```php
$location = 'Cambridge';
echo gettype($location); # string

$temperature = 75;
echo gettype($temperature); # integer

$temperature = '75';
echo gettype($temperature); # string (because of the quotes)
```

While you don't have to set data types, you can convert types using type casting. This is done by prefixing a value with your desired type in parenthesis, e.g.:

```php
# Cast a floating point number to an integer
$score = (int)10.9;
echo gettype($score); # integer     
```

PHP is a loosely typed language that is lenient when it comes to setting and mixing data types. For example, the following is acceptable in PHP:

```php
$temperature = 75; # Starts as integer
$temperature = '75'; # But then becomes a string (because of the quotes)
```

While this is technically acceptable, it's not recommended. This kind of leniency within PHP is a double-edge sword...

On one hand, it makes PHP easier to jump into for beginners as it's not as &ldquo;picky&rdquo; or verbose as a strongly typed language like Java.

On the flip side, such leniency can make for sloppy code. We'll aim follow best-practices and not abuse such leniencies.
