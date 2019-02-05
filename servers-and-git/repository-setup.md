## Repository setup
To recap what we've done so far:
+ Git is installed and confirmed working on your computer
+ You have an account at Github.com and you are able to SSH into it

...now let's create a new repository. __Repository__ is a Git term, and it refers to a project/directory that's being tracked by Git.

As an example, we'll create a new repository called `hello-world` to practice with. Then later, you'll follow these same procedures when creating individual repositories for Projects 1, 2, 3, and 4.

A new repository can be created on your computer and then pushed to Github.com. Or, you can create the new repository on Github.com and then pull it to your computer. Right now, we'll go the latter route. 

In Github, create a __New Repository__ (<https://github.com/new>) called `hello-world`, using the the following settings:

<img src='https://s3.amazonaws.com/making-the-internet/vc-hello-world-repository-on-github@2x.png' style='max-width:872px; width:100%'>


Next you want to clone the `hello-world` repository to your computer, which requires finding the SSH address for the repo (as shown in the following screenshot.)

<img src='https://s3.amazonaws.com/making-the-internet/vc-find-ssh-address@2x.png' style='max-width:1178px;' alt=''>

In this example, the address is `git@github.com:susanBuck/hello-world.git`. (If you're seeing an address that starts with `https`, click the blue text that says *Use SSH*).

Via command line on your computer, navigate to your htdocs folder where where you'll clone the `hello-world` repository.

__Mac__ users:
```bash
$ cd /Applications/MAMP/htdocs/
```

__Windows__ users:
```bash
$ cd c:\xampp\htdocs
```

Once in `htdocs`, execute the following line to clone your repository on Github.com to your computer, replacing `yourGithubUsername`:

```bash
$ git clone git@github.com:yourGithubUsername/hello-world.git
```

If all went well, you should see git clone the repository, and once it's completed you should have a folder called `hello-world` in your document root (`htdocs`).

That's it for setting up your repository. In the next note set, we'll see how to track changes in the repository.

## Tips
If something went wrong with creating this repository and you need to start over:

1. Follow the steps under the *Delete* section in your repo's settings on Github.
2. Remove the `hello-world` directory on your computer from your document root folder.
