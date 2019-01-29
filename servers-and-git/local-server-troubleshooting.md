# Local server troubleshooting

## Log files
If your MAMP or XAMPP Apache or MySQL server won't start, the first place you want to check for clues is your log files.

Here are the log file locations:

+ MAMP: Apache and MySQL logs are all found in `/Applications/MAMP/logs`
+ XAMPP:
    + Apache errors: `C:\xampp\apache\logs`
    + MySQL errors: `C:\xampp\mysql\data\mysql_error`
    + Alternatively, from the XAMPP Control Panel, there's a *logs* button next to each service.


## Port issues
The #1 cause of MAMP or XAMPP not being able to start Apache or MySQL is a conflicting port issue, that is, some other service on your computer is already using the port that Apache or MySQL is trying to use.

Ideally, we'd like to use Apache's default port `80` and MySQL's default port `3306`.


## Freeing ports on Windows
First, __restart your computer__. Some students have reported that after a fresh install of XAMPP, this step is needed.

The next easiest fix to try is close Skype if you have it open, then trying to start your server again. Skype on Windows is known for causing port conflicts with local servers.

If the above &ldquo;low hanging fruit&rdquo; steps don't work, download and open [CurrPorts](http://www.softpedia.com/get/Network-Tools/Network-Information/CurrPorts.shtml), a free program to easily see and terminate processes on Windows. There are other ways you can manage your ports on Windows, including via the Command Line or Task Manager, but I've found CurrPorts to be the most straightforward so it's worth the extra download.

__If you're having a port issue with MySQL:__
With CurrPorts running, look for processes named `mysqld.exe` (MySQL), right click them and choose *Kill Processes of Selected Ports*. Then right click again and choose *Close Selected TCP connections*.

__If you're having a port issue with Apache:__
Follow the same steps as above, but search for processes labeled `httpd.exe` (short for *HTTP daemon*; it's equivalent to Apache) and terminate them.

<img src='https://s3.amazonaws.com/making-the-internet/sysadmin-curr-ports@2x.png' style='max-width:729px; width:100%' alt='CurrPorts'>

You can also look under the __Local Port__ column to find processes that are using your default MySQL (`3306`) or Apache (`80`) port.

After you've identified and terminated the appropriate processes, return to XAMPP and attempt to restart your server.


## Freeing ports on a Mac
Load `Activity Monitor`, a program default to your Mac that gives lots of details about your system.

You can find this program by typing `Activity Monitor` into Spotlight (the little magnify glass on the top right of your screen).

__If you're having a port issue with MySQL:__
Under the `CPU` column, search for `mysql`. Look for processes labeled `mysql`, select them, and then click the X on the top left to terminate them.

<img src='https://s3.amazonaws.com/making-the-internet/sysadmin-mac-activity-monitor@2x.png' style='max-width:771px; width:100%' alt='Activity Monitor'>

__If you're having a port issue with Apache:__
Follow the same steps as above, but search for processes labeled `httpd` (short for HTTP daemon, it's equivalent to Apache) and terminate them.

After you've identified and terminated the appropriate processes, return to MAMP and attempt to restart your server.


## Using alternative ports
If you are unable to free up the 80/3306 ports, or you wish to reserve these ports for existing software on your machine, you can use alternative ports as a last-resort.

Common alternative ports in MAMP/XAMPP are 8888 for Apache and 8889 for MySQL.

If you use an alternative Apache port, you will have to append this port to your URLs, e.g. `http://localhost:8888`.


## Troubleshooting: Local server permissions issue - error 500  "Internal Server Error"
Run this command on the document root:

```bash
chmod -R g-w /path/to/document/root
```


