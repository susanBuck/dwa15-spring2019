# Routes
As we saw in the [*Basic flow*](/laravel/basic-flow.md) notes, your application’s web routes are declared in `routes/web.php` using Laravel's Route facade. For example:

```php
Route::get('/books', function () {
    return 'Here are all the books...';
});
```

In addition to `get`, the `Route` class also has methods for the following [HTTP methods](https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.4):

1. GET
2. POST
3. PUT
4. DELETE

Looking at the [API documentation for Route's `get` method](https://laravel.com/api/5.8/Illuminate/Routing/Router.html#method_get), we see the following information:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-router-get-function-signature@2x.png' style='max-width:982px;' alt=''>

Studying this function signature, we see the `get` method expects **2 parameters**.

1. `$uri`
2. `$action` (Can be a `Closure`, `array`, or `string`)

<br><br>
Knowing this, we can breakdown our examples so far like so:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-route-breakdown@2x.png' class='' style='max-width:545px; width:100%' alt='Route breakdown'>

If you're unfamiliar with closures...

>> &ldquo;*Anonymous functions, also known as closures, allow the creation of functions which have no specified name. They are most useful as the value of callback parameters, but they have many other uses.*&rdquo; ([src](http://us2.php.net/manual/en/functions.anonymous.php))


## Route parameters
You can make route URI's more flexible with route parameters. These parameters are indicated with curly brackets `{ }` and act as placeholders that will detect patterns in the URL. When the routes are processed, the parameters in the URL are passed as arguments to the corresponding closure.

For example:

```php
Route::get('/books/{title}', function($title) {
    return 'Results for the book: '.$title;
});
```

Test the above route by visiting `http://foobooks.loc/books/war-and-peace`.

Next, test it again, but this time purposefully exclude the book title, `http://foobooks.loc/books/`; this should show a generic error page that says *Sorry, the page you are looking for could not be found*.


### Optional route parameters
Rather than throw an error, you can make the title route parameter *optional* by adding a question mark, e.g. `{title?}`.

If you do this, you'll want to update the closure's `$title` parameter so it defaults to an empty string, e.g. `$title = ''`.

Then, you can create a more useful response for the visitor as to why their request did not work.

To demonstrate this, replace the above `/book` route with this updated version:

```php
Route::get('/books/{title?}', function($title = '') {
    if ($title == '') {
        return 'Your request did not include a title.';
    } else {
        return 'Results for the book: '.$title;
    }
});
```

Again visit the URL omitting the title, `http://foobooks.loc/books/`, and note the difference.


### Multiple route parameters

Routes can accept multiple parameters, for example:

```php
Route::get('/books/{category}/{subcategory}', function($category, $subcategory) {
    return 'Here are all the books in the category '.$category.' and '.$subcategory;
});
```

Note that the arguments the closure will receive correspond to the order in which the route parameters are defined in the URI pattern. E.g. because the `{category}` route parameter is listed first, it’s the first argument passed to the closure (which is why it’s logical to name that parameter `$category` as well).

The actual names you give the parameters is technically irrelevant - only the order matters - as is evidenced by this example:

```php
Route::get('/books/{category}/{subcategory}', function($x, $y) {
    return 'Here are all the books in the category '.$x.' and '.$y;
}); 
```

That being said, it’s best practice to be consistent with the names of your route parameters and the closure parameters to avoid confusion.







## Artisan routes
[Artisan](https://laravel.com/docs/artisan) is a PHP command line tool that ships with Laravel and provides shortcuts and utilities for working with your application.

For our first example of what Artisan can do, have it tell you what routes are set up in your application:

```bash
$ php artisan route:list
```

Example output:

```xml
/Applications/MAMP/htdocs/foobooks $ php artisan route:list
+--------+----------+---------------+------+---------+--------------+
| Domain | Method   | URI           | Name | Action  | Middleware   |
+--------+----------+---------------+------+---------+--------------+
|        | GET|HEAD | /             |      | Closure | web          |
|        | GET|HEAD | api/user      |      | Closure | api,auth:api |
|        | GET|HEAD | books         |      | Closure | web          |
|        | GET|HEAD | books/{title} |      | Closure | web          |
+--------+----------+---------------+------+---------+--------------+
```

Note: The `php artisan` command must always be run from *within* your application directory.

