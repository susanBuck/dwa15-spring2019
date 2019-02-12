# PHP Syntactic sugar

> In computer science, syntactic sugar is syntax within a programming language that is designed to make things easier to read or to express. It makes the language "sweeter" for human use: things can be expressed more clearly, more concisely, or in an alternative style that some may prefer. [ref](https://en.wikipedia.org/wiki/Syntactic_sugar)

As you're studying the [form inputs](https://github.com/susanBuck/dwa15-php/tree/master/forms-inputs) examples I refer to in Week 3's lecture videos, you'll see some examples of PHP shortcuts for writing if constructs.

These shortcuts (often refered to as &ldquo;syntactic sugar&rdquo;) can be used to make code more succinct and easier to parse, and this can be especially useful in display files where we want to minimize the PHP syntax in favor of HTML.

Let's look at two important examples...

## Ternary operator (`? :`)
The ternary operator `? :` can be used to shorten simple if constructs.

For an example, consider the following code:

```php
if (!isset($_POST['action'])) {
    $action = 'default';
    
} else {
    $action = $_POST['action'];
}
```

Using a ternary operator, we can shorten the above code to this:

```php
$action = (!isset($_POST['action'])) ? 'default' : $_POST['action'];
```

The use of the ternary operator follows this pattern:
```
(boolean expression) ? optionA : optionB
```

A boolean expression is evaluated, and if it evaluates to `true`, `optionA` is chosen, otherwise `optionB` is chosen.

Notice that the boolean expression is followed by a question mark (`?`), and each option is separated by a colon (`:`).


Here's another example:

```php
if($total > 0) {
    $prefix = '+';
}
else {
    $prefix = '-';
}
```

This can be shortened to...

```php
$prefix = ($total > 0) ? '+' : '-';
```


## Null Coalescing Operator (`??`)
Another shortcut operator is the null coalescing operator, or `??`, which allows you to specify an alternative value, if the value you're seeking is null.

For example:
```
$action = $_POST['action'] ?? 'default';
```


In this example, if `$_POST['action']` was not `null`, $action would be set to whatever `$_POST['action']` is.
However, if `$_POST['action']` *was* `null`, it would be set to the string `'default'`.


The above code is equivalent to the following:
```php
if (isset($_POST['action'])) {
    $action = $_POST['action'];
} else {
    $action = 'default';
}
```

The null coalescing operator can be handy for making display code more succinct. For example:

Before:
```php
<input type='text' name='searchTerm' value='<?php if (isset($searchTerm)) echo $searchTerm ?>'>
```

After:
```php
<input type='text' name='searchTerm' value='<?= $searchTerm ?? '' ?>'>
```

## When to use these shortcuts and when to avoid them
The above shortcuts are best reserved for simplifying short if constructs where you're choosing between simple values or expressions.

For more complex values/expressions, however, the shortcut can make for a complex line of code that is needlessly difficult to understand at a glance.

For example, in Foobooks0, we saw this if statement:

```php
if($caseSensitive) {
    $match = $title == $searchTerm;
} else {
    $match = strtolower($title) == strtolower($searchTerm);
}
```

If we were to re-write that using a ternary operator, it'd look like this:
```php
$match = ($caseSensitive) ? $title == $searchTerm : strtolower($title) == strtolower($searchTerm);
```

Arguably, this single line statement is a bit of a &ldquo;mouthful&rdquo; and sacrifices clarify for the sake of brevity.


## Reference
+ [PHP.net Comparison Operators](http://php.net/manual/en/language.operators.comparison.php) (Search the page for *Ternary Operator* and *Null Coalescing Operator*)







