# Foobooks: Many to Many

The following is a __rough outline__ of modifications I'll make to Foobooks during Week 13's lectures.

__This should not be considered a stand-alone document; for full details please refer to the lecture video and the Foobooks code source.__


## Tags in the *Edit Book* feature
We have everything set up for a tags feature&mdash; migrations, seeders, models&mdash; now let's look at how we'd implement tags.

Starting with the *Edit Book* feature, we need a way to associate tags with books. For authors, this was done with a dropdown which worked because each book can have only *one* author.

Each book can have *many* tags, though, so a dropdown won't do. Instead, let's show all possible tags with checkboxes. Example of what we're aiming for:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-foobooks-tag-checkboxes@2x.png' style='max-width:357px; width:100%' alt='Tags checkboxes'>

To accomplish this, we'll need to gather the following data:

1. All the possible tags
2. All the tags associated with the book we're looking at.

First, a `getForCheckboxes()` method in the Tag model:

```php
public static function getForCheckboxes()
{
    $tags = self::orderBy('name')->get();

    $tagsForCheckboxes = [];

    foreach ($tags as $tag) {
        $tagsForCheckboxes[$tag['id']] = $tag->name;
    }

    return $tagsForCheckboxes;
}
```

Then update `BookController@edit`:

```php
public function edit($id = null)
{
    # Get this book and eager load its tags
    $book = Book::with('tags')->find($id);

    if (!$book) {
        return redirect('/book')->with('alert', 'Book not found');
    }

    # Get authors
    $authors = Author::getForDropdown();

    # Get all the possible tags so we can include them with checkboxes in the view
    $allTags = Tag::getForCheckboxes();

    # Get just the tag names for tags associated with this book;
    # will be used in the view to decide which tags should be checked off
    $tags = $book->tags->pluck('tags.id')->toArray();

    return view('book.edit')
        ->with([
            'book' => $book,
            'authors' => $authors,
            'allTags' => $tagsForCheckboxes,
            'tags' => $tags,
        ]);
}
```

Use this array of tags to construct the checkboxes in the view:
```php
# /resources/views/book/edit.blade.php

# [...]

<label>Tags</label>
@foreach($tags as $tagId => $tagName)
    <ul class='tags'>
        <li>
            <label>
                <input
                    {{ (in_array($tagId, $tags)) ? 'checked' : '' }}
                    type='checkbox'
                    name='tags[]'
                    value='{{ $tagId }}'>
                {{ $tagName }}
            </label>
        </li>
    </ul>
@endforeach

# [...]
```


In `BookController@update` where we save the updates, sync the tags from the request:
```php
public function update(Request $request, $id)
{
    # [...validation removed for brevity...]

    # Find and update book
    $book = Book::find($request->id);

    # Sync the tags
    $book->tags()->sync($request->tags); # <--- NEW CODE

     # Update other book data
    $book->title = $request->title;
    $book->published_year = $request->published_year;
    $book->author_id = $request->author_id;
    $book->cover_url = $request->cover_url;
    $book->purchase_url = $request->purchase_url;

    # Save edits
    $book->save();

    # [...finish removed for brevity..]
}
```

## Tags in the *Add a Book* feature
See:  
+ [/resources/views/books/create/blade.php](https://github.com/susanBuck/foobooks/blob/master/resources/views/books/create.blade.php#L52)
+ [/app/Http/Controllers/BookController.php](https://github.com/susanBuck/foobooks/blob/master/app/Http/Controllers/BookController.php#L131)



## Revisiting the book delete feature
Now that books are associated with tags, you'll get a *foreign key constraint* SQL error when trying to delete a book. To fix, you want to remove any tag associations before the book is deleted...

```php
public function delete(Request $request)
{
    $book = Book::find($id);

    if (!$book) {
        return redirect('/books')->with('alert', 'Book not found');
    }

    $book->tags()->detach();

    $book->delete();

    return redirect('/books')->with('alert', $book->title.' was removed.');
}
```



