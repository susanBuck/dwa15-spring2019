>> &ldquo;Any fool can write code that a computer can understand. Good programmers write code that humans can understand.&rdquo; – Martin Fowler, Refactoring: Improving the Design of Existing Code.


# Code style
It's common for development teams to have a coding style guide&mdash; a set of rules for how code should be written, which covers details like:

+ Case conventions - e.g., when/where to use lowerCamelCase, snake_case, UpperCamelCase, etc.
+ Structural conventions - e.g., whether to use spaces or tabs, where to place braces, what's the maximum length a line of code should be, etc.
+ Etc...

The purpose of a style guide is to keep work consistent amongst a group of developers. Even if you're working independently, abiding by a style guide will help produce more consistent code that's less prone to errors.

As an example, this is the [Ruby style guide that the team at Github.com uses](https://github.com/github/rubocop-github/blob/master/STYLEGUIDE.md).

On a more macro level, sometimes entire languages have dedicated style guides, such as the case with [Python's PEP 8 style guide](https://www.python.org/dev/peps/pep-0008/).

PHP has two style guides maintained by the [PHP Framework Interop Group (FIG)](http://www.php-fig.org):

+ [PSR-1 Basic Coding Standard](http://www.php-fig.org/psr/psr-1)
+ [PSR-2 Coding Style Guide](http://www.php-fig.org/psr/psr-2/)

When a language has an official style guide, it's not required that it be implemented 100%, and teams may decide to go off course with their own variations. The emphasis on style is not about which style guide you're following, simply that you are following *some* style guide and are aiming to be consistent and thoughtful in regards to code design.

**In this course, we will follow the PSR-1/PSR-2 guidelines in our PHP code files** 

You can diverge from these guidelines, but you will be required to outline your divergences in your project's README.md file, and the divergences must be reasonable.

PhpStorm will *mostly* keep you in line with the guidelines, so use it to reformat your code often, and pay attention to warnings/notes it shows you.


## Example
Consider the following code example which is problematic in several ways:

```php
<?php

function getCelsius($temperature = NULL,$includeUnit = TRUE) {

    # $x = ($temprature * 1.8 + 32 # f -> c
    $x = ($temprature - 32) / 1.8

    if ($includeUnit == TRUE) {

        return $x .= ' C';
    }
    else{
        return $x;


    }
}

?>
```

Things PhpStorm will clean-up for you when you *Reformat Code*:
+ Constants, booleans, and null values should be lowercase.
+ Comma separated lists (e.g. the parameter list) should have a space after each comma.
+ Inconsistent spacing of braces after the `if` and `else`.
+ Function/method opening brace should be on its own line.
+ Unnecessary closing PHP tag.
+ Extra spacing between lines.
+ Incorrect indentation&mdash; the first `return` statement is a child of the `if` construct and thus it should be indented.

Things PhpStorm will alert you about:
+ There's a typo in the variable name (`$temprature` should be `$temperature`).
+ Missing semi-colon at the end of the line setting variable `$x`.
+ Unnecessary closing PHP tag

General problems that PhpStorm can't catch but you should be aware of:
+ The variable name `$x` is generic and in a larger context it could be confusing. A better name would be `$result`.
+ There's a commented-out line of code that's not being used, and no context is provided as to why it's still there. Lines like this should be cleaned up when finalizing a project. Exceptions are made if you comment that you're leaving the old code in for learning purposes.
+ The structure/use of the if/else construct and return statement could be optimized.

Here's that same example, cleaned up and optimized:
```php
<?php

function getCelsius($temperature = null, $includeUnit = true)
{
    $result = ($temperature - 32) / 1.8;

    if ($includeUnit) {
        $result .= ' C';
    }

    return $result;
}
```



## Comments
>> "Good comments don't repeat the code or explain it. They clarify its intent. Comments should explain, at a higher level of abstraction than the code, what you're trying to do." -Steve McConnell

The PSR guidelines offer no rules on PHP commenting style, so any of the following PHP commenting styles are acceptable.

Multi-line block comment:
```php
/* 
This is a 
multi-line
comment in PHP
*/
```

Single line inline comments:
```php
# This is a single line in comment using a hash sign

// This is also a single line comment using two forward slashes, or "C++ style"
```



## Other, non-PHP code
There are no specific style guides I ask you adhere to when it comes to JavaScript, CSS, or HTML in your work.

However, just like PHP, it's expected that this code is consistent and neat for maximum legibility, __following the best practices and requirements for the respective language__.

That being said, here are some common issues I see in student's HTML code that you should avoid:

+ While the contents of most block elements should be indented appropriately, the contents of the `head` and `body` element should not be indented.
+ CSS and JS should always be linked externally, not applied inline or via embedded code.
+ Always use the most appropriate HTML element for the job
    + E.g. Don't use a `<h1>` tag just to make text big
    + E.g. Don't put the site's navigation links in a `<div>`, put them in a `<nav>`
    + Related: [Avoid div as much as possible](https://github.com/hail2u/html-best-practices#avoid-div-element-as-much-as-possible)
    + Likewise: [Avoid span as much as possible](https://github.com/hail2u/html-best-practices#avoid-span-element-as-much-as-possible)
+ [Don't mix quotation marks](https://github.com/hail2u/html-best-practices#dont-mix-quotation-marks)
+ [Write one list item per line](https://github.com/hail2u/html-best-practices#write-one-list-item-per-line)
+ [Use clear link text](https://github.com/hail2u/html-best-practices#clear-link-text)
+ [Don't use br element for presentational purpose](https://github.com/hail2u/html-best-practices#dont-use-br-element-only-for-presentational-purpose)
+ [Don't use placeholder attribute for labeling](https://github.com/hail2u/html-best-practices#dont-use-placeholder-attribute-for-labeling)
+ [Don't mix character cases](https://github.com/hail2u/html-best-practices#dont-mix-character-cases)

## Validating HTML
During development and before submission, run any/all pages of your project via the [w3 validator](https://validator.w3.org) to identify and fix any errors or warnings. (If you disagree with any of the warnings the validator is showing, email me ahead of time so we can confer on whether ignoring the warning is acceptable).

## PHP Code in display files
You may diverge PSR-1/PSR-2 guidelines in display files (.html, .blade.php) that incorporate PHP if it's for the purposes of writing more legible display code. 




 
