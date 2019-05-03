# Authentication Setup

**Preface: Integrating authentication into Project 4 is optional, and this material will not be coverd in any assignment questions.**


## What is authentication?
Authentication is the broad term used to describe the features of an application that lets *users* access functionality not available to non-users (*guests*). Furthermore, once a user is identified on an application (i.e. logged in), the app can deliver content specific to that user (e.g., instead of showing all books in the library, show just the books that belong to the user).

Typically, an authentication system involves the following components:

+ Registration page
+ Login page
+ Logout functionality
+ Forgot password page
+ Ability to &ldquo;recognize&rdquo; the user
    + Lock down pages/features depending on whether visitor is a user or guest
    + Display different content depending on whether visitor is a user or guest and which User
    + Etc...

Much of what you need for authentication comes built into Laravel. That being said, there is some work you need to do to get things working.

Let’s start with what exists...



## Auth Config
Open `config/auth.php` to see the default configurations for how authentication works. For our purposes, we don’t have to change anything here, but you should skim through the well-commented options.



## User Model
Next, there's the existing `app\User.php` which is a Eloquent model for interacting with the `users` table. You don’t have to change anything here to get started.



## Migration for the `users` table
The default install of Laravel comes with a Migration file to generate the `users` table.

If you open `database/migrations/2014_10_12_000000_create_users_table.php` you can see the structure of this table by examining the `up` method:

```php
public function up()
{
    Schema::create('users', function (Blueprint $table) {
        $table->bigIncrements('id');
        $table->string('name');
        $table->string('email')->unique();
        $table->timestamp('email_verified_at')->nullable();
        $table->string('password');
        $table->rememberToken();
        $table->timestamps();
    });
}
```

This migration includes the default fields Laravel will require to have authentication work &ldquo;out of the box&rdquo;.

You can modify this migration to include the fields needed for users in your application. For example, you may want to add additional fields (e.g. `username`, `ip_address`, `country`, etc.). Or you may want to edit existing fields like breaking out the `name` field into `first_name` and `last_name`. For now though, don’t make any edits&mdash; let’s just get authentication working.

Make sure your migrations have been run and you have the `users` table in your database.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-confirm-users-table-exists@2x.png' style='max-width:1068px; width:100%' alt=''>



## Controllers
Next, open `/app/Http/Controllers/Auth/` and note the various existing controllers that will be used as part of your authentication system.

+ `ForgotPasswordController.php`
+ `LoginController.php`
+ `RegisterController.php`
+ `ResetPasswordController.php`
+ `VerificationController.php`


## php artisan make:auth
Now that you’ve seen the existing auth-related files that Laravel ships with, the next step is to run the command `php artisan make:auth`. This will make some modifications and additions necessary for authorization.

Below is an example output of `git status` after running this command, to highlight the changes it produces:
 
<img src='https://s3.amazonaws.com/making-the-internet/laravel-changes-after-artisan-auth@2x.png' style='max-width:400px;' alt='Changes after Artisan auth is run'>


## Routes
One of the changes made by `make:auth` is it edits your `routes/web.php` file adding two lines at the bottom.

The first new line is this one:
```php
Auth::routes();
```

This single line adds 10 new routes for your application, including:

+ `/login` (GET & POST)
+ `/logout` (GET)
+ `/password/email` (GET)
+ `/password/reset` (GET & POST)
+ `/password/reset/{token}` (GET)
+ `/register` (GET & POST)

To see all these routes, run `php artisan route:list`. The following screenshot shows the relevant routes, marked by a green dot:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-auth-routes@2x.png' style='max-width:1180px;' alt=''>

The second line added to your routes file is:
```php
Route::get('/home', 'HomeController@index')->name('home');
```

By default, the `/home` route is where a user is redirected after they register, login, or logout.
We want to customize this in Foobooks, since the path `/` is what we’ve been using as &ldquo;home&rdquo;.

To make this customization, you'll edit the following files:
+ `app/Http/Controllers/Auth/LoginController.php`
+ `app/Http/Controllers/Auth/RegisterController.php`
+ `app/Http/Controllers/Auth/ResetPasswordController.php`
+ `app/Http/Controllers/Auth/VerificationController.php`

