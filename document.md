How to run:

1. clone repo to \~/
2. go inside the directory
3. run "./compile.sh"
4. run "./deploy.sh"
5. run "./test.sh"
6. run "./setup-httpd.sh"
7. run "./httptest.sh"





Unix Task 2

Commit number 1:
Spent a lot of time thinking that we weren't allowed to use package managers at all for this task, until I figured out that we cannot use the package manager to install BusyBox, but we can use it to install things like make, gcc or bzip2 (which i did install).
Had a problem with "invalid use of undefined type ‘struct tc\_cbq\_wrropt’" which crashed the building of BusyBox, the issue was that the kernel config options required for this feature were not enabled in BusyBox config.

Commit number 2:
Added a complete deploy.sh; had a problem with permissions, since a regular user cannot write to /bin, so I had to add an additional check that checks if a regular user ran ./deploy.sh, if true then runs it with sudo permissions.

Commit number 3:
Added test.sh; problems: couldn't figure out how to test bb-\[ and bb-\[\[, for simple commands like ls, cat, echo and so on I added normal tests but for more complex ones like reboot, httpd, vi or such added a simple --help check, which proves that the applet can start, BB internal routing is working and executable is valid.

Commit number 4:
Added testhttp.sh and setup-httpd.sh; before running testhttp.sh, setup-httpd.sh must be ran; setup-httpd.sh automates service enable/start, the creation of web directory, html page, BB httpd config, systemd service; only after these are created testhttp.sh must be ran.

