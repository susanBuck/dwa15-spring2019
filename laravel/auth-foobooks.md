# Authentication and Foobooks
**Preface: Integrating authentication into Project 4 is optional, and this material will not be coverd in any assignment questions.**


## Integrating your existing data and authentication
Couple different approaches:

1. *One to Many*: Every book is connected to a single user
2. *Many to Many*: Individual books aren’t associated with any one user. Instead users can favorite books, powered by a many to many relationship between books and users.

Let’s go with #1.


## Connect books and users
To do this, we’ll need a migration to update our `books` table to have the `user_id` foreign key. This is the same thing we did when connecting *authors* and *books*.

Create the migration:
```bash
$ php artisan make:migration connect_books_and_users
```

Fill in the migration:
```php
public function up()
{
    Schema::table('books', function (Blueprint $table) {
        # Add a new INT field called `user_id` that has to be unsigned (i.e. positive)
        $table->bigInteger('user_id')->unsigned();

        # This field `user_id` is a foreign key that connects to the `id` field in the `authors` table
        $table->foreign('user_id')->references('id')->on('users');
    });
}

public function down()
{
    Schema::table('books', function (Blueprint $table) {
        # ref: http://laravel.com/docs/5.1/migrations#dropping-indexes
        $table->dropForeign('books_user_id_foreign');

        $table->dropColumn('user_id');
    });
}
```

Don’t forget to run the migration after you create it.


## Update seeders
Because we’ve created a foreign key between `books` and `users`, make sure your `UsersTableSeeder` is invoked *before* the BooksTableSeeder:

```php
# DatabaseSeeder.php
$this->call(UsersTableSeeder::class);
$this->call(TagsTableSeeder::class);
$this->call(AuthorsTableSeeder::class);
$this->call(BooksTableSeeder::class);
$this->call(BookTagTableSeeder::class);
```

Finally, update the BooksTableSeeder so that each book is associated with a user. For our example, we’ll associate every book to user id 1 (`jill@harvard.edu`).

```php
# [...]
$book->purchase_url = $bookData[4];
$book->user_id = 1; # <--- NEW LINE
$book->save();
```


## Update models
Next, update the `Book` and `User` model so they're aware of this new relationship.

Add this to `Book.php`:
```php
public function user()
{
    return $this->belongsTo('App\User');
}
```

Add this to `User.php`:
```php
public function books()
{
    return $this->hasMany('App\Book');
}
```


## Your Books
Setup complete! Now let’s make it so that when a user is logged in they only see *their* books.

To do this, update the first two lines of your index method as shown:

```php
public function index(Request $request)
{
    # ** NEW LINE ** Get the user object
    $user = $request->user(); 
  
    # ** UPDATED LINE ** Edit the books query so it's fetching the books via the user object
    $books = $user->books()->orderBy('title')->get(); 
    
    # Approach 1 - Query the database
    # $newBooks = Book::latest()->limit(3)->get();
    
    # Approach 2 - Query the collection (more efficient)
    $newBooks = $books->sortByDesc('created_at')->take(3);
    
    return view('books.index')->with([
      'books' => $books,
      'newBooks' => $newBooks
    ]);
}
```


### View modifications
In addition to the above changes, you should also make the following modifications to the book index view:

+ Update the heading on the book index from *All Books* to *Your Books*.
+ Only show the new books call-out if there are new books.
+ If there are no books to show, link to the page to add a new book.

```php
@section('content')
    @if($newBooks->count() > 0)
        <section id='newBooks'>
            <h2>Recently added books</h2>
            <ul>
                @foreach($newBooks as $book)
                    <li>{{ $book->title }}</li>
                @endforeach
            </ul>
        </section>
    @endif

    <section id='allBooks'>
        <h2>Your books</h2>
        @if($books->count() == 0)
            <p>You don't have any books yet; would you like to <a href='/books/create'>add one?</a></p>
        @else
            @foreach($books as $book)
                @include('books._book')
            @endforeach
        @endif
    </section>
@endsection
```
    
### Test it out
+ Login as Jill and you should see all the books (since they’re all seeded to her)
+ Login as Jamal to see the &ldquo;blank slate&rdquo; page with no books to show.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-books-and-no-books@2x.png' style='max-width:1070px;' alt='Comparing the view when you have books vs. when you do not'>




## Associating books with the logged in user
Update BookController's `store` method to set the book's user_id right before the book is saved:

```php
$book->user_id = $request->user()->id; # <--- NEW LINE
$book->save();
```

Once a book is created it is tied to that user; because of this there's no need to do anything with the *Edit Book* in regards to user associations.


## Blocking access to books that do not belong to a user

We’ve already made it so you have to be logged in to access the book related routes, but now we need to take our restrictions one step further by making sure a user can only view, update, or delete a book that belongs to them.

One way to do this is by checking that the given book’s `user_id` matches the `id` of the logged in user. If it doesn’t we can redirect the user away. Here’s an example of that in the *Show a book* feature:

```php
/*
 * GET /books/{id}
 */
public function show(Request $request, $id)
{
    $book = Book::with('author')->find($id);

    # NEW CODE:
    if($book->user_id != $request->user()->id) {
        return redirect('/books')->with(['alert' => 'Access denied.']);
    }

    if (!$book) {
        return redirect('/books')->with(['alert' => 'Book not found']);
    }

    return view('books.show')->with([
        'book' => $book
    ]);
}
```

Alternatively, Laravel provides advanced tools called **Gates** and **Policies** for these sorts of restrictions which you can read more about here: [Authorization](https://laravel.com/docs/authorization).

For a simple example, let’s set up a Gate:

>> Gates are Closures that determine if a user is authorized to perform a given action and are typically defined in the App\Providers\AuthServiceProvider class using the Gate facade.

We’ll create a Gate called `books.manage` which we can apply to any of our read, update, or delete actions. This gate definition should go in the `boot` method of your `App\Providers\AuthServiceProvider` class like so:

```php
public function boot()
{
    $this->registerPolicies();

    # NEW CODE:
    Gate::define('books.manage', function ($user, $book) {
        # In order for this gate the pass, the following must be true
        return $user->id === $book->user_id;
    });
}
```

Once this Gate is defined, we can use it in our BookController methods like so:

```php
/*
 * GET /books/{id}
 */
public function show(Request $request, $id)
{
    $book = Book::with('author')->find($id);

    # NEW CODE:
    if (!Gate::allows('books.manage', $book)) {
        return redirect('/books')->with(['alert' => 'Access denied.']);
    }

    if (!$book) {
        return redirect('/books')->with(['alert' => 'Book not found']);
    }

    return view('books.show')->with([
        'book' => $book
    ]);
}
```
