# Watchdog

This script checks remote files. For example, you need
an always-fresh copy of some remote file and to be notified if there are
any changes. The script checks your files every 6 hours (by default) and
sends notifications via Mail.app.

## Preconditions

OS X Yosemite at least.

## Installation

1. Copy files.

  ```
  $ cp watchdog.js ~/Library/Scripts/
  $ cp watchdog.plist ~/Library/LaunchAgents/
  ```

2. Set directories, filenames, links and message recipients.

  ```
  $ vim ~/Library/Scripts/watchdog.scpt
  ```

## Usage

The script should work automagically after you log in.
You can run the command below to make the script work without relogin as well.

```
$ launchctl load ~/Library/LaunchAgents/watchdog.plist
```

Plus you can check how `launchd` sees it.

```
$ launchctl list | grep watchdog
```
