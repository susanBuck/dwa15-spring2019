# Authentication usage
**Preface: Integrating authentication into Project 4 is optional, and this material will not be coverd in any assignment questions.**


## Auth::check()
With the mechanisms for authorization in place you can now adapt your application to do different things based on whether the visitor is logged in or not.

To demonstrate this, we’re now going to shift Foobooks so its features are only accessible to logged in users.

So if the visitor is *not* logged in, they should see these links:
+ Register
+ Login
+ About
+ Contact

If the visitor *is* logged in they should these links:
+ Books
+ Search
+ Add a Book
+ Practice
+ About
+ Contact
+ Logout

You'll recall that our navigation links are defined in `/config/app.php`:

```php
'nav' => [
    // URL => Link label
    'books' => 'Books',
    'books/search' => 'Search',
    'books/create' => 'Add a book',
    'practice' => 'Practice',
    'about' => 'About',
    'contact' => 'Contact',
],
```

We’re going to split this into two separate configs, one for when the visitor is not logged in (`nav`) and one for when they are (`nav1`):
```php
# Guest navigation links
'nav' => [
    'register' => 'Register',
    'login' => 'Login',
    'about' => 'About',
    'contact' => 'Contact',
],

# Logged-in user navigation links
'nav1' => [
    // URL => Link label
    'books' => 'Books',
    'books/search' => 'Search',
    'books/create' => 'Add a book',
    'practice' => 'Practice',
    'about' => 'About',
    'contact' => 'Contact',
],
```


Next, in the nav view we’ll use the __`Auth::check()`__ method to dynamically specify whether `nav` or `nav1` should be displayed. We’ll also use it to decide whether to show the logout link or not. (We can’t just include our logout link in our nav config because it requires a form, which is different from the other links.)

```php
<nav>
    <ul>
        @foreach(config('app.nav'.Auth::check()) as $link => $label)
            <li>
            {{-- If the current path is the same as this link, display as plain text, not a hyperlink--}}
            @if(Request::is($link))
                {{ $label }}
                {{-- Otherwise, display as a hyerlink --}}
            @else
                <a href='/{{ $link }}'>{{ $label }}</a>
            @endif
            </li>
        @endforeach

        @if(Auth::check())
            <li>
                <form method='POST' id='logout' action='/logout'>
                    {{ csrf_field() }}
                    <a href='#' onClick='document.getElementById("logout").submit();'>Logout</a>
                </form>
            </li>
        @endif
    </ul>
</nav>
```



## Restricting routes with middleware
One of the purposes of authentication is to keep non-registered visitors away from certain routes.

One way this can be accomplished is using [middleware](http://laravel.com/docs/middleware) which lets you filter requests entering your application. (Earlier, we saw an example of middleware with the CSRF checking that happens when forms are submitted.)

Laravel ships with a default middleware file for authentication (`Illuminate\Auth\Middleware\Authenticate`). When this filter is used, a check is done to see if a visitor is authenticated, and if not they’re redirected to the login page.

To understand how this middleware is used, open `/app/Http/Kernel.php` and note that it's part of the `$routeMiddleWare` array with the key `auth`:
```php
protected $middleware = [
    \App\Http\Middleware\CheckForMaintenanceMode::class,
    \Illuminate\Foundation\Http\Middleware\ValidatePostSize::class,
    \App\Http\Middleware\TrimStrings::class,
    \Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull::class,
    \App\Http\Middleware\TrustProxies::class,
];
```

Knowing this, we’ll adapt a route to use this middleware.

For example, here’s the existing route to view the *Add a book* page:

```php
Route::get('/books/create', 'BookController@create');
```

Update this route to look like this:
```php
Route::get('/books/create', [
    'middleware' => 'auth',
    'uses' => 'BookController@create'
]);
```

Now, when `/book/create` is visited, the `auth` middleware will apply.

__Test it out:__

If you are not logged in and you attempt to visit `http://foobooks.loc/books/create` you should be redirected to the login page.

Then, if you successfully login, you’ll be sent back to `http://foobooks.loc/books/create`.



## Restricting multiple routes with Middleware
In the above example, we restricted a single route, but you can also restrict many routes using a route group like this:

```php
Route::group(['middleware' => 'auth'], function () {
    # Create a book
    Route::get('/books/create', 'BookController@create');
    Route::post('/books', 'BookController@store');

    # Edit a book
    Route::get('/books/{id}/edit', 'BookController@edit');
    Route::put('/books/{id}', 'BookController@update');

    # Delete a book
    Route::get('/books/{id}/delete', 'BookController@delete');
    Route::delete('/books/{id}', 'BookController@destroy');

    # View all books
    Route::get('/books', 'BookController@index');

    # View a book
    Route::get('/books/{id}', 'BookController@show');

    # Search all books
    Route::get('/books/search', 'BookController@search');
});
```


## Making the user data available to many or all views
It’s common to want the logged-in user’s data available to many or all views. For example, if you had a nav/menu bar, you may want a link to the user’s profile or settings on every page.

One way to do this is to make sure every time you return a view, you include `$user` as part of the data:

```php
return view('x')->with(['user' => $user]);
```

However, if *every* page needs this info, this makes for a lot of repeat code. A better approach is to find a way to make this data &ldquo;universally&rdquo; available.

There’s several different ways you accomplish this task, but we'll use a [view composer](https://laravel.com/docs/views#view-composers).

> &ldquo;View composers are callbacks or class methods that are called when a view is rendered. If you have data that you want to be bound to a view each time that view is rendered, a view composer can help you organize that logic into a single location.&rdquo;

To demonstrate this, we'll make it so that the *LOGOUT* link in the nav bar includes the logged in user’s name.

Start by creating a new class called `ViewServiceProvider.php` in `app/Providers` with the following code:

```php
<?php

namespace App\Providers;

use Illuminate\Http\Request;
use Illuminate\Support\ServiceProvider;

class ViewServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap the application services.
     * @return void
     */
    public function boot()
    {
        # This view composer will make the data available for the `layouts.master` view, which
        # includes the `modules.nav` view where we want to use this data.
        view()->composer('layouts.master', function ($view) {
            $user = request()->user();
            $view->with('user', $user);
        });
    }

    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
```

Then in `config/app.php` register this new provider by adding the line `App\Providers\ViewServiceProvider::class,` to the end of the `providers` array.

```php
    'providers' => [

        # [...]

        /*
         * Application Service Providers...
         */
        App\Providers\AppServiceProvider::class,
        App\Providers\AuthServiceProvider::class,
        // App\Providers\BroadcastServiceProvider::class,
        App\Providers\EventServiceProvider::class,
        App\Providers\RouteServiceProvider::class,
        App\Providers\ViewServiceProvider::class, # <-- NEW
    ],

],
```

Your master and nav views should now have access to a variable `$user`. Here's an example showing usage of that variable as part of the logout link from the nav:

```php
<li>
    <form method='POST' id='logout' action='/logout'>
        {{ csrf_field() }}
        <a href='#' onClick='document.getElementById("logout").submit();'>Logout {{ $user->name }}</a>
    </form>
</li>
```


## Reference
+ [Docs: Authentication](http://laravel.com/docs/authentication)
+ [Docs: Middleware](http://laravel.com/docs/middleware)
