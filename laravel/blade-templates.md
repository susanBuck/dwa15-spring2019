# Blade templates
If we continued down the path outlined in the previous note set, we’d create individual views for all of our book routes. The problem with this is you'd end up with repeat code as each view would include your doctype, the `<head>`, the `<header>` with the logo, the `<footer>`, etc.

A better solution is to divide your views into __layout templates__ and __child views__.

This is called __template inheritance__ and an example is conveyed in this graphic:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-view-inheritance@2x.png' style='max-width:801px;' alt='Template inheritance'>

With template inheritance you create a __master layout__ view (figure a) that contains common, shared parts that similar HTML files/views will need. For example, the doctype, the `<head>`, CSS includes, menus, footers, etc. 

Then, you'll create __child__ views (figures b and c) for individual pages that __inherit__ the master template.

In the master layout, you'll define __sections__ that act as placeholders to be filled in with content defined in the child views.


## Example
Let’s apply template inheritance to our book example thus far and start by creating a new layout view at `/resources/views/layouts/master.blade.php` (`layouts` is a new subdirectory you should create).

In this new file, add these contents:

```html
<!doctype html>
<html lang='en'>
<head>
    <title>@yield('title')</title>
    <meta charset='utf-8'>

    <link href='/css/foobooks.css' rel='stylesheet'>

    @yield('head')
</head>
<body>

<header>
    <a href='/'><img src='/images/foobooks-logo@2x.png' id='logo' alt='Foobooks Logo'></a>
</header>

<section>
    @yield('content')
</section>

<footer>
    &copy; {{ date('Y') }}
</footer>

</body>
</html>
```

Note how everything in this view is pretty generic&mdash; it could be applied to any page of our Foobooks app thus far. Also note the use of the Blade directive `@yield`.

Next, we want to adapt `/resources/views/book/show.blade.php` into a child view so *replace* the content there with this code:

```html
@extends('layouts.master')

@section('title')
    {{ $title }}
@endsection

@section('head')
    {{-- Page specific CSS includes should be defined here; this .css file does not exist yet, but we can create it --}}
    <link href='/css/books/show.css' rel='stylesheet'>
@endsection

@section('content')
    <h1>{{ $title }}</h1>
    
    <p>
        Details about this book will go here...
    </p>
@endsection
```

Run `http://foobooks.loc/books/war-and-peace` in your browser and test everything is working as it did before we implemented template inheritance:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-first-view-with-assets@2x.png' style='max-width:743px;' alt='First view with assets loaded'>

## Things to note
+ **Sections** of code are defined in the child view using the `@section` directive, and then rendered in the master layout using the `@yield` directive. 
+ Indentation is used to show the hierarchy of content in the Blade directives. For example, the body of each `@section` directive is indented 1x.
+ In addition to *sections*, Blade also supports directives called [stacks](https://laravel.com/docs/blade#stacks) as well as [components and slots](https://laravel.com/docs/5.8/blade#components-and-slots), which you can read more about in the documentation. Each of these directives can achieve a similar outcome with a slight variation in how they work. To keep things simple, and because they fits our needs, we'll stick with the use of sections.






