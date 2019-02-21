# PHP and HTML
In all the examples thus far, we've been running blocks of PHP code in a .php file, and we were able to see the results by running the file via a server, with the output displayed in the browser.

This works for demonstration purposes, but obviously our web applications should ultimately be producing properly formatted HTML web pages.

We turn now, then, to the discussion of how PHP and HTML work together.

First, it’s important to know that a .php file can include both HTML and PHP code, for example, paste the following code in a new practice file called `today.php`:

```html
<?php
date_default_timezone_set('America/New_York');
$day = date('l');

if (in_array($day, ['Friday', 'Saturday', 'Sunday'])) {
    $toDo = 'relax';
} else {
    $toDo = 'work';
}
?>

<!DOCTYPE html>
<html>
<head>
    <!-- Head code excluded for brevity -->
</head>
<body>
    <h1>Daily Planner</h1>
    <p>
        Today is <?php echo $day; ?>; it's time to <?php echo $toDo; ?>.
    </p>
</body>
</html>
```

In this code we see mostly HTML, with some PHP sprinkled in a couple places. If you run this example, you'll see the HTML produced in the browser looks like this (this example was generated on a Friday):

```xml
<!DOCTYPE html>
<html>
<head>
    <!-- Head code excluded for brevity -->
</head>
<body>

    <h1>Daily Planner</h1>

    <p>
        Today is Friday; it's time to relax.
    </p>

</body>
</html>
```

From these results, we can conclude that the local server processed the PHP code and produced the resulting HTML.

When PHP code is mixed with HTML like this, it's done so via what we'll call &ldquo;code islands&rdquo;&mdash; that is, blocks of PHP code separated from the surrounding HTML with start/end tags `<?php ?>`.

At the top of the file, there was a larger PHP code island that performed some logic to determine the day and "to do" item:

```php
<?php
date_default_timezone_set('America/New_York');
$day = date('l');

if (in_array($day, ['Friday', 'Saturday', 'Sunday'])) {
    $toDo = 'relax';
} else {
    $toDo = 'work';
}
?>
```

Down in the body of the HTML, a small PHP code island was used to display the "to do" item.

```html
<p>
    Today is <?php echo $day; ?>; it's time to <?=php echo $toDo; ?>
</p>
```

As you can see, mixing PHP and HTML code is straightforward, and in this simplistic example it works just fine.
When dealing with even moderately complex web applications, however, this mixing of logic and display will be problematic, and so we'll design our codebase such that the logic and display code is separated yet connected  (rather than intermingled).

Before we talk about how to do that, let’s first spend more time explaining the distinction between logic and display PHP.


## Logic and Display
Generally speaking, code can be divided into two categories:

1. **Logic:** Code that defines or performs logic, for example, setting a variable, defining or invoking a function.
2. **Display:** Code that produces output (sometimes called side-effects)

__Example logic code:__

```php
<?php
$x = 1;

function square($x)
{
    return $x * $x;
}

if (isset($user)) {
    $loggedIn = true;
}
?>
```

Note that there is no output produced from this code.

Contrast that to this __example display code__:

```php
<?php
echo 'Hello<br>';
echo square(4);
?>

<h1>Welcome to <?php echo $title; ?></h1>
```
This example would produce 3 lines of output in your HTML page.

You can think of logic code as the &ldquo;brains&rdquo; of your application that is in charge of all the prep work that happens *before* output is displayed.

__Example logic task:__ Fetch a user's recent orders from the database.

Display code takes the product of this logic and, in combination with HTML, displays it on the page.

__Example display task:__ If a user has recent orders, display each one.

Your logic and display code depend on one another, but following the practices of [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns), it’s important to keep them separate in your codebase.

For a basic PHP page like the daily planner example above, this is as simple as separating the two types of code into two different files and then connecting them.

Try it...

Create a new file, `today-logic.php` and extract the logic code from `today.php` into it:

