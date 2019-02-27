# Namespacing
The topic of namespacing was first introduced when we learned about [Object Oriented Programming in PHP](/php/oop.md).

To recap: Namespacing is a programming feature that helps prevent **name collisions**. Name collisions occur when two different packages of code try to use the same class names.

Not only does namespacing help prevent name collisions, it also helps power [__autoloading__](http://php.net/manual/en/language.oop5.autoload.php).

Autoloading is a feature PHP has which makes it possible to invoke classes in your code without having to explicitly require the corresponding class files. Instead, the class is loaded as needed, when invoked.

In order for autoloading to work, you have to first give your autoloading function some details about *where* to find your classes.

In Laravel, some of the autoloading is configured in `composer.json` :

```json
 "autoload": {
    "classmap": [
        "database/seeds",
        "database/factories"
    ],
    "psr-4": {
        "App\\": "app/"
    }
},
```

This is using 2 different methods of setting up your autoloading:

1. By `classmap`. This is simply autoloading by directory. It's saying &ldquo;*Look in the `database/` directory, you'll find classes there*&rdquo;.

2. By `psr-4`. This is where namespacing and autoloading join forces.

`psr-4` is one of several PSRs (PHP Standard Recommendation) designed by the PHP [__FIG - Framework Interoperability Group__](http://www.php-fig.org/).

Read more here: [PSR-4: Autoloading Standard](http://www.php-fig.org/psr/psr-4/)

What PSR-4 does is creates a correlation between your class names and the location of your class files.

So, for example if you had PSR-4 configured and used this class setup:

```php
namespace Texter;

class Message() {

}
```

...your autoloader would look for this class at `Texter\Message.php`.


## PSR-4 in Laravel
Looking at `composer.json` in Laravel we see this PSR-4 setting:

```json
"psr-4": {
    "App\\": "app/"
}
```

The key `App` is the namespace and `app/` is the file path.

The `\\` after App is used to prevent name collisions with other namespaces like, for example, `Apples` or `Application`.

This key-value pair indicates that when we use a namespace that starts with `App`, the autoloader should look for the corresponding file in `app/`.

You can see this in action in our `BookController.php`.

At the top, the namespace is set to:

```xml
namespace App\Http\Controllers;
```

And the path to the file corresponds at:

```xml
app/Http/Controllers/BookController.php
```

Note that the autoloading config we see in `composer.json` is just a fraction of the autoloading configs our Laravel applications actually uses, and it's isolated to the components of our application that we will actually edit. There is more autoloading happening behind the scenes that pulls in all the many classes that run the framework.


## Manually adding new classes - `composer dump-autoload`
When you manually add new classes to your application in either the `psr-4` or `classmap` specified directories, you need to run the command `composer dump-autoload` so that Composer will recognize the addition of the new class.

When we added new controllers, we did skip the `composer dump-autoload` step, but only because the `php artisan make` commands invokes it for us automatically.


## Summary
1. Namespacing helps avoid name collisions
2. Namespacing facilitates autoloading by mapping namespaced class names to file paths
3. Every class in the `app` directory is autoloaded so they can be invoked without explicitly requiring them
4. Run `composer dump-autoload` after manually adding new classes