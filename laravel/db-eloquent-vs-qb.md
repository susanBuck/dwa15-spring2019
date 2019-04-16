# Eloquent vs. Query Builder 
*These notes are based on a post originally written at <http://blog.sriraman.in>. As of this writing, this blog is no longer active so I have adapted the information and present it here.*


## Eloquent
Eloquent is a Laravel tool that provides for a developer-friendly means of interacting with the database. 

Eloquent is built around Models which each correspond to a table. E.g., a `Post` model will correspond to a `posts` table, allowing you to execute statements like the following:

```
Post::all(); # Get all the posts
Post::find($id); # Find a post
Post::delete($id); # Delete a post
```

You can also define relationships between Models (tables) and easily query for related dated, e.g.:

```php
Post::with('comments')->find($id);
``` 

## Query builder
Another database tool Laravel provides is the Query Builder, which also provides a fluent interface to create and run database queries, but it's more similar to raw SQL queries and is not designed around Model objects.

Examples:
``````
DB::table('posts')->get(); # Get all the posts
DB::table('posts')->where('id', $id)->first(); # Find a post
DB::table('posts')->where('id', $id)->delete(); # Delete a post
```

## Eloquent vs. Query Builder
Both Eloquent and Query Builder have pros and cons regarding readability, performance, etc.

To test the performance of each, consider this test to insert 1000 rows in a table.

### Using Eloquent (Execution time : 1.41s, Queries Executed : 1000)
```php
Route::get("test",function(){
    for($i=0;$i<1000;$i++){
         $t=new Country();
         $t->label=$i." Row";
         $t->save();
    }
});
```

### Using Query Builder (Execution time : 938 ms, Queries Executed : 1000)
```php
Route::get('test', function(){
    for($i=0; $i<1000 ;$i++){
         DB::table("countries")->insert(["label" => $i." Row"]);
    }
});
```

The above tests show that Eloquent takes little bit more time to process and is not using any join queries while getting data from two tables. 

For the next test, let’s compare the performance while accessing data from two tables.

### Using Eloquent – Type 1 (Exec.time : 2.72 s , Queries executed : 3000)
```php
Route::get('test', function () {
    for ($i=0;$i<1000;$i++) {
         $state = State::find(1)->with('Country')->first();
    }
});
```

### Using Eloquent – Type 2 (Exec.time : 2.16 s , Queries executed : 2000)
```
Route::get('test', function () {
    for ($i=0; $i<1000; $i++) {
         $state = State::where('id', 1)->with('Country')->first();
    }
});
```

### Using Query Builder (Exec.time : 991 ms, Queries executed : 1000)
```php
Route::get('test', function () {
    for($i=0; $i<1000; $i++){
         $state = DB::table('states')->where('states.id',1)
            ->join('countries','states.country_id','=','countries.id')
            ->select('countries.label as country','states.label as state')
            ->get();
    }
});
```
Again, we can see Query Builder is the winner in regards to performance.


## Readability
When comparing two similar statements, it’s clear to see that Eloquent is the winner when it comes to expressiveness and readability. Some examples for comparison:

Getting a single post by id:
```
$post = Post::find($id); # Eloquent version

$post = DB::table('posts')->where('id', $id)->get(); # Query Builder version
```

Getting data from two related tables:
```php
$post = Post::with('comments')->find($id); # Eloquent version

$post = DB::table('posts')->where('id', $id)->join('comments', 'comments.post_id', '=', 'posts.id'); # Query Builder version
```


## Conclusion
Eloquent is an extension of the Query Builder, so all the functionality we get with the Query Builder can also be taken advantage of when using Eloquent.

Given this, it’s a matter of weighing the needs of your development team and application needs, and perhaps the 80:20 rule applies.

For 80% of your application, you can take advantage of the simplicity and convenience of Eloquent.
But for 20% of your application (large and/or complex queries), you may need the performance benefits of the Query Builder.


## Read more
+ [Laravel Eloquent vs query builder - Why use eloquent to decrease performance
](https://stackoverflow.com/questions/38391710/laravel-eloquent-vs-query-builder-why-use-eloquent-to-decrease-performance?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)