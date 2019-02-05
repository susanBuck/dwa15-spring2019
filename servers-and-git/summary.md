# Summary

## Recap: New app setup
By the time you get to this note set you will have created a new application called `hello-world` which exists on your local computer/server, on Github.com, and on DigitalOcean.

Also, you are able to access this application via a local domain (e.g. `http://hello-world.loc`) and a production domain (e.g. `http://hello-world.yourdomain.com`)

__The above points will be repeated for every application you create in this course__, including Projects 1, 2, 3, and 4.

For reference, I've put together a [new app cheat sheet](/servers-and-git/new-app-cheat-sheet.md) you can refer to as needed.

(You could set each of these apps up now while it's fresh in your memory, but I don't recommend doing that. Repeating these steps during the semester as we get to each new project will give you practice with these concepts and serve you better in the long run.)


## Recap: Bigger picture setup
Other steps you've taken up until this point include:

+ Downloading running a local server via MAMP/XAMPP 
+ Setting up a Github.com account
+ Setting up Git
+ Creating a new DigitalOcean droplet
+ Creating [SSH key connections](/servers-and-git/ssh-keys-cheat-sheet.md) between the following:
    + Your computer <-> Github.com
    + Your computer <-> DigitalOcean server
    + DigitalOcean server <-> Github.com

Assuming nothing goes awry - these latter steps should not have to be completed again this semester.

## Development workflow

Once an application is set up, your development workflow can be summarized as follows:

+ __Develop__
    + Make changes to your application's codebase locally
    + Test/tweak those changes until you're happy with them
+ __Track__
    + Stage all the files you wish to "go live" with (`git add`)
    + Create a commit of all staged files (`git commit -m "Commit message goes here"`)
    + Push your commit to Github.com (`git push`)
+ __Deploy__
    + SSH into your DigitalOcean server
    + Navigate to the document root of the app you're working on (e.g. `cd /var/www/hello-world`)
    + Pull recent commits from Github.com (`git pull`)
    + If a Laravel application, run `composer install` to rebuild classmap and pull in any package updates. 
    + View app in browser via production URL, confirming everything is working as expected
    
Later in the semester, I'll share a script that can help automate the last steps under Deploy, but for now I believe it's useful to manually go through the steps to become familiar/comfortable with the process. 
