# Arrays
In PHP, an array is an ordered map that associates values to keys.

A new empty array can be defined like so:

```php
$translations = [];
```

Or, it can be defined with initial values like so:
```php
$translations = [
    'hello' => 'hola',
    'goodbye' => 'adios',
];
```

Note that the array's contents is encapsulated in square brackets.

Each element in the array (e.g. `hello => hola`) is made up of a **key => value pair**.

These key => value pairs are separated by the symbols `=>`, which is often verbalized as &ldquo;points to&rdquo; E.g. In describing this array, you might say: &ldquo;hello *points to* hola&rdquo;

Elements in an array are separated by commas; the comma after the last item in the array is optional.

In the above example, the keys of the array were Strings, and this is referred to as an **associative array**.

The keys of an array can also be Integers, and this is referred to as an **indexed array**:

```php
$phrases = [
    0 => 'hola',
    1 => 'adios',
    2 => 'hasta luego',
    3 => 'por favor',
    4 => 'de nada'
];
```

Indexed arrays can also be written like this, where the key is implicitly defined, starting at 0.

```php
$phrases = [
    'hola',
    'adios',
    'hasta luego',
    'por favor',
    'de nada',
];
```

It's not necessary for the elements of an array to be written on their own lines as shown in the above examples; the syntax can be compacted like so:

```php
$phrases = ['hola', 'adios', 'hasta luego', 'por favor', 'de nada'];
```


## Working with elements in an array
You can access elements in an array using the square bracket syntax, *array[key]*.

```php
echo $phrases[0]; # Output: hola
echo $translations['goodbye']; # Output: adios
```

You can add new values to an existing array using the square bracket syntax:

Example with an associative array:
```php
$translations['good afternoon'] = 'buenas tardes';
```

This same approach can also be used to update an existing value in an array:

```php
# Before
echo $translations['goodbye']; # adios

# Update
$translations['goodbye'] = 'adiós';

# After
echo $translations['goodbye']; # adiós
```

When adding an element to an indexed array, omitting the key will simply add the value as a new element at the end of the array.
```php
$phrases[] = 'buenas tardes';
```

As an alternative to the square bracket syntax, elements in an array can be added/changed using the built-in functions [array_push](http://php.net/manual/en/function.array-push.php) or [array_replace](http://php.net/manual/en/function.array-replace.php).


## Debugging arrays
The built-in PHP function [var_dump](http://php.net/manual/en/function.var-dump.php) can be used to output the contents of an array for debugging purposes.

```php
var_dump($translations);
```

Output:
```xml
array(2) { ["hello"]=> string(4) "hola" ["goodbye"]=> string(5) "adios" }
```

The output of `var_dump` is easier to read when it's nested in a HTML `pre` element.
```php
echo '<pre>';
var_dump($translations);
echo '</pre>';
```

Output:
```xml
array(2) {
  ["hello"]=>
  string(4) "hola"
  ["goodbye"]=>
  string(5) "adios"
}
```

To save you time, a function called `dump` is included in the [`helpers.php`](https://github.com/susanBuck/php/blob/master/helpers.php) helper file discussed in notes on [Imports](/php/imports.md)..

Using this function is as simple as this:
```php
dump($translations);
```

Output:
```xml
array(2) {
  ["hello"]=>
  string(4) "hola"
  ["goodbye"]=>
  string(5) "adios"
}
```

## Value types
While the key of an array can be either a String or an Integer, the values of an array can be many different data types, and the data types can be mixed.

```php
$mixedBag = [
    False, # Booleans
    4.0, # Floats
    1, # Integers
    ['a', 'b', 'c'] # Even other Arrays!
];

dump($mixedBag);
```

Produces:
```xml
array(4) {
  [0]=>
  bool(false)
  [1]=>
  float(4)
  [2]=>
  int(1)
  [3]=>
  array(3) {
    [0]=>
    string(1) "a"
    [1]=>
    string(1) "b"
    [2]=>
    string(1) "c"
  }
}
```

An array containing other arrays is referred to as a **multidimensional array**.

```php
$countries = [
    'US' => [
        'name' => 'United States',
        'languages' => ['English'],
    ],
    'CA' => [
        'name' => 'Canada',
        'languages' => ['English', 'French'],
    ],
    'MX' => [
        'name' => 'Mexico',
        'languages' => ['Spanish'],
    ],
];
```

Accessing elements in a multi-dimensional array requires multiple levels of square brackets

```php
dump($countries['CA']['languages'][0]); # string(7) "English"
```



## Iterating through arrays
PHP's built-in construct [foreach](http://php.net/manual/en/control-structures.foreach.php) is used to iterate through elements in an array.

### Example 1
Print the name of all the countries in the array
```php
foreach($countries as $countryCode => $country) {
    echo $country['name'].'<br>';
}
```

Produces:
```xml
United States
Canada
Mexico
```

### Example 2
Print the country code (key) of all the countries in the array

```php
foreach ($countries as $countryCode => $country) {
    echo $countryCode.'<br>';
}
```

Produces:
```xml
US
CA
MX
```

### Example 3
Print a line that uses the country name, code (key), and languages

```php
foreach ($countries as $countryCode => $country) {
    echo '<br>Primary language(s) of '.$country['name'].' ('.$countryCode.'): <br>';

    foreach($country['languages'] as $key => $language) {
        echo $language.'<br>';
    }
}
```

Produces:
```xml
Primary language(s) of United States (US):
English

Primary language(s) of Canada (CA):
English
French

Primary language(s) of Mexico (MX):
Spanish
```


### Example 4
Update the array so that all the country names are uppercase
```php
foreach ($countries as $countryCode => $country) {
    $countries[$countryCode]['name'] = strtoupper($countries[$countryCode]['name']);
}
```

Note how indexing is used in the foreach loop to access the current country in the iteration, `$countries[$countryCode]`

Alternatively, if you pass your value by reference, you can edit it directly, e.g.:

```php
foreach ($countries as $countryCode => &$country) {
    $country['name'] = strtoupper($country['name']);
}
```



## Built-in array functions
Skim the complete list of built-in PHP [array functions](http://php.net/manual/en/ref.array.php) so you're aware of what's available.

Sampling of commonly used array functions:
+ count — Count all elements in an array
+ in_array — Checks if a value exists in an array
+ krsort — Sort an array by key in reverse order
+ ksort — Sort an array by key
+ rsort — Sort an array in reverse order
+ shuffle — Shuffle an array
+ sort — Sort an array
+ array_pop — Pop the element off the end of array
+ array_push — Push one or more elements onto the end of array
+ array_search — Searches the array for a given value and returns the first corresponding key if successful
+ array_shift — Shift an element off the beginning of array
+ array_slice — Extract a slice of the array
+ array_sum — Calculate the sum of values in an array
