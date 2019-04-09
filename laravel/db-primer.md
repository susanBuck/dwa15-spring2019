# Database primer

## Intro
Databases are an essential component of most web applications as they provide a mechanism for storing and retrieving data over time. A database is one way to give your application persistent memory.

In this course, we'll use [**relational databases**](https://en.wikipedia.org/wiki/Relational_database), which involves **tables** of data made up of **columns** and **rows**. 

For example, the Foobooks app will need a *books* table, and eventually an *authors* table, and *tags* table.

Each table is like a spreadsheet with **columns** describing the data that table is storing (e.g. a *books* table would have columns like `title`, `published_year`, etc.)

Data is stored in the tables as **rows** (e.g. a *books* table would have a row for the book *The Great Gatsby*, another row for the book *The Bell Jar*, etc.)

<img src='https://s3.amazonaws.com/making-the-internet/laravel-table-visualization@2x.png' style='max-width:1000px;' alt='Database table visualization'>


## Database types
Laravel makes it convenient to connect to a variety of database technologies:

+ MySQL (or its equivalent, MariaDB)
+ SQLite
+ PostgreSQL
+ SQL Server

If interested, [here's an article on the differences between these database types](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems).

In this course, we'll be using __MySQL__ databases, so the first step is getting MySQL sorted out on your local server...

## Local database
In addition to providing an Apache web server, MAMP and XAMPP also provide a MySQL server for database interaction.

Now's a good time to make sure MySQL is running in MAMP/XAMPP:
<img src='http://making-the-internet.s3.amazonaws.com/mysql-running-in-xampp-and-mamp@2x.png' style='max-width:921px; width:100%' alt='MySQL running in XAMPP and MAMP'>

If MySQL is not running refer to these notes: [Local server troubleshooting](/servers-and-git/local-server-troubleshooting.md)


## Working with the database
There are a few ways you can interact with a MySQL database:

1. Via a database manager such as phpMyAdmin
2. Via MySQL's command line tool
3. Via your application code

These notes will cover examples of each.


## phpMyAdmin
phpMyAdmin is a __web-based MySQL database manager__ that comes with MAMP and XAMPP by default. It's also a common tool on shared web servers, and can be installed on virtual private servers like the ones we use on DigitalOcean.

To access phpMyAdmin via MAMP or XAMPP go to **<http://localhost/phpmyadmin>**.

<img src='http://making-the-internet.s3.amazonaws.com/laravel-phpmyadmin@2x.png' class='' style='max-width:631px; width:100%' alt='phpMyAdmin Screenshot'>

Optional: As an alternative to phpMyAdmin, there are also desktop database application, e.g.:

+ Mac: [SequelPro](http://www.sequelpro.com/)
+ Windows: [HeidiSQL](http://www.heidisql.com/)



## New database
In phpMyAdmin, find the __Database tab__ and create a new database called `foobooks` with the [collation](https://dev.mysql.com/doc/refman/5.7/en/charset-general.html) set to `utf8mb4_unicode_ci`:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-phpmyadmin-create-new-database@2x.png' style='max-width:986px; width:100%' alt='Creating a new database in phpMyAdmin'>

After the database is created, it's now time to design our tables...

## Planning the columns needed for the `books` table
For Foobooks, our first table will be **books**, and we'll construct this table using the same structure/data data we saw in [`books.json`](https://github.com/susanBuck/foobooks/blob/master/database/books.json)

```json
{
    "The Great Gatsby": {
        "id" : 0,
        "author": "F. Scott Fitzgerald",
        "tags" : ["novel","fiction","classic","wealth"],
        "published_year" : 1925,
        "cover_url" : "http://img2.imagesbn.com/p/9780743273565_p0_v4_s114x166.JPG",
        "purchase_url" : "http://www.barnesandnoble.com/w/the-great-gatsby-francis-scott-fitzgerald/1116668135?ean=9780743273565"
    },
    "The Bell Jar": {
        "id" : 1,
        "author": "Sylvia Plath",
        "tags" : ["novel","fiction","classic","women"],
        "published_year" : 1963,
        "cover_url" : "http://img1.imagesbn.com/p/9780061148514_p0_v2_s114x166.JPG",
        "purchase_url" : "http://www.barnesandnoble.com/w/bell-jar-sylvia-plath/1100550703?ean=9780061148514"
    },
    "I Know Why the Caged Bird Sings": {
        "id" : 2,
        "author": "Maya Angelou",
        "tags" : ["autobiography","nonfiction","classic","women"],
        "published_year" : 1969,
        "cover_url" : "http://img1.imagesbn.com/p/9780345514400_p0_v1_s114x166.JPG",
        "purchase_url" : "http://www.barnesandnoble.com/w/i-know-why-the-caged-bird-sings-maya-angelou/1100392955?ean=9780345514400"
    }
}
```

Looking at this data, we see we'll need the following columns:

1. `id`
2. `title`
3. `author`
4. `published_year`
5. `cover_url`
6. `purchase_url`

(the `tags` column was purposefully omitted; we'll cover that later in a separate table.)

## Create the new `books` table
In phpMyAdmin, create your first table in the `foobooks` database, named `books`. Set the *Number of columns* to be 6.

<img src='https://s3.amazonaws.com/making-the-internet/laravel-new-books-table@2x.png' style='max-width:1086px; width:100%' alt='Create the new books table in phpMyAdmin'>

After naming your table, you'll be prompted on the next screen to design your table configuring the columns (name, data type, settings, etc.)

This is the design we'll aim for:

<img src='http://making-the-internet.s3.amazonaws.com/laravel-books-table-design@2x.png' style='max-width:282px; width:100%' alt='books table design'>

The above graphic was created using [dbdesigner.net](http://dbdesigner.net), a program that can be used to sketch out table designs. The third column in the graphic (`int`, `varchar(255)`, etc.) indicates the MySQL data types we plan to set for each column. Data types are specified to best optimize *how* MySQL stores the data.

In lecture I will discuss the most commonly used data types, but you'll also want to read through the following to familiarize yourself with all the data types available:

+ [MySQL Reference Manual: Data Types](https://dev.mysql.com/doc/refman/5.7/en/data-types.html)
+ [Tutorialpoint: MySQL Data Types](https://www.tutorialspoint.com/mysql/mysql-data-types.htm)
+ The SQL readings assigned in the Week 10 assignment

If we implement the above `books` table design in phpMyAdmin, it looks like this:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-phpmyadmin-design-books-table@2x.png' style='max-width:1226px; width:100%' alt='books table built in phpMyAdmin'>

Note the following about the above design:
+ The columns `title`, `author`, `cover_url`, and `purchase_url` are all set to the MySQL data type `VARCHAR` with a max length of 255 (the max for `VARCHAR`)
+ The column `published_year` is set to the MySQL data type `YEAR` with a max length of 4 (with the expectation that we would store a 4 character representation of the year, e.g. `1998` or `2015`).
+ Primary Index:
    + The first column, `id`, is set to be the **Primary Index** (aka **Primary Key**) and **AI (Auto Increment)** is checked. With some exceptions, most tables should start with an `id` column that has these characteristics.
    + Setting the `id` column as the Primary Index will come into play when you form relationships between tables and also when you create indexes to optimize queries.
    + Setting the `id` column to auto-increment will make MySQL generate a new, unique id for every row that gets entered into this table.


### Save your new table
After you're done entering the settings for your new `books` table, save your work and double check the design of your new table via the **Structure** tab:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-phpmyadmin-books-table-done@2x.png' style='max-width:1118px;' alt='Books table created'>



## SQL
*Note: The following section is FYI only; no action is required.*

MySQL, SQLite, PostgreSQL, and SQL Server all rely on **SQL (Structured Query Language)**, a language designed for interacting with **Relational Database Management Systems (RDBMS)**.

The actions we've done thus far in phpMyAdmin could have actually be completed with SQL commands, run either via MySQL Command Line, or via the *SQL* tab in phpMyAdmin.

Essentially phpMyAdmin is a visual abstraction for SQL commands, giving you an interface to enter info which the program then converts to SQL commands to run against your database.

For example, when you created the database `foobooks`, phpMyAdmin built and ran this SQL command:

```sql
CREATE DATABASE foobooks;
```

The SQL equivalent of clicking on `foobooks` from the left menu would be this SQL command:

```sql
USE foobooks;
```

And when you created the table, the SQL command was this:

```sql
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    published_year YEAR(4),
    cover_url VARCHAR(255),
    purchase_url VARCHAR(255)
);
```



## New rows
To create a new row in the `books` table, i.e. add your first book, you could do it via the *Insert* tab in phpMyAdmin:

<img src='https://s3.amazonaws.com/making-the-internet/laravel-phpmyadmin-insert-new-book@2x.png' class='' style='max-width:986px; width:100%' alt='Manually adding a new book via phpMyAdmin'>

Or you could run the following SQL command:

```sql
INSERT INTO `foobooks`.`books`
(`id`, `title`, `author`, `published_year`, `cover_url`, `purchase_url`)
VALUES (
    NULL,
    'The Great Gatsby',
    'F. Scott Fitzgerald',
    '1925',
    'http://img2.imagesbn.com/p/9780743273565_p0_v4_s114x166.JPG',
    'http://www.barnesandnoble.com/w/the-great-gatsby-francis-scott-fitzgerald/1116668135?ean=9780743273565'
    );
```

<img src='http://making-the-internet.s3.amazonaws.com/laravel-phpmyadmin-insert-new-book-with-sql@2x.png' class='' style='max-width:857px; width:100%' alt='Creating a new book with a SQL command'>




## Reading data
In the above examples we made a table and entered data into that table. Now let's look at how we can read data from the table.

Here's an SQL command that would fetch all the rows in the `books` table:

```sql
SELECT * FROM books
```

<img src='http://making-the-internet.s3.amazonaws.com/laravel-phpmyadmin-select-all-books@2x.png' class='' style='max-width:1021px; width:100%' alt=''>

Here's an SQL command that would fetch all the rows from the `books` table where the author name included the word &ldquo;Scott&rdquo;:

```sql
SELECT * FROM books WHERE author LIKE '%Scott%'
```

Alternatively you could have achieved the same results by exploring the *Search* tab in phpMyAdmin.

The above SQL commands are pretty human readable, so you should get the gist of what they're doing, but take a moment to skim over this [SQL Cheat Sheet](http://www.sql.su) to see the variety of commands that SQL has.




## Executing SQL from your applications
The above methods of interacting with your database all come from the perspective of you, the developer.

Obviously, though, you'll want to create features in your application that interact with your database.

In PHP, one way you can tap into a MySQL database is using the [mysqli extension](http://php.net/manual/en/mysqli.quickstart.statements.php).

Here's an example of a simple PHP script that connects to a database (`foobooks`) and then runs a SQL query against a table in this database (`SELECT * FROM books`):

```php
# Step 1) Connect to the database
$mysqli = new mysqli('localhost', 'root', 'root', 'foobooks');
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error;
}

# Step 2) Run a query
$books = $mysqli->query('SELECT * FROM books');

# Step 3) Loop through results
$books->data_seek(0);
while ($book = $books->fetch_assoc()) {
    dump($book['title']);
}
```

The above code is the approach we'd use if we were writing &ldquo;plain PHP&rdquo; without a framework like Laravel. __You don't have to run this code, just skim through it for the general idea__.




## Enter Laravel...
Everything described thus far is roughly what you'd do if you were interacting with a database without the utilities a framework provides.

However, because database interaction is such an essential aspect of application development, frameworks like Laravel give us many tools to make database work easy.

Here's just some of the examples of the benefits Laravel provides for database interaction:

+ Manage one or more database connections.
+ Environment specific database management.
+ Abstraction which provides the ability to easily switch between database types.
+ Automatically protects against [SQL Injection Attacks](http://imgs.xkcd.com/comics/exploits_of_a_mom.png).
+ Object mapping - the ability to easily connect the Objects of your application to rows in a table.
+ Migrations - PHP Classes used to structure database tables.
+ Seeding - PHP Classes used to to pre-fill database tables.

From this point forward we're going to look at database interaction from the perspective of Laravel which is going to abstract a lot of the SQL-related work we did above. Despite this, it's still useful to have a foundational SQL understanding so you better understand what Laravel is doing beneath the surface.

## Summary
The above notes covered a lot of background information to help you understand how MySQL databases work. To recap on just the actionable steps, though, here's what we did:

1. Created a new database called `foobooks` using phpMyAdmin.
2. In this database, created a new table called `books`.
3. Entered at least one book into this new table, using the *Insert* tab in phpMyAdmin.




## Tip: Via MySQL Command Line
If you want to bypass phpMyAdmin, you can interact directly with MySQL from the command line using MySQL's executable.

Launch MySQL from MAMP:

```xml
$ /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot
```

Launch MySQL from XAMPP:

```xml
$ C:\xampp\mysql\bin\mysql.exe --user=root --password=
```

Once you're in mysql mode you should see a prompt that looks like this:

```bash
mysql >
```

At this prompt, you can type any SQL command. For example, here's a command to show all the databases on your system:

```bash
mysql > SHOW DATABASES;
```

End your statement with a semi-colon; this tells MySQL you're done so it can execute the line.

This command lets you select the `foobooks` database.

```bash
mysql > USE foobooks;
```

See all the tables:
```bash
mysql > SHOW TABLES;
```

Now you can practice any of the commands covered above, such as selecting books:
```bash
mysql > SELECT * FROM books;
```

Hit CTRL-C when you're done to exit MySQL.
