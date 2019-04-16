# CRUD: Create, Read, Update, Delete
Most database interactions can be boiled down to these four actions:

1. Create - add new row(s) to a table
2. Read - query for existing row(s) in a table
3. Update - alter row(s) in a table
4. Delete - delete row(s) in a table

These actions are often abbreviated using the acronym **CRUD (Create, Read, Update, Delete)**.



## CRUD Examples
Imagine a hypothetical e-commerce store:

### Create
When a customer places an order, a new row is created in an `orders` table.

SQL Query:
```sql
INSERT INTO orders (user_id, created_at, total, address_id, shipping_method, status)
VALUES (99, '2018-04-10 07:33:18', 55.45, 8, 'Priority', 'pending');
```

### Read
When a customer goes to their order history page, an `orders` table is queried for any order associated with that customer's id.

SQL Query:
```sql
SELECT * FROM orders WHERE user_id = 99
```

### Update
When an order is shipped, the corresponding row in the `orders` table is updated so that the `status` field is changed from `pending` to `shipped`. 

SQL Query:
```sql
UPDATE orders SET status = 'shipped' WHERE id = 1
``` 

### Delete
When a customer goes to their account settings and deletes a saved shipping address, the corresponding row in an `addresses` table is removed.

SQL Query:
```sql
DELETE FROM addresses WHERE address_id = 8
```



## Laravel and database interaction
Our goal is to be able to perform actions like the ones described above - but instead of writing our own SQL, we'll explore two tools Laravel provides to generate and execute SQL statements against the database.

__The first tool is the [Query Builder](https://laravel.com/docs/queries), accessed via the DB facade:__

>> *&ldquo;Laravel's database query builder provides a convenient, fluent interface to creating and running database queries. It can be used to perform most database operations in your application and works on all supported database systems.&rdquo;*


Query Builder example statements:
```php
DB::table('books')->get(); # Get all the books
DB::table('books')->where('id', $id)->first(); # Find a book by its id
DB::table('books')->where('id', $id)->delete(); # Delete a book
```

__The second tool is [Eloquent ORM](https://laravel.com/docs/eloquent) (Object-relational Mapping):__

>> *&ldquo;The Eloquent ORM included with Laravel provides a beautiful, simple ActiveRecord implementation for working with your database. Each database table has a corresponding &lsquo;Model&rsquo; which is used to interact with that table. Models allow you to query for data in your tables, as well as insert new records into the table.&rdquo;*

Eloquent example statements:

```php
Book::all() # Get all the books
Book::find($id) # Find a book by its id
Book::delete($id) # Delete a book
```



## Which tool to use?
Some projects/developers use only the Query Builder, while some use only Eloquent.

Most projects/developers use some combination of both, with a favoring towards Eloquent.

Neither tool is necessarily better than the other, they're just different with their own pros and cons (speed, control, ease of use, etc.).

In the interest of time, __we’ll focus our attention in this course on using Eloquent ORM__.

(If you have experience with writing code to interact with databases, you can read more about the [pros/cons of Eloquent vs. Query Builder here](/laravel/db-eloquent-vs-qb.md))



## Summary
+ Our applications will need to Create, Read, Update, and Delete data.
+ To do this, we'll use Eloquent ORM.



## Before you go: seed data
In the next note set we'll explore examples of querying the `books` table in the `foobooks` database, so it'll be useful if we're all working with the same data.

On your local server, in phpMyAdmin, select the `foobooks` database then find the *SQL* tab.

Copy/paste and run the following SQL:

```sql
DELETE FROM books;
INSERT INTO `books` (`id`, `created_at`, `updated_at`, `title`, `author`, `published_year`, `cover_url`, `purchase_url`) VALUES
(1, '2017-04-13 13:19:36', '2017-04-13 13:19:36', 'The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'http://img2.imagesbn.com/p/9780743273565_p0_v4_s114x166.JPG', 'http://www.barnesandnoble.com/w/the-great-gatsby-francis-scott-fitzgerald/1116668135?ean=9780743273565'),
(2, '2017-04-13 13:19:36', '2017-04-13 13:19:36', 'The Bell Jar', 'Sylvia Plath', 1963, 'http://img1.imagesbn.com/p/9780061148514_p0_v2_s114x166.JPG', 'http://www.barnesandnoble.com/w/bell-jar-sylvia-plath/1100550703?ean=9780061148514'),
(3, '2017-04-13 13:19:36', '2017-04-13 13:19:36', 'I Know Why the Caged Bird Sings', 'Maya Angelou', 1969, 'http://img1.imagesbn.com/p/9780345514400_p0_v1_s114x166.JPG', 'http://www.barnesandnoble.com/w/i-know-why-the-caged-bird-sings-maya-angelou/1100392955?ean=9780345514400'),
(4, '2017-04-13 13:19:36', '2017-04-13 13:19:36', 'Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling', 1997, 'http://prodimage.images-bn.com/pimages/9780590353427_p0_v1_s484x700.jpg', 'http://www.barnesandnoble.com/w/harry-potter-and-the-sorcerers-stone-j-k-rowling/1100036321?ean=9780590353427'),
(5, '2017-04-13 13:19:36', '2017-04-13 13:19:36', 'Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 1998, 'http://prodimage.images-bn.com/pimages/9780439064873_p0_v1_s192x300.jpg', 'http://www.barnesandnoble.com/w/harry-potter-and-the-chamber-of-secrets-j-k-rowling/1004338523?ean=9780439064873'),
(6, '2017-04-13 13:19:36', '2017-04-13 13:19:36', 'Harry Potter and the The Prisoner of Azkaban', 'J.K. Rowling', 1999, 'http://prodimage.images-bn.com/pimages/9780439136365_p0_v1_s192x300.jpg', 'http://www.barnesandnoble.com/w/harry-potter-and-the-prisoner-of-azkaban-j-k-rowling/1100178339?ean=9780439136365');
```

<img src='http://making-the-internet.s3.amazonaws.com/laravel-foobooks-sql-seed@2x.png' style='max-width:1343px;' alt=''>

With some data to work with, proceed to the next note set: [Eloquent](/laravel/db-eloquent.md)
