# Functions

## User-defined functions
Here's an example to demonstrate the syntax for user-defined functions:

```php
function getCelsius(int $temperature, $includeUnit = true)
{
    $result = ($temperature - 32) / 1.8;

    if ($includeUnit) {
        return $result .= ' C';
    } else {
        return $result;
    }
}

# Example usage
echo getCelsius(75); # Output: 23.8888888889 C
echo getCelsius(75, false); # Output: 23.8888888889
```

Observations:

* Function begins with the keyword `function`.
* Naming
    * `getCelsius` is the user-defined name for this function.
    * Function names should start with a letter or underscore, followed by any number of letters, numbers, or underscores.
    * In this course, our convention is to use `lowerCamelCase` function names.
* Parameters
    * Functions can accept 0 or more parameters, separated by commas (this example accepts 2).
    * A default argument can be assigned (`$includeUnit = true`).
    * Parameters can be type hinted (`int $temperature`), requiring arguments for that parameter to match the specified type.
* The body of a function is encapsulated in curly brackets and indented.
* This function returns a value, but a return statement is not required.


## Built-in functions
PHP has many built-in functions to address common program needs.

For example, the built-in Math function [rand](http://php.net/manual/en/function.rand.php) can be used to produce a pseudo-random number:

```php
$luckyNumber = rand();
$luckyNumber = rand(0, 100);
```

__To be covered in lecture: reading function signatures in the documentation.__


There are many built-in PHP functions ([full reference](http://php.net/manual/en/funcref.php)); here's a summary of some commonly used ones to give you a sense of what tools you have at your disposal:

[String functions](http://php.net/manual/en/book.strings.php)
+ strstr — Find the first occurrence of a string
+ strtolower — Make a string lowercase
+ strtoupper — Make a string uppercase
+ substr_count — Count the number of substring occurrences
+ substr_replace — Replace text within a portion of a string
+ str_replace — Replace all occurrences of the search string with the replacement string
+ ucfirst — Make a string's first character uppercase
+ ucwords — Uppercase the first character of each word in a string
+ ltrim - Strip whitespace (or other characters) from the beginning and end of a string
+ rtrim — Strip whitespace (or other characters) from the end of a string
+ explode — Split a string by string
+ htmlentities — Convert all applicable characters to HTML entities

[Math functions](http://php.net/manual/en/book.math.php)
+ ceil — Round fractions up
+ floor — Round fractions down
+ max — Find highest value
+ min — Find lowest value
+ round — Rounds a float

[Date/Time functions](http://php.net/manual/en/ref.datetime.php)
+ date — Format a local time/date
+ getdate — Get date/time information
+ gettimeofday — Get current time

[Filesystem functions](http://php.net/manual/en/book.filesystem.php)
+ copy — Copies file
+ delete — See unlink or unset
+ rename — Renames a file or directory
+ file_exists — Checks whether a file or directory exists
+ file_get_contents — Reads entire file into a string
+ file_put_contents — Write a string to a file
+ file — Reads entire file into an array
+ filesize — Gets file size
+ filetype — Gets file type
+ is_dir — Tells whether the filename is a directory
+ is_file — Tells whether the filename is a regular file
+ mkdir — Makes directory
+ move_uploaded_file — Moves an uploaded file to a new location

[JSON functions](http://php.net/manual/en/book.json.php)
+ json_decode — Decodes a JSON string
+ json_encode — Returns the JSON representation of a value
