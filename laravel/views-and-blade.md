# Views and Blade

## What are views?
> &ldquo;*Views contain the HTML served by your application and separate your controller/application logic from your presentation logic.*&rdquo; -[ref](https://laravel.com/docs/views)

In short, views in a framework are the equivalent to the __display__ code/files we used when working with &ldquo;from-scratch&rdquo; PHP in Project 2.

Key facts about views in Laravel:
+ View files are stored in in `/resources/views/`.
+ View files end with the `.blade.php` extension.
+ Laravel uses a templating language called [Blade](http://laravel.com/docs/blade) which provides shortcuts for common display-related code necessary in views.


## Basic example
Let's rework our *Show a book* page so it uses a view.

We already have this route:
```php
Route::get('/books/{title}', 'BookController@show');
```

And the `show` method in `BookController.php` currently looks like this:
```php
/**
* GET
* /books/{title}
*/
public function show($title = null)
{
    return 'You are viewing the book ' . $title;
}
```

Our goal is to replace the line `return 'You are viewing the book ' . $title;` with a view.


## Create your first view
Start by creating a new, blank file in `/resources/views/books/show.blade.php`.

(The `books` directory does not yet exist in `/resources/views/`... you should create this when creating this file.)

Note how the file name `show.blade.php` ends in `.blade.php`. This is required in order to use the Blade templating engine.

__Organizing view files:__ How you organize your view files is up to you, but here's one suggested approach...

+ Create a subdirectory for each controller. For example, we have a subdirectory `/resources/views/books/` for the `BookController.php`.
+ Make the controller's method name (`show`) correspond to the file name (`show.blade.php`).

The benefit of these two conventions is it makes it easy to correlate controller actions to view files.


## Build your first view
With your new view created, fill it with the following content:

```html
<!doctype html>
<html lang='en'>
<head>
    <title>{{ $title }}</title>
    <meta charset='utf-8'>
    <link href='/css/foobooks.css' type='text/css' rel='stylesheet'>
</head>
<body>

    <header>
        <a href='/'><img src='/images/foobooks-logo@2x.png' id='logo' alt='Foobooks Logo'></a>
    </header>

    <section>
        <h1>{{ $title }}</h1>
        
        <p>
            Details about this book will go here...
        </p>
    </section>

    <footer>
        &copy; {{ date('Y') }}
    </footer>

</body>
</html>
```

Note that most of the above file looks like regular HTML. The exception is the content in the `<section>` and `<footer>` where you see the double brackets being used (`{{ }}`). Those brackets are part of the Blade templating language and they're used to echo content to the page.

So when you use Blade syntax like this...
```php
{{ $title }}
```

...the Blade templating engine will translate that a PHP echo statement similar to this:
```php
<?php echo $title; ?>
```


## Use your first view
With your first view built, the next step is to have the controller load this view:

```php
/**
* GET /books/{title}
*/
public function show($title)
{
    return view('books.show')->with(['title' => $title]);
}
```

Observations about the above code:
+ Views can be loaded with the global helper `view()`.
+ Omit the `blade.php` extension since it's assumed. I.e. `show.blade.php` becomes just `show`.
+ The view file name is specified using dot notation. I.e. instead of writing `books/show` you write `books.show`.
+ You don't have to include `/resources/views/` as part of the path to your view&mdash; it's assumed.
+ The `with()` method is used to pass data to the view, in this case an array of key => value pairs is passed.
+ That data is echo'd out in the view using this Blade syntax: `{{ $title }}`.

With the above code in place, test your new view by visiting `http://foobooks.loc/books/war-and-peace` in your browser. (The logo and CSS won't display yet because we have to add those files in the next step).

<img src='https://s3.amazonaws.com/making-the-internet/laravel-first-view@2x.png' style='max-width:743px;' alt='Book show view'>


## Assets 
The above HTML linked two front-end assets: a image for the logo, and a CSS file.

Asset such as these should be placed in the `/public` directory of your Laravel app because that is the document root of your app, and thus the browser will be able to load files from there.

You should create directories like `/public/images/` and `/public/css` (if they don't already exist) to organize your assets.

For your foobooks practice app, you can download a copy of the [foobooks-logo@2x.png](https://s3.amazonaws.com/dwa15.com/foobooks-logo@2x.png) and put it in `/public/images/`.

Likewise, you can create a new css file at `/public/css/foobooks.css` to serve as your application's master stylesheet. I'll be expanding on this file in upcoming lectures, but for now I've added just the following declarations:

```css
#logo {
    /* Actual width is 632; displaying at half-size for retina screens */  
    width: 316px;
}

h1 {
    font-family: "Helvetica", sans-serif;
}
```

<img src='https://s3.amazonaws.com/making-the-internet/laravel-first-view-with-assets@2x.png' style='max-width:743px;' alt='First view with assets loaded'>


## Asset paths
Note how the paths for the image and CSS are prefixed with a forward slash:

```html
<link href='/css/foobooks.css' type='text/css' rel='stylesheet'>
<img src='/images/foobooks-logo@2x.png' id='logo' alt='Foobooks Logo'>
```

 This ensures that these assets are located from the root of the `public/` directory, rather than relative to the path of the current URI.

 
## Display logic with Blade
We learned earlier in the semester that it's acceptable to use a minimal amount of logic in display files for display purposes. We also emphasized the use of PHP's alternative syntax.

Moving forward, we'll write this display logic using **Blade directives**, which are shortcuts defined in the Blade templating languages.
 
 The following are some common Blade directives used for display logic. Note how each directive begins with `@`.
 
 + `@if(condition)` - Starts an if block
 + `@else` - Starts an else block
 + `@elseif(condition)` - Start a elseif block
 + `@endif` - Ends a if block
 + `@foreach($list as $key => $val)` - Starts a foreach block
 + `@endforeach` - Ends a foreach block
 
For an example, let's imagine the *Show a book* page needed to accommodate a situation where the book was not found. This can be accomplished using the `@if/@else` directive:

```html
<section>
  @if(isset($title))
      <h1>{{ $title }}</h1>

      <p>
          Details about this book will go here...
      </p>
  @else 
      <p>
          Book not found
      </p>
  @endif
</section>
```

Refer to this [Blade cheat sheet](/laravel/blade-cheat-sheet.md) to learn about other Blade directives.


## Understanding how Blade works
When you load a view, the Blade templating engine converts any Blade syntax into regular PHP syntax and a cached version of that view is created and stored in `/storage/framework/views/`. That cached version will be loaded the next time the same view is requested *unless* that view has been updated (at which point it will re-cache).

Open any of the files in `/storage/framework/views/` to see an example of a rendered view from the examples we ran above.

When you have bugs in your views, the Laravel *whoops* error page may reference the code in the rendered/cached version of your view, *not* the original Blade file. Given this, you may have to occasionally refer to these cache files to track down where a problem is.

