# Foobooks: One to Many

The following is a __rough outline__ of the modifications I'll make to Foobooks during Week 13's lectures.

__This should not be considered a stand-alone document; for full details please refer to the lecture video and the Foobooks code source.__


## Author dropdown
To associate Authors with Books we'll use a dropdown filled with authors. I'll start by showing this in the *Add a book* feature, and later add it to the *Edit a book* feature.

```php
# BookController.php
public function create($id)
{
    # Get data for authors in alphabetical order by last name
    $authors = Author::orderBy('last_name')->select(['id', 'first_name', 'last_name'])->get();

    return view('book.edit')->with([
        'authors' => $authors
    ]);
}
```

Construct the dropdown (`<select>`) in the view using this data:
```html
<label for='author_id'>* Author</label>
<select name='author_id'>
    <option value=''>Choose one...</option>
    @foreach($authors as $author)
        <option value='{{ $author->id }}' {{ (old('author_id') == $author->id) ? 'selected' : '' }}>{{ $author->first_name.' '.$author->last_name }}</option>
    @endforeach
</select>
@include('modules.field-error', ['field' => 'author_id'])
```

Update the `BookController@store` method to also save the author details about the book.

One way to do this:
```php
$author = Author::find($request->author_id);
$book->author()->associate($author);
```

Or, just manually specify the `author_id` since we already have it in the request. Saves us a trip to the database to fetch the Author object.
```php
$book->author_id = $request->author_id;
```


## Custom model methods
We'll want to do the same thing on the *Edit* page.

Rather than duplicate the &ldquo;get authors for dropdown&rdquo; code, we can extract it out of the controller and add it as a method to the `Author` model:

```php
# app/Author.php
public static function getForDropdown() {
    return self::orderBy('last_name')->select(['id', 'first_name', 'last_name'])->get();
}
```

Then in `BookController@edit`:
```
$authors = Author::getForDropdown();
```


## Validation
```php
$this->validate($request, [
    'title' => 'required|min:3',
    'author_id' => 'required', # <---- Validate author dropdown
    'published' => 'required|min:4|numeric',
    'purchase_link' => 'required|url',
    'cover' => 'required|url',
]);
```
