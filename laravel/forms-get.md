# Forms with GET

## Preface
What we know about forms so far:

+ Forms are constructed using HTML elements
+ Data entered into forms can be sent to the server using the HTTP methods GET or POST
+ This data can then be extracted from PHP superglobals, `$_GET` or `$_POST`
+ Data collected from forms should be
    + __validated__ to ensure the visitor is entering the appropriate data
    + __escaped/sanitized__ before being output to the page

All these points hold true when it comes to working with forms in a framework, but Laravel will provide tools that make our interactions with forms easier and more robust.


## Search form
To demonstrate forms in Laravel, we're going to replicate a feature we built in our pre-Laravel iteration of Foobooks&mdash; **the ability to search for a book.**

In the following steps, I'll provide the necessary code which will be explained in more detail in lecture.


### Step 1) Data
First step, we'll need some book data to work with, so copy the json code from Foobooks v0's [books.json](https://github.com/susanBuck/foobooks0/blob/master/books.json) and save this in a file called `books.json` in your application's `database/` directory.


### Step 2) View
Next, create a new view that will display this form:
```html
{{-- /resources/views/books/search.blade.php --}}
@extends('layouts.master')

@section('title')
    Search
@endsection

@section('content')
    <h1>Search</h1>

    <form method='GET' action='/books/search-process'>

        <fieldset>
            <label for='searchTerm'>Search by title:</label>
            <input type='text' name='searchTerm' id='searchTerm'>
    
            <input type='checkbox' name='caseSensitive'>
            <label>case sensitive</label>
        </fieldset>

        <input type='submit' value='Search' class='btn btn-primary'>

    </form>
@endsection
```

### Step 3) Controller action
Then create two new methods in the BookController. The first method will display the form, and the second will process the form.
```php
# app/Http/Controllers/BookController.php

/**
* GET
* /books/search
* Show the form to search for a book
*/
public function search() 
{
    return view('books.search');
}

/**
* GET
* /books/search-process
* Process the form to search for a book
*/
public function searchProcess() 
{
    # Code to process the form will go here...
}
```


### Step 4) Route
Next, create two new routes to access the two methods you just created. Make sure these routes are added before the `/books/{title}` route because the URI is ambiguous and you want it to take precedence.

```php
# /routes/web.php
Route::get('/books/search', 'BookController@search'); # <-- NEW 1 of 2
Route::get('/books/search-process', 'BookController@searchProcess'); # <-- NEW 2 of 2
Route::get('/books/{title}', 'BookController@show');
```



## Test it out
Studying the form construction....

```html
<form method='GET' action='/books/search-process'>
    [...etc...]
</form>
```

...we can see the form is configured to submit with GET (method) via the route `/books/search-process` (action).

Thus, if you visit `/search`, enter a title (e.g. *the great gatsby*), click *Search*, it should lead you to a URL like `http://foobooks.loc/books/search-process?searchTerm=the+great+gatsby`.

If it does, it means everything is set up correctly thus far.


## Accessing form data via the Request
In the `BookController@searchProcess` method, we could access the form data using PHP's superglobal `$_GET`, but instead we're going to take advantage of Laravel's [Request](https://laravel.com/docs/requests) class which will give us everything `$_GET` gives us, plus a lot more.

To explore this class, update `BookController@searchProcess` method with the code below which:

1. Added the parameter `Request $request` which will make a request object available to the method
2. Added a series of dump statements to see all the things we can do with the `$request` object

```php
/**
* GET
* /books/search-process
* Process the form to search for a book
*/
public function searchProcess(Request $request) {

    # ======== Temporary code to explore $request ==========

    # See all the properties and methods available in the $request object
    dump($request);

    # See just the form data from the $request object
    dump($request->all());

    # See just the form data for a specific input, in this case a text input
    dump($request->input('searchTerm'));
    
    # See what the form data looks like for a checkbox
    dump($request->input('caseSensitive'));
    
    # Form data can also be accessed via dynamic properties
    dump($request->searchTerm);

    # Boolean to see if the request contains data for a particular field
    dump($request->has('searchTerm')); # Should be true
    dump($request->has('publishedYear')); # There's no publishedYear input, so this should be false

    # You can get more information about a request than just the data of the form, for example...
    dump($request->path()); # "books/search-process"
    dump($request->is('books/search-process')); # True
    dump($request->is('search')); # False
    dump($request->fullUrl()); # e.g. http://foobooks.loc/books/search-process?searchTerm=abc
    dump($request->method()); # GET
    dump($request->isMethod('post')); # False

    # ======== End exploration of $request ==========
}
```


After updating the `search` method, refresh your form, enter some data and click the *Search* button. Study the code and results to learn about some of the features of the Request object.

To see a full list of methods available to Request, refer to the [docs on Requests](https://laravel.com/docs/requests#accessing-the-request).


## Process the request
At this point we're able to submit the form and get the data from the form; the next step is handling that data.

This is where procedures are going to vary depending on what your application is trying to accomplish. You'll have to come up with the specific design for what *your* application needs to do, but for the sake of an example, the following is the code for how a Foobooks search could work. You'll note a lot of this code is familiar, because it's the same logic we used earlier in the semester when building foobooks v0, pre-Laravel.

Read carefully through the comments, as it explains what is going on and also offers some additional tips.

```php
/**
* GET
* /books/search-process
* Process the form to search for a book
*/
public function searchProcess(Request $request) {

    # Start with an empty array of search results; books that
    # match our search query will get added to this array
    $searchResults = [];
    
    # Store the searchTerm in a variable for easy access
    # The second parameter (null) is what the variable
    # will be set to *if* searchTerm is not in the request.
    $searchTerm = $request->input('searchTerm', null);
    
    # Only try and search *if* there's a searchTerm
    if ($searchTerm) {
        # Open the books.json data file
        # database_path() is a Laravel helper to get the path to the database folder
        # See https://laravel.com/docs/helpers for other path related helpers
        $booksRawData = file_get_contents(database_path('/books.json'));
        
        # Decode the book JSON data into an array
        # Nothing fancy here; just a built in PHP method
        $books = json_decode($booksRawData, true);
        
        # Loop through all the book data, looking for matches
        # This code was taken from v0 of foobooks we built earlier in the semester
        foreach ($books as $title => $book) {
            # Case sensitive boolean check for a match
            if ($request->has('caseSensitive')) {
                $match = $title == $searchTerm;
            # Case insensitive boolean check for a match
            } else {
                $match = strtolower($title) == strtolower($searchTerm);
            }
            
            # If it was a match, add it to our results
            if ($match) {
                $searchResults[$title] = $book;
            }
        }
    }
    
    # Redirect back to the search page w/ the searchTerm *and* searchResults (if any) stored in the session
    # Ref: https://laravel.com/docs/redirects#redirecting-with-flashed-session-data
    return redirect('/books/search')->with([
        'searchTerm' => $searchTerm,
        'caseSensitive' => $request->has('caseSensitive'),
        'searchResults' => $searchResults
    ]);
}
```


## Show the form, post-processing
Next, we want to update the `search` method so it will extract `searchTerm`, `caseSensitive`, and `searchResults` from the session (if it's available) and make it available to the view so we can display any results. One way to do this is via the `$request->session()` method.

```php
/**
 * GET
 * /books/search
 * Show the form to search for a book
 */
public function search(Request $request)
{
    return view('books.search')->with([
        'searchTerm' => $request->session()->get('searchTerm', ''),
        'caseSensitive' => $request->session()->get('caseSensitive', false),
        'searchResults' => $request->session()->get('searchResults', []),
    ]);
}
```

The final piece of the puzzle is to display the results of the request in the view.

In `search.blade.php`, right after the form, add this code:

```html
@if($searchTerm)
    <h2>Results for query: <em>{{ $searchTerm }}</em></h2>

    @if(count($searchResults) == 0)
        No matches found.
    @else
        @foreach($searchResults as $title => $book)
            <div class='book'>
                <h3>{{ $title }}</h3>
                <h4>by {{ $book['author'] }}</h4>
                <img src='{{ $book['cover_url'] }}' alt='Cover image for the book {{ $title }}'>
            </div>
        @endforeach
    @endif
@endif
```


## Finishing touches: Retain data in inputs
To retain the data in your form inputs after submission, update the `value` attribute of your `searchTerm` input to look like this:
```html
<input type='text' name='searchTerm' id='searchTerm' value='{{ $searchTerm }}'>
```

And update your `caseSensitive` checkbox to look like this:
```html
<input type='checkbox' name='caseSensitive' {{ ($caseSensitive) ? 'checked' : '' }} >
```


## Misc. FYI 

### Sanitizing output
Note that no where in the above examples did I explicitly sanitize/escape any visitor-entered form data before printing it to the page.

This is because Blade takes care of this for us when using the [`{{ }}` echo shortcuts](https://laravel.com/docs/blade#displaying-data) which invoke Laravel's [`e` (escape) helper method](https://laravel.com/docs/helpers#method-e).

### Flash data
Data flashed to the session as part of a redirect only exists for a single request (hence the name, *flashed*). Thus, if you submit the form, see the results, then refresh the page - you would no longer see any results. If you wish to retain data for longer than a single request you'd want to explicitly set the data in the session instead of flashing it as part of the redirect. More info here: [HTTP Session: Using the session](https://laravel.com/docs/session#using-the-session)
 
