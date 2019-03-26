# Validation
[Earlier this semester](/php/validation.md), we learned why form validation is important, the kinds of things you should be validating for, and how to do some simple validation with a provided [Form.php](/php/form.php-usage.md) class.

Now that we're working in a framework, we want to explore the tools Laravel provides to handle validation.

As a demonstration, we'll add validation to our *Add a book* feature.


## Validating the request
```php
/**
* POST /books
* Process the form for adding a new book
*/
public function store(Request $request) {

   # Validate the request data
   $request->validate([
       'title' => 'required',
       'author' => 'required',
       'published_year' => 'required|digits:4',
       'cover_url' => 'required|url',
       'purchase_url' => 'required|url'
   ]);

    # Note: If validation fails, it will redirect the visitor back to the form page
    # and none of the code that follows will execute.

    # Code will eventually go here to add the book to the database,
    # but for now we'll just dump the form data to the page for proof of concept
    dump($request->all());
}
```

Notes about the above:

1. When using validation, be sure the `Request $request` object is passed to the method. The validator is run on this object, so it's necessary.
2. `$this->validate` is automatically available to your controller methods. You pass it the request object and an array of fields and [validation rules](https://laravel.com/docs/validation#available-validation-rules).

To test your validation, first submit the form adding appropriate values for each field. It should submit as it was previously, with the form data dumped to the page.

Next, submit the form without filling out all the fields or providing invalid data. Upon submission, you should be immediately redirected back to the form to fix your validation errors. It won't be clear there are errors though, because we have to add code to our view to display the errors... 





## Displaying errors
If validation fails, Laravel automatically redirects the user back to their previous location. In this process, Laravel also makes error messages available to your view in a variable called `$errors` which is an instance of `Illuminate\Support\MessageBag`.

Given this, you can display errors in your view like so:
```html
@if(count($errors) > 0)
    <ul>
        @foreach ($errors->all() as $error)
            <li>{{ $error }}</li>
        @endforeach
    </ul>
@endif
```

In the above example, we're using the `all` method on `$errors`, one of many methods available when dealing with the error MessageBag.

Alternatively, if we wanted *just* the errors related to a specific field you could write something like this:

```html
@if($errors->get('title'))
    <div class='error'>{{ $errors->first('title') }}</div>
@endif
```

Read the docs page [Working with Error Messages](https://laravel.com/docs/validation#working-with-error-messages) to see more about the methods available to you in the `$error` MessageBag.


## Available validation rules
In the above example, we only saw two rules: `required` and `min`. There are currently 62 total validation rules provided for you from Laravel&mdash; you can read about them here: [Validation: Available Validation Rules](http://laravel.com/docs/validation#available-validation-rules).


## Retaining form data when validation fails
When validation fails and the visitor is redirected back to the form, the form data from the request is automatically flashed to the session for a single page request. You can access this data in your view via Laravel's [`old`](https://laravel.com/docs/helpers#method-old) helper method in order to pre-fill your inputs.

For example:
```html
<input type='text' name='title' id='title' value='{{ old('title') }}'>
```