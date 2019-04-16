# Eloquent ORM
__ORM (Object-relational Mapping)__ is the software practice of using objects to represent data entities of an application.

(In all of our work, our *data entities* are database tables/rows, but a data entity could come from other sources, for example some external API that delivers JSON data.)

In Laravel, the ORM system is called __Eloquent__.

If we think ahead with Foobooks, we'll eventually have the following data entities:

+ Books
+ Authors
+ Tags

For each of these entities, we'll have a database table (`books`, `authors`, `tags`) and a corresponding Class (`Book`, `Author`, `Tag`) for interacting with that data.

These classes used for ORM are referred to as __Models__.

Eloquent is unique to Laravel, but ORM is seen in other languages/frameworks under different implementations. For example, in Ruby on Rails, their ORM tool is called [Active Records](http://guides.rubyonrails.org/active_record_basics.html), and it was a large inspiration for Laravel’s Eloquent.



## Create a Model
Our first Model will be the __Book__ Model, which will interface with the __books__ table.

Use the following Artisan command to generate a new Model called Book.

```xml
php artisan make:model Book
```

This command will generate a new PHP class file called `Book.php` in your `app/` folder (where Models go by default), and it will contain this boilerplate code:

```php
<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Book extends Model
{
    //
}
```

Notice how this new class *uses* `Illuminate\Database\Eloquent\Model` and extends the `Model` class.
This is what will give the Book class all the functionality provided by Eloquent.



## Eloquent Expectations
In order for Eloquent to work its magic, there are a 3 conventions we should follow:

__Convention 1) Model/table naming__

A Model's class name should be the singular version of the corresponding table name, and it should be capitalized.

So...

| Model  | Table |
|---|---|
| Book | books |
| Author | authors |
| Tag | tags |

(For words with atypical conversions between plural and singular versions (e.g. mouse => mice), you can use the [str_plural](https://laravel.com/docs/helpers#method-str-plural) and [str_singular](https://laravel.com/docs/helpers#method-str-singular) helper methods to figure out what words to use.)

__Convention 2) Id field__

Tables should have a __Auto Incremented__, __Primary Key__ field named `id`. We discussed the special `id` field when we set up our migrations, so your `books` table already meets this criteria.

__Convention 3) Timestamps__

Tables should have `created_at` and `updated_at` fields. Again, this was something we covered during migrations, so your `books` table should be all set.

These 3 conventions can be overridden (as described in the documentation), but we’ll avoid straying off convention as much as possible. 

With this infrastructure in place, you can start to put your Model to work with some queries...



## CRUD - Creating
There's not much going on in our Book Model so far, but that bare minimum is all you need to start interfacing with the database. Just by extending the `Illuminate\Database\Eloquent\Model` class, you can start taking advantage of the methods provided by Eloquent.

To demonstrate, we'll create an example in the [PracticeController](/laravel/practice-work.md) method.

Note the addition of `use App\Book;` at the top of the Controller so the Book class is accessible in the Controller's namespace.

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Book; # <----------- NEW

class PracticeController extends Controller
{

