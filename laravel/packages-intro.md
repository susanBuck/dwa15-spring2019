# Packages intro


## What is a package?
A package is a bundle of software that developers create and share using Composer.

Laravel itself is a package (that depends on many other packages).

Packages save you time and effort. Here are some example scenarios:

+ Need to resize your user's profile photos? [There's a package](https://github.com/Intervention/image) that gives you all sorts of PHP image resizing functionality including cropping, resizing, converting formats, etc.
+ Need to output PDF receipts for your users? [There's a package](https://github.com/cangelis/php-pdf) for converting HTML to PDFs.
+ Need to distinguish your users by roles such as admin, moderator, guest, etc.? [There's a package](https://github.com/Zizaco/entrust) for managing roles and permissions.


## Finding and choosing packages
The main source for researching/browsing packages is [Packagist](https://packagist.org/).

There's also a Laravel-specific package browsing site called [Packalyst](http://packalyst.com/packages).

This brings up some interesting points:
+ Packages are not Laravel specific.
+ Some packages are designed to work specifically with Laravel.
+ Other packages are more generic and can work with any project, including Laravel.
+ Some packages are designed for other frameworks, and won't play nice with your Laravel project.

These are factors you'll want to consider when choosing which packages you'll use.

### Compatibility
+ Will this package work with my Laravel app?
+ Specifically, will it work with the version of Laravel I'm using?
+ If it was not designed for Laravel, can I still use it?

### Quality
+ Does it have a lot of downloads?
+ Is the documentation clear and well written? The quality of the documentation/README.md file is usually a good reflection of how well written the package itself is written.
+ Has it been recently updated or is it several years old?
+ Is it being recommended by a reputable source?

When browsing for a package, it doesn't necessarily have to pass *all* of these tests. For example, there are many good packages that are several years old and still get the job done. But if it's old, *and* the documentation is terrible, *and* there's only 10 downloads...you might want to stay away.

### Test driving
If you come across several quality options that may help you accomplish the task at hand, you may want to &ldquo;test drive&rdquo; the different packages.

These are questions you might ask yourself when comparing packages:
+ Is one package easier to use than another?
+ Is one package written in a code style you prefer more vs another?
+ Is one package lacking the features you need?
+ Is one package packed with more features than you actually need?
+ Is one package better integrated with Laravel vs another?


## Learning more about a package
When searching for packages on Packagist or Packalyst, you'll enter keywords for the kind of feature you're looking to add, for example you might type in &ldquo;image&rdquo; if you needed a package for basic image manipulation (cropping, resizing, etc.):

<img src='http://making-the-internet.s3.amazonaws.com/laravel-searching-for-image-package@2x.png' style='max-width:823px; width:100%' alt=''>

From there, you can choose matches that look good to learn more.

The main thing you want to find in the information page is the link to the Package's Github page, because that's where the most comprehensive info is.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-getting-to-github-page-from-packagist@2x.png' style='max-width:838px; width:100%' alt=''>

The Github page should include details such as:

+ General description of what the package does
+ Any requirements (for example, a certain version of PHP)
+ List of features
+ Installation instructions
+ Usage instructions
+ Examples


## Installing a package
There are two ways a package can be added to your project:

1. By running `composer require` followed by the vendor/package name.
2. By adding the vendor/package name to your project's `composer.json` file and running `composer update`.

In the next note set ([Package examples](/laravel/packages-examples.md)) we’ll cover both approaches.

Installed packages are stored in the `vendor/` folder at the root of your project. You should never modify code in this folder because it would cause your files to become out of sync and your changes may be overwritten by Composer processes.


## Using a package
How you use a package is going to depend on how that package is built.

Some packages are built specifically for Laravel and utilize Service Providers.

(In Laravel, a [Service Provider](https://laravel.com/docs/master/providers) is an organizational tool that lets you group together related classes. Service Providers are loaded when your app &ldquo;boots up&rdquo;, making those services available for use.)

Other packages are not built specifically for Laravel, but can still be used within your Laravel projects.

In the next note set ([Package examples](/laravel/packages-examples.md)) we’ll cover an example of both.
