# Practice work
Throughout lecture and your own practice work, we'll need a way to test out examples.

For example, in the notes on Environments, we learn that you can get config variables using the `config` helper method, e.g.:

```php
dump(config('mail.driver'));
```

Where should you run this command to test it out? You have a few options, described below.

(Side note: the above code also uses the [Laravel helper method *dump*](https://laravel.com/docs/helpers#method-dump) which we'll use a lot when working locally and we want our app to simply output some data/info so we can examine it.)


## Option 1: Practice route
You can create a temporary practice route:

```py
Route::get('/practice', function () {
    dump(config('mail.driver'));
});
```

+ __Pros:__ Quick and easy
+ __Cons:__ Not ideal to clutter up your routes file, but not a big deal if you remember to remove it when done.


## Option 2: Practice controller
Create a controller dedicated to practice work, `PracticeController.php`, with a dynamic route to access the individual methods. This is what I'll do for lecture.

Refer to the following foobooks' files to see how it's set up:
+ [/routes/web.php](https://github.com/susanBuck/foobooks/blob/master/routes/web.php)
+ [/app/Http/Controllers/PracticeController.php](https://github.com/susanBuck/foobooks/blob/master/app/Http/Controllers/PracticeController.php)  
+ [/resources/views/practice.blade.php](https://github.com/susanBuck/foobooks/blob/master/resources/views/practice.blade.php)

+ __Pros:__ It's convenient, and we'll have a running history of examples in PracticeController to be tracked in Github so they're available for your reference.
+ __Cons:__ None



## Option 3: Artisan Tinker
If you run `php artisan tinker` in your Laravel project, you'll get an interactive console for tinkering with your app.

Example:

```xml
/Applications/MAMP/htdocs/foobooks (master)  $ php artisan tinker
Psy Shell v0.7.2 (PHP 5.6.25 — cli) by Justin Hileman
>>> dump(config('mail.driver'));
"smtp"
=> "smtp"
```

Tip: Hit `ctrl` + `c` to exit the Tinker console.

+ __Pros:__ Convenient for quick examples, requires no additional files to clutter up your project.
+ __Cons:__ For lecture purposes this isn't ideal, because there will be no history of the examples, but feel free to use during your own practice.