In these files, find this line:
```php
protected $redirectTo = '/home';
```

And update it to the path you want:
```php
protected $redirectTo = '/';
```

We need to make a similar edit in `app/Http/Middleware/RedirectIfAuthenticated.php` which is the middleware used to redirect a logged in user away from pages they don't need access to. For example, if a visitor is already logged in, they should not be able to view the login page.

In `RedirectIfAuthenticated.php` change this line...
```php
return redirect('/home');
```

...to the path you want:
```php
return redirect('/');
```


Finally, because we're not actually using the `/home` route, you can delete this line from your routes file:
```php
Route::get('/home', 'HomeController@index')->name('home');
```



## Views
When you invoked `php artisan make:auth` create the auth routes, this command also created some new auth-related view files which you'll want to customize to match your application.

To begin, open `resources/views/auth/login.blade.php`&mdash; we want to adapt this view to match the patterns we’ve been using in our other views.

Below is the resulting login view for Foobooks with the following modifications:
+ Extend our master layout (`layouts.master`)
+ Remove extraneous Bootstrap related HTML markup
+ Add a link to register (for users who end up on the login page without yet being registered)
+ Display errors using our `includes.error-field` view.

Note that the following essential pieces are kept in tact:
+ email input
+ password input
+ &ldquo;remember me&rdquo; checkbox

`resources/views/auth/login.blade.php`:

```php
@extends('layouts.master')

@section('content')

    <h1>Login</h1>

    Don't have an account? <a href='/register'>Register here...</a>

    <form method='POST' action='{{ route('login') }}'>

        {{ csrf_field() }}

        <label for='email'>E-Mail Address</label>
        <input id='email' type='email' name='email' value='{{ old('email') }}' required autofocus>
        @include('includes.error-field', ['fieldName' => 'email'])

        <label for='password'>Password</label>
        <input id='password' type='password' name='password' required>
        @include('includes.error-field', ['fieldName' => 'password'])

        <label>
            <input type='checkbox' name='remember' {{ old('remember') ? 'checked' : '' }}> Remember Me
        </label>

        <button type='submit' class='btn btn-primary'>Login</button>

        <a class='btn btn-link' href='{{ route('password.request') }}'>Forgot Your Password?</a>

    </form>

@endsection
```

Similarly, we can amend `resources/views/auth/register.blade.php` to this:

```php
@extends('layouts.master')

@section('content')
    <h1>Register</h1>

    Already have an account? <a href='/login'>Login here...</a>

    <form method='POST' action='{{ route('register') }}'>
        {{ csrf_field() }}

        <label for='name'>Name</label>
        <input id='name' type='text' name='name' value='{{ old('name') }}' required autofocus>
        @include('includes.error-field', ['fieldName' => 'name'])

        <label for='email'>E-Mail Address</label>
        <input id='email' type='email' name='email' value='{{ old('email') }}' required>
        @include('includes.error-field', ['fieldName' => 'email'])

        <label for='password'>Password (min: 8)</label>
        <input id='password' type='password' name='password' required>
        @include('includes.error-field', ['fieldName' => 'password'])

        <label for='password-confirm'>Confirm Password</label>
        <input id='password-confirm' type='password' name='password_confirmation' required>

        <button type='submit' class='btn btn-primary'>Register</button>
    </form>
@endsection
```


## Test it: Registration
At this point the following components should be set up:

1. The `users` table
2. The `User` Model
3. Registration, login, and logout routes
4. Views for registering and logging in

Given that, we can test things out. When you visit `/register` you should see a registration form similar to this (style may vary):

<img src='http://making-the-internet.s3.amazonaws.com/laravel-register-form@2x.png' style='max-width:769px; width:100%' alt='Register form in Laravel'>

If you fill out this form and submit it, you should be logged in and redirected to `http://foobooks.loc/` (assuming validation passed).

How do you know it worked? First, check your `users` table and make sure a new row was added.

Second, you can confirm you are logged in by adding and visiting this temporary route:

```php
Route::get('/show-login-status', function () {
    $user = Auth::user();

    if ($user) {
        dump('You are logged in.', $user->toArray());
    } else {
        dump('You are not logged in.');
    }

    return;
});
```

