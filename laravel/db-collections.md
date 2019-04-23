## Collections

If we study the data type of `$results` for the following queries, we'll see it contains a single objects (of type Book):

```php
# The following queries return a Book object
$results = Book::find(1);  

$results = Book::orderBy('title')->first();
```

Compare that to the results of the following queries, where we'll see a Collection object containing 0 or many objects (of type Book):
```php
# Yields a collection of multiple books
$results = Book::all(); 
$results = Book::orderBy('title')->get(); 

# Should match 1 book; yields a Collection of 1 Book
$results = Book::where('author', 'F. Scott Fitzgerald')->get();

# Should match 0 books; yields an empty Collection
$results = Book::where('author', 'Virginia Wolf')->get();

# Even though we limit it to 1 book, we're using the `get` fetch method so we get a Collection (of 1 Book)
$results = Book::limit(1)->get();
 
```

> &ldquo;All **multi-result sets** returned by Eloquent are instances of the `Illuminate\Database\Eloquent\Collection` object, including results retrieved via the get method [...]. The Eloquent collection object extends the Laravel base collection, so it naturally inherits dozens of methods used to fluently work with the underlying array of Eloquent models.&rdquo; [-laravel.com/docs/eloquent-collections](https://laravel.com/docs/eloquent-collections)


## Collection Magic
Collections come built in with [magic methods](http://php.net/manual/en/language.oop5.magic.php) that lets them (the Collections) adapt to how you use them.

### String magic
For example, if you treat a Collection like a String (e.g. you `echo` it), it will transform itself into a JSON string.

```php
$books = Book::all();

# This will output a JSON string
echo $books;
```

This works because the Collection class contains the [__toString](http://php.net/manual/en/language.oop5.magic.php#object.tostring) magic method which is programmed to output a JSON string.

### Array magic
You can also treat a Collection like an array:

```php
$books = Book::all();

# loop through the Collection and access just the data
foreach ($books as $book) {
    dump($book['title']);
}
```

Depending on your data, the results of the above might look like this:
```
The Great Gatsby
The Bell Jar
I Know Why the Caged Bird Sings
```

This works because the Collection class implements PHP's [IteratorAggregate](http://php.net/manual/en/class.iteratoraggregate.php) interface.


### Object magic
Or, if you prefer object notation...

```php
$books = Book::all();

foreach ($books as $book) {
    dump($book->title);
}
```

Depending on your data, the results of the above might look like this:
```text
The Great Gatsby
The Bell Jar
I Know Why the Caged Bird Sings
```



## Using Collections in views
Because of the above points, you can pass a Collection to a view where it can be iterated through like a regular array or object:

Controller:
```php
function index() 
{
    $books = Book::orderBy('title')->get();
    
    return view('books.index')->with([
        'books' => $books
    ]);
}
```

View:
```php
@foreach($books as $book)
    <h2>{{ $book->title }}</h2>
@endforeach
```




### Get *just* the data
If you want just a &ldquo;pure&rdquo; array of the data in your Collection, use can use the [toArray()](http://laravel.com/api/5.0/Illuminate/Support/Collection.html#method_toArray) method. This will "strip" out all the methods of the Collection, giving you *just* the data attributes.

```php
$books = Book::all();
dump($books->toArray());
```

Depending on your data, the results of the above might look like this:
```
array:3 [▼
  0 => array:9 [▼
    "id" => 1
    "created_at" => "2015-11-11 04:03:26"
    "updated_at" => "2015-11-11 04:03:26"
    "title" => "The Great Gatsby"
    "author" => "F. Scott Fitzgerald"
    "page_count" => 0
    "published" => 1925
    "cover" => "http://img2.imagesbn.com/p/9780743273565_p0_v4_s114x166.JPG"
    "purchase_link" => "http://www.barnesandnoble.com/w/the-great-gatsby-francis-scott-fitzgerald/1116668135?ean=9780743273565"
  ]
  1 => array:9 [▶]
  2 => array:9 [▶]
]
```



## Collection Methods
Below is a list of some of the most commonly used methods built into the Collection object.

__Refer to the docs on [Collections: Available Methods](https://laravel.com/docs/collections#available-methods) for a full list and demo code.__


| Method   |      Usage      |
|----------|-------------|
| `all()`|  Get all of the items in the collection. |
| `first()` | Get the first item from the collection. |
| `last()` | Get the last item from the collection. |
| `shift()` | Get and remove the first item from the collection. |
| `pop()` | Get and remove the last item from the collection. |
| `each()` | Loop through each item in a collection. Can be used as an alternative to a regular `foreach`. |
| `map()` | Loop through a collection, returning a new collection as a result. Good for copying and editing a collection.
| `filter()` | Loop through a collection, returning true/false as you go. What is true stays, what is false gets removed.
| `sort()` | Sort through each item with a callback.
| `sortBy()` | Sorts the collection by a given key.
| `sortByDesc()` | Sorts the collection in the opposite order by a given key.
| `reverse()` | Reverses a collection.
| `isEmpty()` | Determine if the collection is empty or not.
| `toArray()` | Get the collection of items as a plain array.
| `toJson()` | Get the collection of items as JSON.
| `count()` | Count the number of items in the collection. |
| `take()` | Get new collection with the specified number of items. |


Some of these method names may look familiar (e.g. `first`, `all`) because we saw them when learning about Eloquent query constraints.

So what's the difference? Read on...


## Query responsibility
When possible, you want to minimize the number of queries made to a database, as excess queries can slow down an application's load time.

One way to minimize queries is to look for ways you can essentially re-use the data from an existing query.

__For example...__

Imagine a scenario in which you're building a page that shows an alphabetical listing of all the books in the foobooks database. You start with an Eloquent query:

```php
# Query DB
$books = Book::orderBy('title')->get(); 
```

Now imagine that on the same page you also want to have a special *What's New* section at the top which highlights the three most recently added books the the library.

You *could* run another Eloquent query to fetch the three most recently added books:

```php
# Query DB
$newBooks = Book::orderByDesc('created_at')->limit(3)->get(); 
```

But this is wasteful&mdash; the information you need already exists in the `$books` Collection from the previous query, so you should extract it from there rather than making &ldquo;another trip&rdquo; to the database. And so, using some Collection methods, you can extract the information you need from the `$books` Collection:

```php
# Query existing Collection
$newBooks = $books->sortByDesc('created_at')->take(3); 
```
