# Namespacing in Controllers
Laravel class facades are readily available for use in your routes file. For example, the following would work:

```php
Route::get('/example', function () {
    return App::environment();
})
```

In this example, we've used Laravel's App facade to return the current environment.

If we tried to use this same statement (`return App::environment()`) in a controller, however, it would fail. To quickly test this out, add the `App::environment` line to your BookController's index method:

```php
public function index() {    
    return App::environment(); # <- This is what we're testing out
    #return 'Here are all the books...';
}
```

Testing the above action would show this error:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-in-controller-namespace@2x.png' style='max-width:1063px;' alt='Class not found'>

The reason the `App::environment()` statement works in the `web.php` routes file is because that file is in the __global namespace__.

When you move into the controller, you're then in that controller's namespace, which is `App\Http\Controllers`.

The error message makes this clear&mdash;

>> `Class 'App\Http\Controllers\App' not found`

To fix this add a `use` statement at the top of your controller  to import the App class:

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App; # <- Add this

class BookController extends Controller
{

    public function index()
    {    
        return App::environment(); # Now it should work!
        #return 'Here are all the books...';
    }
```


## Summary
When using a Laravel class facade in a controller file, a `use` statement is needed to &ldquo;import&rdquo; that class into the controller's namespace.