```php
<?php
date_default_timezone_set('America/New_York');
$day = date('l');

if (in_array($day, ['Friday', 'Saturday', 'Sunday'])) {
    $toDo = 'relax';
} else {
    $toDo = 'work';
}

# Closing PHP tag purposefully excluded; reason why explained below.
```

In place of the logic code you extracted from `today.php`, add a require statement to import the code from `today-logic.php`:


```html
<?php require 'today-logic.php'; ?>
<!DOCTYPE html>
<html>
<head>
    <!-- Head code excluded for brevity -->
</head>
<body>

    <h1>Daily Planner</h1>

    <p>
        Today is <?php echo $day; ?>; it's time to <?php echo $toDo; ?>.
    </p>

</body>
</html>
```

As you can see, all the prep work needed for the page is done in the logic file, `today-logic.php`. Then, the resulting HTML is built in the display file, `today.php`.

### Omitting the closing PHP tag in logic files
The above logic file purposefully excluded a closing PHP tag; it's not needed in files that don't produce any output, and excluding it helps prevent trailing spaces from being output to the page, which can break certain PHP functionality like redirects or setting cookies.


## Display code other than echos
Most of the PHP code you'll see in display files will be simple echo statements:

```html
Today is <?php echo $day; ?>; it's time to <?php echo $toDo; ?>
```

However, other PHP constructs can facilitate your display. Consider this hypothetical example to display a series of recent orders:

```html
<h1>Recent Orders</h1>
<?php foreach ($orders as $orderId => $order) { ?>
    <a href='/orders/<?php echo $orderId'> <?php echo $order['dateTime'] ?>

    <div class='shipStatus'>
        <?php if ($order['shipped']) { ?>
            Your order has shipped! Tracking: <?php echo $order['trackingNumber']; ?>
        <?php else { ?>
            Expected ship date: <?php echo $order['shipDate']; ?>
        <?php } ?>
    </div>
<?php } ?>
```

In the above example a *foreach loop* and *if* construct is used to produce the display. This kind of mixing of PHP and HTML code is okay, as long as the constructs are only for display purposes.

Contrast this to if we wanted to add the total cost of all orders to our display page and we did something like this:

```html
<?php
$total = 0;
foreach ($orders as $orderId => $order) {
    $total += $order['amount'];
}
?>
<div class='total'>
    Order history total: $<?php echo $total; ?>
</div>
```

This is poor design&mdash; the logic used to calculate the order history total should happen in the logic file. Adding it to the display page breaks the separation of concerns and clutters the HTML.


## Alternative syntax
PHP has syntax shortcuts that make PHP display code easier to integrate and read in HTML code.

First, there's the echo shortcut&mdash;

Instead of:
```php
Today is <?php echo $day ?>
```

You can write:
```php
Today is <?=$day?>
```

It’s a small difference, but the terser syntax will be appreciated in complex HTML structures.

With for loops, instead of writing this:

```html
<?php foreach ($orders as $orderId => $order) { ?>
    [...]
<?php } ?>
```

You can replace the open/close curly brackets with a `:` and `endforeach`, like so:

```html
<?php foreach ($orders as $orderId => $order) : ?>
    [...]
<?php endforeach; ?>
```

This syntax is actually more verbose, but it makes reading the code easier since it explicitly spells out the close of the foreach block. This is desirable for long blocks of code with lots of HTML, because when you reach the end `<?php endforeach; ?>` you know what it's ending, compared to the less explicit `<?php } ?>`.

The same alternative syntax can be used for if statements:
```php
<?php if ($order['shipped']) : ?>
    Your order has shipped! Tracking: <?=$order['trackingNumber'] ?>
<?php else: ?>
    Expected ship date: <?=$order['shipDate'] ?>
<?php endif; ?>
```

Read more: [php.net Alternative syntax for control structures](http://php.net/manual/en/control-structures.alternative-syntax.php)

