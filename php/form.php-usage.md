# Form.php usage
`Form.php` is a class which contains form-related helper methods including validation.

[You can download a copy of Form.php here.](https://github.com/susanBuck/dwa15-php/blob/master/includes/Form.php)

Examples of `Form.php` in use can be found here:
+ Demo: 
    + <http://php.dwa15.com/validation.php>
+ Code:
    + <https://github.com/susanBuck/dwa15-php/blob/master/validation.php>
    + <https://github.com/susanBuck/dwa15-php/blob/master/validation-logic.php>



## Known limitations
`Form.php` is a rudimentary class designed to give us practice with working with external code (specifically OOP code) and form validation.

Given that, it has the following limitations:
+ Without extending the class, you can not customize the error messages, nor the name of the field they're reporting on. This is acceptable for P2.
+ There are only 11 validation rules.

I do not consider `Form.php` a &ldquo;real world&rdquo; solution&mdash; we're using it for learning/course purposes and to ease us into more sophisticated form operations and validation which we'll see when we get to Laravel. 

(For some context and a preview of what's to come, you can skim the [Laravel docs on validation](https://laravel.com/docs/validation#available-validation-rules) including the [over 50 different validation rules](https://laravel.com/docs/validation#available-validation-rules)).


## Installation
Place a copy of [Form.php](https://github.com/susanBuck/dwa15-php/blob/master/includes/Form.php) in your project.


## Usage 
Include `Form.php` and invoke the `use` statement to make the class avilable:

```php
require 'Form.php';

use DWA\Form;
```

Instantiate an object from the Form class, passing in the $_GET or $_POST superglobal (depending on which method your form request is using):
```php
$form = new Form($_GET);
```


## Methods/Properties examples
The following is a series of examples showing the usage of Form's methods and properties. For complete details, read through the `Form.php` class.

Extract a value from the request:
```php
$email = $form->get('email');
```

If the value does not exist in the request, this method will return `null`. 

Optionally, you can provide a second parameter to use as a default if the value does not exist, e.g.:

```php
$country = $form->get('country', 'USA');
```

Determine if a value is present in the request:
```php
$email = $form->has('email');
```

Determine if the form submission has occurred:
```php
$isSubmitted = $form->isSubmitted();
```

Access Form's `hasErrors` property which contains a Boolean value as to whether or not the form has errors.
```php
$hasErrors = $form->hasErrors;
```

Validate form data by invoking the `validate` method with an array of fields => validation rules.
```php
$errors = $form->validate(
    [
        'email' => 'required|email',
        'url' => 'required|url',
        'username' => 'required|alphaNumeric',
        'year' => 'required|digit|minLength:4|maxLength:4',
        'total' => 'required|numeric',
        'age' => 'required|min:18',
        'score' => 'required|max:100',
        'rank' => 'required|digit|min:1|max:5',
        'rating' => 'required|numeric|min:1|max:5',
    ]
);
```

Note that a field can have multiple rules applied, with each rule separated by a `|` character.

The validator will loop through each field's rules, building an array of error messages. Only the first error for a given field will be reported.


## Available validation rules
+ `required` - Value can not be blank

+ `alpha` - Value can only contain letters; no symbols.
+ `alphaNumeric` - Value can only contain letters and/or numbers; no symbols.

+ `digit` - The value can only contain digits (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
+ `numeric` - The value can contain only contain numbers (e.g `1`, `-1`, `1.0`)

+ `email` - Value must be a properly formatted email address (e.g. `x@y.tld`)
+ `url` - Value must be a properly formatted URL address

+ `min:x` - The value must be >= than the given parameter (x).
+ `max:x` - The value must be <= than the given parameter (x).

+ `minLength:x` - The character count of the value must be >= the given parameter (x)
+ `maxLength:x` - The character count of the value must be <= the given parameter (x) 

(If you wish to add your own validation rules, read this: [Extending Form.php](/php/form.php-extending.md))
 
 
## Displaying errors
Example of how you might output the errors in your display file:
```html 
<?php if ($hasErrors) : ?>
    <div class='alert alert-danger'>
        <ul>
            <?php foreach ($errors as $error) : ?>
                <li><?= $error ?></li>
            <?php endforeach ?>
        </ul>
    </div>
<?php endif ?>
```
