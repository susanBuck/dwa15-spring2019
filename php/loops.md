# Loops
Loops in PHP are very similar to loops in other programming languages (specifically they're styled after the syntax seen in C).



## While loops
A [while](http://php.net/manual/en/control-structures.while.php) loop will execute some statement(s) of code repeatedly until some truth condition is met.

The basic structure of a while loop looks like this:
```php
while(boolean expression) {
    statement(s)
}
```

For example:
```php
$i = 0;
$results = '';

while($i < 10) {
    $results .= $i.' ';
    $i++;
}

dump($results); # string(20) "0 1 2 3 4 5 6 7 8 9 "
```


## For loops
[For loops](http://php.net/manual/en/control-structures.for.php) follow this structure:

```php
for(expr1; expr2; expr3) {
    statement(s)
}
```

+ The first expression (expr1) is evaluated once at the beginning of the loop.
+ At the beginning of each iteration, expr2 is evaluated. If it evaluates to *True*, the loop continues and the nested statement(s) are executed. If it evaluates to *False*, the execution of the loop ends.
+ At the end of each iteration, expr3 is evaluated, and it's typically used to increment a cursor position in the loop.

Here's the above while loop example, re-written using a for loop:
```php
$results = '';

for($i = 0; $i < 10; $i++) {
    $results .= $i.' ';
}

dump($results); # string(20) "0 1 2 3 4 5 6 7 8 9 "
```


## Foreach loops
As was seen in the Array notes, a foreach loop is designed to iterate through an array using this structure:

```php
foreach($array as $key => $value) {
    statement(s)
}
```

For example:

```php
$translations =
[
    'hello' => 'hola',
    'goodbye' => 'adios',
];

foreach($translations as $englishWord => $spanishWord) {
    echo $englishWord.' in Spanish is '.$spanishWord.'<br>';
}
```
Produces:
```php
hello in Spanish is hola
goodbye in Spanish is adios
```


## Altering the flow of loops

### Break
You can &ldquo;early exit&rdquo; a loop using a [`break`](http://php.net/manual/en/control-structures.break.php):

In this example, we iterate through an array of random numbers, stopping at the first even number:
```php
$results = '';
$randomNumbers = [45, 67, 33, 56, 42, 100, 67];

foreach($randomNumbers as $index => $number) {

    if($number % 2 == 0) {
        break;
    }
    $results .= $number.' ';

}
dump($results); # string(9) "45 67 33 "
```

### Continue
You can skip to the next iteration of a loop using [`continue`](http://php.net/manual/en/control-structures.continue.php):

In this example `continue` is used to exclude even numbers from the results:
```php
$results = '';
$randomNumbers = [45, 67, 33, 56, 42, 100, 67];

foreach($randomNumbers as $index => $number) {

    if($number % 2 == 0) {
        continue;
    }
    $results .= $number.' ';

}
dump($results); # string(12) "45 67 33 67 "
```
