## Vocabulary preface
+ The term __local__ will refer to the copy of your application that is edited and run on your computer via your local server.

+ The term __production__ will refer to the copy of your application that is run on a publicly accessible web server and is used by your audience. In this course, we use DigitalOcean as our production server provider.


## Development workflows
Common beginner workflows:

+ Edit files &ldquo;live&rdquo; on production via FTP
+ Maintain a local copy of files and manually replace them on production when there are changes

We need a more sophisticated workflow.

Goals:

+ Ability to test locally without interfering with production
+ Ability to easily sync changes between local and production, without having to manually manage changes
+ Removes FTP from the picture; FTP has its purposes but it does not excel at managing an evolving codebase
+ Maintain an up-to-date backup of codebase in case of emergencies
+ Track changes to codebase over time
    + Minimize conflicts between team members working on the same code
    + Who changed what
    + When a change was made
    + Ability to &ldquo;roll-back&rdquo; to working code
+ Ease of collaboration
+ Ability to create *branches* of codebase for working on new features, starting on different versions, etc.


## Enter: __Version control__

Our workflow will be powered by version control:

>> &ldquo;Version control is the management of changes to documents, computer programs, large web sites, and other collections of information. Changes are usually identified by a number or letter code, termed the &lsquo;revision number&rsquo;, &lsquo;revision level&rsquo;, or simply &lsquo;revision&rsquo;. For example, an initial set of files is &lsquo;revision 1&rsquo;. When the first change is made, the resulting set is &lsquo;revision 2&rsquo;", and so on. Each revision is associated with a timestamp and the person making the change. Revisions can be compared, restored, and with some types of files, merged.

>> The need for a logical way to organize and control revisions has existed for almost as long as writing has existed, but revision control became much more important, and complicated, when the era of computing began. The numbering of book editions and of specification revisions are examples that date back to the print-only era. Today, the most capable (as well as complex) revision control systems are those used in software development, where a team of people may change the same files.&rdquo; -[ref](https://en.wikipedia.org/wiki/Version_control)

There are different implementations of version control software; in this course we'll use __Git__.

<img src='https://s3.amazonaws.com/making-the-internet/vc-git-banner@2x.png' style='max-width:993px; ' alt='Git banner'>

## Our workflow
<img src='https://s3.amazonaws.com/making-the-internet/vc-local-to-git-and-live-server-alternative@2x.png' style='max-width:537px;' alt='Version Control Workflow'>


## Learn more
This is not a Git course&mdash; we're covering just enough Git for our purposes.

In the interest of time, we are omitting certain Git concepts that are common in real-world settings such as branching, forking, staging servers, etc.

To continue your education on Git, you can refer to the following resources:

+ [Scott Chacon's Pro Git Book](http://Git-scm.com/book)
+ [Chacon's Git Videos](http://Git-scm.com/videos) (about 25 min total)
+ [gitref.com](http://gitref.org)

## To-do
Week 1:

+ Local server setup (MAMP/XAMPP)

Week 2:

+ Git/Github.com
+ Production servers (DigitalOcean)
+ Domains

The challenge ahead: many different variables...

+ Operating systems
+ Servers
+ Settings
+ Etc.

Expect troubleshooting; follow instructions carefully; retrace your steps when things don't work.

Good news: set it and (mostly) forget it.


## A note on Homestead and virtual machines
As we dig into Laravel later in the semester, another local server option you'll encounter (in tutorials, forums, etc.) is [Homestead](https://laravel.com/docs/5.4/homestead) and virtual machines. These technologies involve using software to boot up a unique operating system to act as a server on your computer.

In this course, we use MAMP/XAMPP instead of virtual machines for the following reasons:

+ Virtual machines can demand a lot of computer resources (space, processor speed, etc.) which not every student has access to
+ MAMP/XAMPP fits our needs and is arguably simpler to setup
+ Virtual machines excel when you are working on different applications that have unique server requirements. All the projects in this course have the same server requirements, so this feature is not necessary

A virtual machine setup may be something you &ldquo;grow into&ldquo; outside of the context of this course. 
