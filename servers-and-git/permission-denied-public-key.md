# `Permission denied (publickey)` when SSH'ing into DigitalOcean server

If when SSH'ing into your server you get the following error...

```
Permission denied (publickey)
```

...it means there's a mismatch between the private key on your machine and the public key on your server. Possible reasons for this:

1. When creating your Droplet, you did not check off that your SSH key should be added.
2. You created a new Droplet and *then* you added a new SSH key your DigitalOcean settings. Keys you save in settings are only added to *new* droplets.
3. There was some mistake in the copying/pasting of keys.

If you've just created the Droplet, the quickest way to resolve this problem is to start over: destroy the Droplet and create a new one. Before you do this, make sure you have the SSH key saved in your DigitalOcean settings, and make sure that key is chosen when you create the new Droplet.

If you've had the Droplet for a while, you obviously don't want to start over, so you'll need to run through the following instructions.


## Step 1) Login to the server via the DigitalOcean console
To fix your SSH key misconnection, you need access to the server so that you can correct the keys.

But how do you get access to the server if it won't let you SSH in? The answer is to __enable password authentication__ via DigitalOcean's __web console__ which provides a direct connection to your server.

To do this, find your droplet in DigitalOcean, and under the *Access* section choose *Reset Root Password*.

This will email you a root password.

Next, also from within *Access* in DigitalOcean, click *Launch Console* (this will bring up the web console)

When it asks for your login name, type __root__.

When it asks for your password, type in the password that was in the email. (In my experience you have to type the password in, you can't copy and paste it.)

It will ask you to change the password. Choose a new password.

It will ask you to type in the existing password again.

You should now be logged in, with a new password set. Make note of this password; you'll need it later.


## Step 2) Enable password logins
Still in the web console, run this command to edit your `sshd` config file:

```bash
sudo nano /etc/ssh/sshd_config
```

Once again, you have to type this in; copy/paste won't work.

Using the down arrow, scroll through this file looking for `PasswordAuthentication`. The value should be set to `no` and you want to change it to `yes`

```
PasswordAuthentication yes
```

`ctrl` + `x` to exit nano; you'll be prompted to save your changes.

Next, to make these changes take effect, run this command to restart the SSH service:
```
sudo service ssh reload
```


## Step 3) Confirm password log in from your computer
Turning back now to your local machine, try to SSH in again...

```
ssh root@your.digital.ocean.ip.address
```

It should now ask for your password instead of saying `Permission denied (publickey)`.

Remember it's the password you changed to, not the one that was originally emailed to you.

After entering your password you should hopefully be logged in, confirming you can get in via a password.

Run `exit` to disconnect from your server. We want to go back to your local machine to fix the SSH keys.


## Step 4) Fix SSH keys
On your local machine, run one of the following commands, replacing `your.digital.ocean.ip.address`. (This command assumes your public key is named `dwa.pub`; if it's something else, make that edit as well.)

Mac:
```
cat ~/.ssh/dwa.pub | ssh root@your.digital.ocean.ip.address "cat >> ~/.ssh/authorized_keys"
```

Windows:
```
cat %homepath%\.ssh\dwa.pub | ssh root@your.digital.ocean.ip.address "cat >> ~/.ssh/authorized_keys"
```

This will take a copy of your local public key (`~/.ssh/dwa.pub`) and put it in your `authorized_keys` file on the server.

When you run this command, it will ask for your server password, and after you type it in and hit enter you won't get any confirmation message, but it should have got the job done.

Try it out... ssh in again:

```
ssh root@your.digital.ocean.ip.address
```

If all went well, you should immediately be logged in, without any password required.

**Tip: If at any point you want to see what public keys have been added to your server, view the contents of the abovementioned `~/.ssh/authorized_keys` file.**

## Step 5) Cleanup
Now that you can SSH in from your local machine again, you  may choose to undo what you did in Step 2 above, disabling password login. It's a more secure option, but isn't necessary.
