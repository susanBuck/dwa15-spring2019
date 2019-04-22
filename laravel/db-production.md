# Production database setup

With the topic of __migrations__ and __seeding__ behind us, the next logical step is to set up the production database.

Here is a summary of the steps we'll take (all on the production server) to get this done:

1. Make sure your production code is up to date.
2. Find your default MySQL password.
3. Create a new database.
4. Create a new MySQL user.
5. Set up these credentials in your production `.env` file
6. Run migrations (to build tables) and seeders (to fill tables).




## 1. Make sure your production code is up to date
Before proceeding with the next steps, the first thing you want to do is make sure any database related changes in your local code base have been added, committed, and pushed to Github, then pulled down to your production server.

Specifically, you want to make sure any __migration files__ and any __seeder files__ are in existence and up to date on your production server. The last step in this document will be to run these migrations and seeders, so we want to make sure they're ready to go.

So, do a `git status` locally. Are there any new or changed migration or seeder files? If so, go ahead and sync up so your live server also has these changes.

### Update class map
Also recall that you want to run `composer install --no-dev` on production when deploying not only to ensure all packages are up to date, but to make sure your Composer autoloading class map file reflects any new classes (including seeds/migrations) that have been added.

## 2. Find your default MySQL password

When you first SSH into your DigitalOcean server, you should see a welcome message (a.k.a &ldquo;[message of the day](http://en.wikipedia.org/wiki/Motd_(Unix))&rdquo;).

This message includes a note indicating that your default MySQL password is saved in `/root/.digitalocean_password`

<img src='http://making-the-internet.s3.amazonaws.com/laravel-motd-mysql-password@2x.png' style='max-width:923px;' alt=''>

Thus, if you use `cat` to view this file, you can see your password:
```bash
root@Fall2016:~# cat /root/.digitalocean_password
root_mysql_pass="9f15faddf3d4c9825fac6f22ab042ad4b47919ff063bd063"
```

In this example, the password is `9f15faddf3d4c9825fac6f22ab042ad4b47919ff063bd063`


## 3. Create a new database
When working locally, we create new databases using phpMyAdmin. phpMyAdmin is not installed on your DigitalOcean server by default, so we’ll instead use the MySQL command line tool to create a new database.

While SSH'd into your DigitalOcean server, run the following command to start the MySQL command line tool:

```bash
$ mysql -u root -p
```

When it prompts for your password, use the MySQL password you copied in the previous step.

If all goes well, you should see some info about MySQL, followed by the `mysql> ` prompt.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-mysql-tool-on-digital-ocean@2x.png' style='max-width:617px; width:100%' alt=''>



Run the SQL command `SHOW DATABASES;` to see what databases exist on your server (there should be 3 default ones).

(Note: Every SQL command you enter should end with a semi-colon)

```xml
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                | 
+--------------------+
3 rows in set (0.00 sec)
```

Next, you can create a new database using the SQL command `CREATE DATABASE <db-name>;`.

For example:
```xml
mysql> CREATE DATABASE foobooks;
Query OK, 1 row affected (0.00 sec)
```

You can run `SHOW DATABASES;` again to confirm the new database exists.


## 4. Create a new MySQL user
Next, we’ll create a new MySQL user that will be used to connect to your databases from your Laravel apps.

While still in the MySQL command line we’ll run the following command to create a new user. Before running this command, note the following:
1. The username is `dwa` (short for *Dynamic Web Applications* - we’ll use this user for all your databases in this course, which is why we're not naming it specific to any one app). 
2. The password is `your-password-here`; can change this to a password of your choosing.

```
CREATE USER 'dwa'@'localhost' IDENTIFIED BY 'your-password-here';
```

Next, we want to grant privileges to our new user, `dwa`:

```
GRANT ALL PRIVILEGES ON * . * TO 'dwa'@'localhost';
```

*Note: we’re being very liberal here allowing the `dwa` user full access (`ALL PRIVILEGES`) to all databases (` * . * `). In a real-world application, you’ll want to be more restrictive for security purposes. You can read more about MySQL [privileges here](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html).*

Next, run this command to make these changes take effect:

```
FLUSH PRIVILEGES;
```

Finally, run `exit;` to get out of the MySQL command line tool.




## 5. Set up these credentials in your production `.env` file
In order for your application to interact with this database, you have to update your production `.env` file with the correct database credentials.

While SSHd into your DigitalOcean server, open your project's `.env` file in nano.

For example:

```bash
$ cd /var/www/html/foobooks/
$ nano .env
```

In your .env file, update your `DB_` settings so they look like the following (change the `DB_USERNAME` and `DB_PASSWORD` to match whatever you used in the previous step):

```xml
DB_DATABASE=foobooks
DB_USERNAME=dwa
DB_PASSWORD=your-password-here
```

When you're done updating your values, save your changes and exit nano (`ctrl + x`, then `y`, then *Enter*).

Next, run `php artisan config:clear` to ensure Laravel detects these changes to your configs.

With the above steps complete, you next want to confirm these credentials work.

If you still have the [/debug route](https://github.com/susanBuck/dwa15-fall2017/blob/master/03_Laravel/24_Local_database_config.md#test-your-connection) from when you were configuring your local database connection, you can use that again to confirm your live database connection.




## 6. Run migrations (to build tables) and seeders (to fill tables)
The final step is to run your migrations on your live server to build your tables, then run your seeders to fill these tables with some sample data.

First, the migrations:
```xml
$ php artisan migrate
```

When you run this command, it will show you a warning, `Application In Production!` and ask you to confirm you wish to run the migration. Type `y` and hit `Enter` to confirm that you do.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-run-migrations-on-digital-ocean@2x.png' style='max-width:771px; width:100%' alt='Run migrations on DigitalOcean'>

Assuming your migrations successfully ran, you can now run your seeders:

```xml
$ php artisan db:seed
```

<img src='http://making-the-internet.s3.amazonaws.com/laravel-run-seeders-on-digital-ocean@2x.png' style='max-width:757px; width:100%' alt='Running seeders on DigitalOcean'>




## Viewing your data
When working locally, to confirm your tables were built and data was entered, you loaded phpMyAdmin to open the `foobooks` database and examine the tables.

As mentioned above, though, we don’t have phpMyAdmin on the DigitalOcean server. As a substitute, we’ll use the MySQL command line tool again. The following commands should be all you need to cover the basics of examining tables.


Start the MySQL command line tool:
```xml
mysql -u root -p
```

Show all the databases that exist on the server:
```xml
SHOW DATABASES;
```

"Open" a particular database:
```xml
USE foobooks;
```

Show all the tables in a opened database:
```xml
SHOW TABLES;
```

Show all the rows in a table:
```
SELECT * FROM books;
```

Show all the rows in a table in a vertical fashion (can more be readable than the default horizontal table layout):
```
SELECT * FROM books\G;
```

Finally, if for some reason you want to start with a fresh database, you can run the following commands:
```
DROP DATABASE foobooks;
CREATE DATABASE foobooks;
```

## Summary

One time steps:
+ Obtain `root` MySQL password so you can access the MySQL command line tool
+ Using the MySQL command line tool, create a `dwa` MySQL user that can access your databases from your applications

To be repeated for each application you create:
+ Use the MySQL command line tool to create a new database for that specific project

## Troubleshooting

### Error: `Access denied`
If you try and run your migrations but they fail, it may be because the DB credentials you put into `.env` are incorrect. If that happens, you may see a message similar to this:

```xml
SQLSTATE[28000] [1045] Access denied for user 'dwa'@'localhost' (using password: YES)
```

If this happen, double check your credentials and try again.


### Error: `Class BooksTableSeeder does not exist`
If you see a message telling you your seeder files does not exist, for example...

```xml
Class BooksTableSeeder does not exist
```

This may be because your Composer autoloading map has not been re-generated and as a result, new Seeder classes are not mapped.

To resolve this, revisit Step 1 at the top of this page, specifically the note about running `composer install --no-dev`.




