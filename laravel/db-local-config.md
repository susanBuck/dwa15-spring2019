# Local database configuration

## Starting assumptions
+ You've already created a database, per the instructions in the [*Databases primer*](/laravel/db-primer.md) notes. Our example database name is `foobooks`.
+ MAMP or XAMPP is open and your MySQL database server is running.

<img src='http://making-the-internet.s3.amazonaws.com/mysql-running-in-xampp-and-mamp@2x.png' style='max-width:921px; width:100%' alt='MySQL running in XAMPP and MAMP'>



## Laravel database configuration
In order for your application to connect to your local MySQL server and database, Laravel needs your MySQL host name, username, and password, as well as the name of the database you want to connect to.

These configurations come from your Laravel project's `/config/database.php` file.

For our examples, because we're using MySQL databases, we want to find `mysql` in the `connections` array in `/config/database.php`:

```php
'mysql' => [
        'driver' => 'mysql',
        'host' => env('DB_HOST', '127.0.0.1'),
        'port' => env('DB_PORT', '3306'),
        'database' => env('DB_DATABASE', 'forge'),
        'username' => env('DB_USERNAME', 'forge'),
        'password' => env('DB_PASSWORD', ''),
        'unix_socket' => env('DB_SOCKET', ''),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => '',
        'strict' => true,
        'engine' => null,
    ],
```

Note how the `env()` method is used for several of the settings (e.g. `host`, `username`, `password`) making it easy to set separate database configurations for your different environments. This is important, because you'll be using two different databases&mdash; one locally and one on production (DigitalOcean). 

Because of this, we'll need to make edits to our local `.env` file to configure the database connection.

__MAMP users__, update your local `.env` file with the following settings:
```
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=foobooks
DB_USERNAME=root
DB_PASSWORD=root
```

(FYI The values for host, username, and password are found on the MAMP start page at <http://localhost/MAMP>)

__XAMPP users__, update your local `.env` file with the following settings:
```xml
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=foobooks
DB_USERNAME=root
DB_PASSWORD=
```

Note that `DB_PASSWORD` is purposefully left blank.

(FYI The above values are found in `C:/xampp/passwords.txt`)

__Do not worry about your production database or production .env file this week. We'll address production databases in Week 11.__


## Test your connection
Here is __temporary__ code you can put in your web routes file to test that the database connection is working:

```php
Route::get('/debug', function () {

    $debug = [
        'Environment' => App::environment(),
    ];

    /*
    The following commented out line will print your MySQL credentials.
    Uncomment this line only if you're facing difficulties connecting to the
    database and you need to confirm your credentials. When you're done
    debugging, comment it back out so you don't accidentally leave it
    running on your production server, making your credentials public.
    */
    #$debug['MySQL connection config'] = config('database.connections.mysql');

    try {
        $databases = DB::select('SHOW DATABASES;');
        $debug['Database connection test'] = 'PASSED';
        $debug['Databases'] = array_column($databases, 'Database');
    } catch (Exception $e) {
        $debug['Database connection test'] = 'FAILED: '.$e->getMessage();
    }

    dump($debug);
});
```

When you visit the resulting route (`http://foobooks.loc/debug`) you should see some debugging information including a test of your database connection.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-database-debug-route@2x.png' style='max-width:1086px;' alt='Database debug route results'>

If your database connection test fails, you have some troubleshooting to do. A collection of common issues/solutions is listed at the bottom of this document.




## Conclusions
With your database setup and your connection confirmed, you're ready to move on to [**Migrations**](/laravel/db-migrations.md) in order to build your tables.


## Troubleshooting

### MAMP users: `No such file or directory`

When testing your database connection, you see the following error:
```xml
Caught exception: SQLSTATE[HY000] [2002] No such file or directory (SQL: SHOW DATABASES;)
```

Or:
```xml
[Illuminate\Database\QueryException]
SQLSTATE[HY000] [2002] No such file or directory (SQL: select * from information_schema.tables where table_schema = foobooks and table_name = migrations)
PDOException
SQLSTATE[HY000] [2002] No such file or directory
```

This error likely means that your application is using a different instance of MySQL than the one MAMP is using. Fix with the following steps.

__Step 1.__
Open your local `/.env` file and paste this line after your other `DB_*` configs:

```xml
DB_SOCKET='/Applications/MAMP/tmp/mysql/mysql.sock'
```

__Step 2.__
In the `/debug` route given to you in the notes above, find this line:

```php
#$debug['MySQL connection config'] = config('database.connections.mysql');
```
...and uncomment it so your database configurations will be visible when you visit `/debug`.

Save your changes and refresh your `/debug` route.

For the values under `MySQL connection config` you should see output like the following, and hopefully, your database connection test should now be passing. If the connection fails, confirm `unix_socket` is set to `/Applications/MAMP/tmp/mysql/mysql.sock`.

```xml
(
    [driver] => mysql
    [host] => localhost
    [port] => 3306
    [database] => foobooks
    [username] => root
    [password] => root
    [charset] => utf8mb4
    [collation] => utf8mb4_unicode_ci
    [prefix] =>
    [strict] => 1
    [engine] =>
    [unix_socket] => /Applications/MAMP/tmp/mysql/mysql.sock
)
```
