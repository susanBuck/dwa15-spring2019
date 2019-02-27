# Facades
In the *Basic flow* notes we saw how routes are declared using Laravel's Router Class:

```php
Route::get('/', function () {
    # [...]
});
```

Before proceeding, let's take a moment to focus on the `Route::get` syntax because you'll see it used frequently throughout Laravel...

First, we need to address an aspect of [object oriented programming](/php/oop.md) which was not discussed earlier, and that's [__static methods__](http://php.net/manual/en/language.oop5.static.php).

__When a method is declared as static, it is accessible without needing an instantiation of the class.__

For example, imagine we had a class called `Email` with a method called `send`.

```php
class Email {
    public function send() 
    {

    }
}
```

As written, in order to invoke `send`, we'd first have to instantiate a new email object:

```php
$email = new Email();
$email->send();
```

However, if the `send` method was modified to indicate it was `static`...

```php
class Email {
    public static function send() 
    {

    }
}
```

...we could then invoke the send method directly from the class using this double colon syntax:

```php
Email::send();
```

Knowing this logistic of object oriented programming, it looks like `Route::get` is **statically** invoking a method called `get` from a class called `Route`.

This implies that the Route class is never instantiated, but that's not actually true. What we're seeing here is what Laravel calls a **facade**.

__A facade is a &ldquo;static alias&rdquo; to a underlying class/object in Laravel.__

Here's another example using Laravel's `Hash` facade:

```php
$hashedPassword = Hash::make('secret123');
```

And another example using Laravel's `App` facade:
```php
$currentEnvironment = App::environment();
```

## Philosophy behind the use of facades
>> *[Laravel facades] provide the benefit of a terse, expressive syntax while maintaining more testability and flexibility than traditional static methods.* -[src](http://laravel.com/docs/facades)


## Facades and their classes
Here's a [list of facades and their underlying classes](http://laravel.com/docs/facades#facade-class-reference).


## Helpers
Some Laravel classes can also be accessed via a **helper method** which provides an even more terse syntax for commonly used methods.

For example, the Config class can be used like this:

```php
$timezone = Config::get('app.timezone');
```

But there's also a helper method that can accomplish the same thing:
```php
$timezone = config('app.timezone');
```

[See a full list of available helper functions here...](https://laravel.com/docs/helpers)


## Fix "Undefined class Route"
The usage of facades are convenient, but they make it harder for PhpStorm to assist you when writing code in regards to auto-completion and providing context about the classes you're using. For example, here's PhpStorm flagging `Route` as an undefined class:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-undefined-class-route@2x.png' style='max-width:456px;' alt='Undefined class route'>

The problem here is not that Route is undefined, it's that PhpStorm is unable to decipher *how* it's defined.

To fix this issue, follow the notes here: [Make PhpStorm Laravel friendly](/laravel/laravel-and-phpstorm.md).