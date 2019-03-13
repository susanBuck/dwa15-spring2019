# Package examples

## barryvdh/laravel-debugbar
For our first example, we're going to install __barryvdh/laravel-debugbar__, which adds a useful debugging/info panel to your Laravel application.

+ <https://packagist.org/packages/barryvdh/laravel-debugbar>
+ <https://github.com/barryvdh/laravel-debugbar>

<img src='http://making-the-internet.s3.amazonaws.com/laravel-debug-preview@2x.png' style='max-width:1051px;' alt='Preview of the laravel-debugbar'>

Following the [instructions](https://github.com/barryvdh/laravel-debugbar), we'll install this package using the `composer require` command, followed by the full name of the package (including the vendor). The `--dev` flag is added so that this package only installs on our local/development server (not production). This is logical since the debugbar is only something we want to use during development, and is not something our users on production need to interact with.

```bash
$ composer require barryvdh/laravel-debugbar --dev
```


After you run the `composer require` command, if you open `composer.json`, you'll see your `require-dev` section now includes a line for the `barryvdh/laravel-debugbar`:

```json
"require-dev": {
    "barryvdh/laravel-debugbar": "^3.2",
    "beyondcode/laravel-dump-server": "^1.0",
    "filp/whoops": "^2.0",
    "fzaninotto/faker": "^1.4",
    "mockery/mockery": "^1.0",
    "nunomaduro/collision": "^2.0",
    "phpunit/phpunit": "^7.5"
},
```

Also, you should now see a `barryvdh/laravel-debugbar/` directory in your `vendors/` directory:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-debugbar-in-vendors@2x.png' style='max-width:278px; width:100%' alt=''>

(Actual files you see may vary from this screenshot, depending on the version you have)

### Using Debugbar
Debugbar is built using a Laravel feature called *package discovery* which means that upon installation you can immediately start using it without any further configuration.

Load any page in your app to test it out.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-debug-bar-open@2x.png' style='max-width:1000pxpx; width:100%' alt=''>

### Debugbar should not run on production
Debugbar is a tool we use when developing our application locally, as it provides useful insight into information about our app.

This information is not something we need/want our visitors to see, so there's no reason Debugbar should ever run on production. This is why we installed this package in the `require-dev` section of the `composer.json` file.

To make sure Debugbar is not installed on production, remember that you should be using the `--no-dev` flag when invoking composer on production: `composer install --no-dev`.



## ianlchapman/pig-latin-translator

For another example, let's experiment with the package [ianlchapman/pig-latin-translator](https://github.com/ianlchapman/PigLatinTranslator). 

This package isn't built specifically for Laravel like debugbar, but looking through its source code we can see it's just made up of a handful of PHP classes and thus it can be incorporated it into any PHP-based project. 

This package is also a good example because it represents the kind of utility that *could* assist with functionality for a hypothetical Project 3 ([Pig Latin translator wireframe](https://s3.amazonaws.com/dwa15.com/wireframe-pig-latin-translator@2x.png)).


### Installing
To install `ianlchapman/pig-latin-translator`, instead of using `composer require` we'll update `composer.json` adding `"ianlchapman/pig-latin-translator": "^1.0"` to the `require` section. (Unlike `debugbar`, it's logical we would want to use this package on production, which is why it goes in `require`, not `require-dev`).

```json
"require": {
    "php": "^7.1.3",
    "fideloper/proxy": "^4.0",
    "laravel/framework": "5.8.*",
    "laravel/tinker": "^1.0",
    "ianlchapman/pig-latin-translator": "1.0.0"
},
```

After adding this line, run `composer update` to have Composer download that package.


### Usage
Following the [instructions](https://github.com/ianlchapman/PigLatinTranslator), we can set up the following example in the Foobooks `PracticeController` created for [practice work](/laravel/practice-work.md).

```php
# Add this use statement at the top of the controller
use IanLChapman\PigLatinTranslator\Parser;

public function practiceX()
{
    $translator = new Parser();
    $translation = $translator->translate('Hello world!');
    dump($translation);
}
```

## Deploying packages to production
If you deploy new code to your production server that involves the addition or removal of a package, you need to run `composer install --no-dev` on production so it will sync up your packages.

Note the command for production is `composer install --no-dev`, not `composer update` which you've been using locally. The difference:

* Use `composer update` on __local environment(s)__ so it grabs the package versions set in your `composer.json` file and updates your `composer.lock` file to match these versions.

* Use `composer install --no-dev` on __production environment(s)__ so it grabs the package versions set in your `composer.lock` file (i.e. mirror the versions exactly as they are on the development environment). The `--no-dev` flag is added so it excludes packages specified in `require-dev`.


## Composer dump autoload
When adding new class files to your program, you may be perplexed when you go to use those classes and you see errors that they're not found.

This can happen because Composer maintains a map of all classes in your application to make loading those classes faster. If you add a new class but the class map has not been updated to reflect this change, your app may fail at locating that class.

The fix is simple; at any point you can run the command `composer dump-autoload` to generate a fresh class map.

This command should not be necessary when adding classes as we did in this note set, because `composer update` and `composer require` should also update the class map, but it's a command that may come in handy when you start adding your own classes.

```xml
$ composer dump-autoload
Generating autoload files
```

## FAQ: Can I use a package in P3?
Here's what the [P3 description](https://dwa15.com/projects/3) says about packages:

+ [barryvdh/laravel-debugbar](https://github.com/barryvdh/laravel-debugbar) should be installed in `require-dev`.
+ You can, but are not required to, implement any other package(s) you find useful for your project.


## Troubleshooting

### Issue: minimum-stability missing
Sometimes when you attempt to install a package with `composer require` you'll see a message telling you the package lacks a `minimum-stability`.

For example, you can see this with a package called [`paste\pre`](https://github.com/paste/Pre.php):

```xml
$ composer require paste/pre
[InvalidArgumentException]                                                                                           
Could not find package paste/pre at any version for your minimum-stability (stable). Check the package spelling or your minimum-stability    
```

This happens when a package is not using version tagging, and as a result Composer does not know what is the latest, stable version.

A workaround to this is to add the package by manually editing `composer.json`, setting the version of the package to `dev-master`:

```php
"require": {
    # [...existing packages...]
    "paste/pre": "dev-master"
}
```

Once you save these changes to `composer.json` you have to run `composer update` to have it go and grab that package.

You should avoid using packages that don't implement version numbers in important, production code. Without version numbers, you have less control over what version of the package you're getting, and it's always possible new versions could break your app without you realizing it at first.

In this case, since `pre` is a debugging tool, we could instead include it under `require-dev` and then it wouldn’t matter as much that we weren’t able to lock into specific versions.
