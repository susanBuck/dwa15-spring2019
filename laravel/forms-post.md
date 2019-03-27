# Forms with POST
Next, let’s look at form processing using POST. For this example, we'll switch from the Foobooks *Search* feature to a new *Add a book* feature that’s a more logical fit for the POST method. We won't be able to complete this feature until we introduce databases, but we can set up the basic flow now.

In the following steps, I'll provide the necessary code, which will be explained in more detail in lecture.


### View
```html
{{-- /resources/views/books/create.blade.php --}}
@extends('layouts.master')

@section('title')
    Add a book
@endsection

@section('content')
    <h1>Add a book</h1>

    <form method='POST' action='/books'>
        <div class='details'>* Required fields</div>
        {{ csrf_field() }}

        <label for='title'>* Title</label>
        <input type='text' name='title' id='title'>

        <label for='author'>* Author</label>
        <input type='text' name='author' id='author'>

        <label for='published_year'>* Published Year (YYYY)</label>
        <input type='text' name='published_year' id='published_year'>

        <label for='cover_url'>* Cover URL</label>
        <input type='text' name='cover_url' id='cover_url' value='http://'>

        <label for='purchase_url'>* Purchase URL </label>
        <input type='text' name='purchase_url' id='purchase_url' value='http://'>

        <input type='submit' value='Add book'>
    </form>
@endsection
```


### Routes
Add the following 2 routes somewhere *before* the `/books/{title?}` route (it does not matter if it comes before/after the search routes).

```php
Route::get('/books/create', 'BookController@create');
Route::post('/books', 'BookController@store');
```

### Controller actions
```php
/**
* GET /books/create
* Display the form to add a new book
*/
public function create(Request $request) 
{
    return view('books.create');
}


/**
* POST /books
* Process the form for adding a new book
*/
public function store(Request $request) 
{
    # Code will eventually go here to add the book to the database, 
    # but for now we'll just dump the form data to the page for proof of concept
    dump($request->all());
}
```

### Test it out
E.g. `http://foobooks.loc/books/create`


## Route and method name choices
Applications often involve specific entities - in the case of Foobooks, those entities will include things like *books*, *authors*, *tags*, and *users*. If you were creating a blog, you might have *posts* and *comments*. If you were creating an e-commerce store, you might have *orders* and *products*.

These entities are often managed in a database, and there are fundamental interactions you'll typically see with them: **creating**, **reading**, **updating**, **deleting** (or **CRUD** for short).

The route design for these four actions often follows a convention summarized by this table:

HTTP Method | URI              | Controller Method/Action
----------|--------------------|--------------
GET       | `/books`           | index
GET       | `/books/create`    | create
POST      | `/books`           | store
GET       | `/books/{id}`      | show
GET       | `/books/{id}/edit` | edit
PUT/PATCH | `/books/{id}`      | update
DELETE    | `/books/{id}`      | destroy

This design comes from a software architecture style referred to as [REST: REpresentational State Transfer](https://en.wikipedia.org/wiki/Representational_state_transfer), which is commonly used when designing [APIs](https://en.wikipedia.org/wiki/Application_programming_interface). 

There's no hard reason we need to follow these conventions, especially because we're not designing Foobooks to be an API - we could come up with whatever route patterns we personally prefer. However, following this convention can be useful as it provides consistency and structure across applications and developers.

Also, keep in mind that this design is specific to routes related to well-defined entities like managing *books*. The same can't be said for the Search feature created in the previous noteset, where no specific route/method pattern was followed. 


## CSRF Protection in Laravel
The above form includes this line:

```html
{{ csrf_field() }}
```

Which will translate to something like this in your HTML;

```html
<input type='hidden' name='_token' value='Qw7HOT2zXe1ouFUuNov73baXFZTz4nHdf0CyJvZe'>
```

This line is necessary when submitting forms with `POST` (or `PUT` or `DELETE`) because it guards against CSRF attacks (explained below).

If you don't have the CSRF token in these forms, your users will get a 419 error page saying *your session has expired* when trying to submit the form.

CSRF protection in Laravel is an example of [__Middleware__](http://laravel.com/docs/middleware#terminable-middleware):

> *&ldquo;HTTP middleware provide a convenient mechanism for filtering HTTP requests entering your application. For example, Laravel includes a middleware that verifies the user of your application is authenticated. If the user is not authenticated, the middleware will redirect the user to the login screen. However, if the user is authenticated, the middleware will allow the request to proceed further into the application.*

> *Of course, additional middleware can be written to perform a variety of tasks besides authentication. A CORS middleware might be responsible for adding the proper headers to all responses leaving your application. A logging middleware might log all incoming requests to your application.*

> *There are several middleware included in the Laravel framework, including middleware for maintenance, authentication, CSRF protection, and more. All of these middleware are located in the app/Http/Middleware directory.&rdquo;*




## What is CSRF?
CSRF, or __Cross-Site Request Forgery__, is a type of web application vulnerability where a user unintentionally runs a script in their browser that takes advantage of their logged in status on a target site.

For a bare-bones example, imagine your application has a form that POSTs to `http://yourdomain.com/users/delete`, which will trigger the deletion of a logged-in user's account.

Now imagine a hacker (perhaps a nefarious competitor?) has dug through your source code to find this URL and wishes to trick your users into deleting their accounts. The hacker does this by creating a form on their site which appears innocuous, but actually triggers the `/users/delete` route on *your* site.

```php
<form method='POST' action='http://yourdomain.com/users/delete'>
    <input type='submit' value='Click to claim your free prize!'>
</form>
```

The hacker would then try to get your users to view the page on their site and submit the form (perhaps through a [phishing](https://en.wikipedia.org/wiki/Phishing) email campaign).

This is an example of a __cross site request forgery__&mdash; the hacker's site is trying to submit a request to *your* site. If your users fall for this trick, and if they're accessing the hacker's site via a browser that's also logged into your site, bad stuff can happen.

__To prevent CSRF attacks you want to verify that the origin of requests on your site are coming from within your site. This is done by sending a unique, encrypted token with each form submission, the CSRF token.__

When the form submission is received by your application, Laravel automatically checks the token to make sure it's valid, thereby verifying the form submissions is legitimate.
 