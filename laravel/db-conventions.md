# Database Conventions

Just like a [code style guide](/misc/code-style.md) creates consistency within projects and amongst development teams, a set of conventions for database design is also important.

The following is a set of conventions you should follow when building your database tables in this course.

 Not only will these conventions create consistency in our projects, we'll also see that many of them are utilized by Laravel's database tools.

## Database
+ No set conventions - could be the app name (e.g. `foobooks`) or named after the project (e.g. `project4`)

## Tables
+ Table names should be lowercase and plural (e.g. `books`, `authors`)
+ Multi-word table names should be `snake_case_separated` (e.g. `password_resets`).
+ A simple, single word table name is preferred to multi-word table names but exceptions are made when it's unavoidable.

## Columns
+ Every table (including pivot tables) should begin with an *auto-incrementing Primary Index* integer field called `id` (singular, lowercase).
+ Column names should be lowercase and singular (e.g. `title`, `published_year`)
+ Multi-word column names should be `snake_case_separated` (e.g. `first_name`, `last_name`).
+ Column names should not include the name of the table (e.g. a table called `orders` might have a field `type` but it should not have a field `order_type` as that's redundant). 
+ Be consistent from table to table (e.g. don't have `zip` in one table and `zip_code` in another).
+ Don't artificially shorten or abbreviate words. It is better for a name to be long and clear than short and confusing. (e.g. `preference` is better than `pref`, `description` is better than `desc`). Consistently avoiding abbreviations also makes it easier for developers to recall column names because you don't have to wonder if/how you abbreviated a column.
+ Typically, a column should not contain more than one element of data (e.g. rather than a `name` field with a user's first and last name, it's better to have a `first_name` and `last_name` field so that each part of the name can be individually accessed).

