**SUPPLEMENTAL/OPTIONAL MATERIAL**

# Summary
In the following instructions, we'll look at the procedures for &ldquo;hardening&rdquo; your DigitalOcean Droplet, making it more difficult for malicious hackers to compromise your server.

Here are the steps we will cover:

1. Create a new, alternative user to `root`.
2. Grant this new user administrative privileges.
3. Disable SSH access from the `root` user.
4. How to run commands as an administrator as your new user.
5. Install fail2ban to block repeated, failed, login attempts.


## Create a new user
The `root` user on your account has the highest priveleges; because of that, if a hacker gains access to your server as the `root` user, they have a lot of power to do a lot of harm.

Because of this, we're going to disable `root` from being able to SSH in to your server.

Before we do that, though, we need to create a new, alternative user that *can* SSH into your server.

Begin by SSH'ing into your Droplet as `root`:

```bash
$ ssh root@your-droplet-ip-address
```

Next we'll use the command `adduser` followed by a username of your choice.

During this procedure, you'll be prompted to create a password for this new user. Strong passwords are essential to prevent brute force attacks (where a machine is used to try and guess your password). If you're not confident in your ability to generate a secure password, use a [password generator tool](http://correcthorsebatterystaple.net/).

With your password chosen, initiate the new user (replace `susanbuck` with a username of your choosing):

```bash
$ adduser susanbuck
```

The process will look like this:

```
Adding user 'susanbuck' ...
Adding new group 'susanbuck' (1000) ...
Adding new user 'susanbuck' (1000) with group 'susanbuck' ...
Creating home directory '/home/susanbuck' ...
Copying files from '/etc/skel' ...
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
Changing the user information susanbuck
Enter the new value, or press ENTER the default
	Full Name []: Susan Buck
	Room Number []:  
	Work Phone []:
	Home Phone []:
	Other []:
Is the information correct? [Y/n] y
```


## Give your new user admin privileges
Next, we want to give your new user administrator privileges.

While still signed in as the root user, run:

```bash
$ visudo
```

This command uses nano to open the files that controls your server's `sudoers` (more on `sudo` later.)

Search for the line that looks like this:

```bash
root    ALL=(ALL:ALL) ALL
```

Below that line, add *new* line that looks like the following (replace `susanbuck` with your username):

```bash
susanbuck ALL=(ALL:ALL) ALL
```

Save your changes (`ctrl` + `x`, then `y`, then *Enter*).


## SSH access for your new user
When you first set up DigitalOcean, you created a SSH key connection between your computer and your server. This allowed you to SSH into your Droplet as `root`, without having to enter a password.

You'll want the same convenience/security that SSH keys provide for your new user as well, so let's set that up.

(In the following steps, it's assumed that you've already created a public key (`id_rsa.pub`) on your local machine when you first followed the [Git setup notes](https://github.com/susanBuck/dwa15-fall2017/blob/master/01_Servers_and_Git/03_Git_setup.md).)

Open a *new* Terminal/Cmder window, so we can grab your public key from your local machine, without losing your connection to your Droplet.

In the new window, on your local computer, get the contents of your `id_rsa.pub` file using the cat command.

Mac:
```bash
$ cat ~/.ssh/id_rsa.pub
```

Windows/Cmder (replace `YourName`):
```bash
$ cat C:\Users\YourName\.ssh\id_rsa.pub
```

The output will look something like this:

```bash
ssh-rsa [LONG STRING OF RANDOM CHARACTERS] your@email.com
```

Select the entire public key and copy it.

Switch back to the Terminal/Cmder window that's SSH'd into your Droplet as `root` and run the following command to switch to your new user (replace `susanbuck` with your username):

```bash
$ su - susanbuck
```

Your new user does not have any SSH settings yet, so let's start by creating a new `.ssh` directory:

```bash
$ mkdir ~/.ssh
```

For security purposes, we'll make it so only you (i.e. the user you're logged in as) can *Read*, *Write* or *Execute* this directory, by setting the permissions to `700`:

```bash
$ chmod 700 ~/.ssh
```

(Permissions are beyond the scope of these notes; if interested, you can [learn more here](/command-line/permissions.md).)

Next, open `authorized_keys` using nano:

```bash
$ nano ~/.ssh/authorized_keys
```

Paste in your public key which you copied above from your local computer.

Save your changes to `authorized_keys` and exit (`ctrl` + `x`, then `y`, then *Enter*).

Finally, we'll alter the permissions on `authorized_keys` to make sure no other user can edit it. We'll use the permission code `600` which will allow just your user to *Read* and *Write* to this file (*Execute* is not needed since it's a file, not a directory).

```bash
$ chmod 600 ~/.ssh/authorized_keys
```

To confirm the above steps worked, first log out of your new user account:

```bash
$ exit
```

Then log out of your Droplet:

```bash
$ exit
```

Then try to SSH back in as your new user:
```
$ ssh yourusername@your-droplet-ip-address
```

If everything went well, you should be logged in again.


## New SSH key for Github
Your new user will want to communicate with Github, so lets set up a new SSH key pair. You've followed these procedures a couple times now (when first setting up DigitalOcean, when first connecting to Github), so here's the express version of what you need to do:

While logged in as your new user, generate a new key pair:

```bash
$ ssh-keygen -t rsa -C "your@email.com"
```

Output the resulting public key:
```bash
$ cat ~/.ssh/id_rsa.pub
```

Copy the output from the above, and in Github.com -> *Settings* -> *SSH Keys* add this new key.

At this point, you might be acquiring quite a collection of keys in Github, so you may want to choose a descriptive name for this key such as:

```
User: [username], DigitalOcean Droplet: [droplet name]
```

After the key is added, confirm it's working with:

```bash
$ ssh -T git@github.com
```


## SSH Key Cheat Sheet
If you're having a hard time wrapping your head around the various SSH key pairs we've set up in this course, check out this [SSH Keys Cheat Sheet](/servers-and-git/ssh-keys-cheat-sheet.md).




## Using administrative privileges with sudo
You're now logged in as your new user, and this new user has administrative privileges.

However, you'll notice that if you try to do some action that requires admin privileges, you won't be able to.

For example, try to run this command to view `auth.log`:
```bash
$ cat /var/log/auth.log
```

You should see this message:
```bash
cat: /var/log/auth.log: Permission denied
```

This doesn't seem to make sense&mdash; didn't we just give our new user administrative privileges in the steps above?

We did! *However*, in order to utilize these privileges, we need to prefix commands with `sudo`.

> sudo (/ˈsuːduː/ or /ˈsuːdoʊ/) is a program for Unix-like computer operating systems that allows users to run programs with the security privileges of another user, by default the superuser. The name is a contraction of "do as su" where "su" is an abbreviation for "super user." -[ref](https://en.wikipedia.org/wiki/Sudo)

Moving forward, if you ever try a command and are told you don't have permissions, try the command again but prefix it with `sudo`.


## Change ownership of /var/www/html
If you try to edit files in your `/var/www/html` as your new user, you'll run into permission issues because that directory is owned by `root`. You can get around permission issues using the `sudo` command, as described above, but to make things easier, you can instead change the ownership of that directory to belong to your new user, with the following command.

Replace `susanbuck` with your username.

```bash
$ sudo chown -R susanbuck /var/www/html
```

Note: The `-R` flag is making this command recursive, so it will change the ownership for only for `/var/www/html` but everything inside of it.


## Disable root access
Now that you've confirmed you can SSH in as your new user, it's safe to disable `root` from SSH'ing into the server.

This is done via the config file, `/etc/ssh/sshd_config`.

Open `sshd_config` in nano with admin privileges (i.e. prefix with `sudo`):

```
$ sudo nano /etc/ssh/sshd_config
```

Once the file is opened, look for the line `PermitRootLogin yes` and toggle `yes` to `no`.

When done, save and exit (`ctrl` + `x`, then `y`, then *Enter*).

To make this change take effect, run the following command to restart your SSH services:

```bash
$ sudo service ssh restart
```

Note how that command was again prefixed with `sudo` since restarting SSH is something only an administrator can do.


## Confirm root user no longer has SSH access
Let's just confirm the above changes worked and the `root` user can no longer SSH into your Droplet.

In a *new* Terminal/Cmder window, try to SSH in as root:

```
$ ssh root@your-server-ip-address
```

You'll note that it will now continually ask for a password, instead of just letting you in as it previously did with your SSH keys set up. Even if you had the password, it would still not let you in.

You might look at this whole procedure and think we're chasing our tails. We prevented the `root` user from logging in because it's dangerous because `root` has administrative privileges.

*But*, we also created a *new* user that also had administrative privileges.

Isn't this just as bad?

It's not, and the reason is because hackers target `root`. They know many, many servers start with a default admin login with the username `root`, and not all server admins will go to the trouble to disable `root`. Because of this, they target their attacks on `root` since it provides them the greatest payoff.

By using a non-default username, you're greatly decreasing the chances a hacker will brute force enter your server.


## Ban failed login attempts
There's a file on your server, `/var/log/auth.log`, which logs authorization requests on your server.

Take a look at its contents:

```bash
$ sudo cat /var/log/auth.log
```

If you look at this file that's been running on a server for even a short time, you'd be amazed by how many outside login attempts are being thrown at your server by malicious hackers you don't know.

You'll likely see lots of login attempts for `root`, and other random user names as well. If you look up the IP address for these login attempts, you'll also see they're coming from all over the world.

By disabling `root` access and using SSH keys, we've reduced the chances these malicious login attempts will work, however, we can take it one step further by banning the IP addresses of machines that have repeated, failed, login attempts.

This is done using a software module called *Fail2Ban*. DigitalOcean has a [full write up on how to use Fail2Ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04), but below are the express instructions.

Tell apt-get to get the latest updates:
```bash
$ sudo apt-get update
```

Install fail2ban:
```bash
$ sudo apt-get install fail2ban
```

Make a copy of the default configs so you can make any needed updates:
```bash
$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
````

Restart fail2ban:
```bash
$ sudo service fail2ban restart
```

Note that with fail2ban implemented, you do stand the chance of accidentally banning yourself from your own server if you have too many failed login attempts.

The default threshold for getting banned is 6 failed login attempts.

If that happens, you will not be able to login from your banned IP address for the default time of 600 seconds (10 minutes).

Note that these default settings can all be adjusted in your `/etc/fail2ban/jail.local` config file. In that file, you can also &ldquo;whitelist&rdquo; your IP address so it will not get banned. If your network provider uses dynamic IPs, however, this change will not be permanent.

## Take a Snapshot of your Current Configuration
You've now put a fair amount of work in to configuring your Droplet. Given that, you should take advantage of [DigitalOcean's *Snapshot* feature](https://github.com/susanBuck/dwa15-fall2017/blob/master/01_Servers_and_Git/999_Extras/02_DigitalOcean_Backups.md).


## Tips/Notes


### whoami
The `whoami` command can be used now (or anytime) to tell you who you're logged in as. This can be useful if you're switching between root and your new user


### passwd
To update your user password, use the `passwd` command.


### What users exist?
To see what users exist on your server, run `cat /etc/passwd`

Note that in addition to the new user you created above, and `root`, there are many other default users on your server. These users do not have full administrator privileges like you and `root` do.


### Disabling password logins
As an extra level of security, you can completely disable the ability for users to SSH into your server with a password, requiring all logins to have a SSH key. This will eliminate the possibility of a hacker entering your server via a password guessing brute force attack.

We don't suggest this approach in the above steps, because in a class environment, it can be useful to have password logins available (for example, if you need to give a TA or instructor access to your server).

In a real-world environment, however, it's a good approach, so below are the steps to make that happen:

Open `sshd_config`:
```bash
$ sudo nano /etc/ssh/sshd_config
```

Find this line:
```
#PasswordAuthentication yes
```

Change it to this:
```bash
PasswordAuthentication no
```
Save and exit.

Restart SSH:
```
sudo service ssh restart
```


### Locked yourself out?
Once you've implemented the above security steps, it's possible you may accidentally lock yourself out of your own account. For example, if you trip fail2ban with too many failed login attempts, or you accidentally delete your private key.

If this happens, you can still login to your Droplet using DigitalOcean's web-based Console Access to fix whatever situation caused you to become locked out.


## Reference:
+ [How To Add and Delete Users on an Ubuntu 14.04 VPS](https://www.digitalocean.com/community/tutorials/how-to-add-and-delete-users-on-an-ubuntu-14-04-vps)
+ [Initial Server Setup with Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04)
