# Make PhpStorm more Laravel friendly

Both PhpStorm and Laravel are robust and complex systems that attempt to make developer’s lives easier by providing an abundance of tools and features for writing software.

Most of the time, these systems work well together and you get the advantage of Laravel’s advanced yet expressive featureset with the support of PhpStorm's rich functionality (code completion, inspections, etc.)

However, sometimes the two systems are not 100% compatible and extra configuration is needed to make them work together more seamlessly. The following notes explain steps to make this happen.


## PhpStorm Laravel Plugin

This [Laravel Plugin](https://plugins.jetbrains.com/plugin/7532-laravel-plugin) for PhpStorm adds the following features:

+ PHP/Route: Controller completion and goto
+ PHP/Route: Router::resource references
+ PHP/Route: detect route names on "as" key
+ PHP/View: completion and goto for view templates
+ PHP/Config: "providers" class array completion
+ PHP/Config: Config key indexer, completion and goto
+ PHP/Translation: Translation key indexer, completion and goto
+ PHP: Service dic
+ Blade: extends, include and Php usage linemarker
+ Blade: section, yield, stack overwrite and implements linemarker
+ Blade: Improvements in Blade template name completion and navigation
+ Blade: trans directive
+ Template: Index for Php usage

To install this plugin, search for it in your PhpStorm plugin settings (via *Preferences/Settings* : *Plugins*).

Once installed, it should prompt you to enable the plugin whenever it detects you've open a Laravel project.

Alternatively, you can manually enable it via *Preferences/Settings* : *Languages & Frameworks* : *PHP* : *Laravel* : *Enable plugin for this project*.

<img src='https://s3.amazonaws.com/making-the-internet/laravel-enable-plugin@2x.png' style='max-width:1000px;' alt='Enable Laravel Plugin'>


## laravel-ide-helper Package

When using Laravel facades (e.g. `Route`) you'll notice PhpStorm flagging the classes as undefined:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-undefined-route-facade@2x.png' style='max-width:500px;' alt=''>

The problem is not that the class isn’t defined, it’s that PhpStorm doesnt understand *how* Laravel has defined the class.

To fix this, we can install the package [barryvdh/laravel-ide-helper](https://github.com/barryvdh/laravel-ide-helper) which will provide meta information to PhpStorm about the class structure of your app, preventing PhpStorm from flagging certain methods as unavailable.

Install this package in `require-dev` with the following command:
```
$ composer require --dev barryvdh/laravel-ide-helper
```

Next, in `app/Providers/AppServiceProvider.php` within the `register` method, add this code to register the ide-helper (on non-production environments only):

```php
if ($this->app->environment() !== 'production') {
    $this->app->register(\Barryvdh\LaravelIdeHelper\IdeHelperServiceProvider::class);
}
```

Next, in `composer.json` in the `scripts` section, add the following:

```php
"post-update-cmd": [
    "Illuminate\\Foundation\\ComposerScripts::postUpdate",
    "php artisan ide-helper:generate",
    "php artisan ide-helper:meta",
    "php artisan ide-helper:models --nowrite"
]
```

Like so:
<img src='https://s3.amazonaws.com/making-the-internet/laravel-post-update-cmd@2x.png' style='max-width:590px;' alt=''>

The above step specifies a series of `php artisan ide-helper` commands to be automatically run whenever you run `composer update`. 

As a result of these commands, 2 new files will be generated in your application: `_ide_helper.php` and `ide_helper_models.php`. These files provide meta information to PhpStorm that it can use to understand the class structure of your app. Both these files can be added/committed in version control.



## Resolve *Validate method not found in Illuminate\Http\Request* flag

Even with the above changes, PhpStorm will still flag the `validate` method as unavailable when invoked on the `$request` object:


<img src='https://s3.amazonaws.com/making-the-internet/laravel-validate-method-phpstorm@2x.png' style='max-width:563px;' alt='Validate method not found'>


You can ignore this flag, or a [hack to fix it](https://github.com/barryvdh/laravel-ide-helper/issues/608) is add a new file `app/IDEAutoCompleteHelp.php` with this code:

```php
<?php
namespace Illuminate\Http;

/**
 * @method bool validate(array $rules, ...$params) Validate the given request with the given rules.
 */
class Request
{
}
```

## Resolve *Cannot resolve file* flag in views

When referencing a route in your views, PhpStorm might report that that path/file can not be resolved:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-can-not-resolve-file@2x.png' style='max-width:787px;' alt=''>

Because of how URLs/directories typically work in a static site, it's looking or a file at `/books/search-process` - but because we're using routing that obviously does not exist.

I'm not aware of any ways to resolve this flag, but you can disable it on a project-by-project basis. To do this, go to *Preferences* : *Editor* : *Inspections* : *HTML* and uncheck *File reference problems*.

<img src='https://s3.amazonaws.com/making-the-internet/laravel-file-reference-problems@2x.png' style='max-width:1143px;' alt='File reference problems'>

Alternatively, you could work around the flag by using Laravel's [`url` helper method](https://laravel.com/docs/helpers#method-url):

```php
<form method='GET' action='{{ url('/books/search-process') }}'>
```

Or, you could use [named routes](https://laravel.com/docs/routing#named-routes):

```php
<form method='GET' action='{{ route('books.searchProcess') }}'>
```
