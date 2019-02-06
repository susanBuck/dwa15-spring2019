# Random quote tips (for P1)

A requirement of Project 1 is a simple PHP feature that displays a different quote each time the page is loaded.

Example seen here: <http://p1.dwa15.com>

If you're unfamiliar with PHP, the course PHP notes assigned in Week 2 will give you all the information you need to accomplish this task.

There are limitless approaches to this simple feature; here are some ideas:

+ Create an array of quotes, and then use PHP's built-in [array_rand](http://php.net/manual/en/function.array-rand.php) to select one of them.

+ Create an array of quotes, [shuffle](http://php.net/manual/en/function.shuffle.php) the array, and then
[pop](http://php.net/manual/en/function.array-pop.php) the last element from the array as your selected quote.

+ Create an array of quotes and generate a random number (using [rand]([rand](http://php.net/manual/en/function.rand.php))) that's between 0 and the length of the array. Use this random number to extract one of the elements of the array as your selected quote.

+ Your own approach...

__Whatever approach you use, be sure to follow the practices described in the note set [PHP and HTML](/php/php-and-html.md) when building Project 1.__
