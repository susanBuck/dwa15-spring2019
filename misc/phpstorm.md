# PhpStorm

PhpStorm is an IDE (Integrated Development Environment), which is a **super-powered code editor** packed with tools intended to make your development process easier. PhpStorm is most focused on PHP, but also has fantastic support for other languages (HTML, CSS, JS, Markdown, etc.). 

+ [PhpStorm](https://www.jetbrains.com/phpstorm)
+ [Apply for a free education license](https://www.jetbrains.com/student)
+ [Help](https://www.jetbrains.com/help/phpstorm/)
+ [Full feature list](https://www.jetbrains.com/phpstorm/features)

An IDE is programmed to understand the code you're writing and assist you along the way with things like **code completion**, **on-the-fly error prevention**, **code clean-up and refactoring tools**, as well as **sophisticated tools for navigating through the structure of your code**.

Alternatives to IDEs include code editors such as [Sublime](https://www.sublimetext.com/3) or [Atom](https://atom.io).

Programs like Sublime text *can* be powerful, especially when you install plugins, but PhpStorm is powerful &ldquo;out of the box&rdquo; and it would take a lot of plugins to match the features in PhpStorm. Furthermore, even if you loaded Sublime with tons of plugins to get all the features you needed, the software would start to become bloated and you're not guaranteed all the various plugins are working seamlessly together.

The downside to IDEs is they're more complex and can be overwhelming at first with a steeper learning curve. Fortunately, though, PhpStorm is highly customizable so you can scale down all the features you're exposed to at first, and slowly bring the ones you need back into action as needed. 

With all this being said though, having a basic editor like Sublime on hand can be useful for occasional quick edits to miscellaneous files when you're not in the middle of a set project. 


## Simplify
If you're new to PhpStorm, I suggest importing my settings which will greatly simplify your interface and provide for a consistent experience with what you see in lecture videos.

As you become more comfortable with the program, you can branch out and customize the program to your liking.

1. Download [dwa-phpstorm-settings.jar](/misc/dwa-phpstorm-settings.jar)
2. *File* > *Import Settings* - select the `dwa-php-storm-settings.jar` file you just downloaded.

My settings include everything *except* keymaps, as this varies between Mac/Windows. More on customizing your keymaps in a moment.


## Projects
PhpStorm is centered around projects.

As an example, we'll create a new project out of our *hello-world* app from Week 2.

+ *File* > *Open* - find and select the *hello-world* directory.

*hello-world* is now loaded and initialized as a PhpStorm project. 

Next time you close and re-open PhpStorm it will give you the option to re-open this project.

Optionally, you can always re-open a project by going to *File* > *Open* and re-selecting the appropriate directory. 

### Project specific config
If you do a `git status` in your *hello-world* directory, you'll see a new folder called `.idea` which holds all the relevant PhpStorm settings for this project.

You probably don't want to track this directory in git, so in the root of your project, you want to edit/add a file called `.gitignore` and add the line `.idea` so it will ignore this directory. 


## Tour of the interface
+ Top: Menus and toolbars
+ Left: Tool windows (project, navigation, favorites, etc.)
+ Right: Editor
+ Bottom: Status bar


## Customizing
Get into preferences:
+ Mac: *PhpStorm* > *Preferences*
+ Win: *File* > *Settings*

Skim through the settings to get a sense of what can be customized.

Note there's a search bar to find the setting you're looking for.

Customize what you see/don't see in the interface:
*Appearance & Behavior* > *Menus & Toolbars*


## Keymaps
Search by the command, or the existing keymap.

The following are the keyboard shortcuts I use most frequently. You should customize these as you see fit and get comfortable using them, especially *Reformat Code* 

Most important:
+ `Cmd + A`: *Select all*
+ `Cmd + L`: *Reformat Code*
+ `Shift + Shift`: *Search Everywhere*

Others:
+ `Cmd + K`: *Hide All Tool Windows*
+ `Cmd + W`: *Close tab*


## Tools we're not using
+ Databases
+ Terminal
+ Version Control
+ Debugging



## Whitespace/Indentation
>> Code MUST use 4 spaces for indenting, not tabs. -[PSR-2 Coding Style Guide](https://www.php-fig.org/psr/psr-2/)

<img src='https://s3.amazonaws.com/dwa15.com/php-show-whitespaces-in-phpstorm.png' style='max-width:521px;' alt='PhpStorm settings for white space'>

<img src='https://s3.amazonaws.com/dwa15.com/php-phpstorm-indent-settings.png' style='max-width:521px;' alt=''>