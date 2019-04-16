# Seeders 

Database seeding is the process of entering sample/testing data into your tables.

Benefits of using seed data:
+ Good for __development environments__, where you don't have real data to work with yet.
+ Good for __testing__, so that your testing scripts have disposable data to work with.
+ Good for __collaboration__; when another developer (colleague, classmate, etc.) clones your project they can quickly build their tables using your migrations, and fill those tables with sample data using your seeders.

We saw a quick-and-dirty example of seeding the `books` table at the start of the Eloquent notes when you ran raw SQL in phpMyAdmin to enter some books.

This works, but a better way of managing seed data is via PHP classes called __seeders__.


## Create your first seeder
Let’s start by creating a new seeder for the books table.

There's an artisan command `make:seeder` that can be used to generate a boilerplate seeder class:

```bash
php artisan make:seeder BooksTableSeeder
```

This will generate a new file in `/database/seeds/BooksTableSeeder.php` which includes one method, `run`.

Add a `use App\Book;` statement at the top of this file so you can use the Book model to add some books.

```php
<?php

use Illuminate\Database\Seeder;
use App\Book; # <------ ADD THIS

class BooksTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
    }
}

```



The `run` method is invoked when this seeder is called. Given that, the `run` method is where you'll put the code that will actually enter seed data into the *books* table.


```php
public function run()
{
     $books = [
        ['The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'http://img2.imagesbn.com/p/9780743273565_p0_v4_s114x166.JPG', 'http://www.barnesandnoble.com/w/the-great-gatsby-francis-scott-fitzgerald/1116668135?ean=9780743273565'],
        ['The Bell Jar', 'Sylvia Plath', 1963, 'http://img1.imagesbn.com/p/9780061148514_p0_v2_s114x166.JPG', 'http://www.barnesandnoble.com/w/bell-jar-sylvia-plath/1100550703?ean=9780061148514'],
        ['I Know Why the Caged Bird Sings', 'Maya Angelou', 1969, 'http://img1.imagesbn.com/p/9780345514400_p0_v1_s114x166.JPG', 'http://www.barnesandnoble.com/w/i-know-why-the-caged-bird-sings-maya-angelou/1100392955?ean=9780345514400'],
        ['Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling', 1997, 'http://prodimage.images-bn.com/pimages/9780590353427_p0_v1_s484x700.jpg', 'http://www.barnesandnoble.com/w/harry-potter-and-the-sorcerers-stone-j-k-rowling/1100036321?ean=9780590353427'],
        ['Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 1998, 'http://prodimage.images-bn.com/pimages/9780439064873_p0_v1_s192x300.jpg', 'http://www.barnesandnoble.com/w/harry-potter-and-the-chamber-of-secrets-j-k-rowling/1004338523?ean=9780439064873'],
        ['Harry Potter and the The Prisoner of Azkaban', 'J.K. Rowling', 1999, 'http://prodimage.images-bn.com/pimages/9780439136365_p0_v1_s192x300.jpg', 'http://www.barnesandnoble.com/w/harry-potter-and-the-prisoner-of-azkaban-j-k-rowling/1100178339?ean=9780439136365'],
    ];

    $count = count($books);

    foreach ($books as $key => $bookData) {
        $book = new Book();

        $book->created_at = Carbon\Carbon::now()->subDays($count)->toDateTimeString();
        $book->updated_at = Carbon\Carbon::now()->subDays($count)->toDateTimeString();
        $book->title = $bookData[0];
        $book->author = $bookData[1];
        $book->published_year = $bookData[2];
        $book->cover_url = $bookData[3];
        $book->purchase_url = $bookData[4];

        $book->save();
        $count--;
    }
}
```


__Carbon Time__

For the `created_at` and `updated_at` fields, we utilized a class called Carbon that comes with Laravel and provides many date/time methods; you can read more about Carbon here: <https://github.com/briannesbitt/Carbon>.


## Master seeder
Next, open `database/seeds/DatabaseSeeder.php` where you should see this existing code:

```php
<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // $this->call(UserTableSeeder::class);
    }
}
```

This `DatabaseSeeder` class is the master seed file that gets called when you run `php artisan db:seed`. Its job is to invoke your individual Seeder classes.

There's a sample invocation commented out:

```php
//$this->call(UserTableSeeder::class);
```

Following this pattern, we can create a statement to invoke the BooksTableSeeder:

```php
$this->call(BooksTableSeeder::class);
```

Finally, run `php artisan db:seed` to run the master seeder, which should invoke the `BooksTableSeeder`.

You should see a result like this:

```
$ php artisan db:seed
Seeded: BooksTableSeeder
```

Open phpMyAdmin to view your *books* table and confirm your seed data was added.



## Running seeds again
If you call `php artisan db:seed` again, it will rerun your seeds, creating duplicate rows, which may not be what you want.

To prevent duplicate rows, you could manually empty your database tables via phpMyAdmin, then run the seeders again.

__Or__, you could run `php artisan migrate:fresh` to rebuild all your tables, effectively emptying them.
Then you can run `php artisan db:seed` again.

__Or__, you can do the last two steps in one with the `migrate:fresh` command followed by the `--seed` flag:

```bash
$ php artisan migrate:fresh --seed
```



## Seeding in Project 4
In addition to migrations, it’s required that your Project 4 application utilizes database seeding to fill all tables with example data. This practice makes it quick for us to easily build and fill your database tables so that we can more efficiently help you troubleshoot.