    public function practiceX()
    {
        # Instantiate a new Book Model object
        $book = new Book();

        # Set the properties
        # Note how each property corresponds to a field in the table
        $book->title = 'Harry Potter and the Sorcerer\'s Stone';
        $book->author = 'J.K. Rowling';
        $book->published_year = 1997;
        $book->cover_url = 'http://prodimage.images-bn.com/pimages/9780590353427_p0_v1_s484x700.jpg';
        $book->purchase_url = 'http://www.barnesandnoble.com/w/harry-potter-and-the-sorcerers-stone-j-k-rowling/1100036321?ean=9780590353427';

        # Invoke the Eloquent `save` method to generate a new row in the
        # `books` table, with the above data
        $book->save();

        dump('Added: '.$book->title);
    }

# [...]
```

Study the comments to understand what is going on.



## CRUD - Reading
Next, let’s look at the Eloquent [`get`](https://laravel.com/docs/5.4/eloquent#retrieving-models) method to *read* data from a table. We'll also introduce the `where` method to filter the results.

```php
public function practiceX()
{
    $book = new Book();
    $books = $book->where('title', 'LIKE', '%Harry Potter%')->get();

    if ($books->isEmpty()) {
        dump('No matches found');
    } else {
        foreach ($books as $book) {
            dump($book->title);
        }
    }
}
```



## Facade vs. Instantiated Models
In the above examples, a new Book object was explicitly instantiated before the query:

```php
$book  = new Book(); # Instantiate new book object
$books = $book->where('title', 'LIKE', '%Harry Potter%')->get(); # Query
```

This can be abbreviated using the Model as a [facade](/laravel/facades.md), e.g.:

```php
$books = Book::where('title', 'LIKE', '%Harry Potter%')->get();
```

You'll see both styles in examples and documentation.



## Query Structure
Now that we’ve seen two examples, let’s dig deeper into the structure of Eloquent queries.

An Eloquent query can typically be broken down into two parts which I'll refer to using the following terminology:

1. __design method(s):__ These methods dictate *what* results your query will return. Design methods can be chained together.
2. __an execution method:__ This method will dictate *how* the query will be executed, and will always come after any design methods.

<br>
<img src='http://making-the-internet.s3.amazonaws.com/laravel-eloquent-constraint-fetch@2x.png' style='max-width:865px;' alt=''>
<br>

Here's a [cheat sheet of common design and execution methods](/laravel/db-eloquent-cheat-sheet.md) you’ll use to build your Eloquent queries.

And here are examples showing several combinations of design and execution methods:


### Example A.
```php
# Get only books published after 1950
#   `where` is the design method
#   `get` is the execution method
$results = Book::where('published_year', '>', 1950)->get();
dump($results->toArray()); # Study the results
```

### Example B.
```php
# Get only books that were authored by F. Scott Fitzgerald
    # `where` is the design method
    # `get` is the execution method
$results = Book::where('author', '=', 'F. Scott Fitzgerald')->get();
dump($results->toArray()); # Study the results
```

### Example C.
```php
# Get the *first* book in the table that was authored by F. Scott Fitzgerald
    # `where` & `orderBy` are the design methods
    # `first` is the execution method
$results = Book::where('author', '=', 'F. Scott Fitzgerald')->orderBy('created_at')->first();
dump($results->toArray()); # Study the results
```

### Example D.
```php
# Get only books that were published after 1950 *and* authored by F. Scott Fitzgerald
    # `where` is the design method, and it's used twice
    # `get` is the execution method
$results = Book::where('published_year', '>', 1950)->where('author', '=', 'F. Scott Fitzgerald')->get();
dump($results->toArray()); # Study the results
```

### Example E.
```php
# Get all the books
    # There is no design method
    # `all` is the execution method
$results = Book::all();
dump($results->toArray()); # Study the results
```

With more information about query structure behind us, let’s look at some examples of updating and deleting data.


## CRUD - Updating
To update a row in a table, we’ll first select which row we wish to edit. Then we can alter the properties of that row and persist those changes using the `save` method.

```php
# First get a book to update
$book = Book::where('author', '=', 'F. Scott Fitzgerald')->first();

if (!$book) {
    dump("Book not found, can't update.");
} else {
    # Change some properties
    $book->title = 'The Really Great Gatsby';
    $book->published_year = '2025';

    # Save the changes
    $book->save();

    dump('Update complete; check the database to confirm the update worked.');
}    
```



## CRUD - Deleting
Similar to updating, when deleting a book, you have to first find the book you want to delete.

```php
# First get a book to delete
$book = Book::where('author', '=', 'F. Scott Fitzgerald')->first();

if (!$book) {
    dump('Did not delete- Book not found.');
} else {
    $book->delete();
    dump('Deletion complete; check the database to see if it worked...');
}
```



## Resources & Practice
The combinations of Eloquent design and execution methods you can use are practically limitless, and building complex queries takes practice.

Knowing that, here are some resources to study:

+ Start by bookmarking and studying [these query examples...](/laravel/db-query-examples.md).
+ Skim the
[API Docs on query methods](https://laravel.com/api/5.8/Illuminate/Database/Query/Builder.html) to see *all* the methods available to you.
+ And, of course, refer to the [Laravel Eloquent Documentation](https://laravel.com/docs/eloquent).

Armed with this information, write queries to accomplish the following...

+ Retrieve the last 2 books that were added to the `books` table.
+ Retrieve all the books published after 1950.
+ Retrieve all the books in alphabetical order by title.
+ Retrieve all the books in descending order according to published date.
+ Find any books by the author “J.K. Rowling” and update the author name to be “JK Rowling”
+ Remove any/all books with an author name that includes the string &ldquo;Rowling&rdquo;.

You should construct/test these queries in a PracticeController within your Foobooks practice application. I'll ask for your solutions to these tasks in your Week 11 assignment.


## Another look at ORM
Now that we’ve seen Eloquent Models in action, let’s revisit the definition of ORM.

As stated above, ORM (__Object-relational Mapping__) is the software practice of using objects to represent data entities in your application.

In our setup, our objects are called Models.

The Models represent data entities in our application (Book, Author, User, etc.)

There is a mapping of the object's properties to fields in the database tables.

We saw this when we did something like `$book->title`. The object was `$book`, the property was `title`. This *maps* to a table called `books` with a field called `title`.

Here's a big picture visualizing the relationship between the Class, Object, and table.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-orm-books@2x.png' style='max-width:1041px; width:100%' alt='ORM Diagram'>
