# Permissions

Files and folders have permissions which allows you control who can edit, view and/or execute the file/directory.

If you run `ls -la` in a directory you can see information about the files/folders in that directory, including permission information:

```bash
~/practice   $ ls -la
total 0
drwxr-xr-x    3 Susan  staff   102 Jan 27 22:36 .
drwxr-xr-x+ 142 Susan  staff  4828 Jan 27 21:54 ..
-rw-r--r--    1 Susan  staff     0 Jan 27 22:36 example.txt
```

In the above example `-rw-r--r--` is indicating the permissions for the file `example.txt` using **Symbolic Notation**.

Symbolic notation uses a 10 character string to represent permission settings.

With `-rw-r--r--` the first character is `-`, the second is `r`, and so on...

Here's a breakdown of the 5 different characters you'll see in a symbolic notation strings:

* `r` = readable
* `w` = writable
* `x` = executable
* `-` = None
* `d` = directory

The next thing to understand is that the placement of these characters in the string has meaning.

Looking at the example `-rw-r--r--`:

* The first slot is used to indicate whether this item is a file or directory. In this case it's `-` which indicates it's a file (if it was a `d` then it'd be a directory).
* The next 3 slots (`rw-`) indicate whether the **User** who owns this item can read, write, or execute the file. In this case it says `rw-` so the User can read, write, but not execute this file.
* The next 3 slots (`r--`) indicate whether the **Group** who owns that file can read, write, or execute the file. In this case it says `r--` so the Group can read but not write or execute this file.
* The final 3 slots (`r--`) indicate whether **everyone** else can read, write, or execute the file. In this case it says `r--` so everyone can read but not write or execute this file.

Here's a graphic to visualize the above description:

<img src='https://s3.amazonaws.com/making-the-internet/sysadmin-example@2x.png' class='' style='max-width:345px; width:100%' alt=''>

Here's some practice reading permission strings:

Given this string: `-rwxr-xr--`
+ Is this a file or directory?
+ What are the read, write, execute settings for the User?
+ What are the read, write, execute settings for the Group?
+ What are the read, write, execute settings for everyone else?

What about for this this string: `dr-x------`?

[The solutions for both of these can be found here.](http://making-the-internet.s3.amazonaws.com/sysadmin-permission-examples@2x.png)

## Numeric/Octal notation
File permissions can also be specified with numeric/octal notation.

With this format, each permission is assigned a numerical value:

* `r` = readable = 4
* `w` = writable = 2
* `x` = executable = 1

These numbers are then added to get the resulting numeric notation.

For example:

<img src='http://making-the-internet.s3.amazonaws.com/sysadmin-octal-example@2x.png' style='max-width:272px; width:100%' alt=''>

Conclusion: The octal/numeric permission representation for `-rwxr-x---` is `750`

(Note the `-` is omitted from the calculation.)


## Changing file permissions
Numeric/octal notation is used with the `chmod` (change file modes) command to change the permissions of a file.

For example, we could change the permissions of our `example.txt` file like this:

```bash
$ chmod 750 foo.txt
```

Results:

```bash
~/practice   $ ls -la
total 0
drwxr-xr-x    3 Susan  staff   102 Jan 27 22:36 .
drwxr-xr-x+ 142 Susan  staff  4828 Jan 27 21:54 ..
-rwxr-x---    1 Susan  staff     0 Jan 27 22:36 example.txt
```

## Tip
Bookmark <http://permissions-calculator.org>

It's very handy for quickly checking your file permissions, converting between symbolic and octal, etc.

## Common Permissions
When working on the web, files are typically set to `644` or `-rw-r--r--`.
This means the User can read/write the file, but the Group and Everyone can only read the file.

For directories, you'll often see `755` or `drwxr-xr-x`. Directories have to be executable in order to traverse into it. In this example, the User can read, write, and execute the directory. The Group and Everyone can only read and execute it.


## Read Write Execute

Here's some extra info about read/write/execute permissions:

>> The **read** permission grants the ability to read a file. When set for a directory, this permission grants the ability to read the names of files in the directory (but not to find out any further information about them such as contents, file type, size, ownership, permissions, etc.)

>> The **write** permission grants the ability to modify a file. When set for a directory, this permission grants the ability to modify entries in the directory. This includes creating files, deleting files, and renaming files.

>> The **execute** permission grants the ability to execute a file. This permission must be set for executable binaries (for example, a compiled C++ program) or shell scripts (for example, a Perl program) in order to allow the operating system to run them. When set for a directory, this permission grants the ability to access file contents and metainfo if its name is known, but not list files inside the directory (unless read is set).


## Reference
* [Permissions Calculator](http://permissions-calculator.org)
* [Chmod](http://ss64.com/bash/chmod.html)
* [Wikipedia - Unix Permissions](http://en.wikipedia.org/wiki/Unix_permissions#Traditional_Unix_permissions)
* [File permissions for uploads](http://superuser.com/questions/581194/setting-correct-permissions-for-uploading-files)
