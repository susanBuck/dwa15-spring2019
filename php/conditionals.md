# Conditionals
PHP, like most programming languages, allows for conditional execution of code via `if`, `else`, and `elseif` constructs.

Example: Single conditional with an `if` construct:

```php
if ($age > 18) {
    $category = 'adult';
}
```

Note the use of curly brackets to indicate the start and end of the conditional body.

Example: Either/or style conditional with an `if` and `else` construct:
```php
if ($age < 18) {
    $category = 'child';
} else {
    $category = 'adult';
}
```

Example: Chained conditional with the `if`, `elseif`, and `else` construct:
```php
if ($age < 3) {
    $category = 'baby';
} elseif ($age < 18) {
    $category = 'child';
} else {
    $category = 'adult';
}
```

Example: Chained conditionals can have several `elseif`s:
```php
if ($age < 3) {
    $category = 'baby';
} elseif ($age < 16) {
    $category = 'child';
} elseif ($age < 18) {
    $category = 'adolescent';
} elseif ($age < 21) {
    $category = 'young adult';
} else {
    $category = 'adult';
}
```

Example: Independent `if` constructs if your &ldquo;decisions&rdquo; are not exclusive of one another.

```php
$privileges = 'You can: ';

if ($age > 16) {
    $privileges .= 'drive, ';
}
if ($age > 18) {
    $privileges .= 'vote, ';
}
if ($age > 21) {
    $privileges .= 'purchase alcohol, ';
}
if ($age > 75) {
    $privileges .= 'retire, ';
}
```

Side note: In the above example the concatenate (`.`) and assignment (`=`) operator are combined (`.=`):

```php
$privileges .= 'drive, ';
```

This is the equivalent of writing:

```php
$privileges = $privileges.'drive, ';
```

## Switch statements
PHP also supports [switch statements](http://php.net/manual/en/control-structures.switch.php) if you prefer that style of conditional execution. 