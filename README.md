# BusyBox from Scratch

This project builds a static BusyBox binary from source, deploys its applets as standalone wrapper scripts under `/bin/`, tests the applets, and sets up a BusyBox HTTP server as a systemd service. The goal is to create a minimal BusyBox environment without using the distribution-provided package.

## Features

* Downloads BusyBox source code (version 1.36.1)
* Installs build dependencies (`build-essential`, `bzip2`, `make`) if missing
* Configures BusyBox using `defconfig`

  * Disables `CONFIG_TC` to avoid build issues
  * Enables static linking
* Compiles a fully static BusyBox binary
* Deploys each applet as a wrapper script:

  * `/bin/bb-<applet>` calls the main BusyBox binary
* Tests core applets:

  * `ls`, `cat`, `cp`, `mv`, `rm`, `mkdir`, `rmdir`, `touch`
  * `grep`, `head`, `tail`, `pwd`, `date`, `uname`, `whoami`
  * `true`, `false`, `sync`
* Uses `--help` fallback for unsupported or unsafe applets
* Configures a BusyBox HTTP server on port 80
* Provides a systemd service for automatic startup

## Requirements

* Debian-based Linux system (tested on Debian 13)
* Root privileges for installation and service setup
* Internet access for downloading sources and dependencies

## Building from Source

### 1. Clone and enter project directory

```bash
git clone https://github.com/nataskasparaitis/unix-busybox-from-scratch.git
cd unix-busy-box-from-scratch
```

### 2. Run build script

```bash
./compile.sh
```

The script will:

* Check for required tools (`gcc`, `bzip2`, `make`)
* Install missing dependencies via `apt`
* Download BusyBox source if needed
* Extract archive
* Run `make defconfig`
* Disable `CONFIG_TC`
* Enable static build (`CONFIG_STATIC`)
* Compile using all CPU cores

Output binary location:

```text
/opt/task2/src/busybox-1.36.1/busybox
```

## Deployment

### Run deployment script

```bash
./deploy.sh
```

The script:

* Ensures root privileges (uses `sudo` if needed)
* Iterates through all BusyBox applets
* Creates wrapper scripts in `/bin`:

  * `bb-<applet>`
* Makes all scripts executable

After deployment, commands become available:

```text
bb-ls
bb-cat
bb-grep
```

## Testing

### Run test suite

```bash
./test.sh
```

The test script:

* Creates temporary test directory
* Executes safe applets with sample inputs
* Verifies exit codes (0 = success)
* Uses `--help` for destructive or interactive applets
* Skips shell-special applets like `[` and `[[`

## HTTP Server Setup

### Deploy BusyBox HTTP server

```bash
./setup-httpd.sh
```

This script:

* Creates web root at `/var/www/html`
* Writes default page:

  * `I am alive naka1314`
* Creates config file:

  * `/etc/bb-httpd.conf`
* Creates systemd service:

  * `/etc/systemd/system/bb-httpd.service`
* Enables and starts the service

### Test server

```bash
./httptest.sh
```

Expected output:

```text
I am alive naka1314
```

## Project Structure

| File             | Description                         |
| ---------------- | ----------------------------------- |
| `compile.sh`     | Downloads and builds BusyBox        |
| `deploy.sh`      | Creates `/bin/bb-*` wrapper scripts |
| `test.sh`        | Tests deployed applets              |
| `setup-httpd.sh` | Configures BusyBox HTTP server      |
| `httptest.sh`    | Sends test request to HTTP server   |
| `document.md`    | Developer notes and history         |

## Cleanup

### Remove applets

```bash
rm -f /bin/bb-*
```

### Stop HTTP service

```bash
sudo systemctl stop bb-httpd
sudo systemctl disable bb-httpd
sudo rm /etc/systemd/system/bb-httpd.service
sudo systemctl daemon-reload
```

### Remove build directory

```bash
rm -rf /opt/task2/src
```

## Notes

* Wrapper prefix `bb-` avoids conflicts with system binaries
* HTTP server runs on port 80 and requires root privileges
* Build path is fixed at `/opt/task2/src` and can be changed in `compile.sh`