<img src='http://making-the-internet.s3.amazonaws.com/laravel-confirm-logging-in-worked@2x.png' style='max-width:1018px; width:100%' alt='Confirmed logging in worked'>


## Log out
Revisiting the authorization routes, you’ll recall there was a POST route to logout, but no GET route. This makes sense, as the option to logout is typically not delivered via it’s own page, but rather presented as a link somewhere in a main heading or menu.

In order to access the logout POST route, we’ll need to submit a form, complete with a CSRF token. The trick, however, is we don’t want it to look like a form, but instead just a regular link. The following code will accomplish this:

```html
<form method='POST' id='logout' action='/logout'>
    {{ csrf_field() }}
    <a href='#' onClick='document.getElementById("logout").submit();'>Logout</a>
</form>
```

(In the interest of simplicity, this code uses some inline JavaScript to submit the form via a link. Ideally, you should move this inline JavaScript to an external JS file.)

Here’s an example of how the logout link could be worked into the Foobooks nav element:
```
<nav>
    <ul>
        @foreach(config('app.nav') as $link => $label)
            <li><a href='{{ $link }}' class='{{ Request::is(substr($link, 1)) ? 'active' : '' }}'>{{ $label }}</a>
        @endforeach

        <li>
            <form method='POST' id='logout' action='/logout'>
                {{ csrf_field() }}
                <a href='#' onClick='document.getElementById("logout").submit();'>Logout</a>
            </form>
        </li>
    </ul>
</nav>
```

<img src='http://making-the-internet.s3.amazonaws.com/laravel-logout-link-added@2x.png' style='max-width:799px;' alt='Logout link in navigation'>

Test out your new logout link and then and revisit the `/show-login-status` test route to confirm it worked.

(Logically, you won’t want the *Logout* link to continue to show when you are no longer logged in; we’ll fix that in the next note set.)




## Test it: Log in
We know that logging in automatically occurs when the user registers, now let’s test and make sure logging in works independently of registration.

Visit `/login` and fill in the credentials you added during the registration test above to confirm logging in is working.

You can use the `/show-login-status` route again to confirm logging in worked.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-confirm-logging-in-worked@2x.png' style='max-width:648px; width:100%' alt=''>



## Seeds
At this point, you should have a working authentication system complete with login, registration, and logout. In the next note set, we’ll look at examples of utilizing authentication, but before we conclude here, let’s set up a seeder for the `users` table.

First step, create the `UsersTableSeeder`:

```bash
$ php artisan make:seeder UsersTableSeeder
```

In the resulting `/database/seeds/UsersTableSeeder.php` file, update the code to add two users:

1. Jill Harvard (jill@harvard.edu)
2. Jamal Harvard (jamal@harvard.edu).

Both these users will have the same password, `helloworld` (lowercase, no spaces).
```php
use App\User;

# [...]

public function run()
{
    $user = User::updateOrCreate(
        ['email' => 'jill@harvard.edu', 'name' => 'Jill Harvard'],
        ['password' => Hash::make('helloworld')
    ]);
    
      $user = User::updateOrCreate(
        ['email' => 'jamal@harvard.edu', 'name' => 'Jamal Harvard'],
        ['password' => Hash::make('helloworld')
    ]);
}
```

Don't forget to also update `/database/seeds/DatabaseSeeder.php` so the `run` method invokes this new seeder:

```php
$this->call(UsersTableSeeder::class);
```

Test your new seeder to make sure it runs without error.

With this seeding in place, anyone in this course (myself, a TA, a classmate) can log into your site using `jill@harvard.edu` / `helloworld` or `jamal@harvard.edu` / `helloworld`, which will help expedite any troubleshooting assistance you're given. 

While it's not required you implement authorization in your Project 4, __it is required that you have these test users *if* you are using authorization__.

Obviously, beyond the scope of this academic setting, should you take your application into the &ldquo;real world&rdquo;, you would want to remove these seeds or update them to use a stronger password.

## Reference
+ [Docs: Authentication](http://laravel.com/docs/authentication)
