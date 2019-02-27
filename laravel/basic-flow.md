# Basic flow

Traditional web application flow:

+ Visitor requests `http://foobooks.loc`
+ Server responds by loading `/foobooks/index.php`

Or...

+ Visitor requests `http://foobooks.loc/books/great-gatsby.php`
+ Server responds by loading `/foobooks/books/great-gatsby.php`

Throw away this traditional &ldquo;*URL maps to specific file*&rdquo; thinking. Modern web frameworks use something called __routing__.

With routing, *all* requests load `index.php` which will parse the URL and load the appropriate content.

So our new flow looks like this:
+ Visitor requests `http://foobooks.loc/books/great-gatsby`
+ Due to a config in `.htaccess` (project specific Apache config file), server responds by loading `/foobooks/public/index.php`
+ `index.php` sets up everything the application needs to run, looks up the URL parameters (`/books/great-gatsby`) in a route map file, and executes the appropriate action to satisfy the request and return a response.



## Request Lifecycle
<img src='http://making-the-internet.s3.amazonaws.com/laravel-lifecycle-request@2x.png' alt='Laravel request Lifecycle diagram' style='max-width:986px; width:100%;'>

Read more: Laravel docs: [Request Lifecycle](https://laravel.com/docs/lifecycle)



## Example 1: Edit an existing route
Knowing this, let's trace how we're seeing this page on our fresh Laravel installs:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-initial-load-via-foobooks-loc@2x.png' style='max-width:870px; width:100%'>

The URL in this example is `http://localhost/`, so the path is simply `/`.

Load `/routes/web.php` and you'll see a single __route__ has been defined:

```php
<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
```

This route matches the URL pattern `/`, and it returns a **view** called `welcome`.

In Laravel, view files are stored in `/resources/views` so navigate to that directory.

You should see a file `welcome.blade.php`, and if you open it, you'll see the underlying HTML of that Laravel welcome screen.

```html
<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Nunito:200,600" rel="stylesheet">

        <!-- Styles -->
        <style>
            /*[redacted for brevity]*/
        </style>
    </head>
    <body>
        <div class="flex-center position-ref full-height">
            @if (Route::has('login'))
                <div class="top-right links">
                    @auth
                        <a href="{{ url('/home') }}">Home</a>
                    @else
                        <a href="{{ route('login') }}">Login</a>

                        @if (Route::has('register'))
                            <a href="{{ route('register') }}">Register</a>
                        @endif
                    @endauth
                </div>
            @endif

            <div class="content">
                <div class="title m-b-md">
                    Laravel
                </div>

                <div class="links">
                    <a href="https://laravel.com/docs">Docs</a>
                    <a href="https://laracasts.com">Laracasts</a>
                    <a href="https://laravel-news.com">News</a>
                    <a href="https://blog.laravel.com">Blog</a>
                    <a href="https://nova.laravel.com">Nova</a>
                    <a href="https://forge.laravel.com">Forge</a>
                    <a href="https://github.com/laravel/laravel">GitHub</a>
                </div>
            </div>
        </div>
    </body>
</html>
```

Clear out this `welcome.blade.php` file and replace it with the following:
```html
<!doctype html>
<html lang='en'>
<head>
    <title>Foobooks</title>
    <meta charset='utf-8'>
</head>
<body>
    <h1>Foobooks</h1>
</body>
</html>
```

Refresh the page and you should now see this:
<img src='http://making-the-internet.s3.amazonaws.com/laravel-edit-welcome@2x.png' style='max-width:756px;' alt=''>

__You've just made your first customization to your new Laravel application!__



## Example 2: Add a new route
Update your `web.php` routes file so it has a new route matching the url pattern `/example` that will return a string rather than a view:

```py
# New route
Route::get('/example', function () {
    return 'hello there!';
});

# Existing route
Route::get('/', function () {
    return view('welcome');
});
```

Save your work then test it out by visiting `http://foobooks.loc/example`; you should see this:
<img src='https://s3.amazonaws.com/making-the-internet/laravel-example-route@2x.png' style='max-width:756px;' alt=''>


## Example 3: Test a non-existent route
Observe what happens when you visit a route that has not be defined, for example, `http://foobooks.loc/xyz`.
<img src='https://s3.amazonaws.com/making-the-internet//laravel-route-not-found@2x.png' style='max-width:1055px;' alt=''>



## Pending questions
+ How exactly does the `Route` method work?
+ Why do the view files end with a `.blade.php` extension?
+ A route can return a string, or a view... what else can it return?
+ How can we respond to different request types, e.g., POST instead of GET?

These questions will all be answered as we continue to dig deeper.
