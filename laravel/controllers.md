# Controllers
Controllers are classes used to group related request handling logic.

You can manually create controller files, or you can have Artisan generate them for you using the command `php artisan make:controller` followed by the controller name.

For example:

```xml
$ php artisan make:controller BookController
Controller created successfully.
```

Find the resulting file at `foobooks/app/Http/Controllers/BookController.php`

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class BookController extends Controller
{
    //
}
```

Some observations about the generated controller:

+ __Location__
	+ Controller class files are stored in `/app/Http/Controllers/`. This directory is [psr-4](http://www.php-fig.org/psr/psr-4/) loaded in `/composer.json`, so anything you put here will be readily available using the appropriate namespace.
+ __Naming conventions__
	+ Suffix controller file names with `Controller` and use [upper CamelCase style](https://en.wikipedia.org/wiki/CamelCase#Variations_and_synonyms) (ex: `BookController`).
	+ Controllers are classes, so they should be named singularly (e.g. `BookController`, not `BooksController`).
+ __Parent Controller class__
	+ Controller classes should extend Laravel's `Controller` class, which also exists in `/app/Http/Controllers/`.
	+ This base class is where you can put common logic shared by all your controllers, and it imports several Laravel convenience methods which we'll be taking advantage of.
+ __Methods (aka actions)__
	+ Within your controller class you'll have **public methods** which represent the **actions** of your Controller; these actions will be tied to routes.


## Connecting routes to controllers
Once you have controllers, you can set up your routes so that they invoke an **action** instead of a closure. In Laravel terms, an action is just a method in a controller that can be invoked from your routes using the pattern `Controller@method`, e.g. `BookController@index`.

So, this...

```php
Route::get('/books', function () {
    return 'Here are all the books...';
});
```

Can become this:

```php
Route::get('/books', 'BookController@index');
```

And the work that *was* happening in the route can now be outsourced to a `index` method in the Controller:

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class BookController extends Controller {

    /**
    * GET /books
    */
    public function index()
    {
        # Work that was previously happening in the routes file is now happening here
        return 'Here are all the books...';
    }
}
```

After making these changes, visit `http://foobooks.loc/books` to make sure it's still working.

## Route parameters 
Your controller actions/methods can accept route parameters just like the closures did, as can be seen if we refactor the *Show a book* route.

Refactor route to invoke `BookController@show`:
```php
Route::get('/books/{title}', 'BookController@show');
```

And add the following `show` method to the BookController.
```php
/**
* GET /books/{title}
*/
public function show($title)
{
    return 'Results for the book: '.$title;
}
```

Note how the `show` method accepts a single parameter, `$title`, which will automatically correspond to our `{title}` route parameter just like it did with closures.


## Summary
Controllers provide a way to organize your application into logical parts. As we progress, we'll add all book related actions (add a book, edit a book, etc.) to the `BookController`.

As applications grow in complexity, you can/should organize them via multiple controller files. For example, eventually our Foobooks app will have the ability to add/edit/view authors, and to handle that functionality we would add an `AuthorController`.