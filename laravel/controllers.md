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
+ __Naming__
	+ It's convention to suffix controller file names with `Controller` and use [upper CamelCase style](https://en.wikipedia.org/wiki/CamelCase#Variations_and_synonyms) (ex: `BookController`).
	+ It's convention for controller names to be singular (e.g. `BookController`, not `BooksController`).
+ __Parent Controller class__
	+ Controller classes should extend Laravel's `Controller` class, which also exists in `/app/Http/Controllers/`.
	+ This base class is where you can put common logic shared by all your controllers, and it imports several Laravel convenience methods which we'll be taking advantage of.
+ __Methods (aka actions)__
	+ Within your controller class you'll have **public methods** which represent the **actions** of your Controller; these actions will be tied to routes.


## Connecting routes to controllers
Once you have controllers, you can set up your routes so that they invoke specific methods in controllers. This means you don't have to embed logic in your routes file as we've been doing this far.

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

Note how we replaced the closure with `BookController@index` where `BookController` is the name of the Controller to use and `index` is the name of the method within that Controller to use.

You'll also want to move the logic into the `index` method in `BookController.php`:

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
        return 'Here are all the books...';
    }
}
```

After making these changes, visit `http://foobooks.loc/books` to make sure it's still working.


## Summary
Controllers provide a way to organize your application into logical parts. As we progress, we'll add all book related actions (add a book, edit a book, etc.) to the `BookController`.

As applications grow in complexity, you can/should organize them via multiple controller files. For example, eventually our Foobooks app will have the ability to add/edit/view authors, and to handle that functionality we would add an `AuthorController`.