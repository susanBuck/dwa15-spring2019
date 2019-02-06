# Variables

```php
$temperature = 75;
$scale = "F";
$location = 'Cambridge';
```

PHP variables don't have to be declared before they're used. Setting a variable for the first time will simultaneously declare that variable.

Variable names should start with a letter or underscore, and can be followed by any number of letters, numbers, or underscores.

Acceptable:

+ `$foo`
+ `$foo1`
+ `$foo_bar`
+ `$fooBar`
+ `$_foo`


Not acceptable:
+ `$1foo`
+ `$foo%`


In this course, our convention is to use `lowerCamelCase` style for variable names, and we will aim for a balance of concise yet descriptive variable names.


## Assignment methods

*The rest of this document gets into the finer details of how variables are handled in PHP; this information is presented for those that are interested, but it isn't crucial. If you're a beginner programmer, you can skim these details, but don't worry about mastering them right now.*

### Assignment by value

By default, when you assign one variable to another, it **copies** the original value to the new one.

This means that any changes to the new variable will not affect the original.

Example:

~~~php
$foo = 1;
$bar = $foo;
$bar = 2; # Change $bar, yet $foo will remain 1
echo $foo; # Outputs 1
~~~

### Assignment by reference

When assigning a variable *by reference*, both variables will point to the same data; nothing is copied.

Assigning a variable by reference is done with an ampersand.

Example:

~~~php
$foo = 1;
$bar = &$foo;
$bar = 2;
echo $foo; # Outputs 2
~~~

Below we'll talk more about how you can pass variables to functions by reference.





## Variable Scope

Variables in PHP have four possible scopes:

* global
* local
* static
* function parameters

The scope of a variable is controlled by where the variable is declared.

### Global variables

A variable declared **outside a function** is **global**. This means it is visible to any part of the script, *except* inside of functions.

Given that, the following would not work:

~~~php
function reportVotes() 
{
	echo "Vote count:".$votes;
}

$votes = 50; # Global
reportVotes();
~~~

The reason is because the variable `$votes` is global, and therefor when you try to use it inside the `reportVotes()` function, it doesn't know what you're talking about.

In order to make a global variable visible in a function, you have to use the **global keyword**.

You could fix the above code like this:

~~~php
function reportVotes() 
{
	global $votes; 	# Makes the global variable $votes visible inside this function
	echo "Vote count:".$votes;
}

$votes = 50; # Global
reportVotes(); # Outputs "Vote count: 50"
~~~

### Local variables

A variable declared **in a function** is **local** to that function. This mean it's only visible to the code in that function; it is not visible outside the function.

~~~php
function upvote() 
{
	$votes++; # Local
}

$votes = 50; # Global
upvote();
echo $votes; # Outputs 50
~~~


### Static variables

Static variables are used in functions, and visible only in functions; they are used to remember a variable's value across multiple function calls.

Example:

~~~php
function upvote() 
{
	static $votes = 99;
	$votes++;
	echo $votes.'<br>';
}

upvote(); # Outputs 100
upvote(); # Outputs 101
upvote(); # Outputs 102
upvote(); # Outputs 103
~~~

### Function variables

Function variables are defined via the parameters of a function call, and are local to the given function.

Example:

~~~php
function upvote($votes) 
{
	$votes++;
	echo $votes.'<br>';
}

upvote(99);  # Outputs 100
echo $votes; # Undefined
~~~


## Variable References
We already talked about assigning variables by reference, now let's look at how they're used in functions...

If you pass a variable **by reference** to a function, **that function has the ability to modify the variable you're passing**.

For example, let's start with a scenario where the parameter passed to a function is *not* passed by reference:

~~~php
function upvote($votes) 
{
	$votes++;
}

$votes = 50;
upvote($votes);
echo $votes; # Outputs 50
~~~


Note how `$votes` is incremented inside the function, but the end result is still 50. This is because the *local* `$votes` used in the function is independent from the *global* `$votes` used outside the function.

Now let's look at that same function, but this time the parameter *is* passed by reference (as indicated with the ampersand):

~~~php
function upvote(&$votes) 
{
	$votes++;
}

$votes = 50;
upvote($votes);
echo $votes.'<br>'; # Outputs 51
~~~

This time, the end result is 51 because the *global* `$votes` variable was passed by reference, allowing it to be updated locally in the function.


## Summary
Given all the above, you may notice that the different variable scopes can be used to achieve the same result.

For example, image this scenario:

You're starting out with 100 votes.
You want a function to increase the votes by 1 each time it is called, and echo the results.
The final output should thus be:

	101
	102
	103

### Using a global variable...

~~~php
function upvote() 
{

	global $votes;
	$votes++;
	echo $votes.'<br>';

}

$votes = 100;
upvote(); # Outputs 101
upvote(); # Outputs 102
upvote(); # Outputs 103
~~~


### Using a static variable...

~~~php
function upvote() 
{
	static $votes = 100;
	$votes++;
	echo $votes.'<br>';
}

upvote(); # Outputs 101
upvote(); # Outputs 102
upvote(); # Outputs 103
~~~


### Using a variable reference....

~~~php
function upvote(&$votes) 
{
	$votes++;
	echo $votes.'<br>';
}

$votes = 100;
upvote($votes); # Outputs 101
upvote($votes); # Outputs 102
upvote($votes); # Outputs 103
~~~


