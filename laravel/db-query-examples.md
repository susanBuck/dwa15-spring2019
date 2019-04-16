# Query examples
```php 
# Get all rows
$result = Book::all();
dump($result->toArray());

# Get a row by id
$result = Book::find(1);
dump($result);

# Throw an exception if the lookup fails
$result = Book::findOrFail(9999);
dump($result->toArray());

# Get all rows with a `where` constraint using fuzzy matching
$result = Book::where('title', 'LIKE', '%Gatsby%')->get();
dump($result->toArray());

# Get all rows with a `where` constraint using exact matching
$result = Book::where('title', '=', 'The Great Gatsby')->get();
dump($result->toArray());

# Get rows with a `orderBy` constraint
# By default order is ascending
$result = Book::orderBy('published')->get();
dump($result->toArray());

# A second param can be passed to `orderBy` constraint to specify descending order
$result = Book::orderBy('published', 'desc')->get();
dump($result->toArray());

# `orderBy` constraints can be chained to order by multiple rows
$result = Book::orderBy('published')->orderBy('title', 'desc')->get();
dump($result->toArray());

# Chain two `where` constraints
$result = Book::where('published', '>', '1960')->where('id', '<', 5 )->get();
dump($result->toArray());

# Chain a `where` and a `orWhere` constraint
$result = Book::where('published', '>', '1960')->orWhere('id', '<', 5 )->get();
dump($result->toArray());

# `whereIn` constraint
$result = Book::whereIn('id', [1, 2])->get();
dump($result->toArray());

# Get just the first result of a query by using the `first` fetch method
$result = Book::where('title', 'LIKE', '%Gatsby%')->orderBy('created_at')->first();
dump($result);

# Throw an exception if the query fails
$result = Book::where('title', '=', 'The Great Gatsbyyyyy')->firstOrFail();
dump($result->toArray());

# Count how many rows match a `where` constraint using the `count` fetch method
$result = Book::where('title', 'LIKE', '%Gatsby%')->count();
dump($result);

# Limit the amount of results a query will return
$result = Book::where('published', '>', 1800)->limit(2)->get();
dump($result->toArray());

# Get a single column's value from the first result of a query
$result = Book::where('published', '>', 1800)->orderBy('published')->value('title');
dump($result);

# Determine if a row exists using the `exists` fetch method (returns a boolean value)
$result = Book::where('title', '=', 'The Great Gatsby')->exists();
dump($result);

# Execute a raw SQL select
$result = Book::raw('SELECT * FROM books WHERE title LIKE %Gatsby%')->get();
dump($result->toArray());

# Delete a row by id
$result = Book::destroy(1);
dump($result);

# Delete any rows matching a `where` constraint
$result = Book::where('title', '=', 'The Great Gatsby')->delete();
dump($result);
```
