# Watchdog

This AppleScript checks remote files. For example, you need
an always-fresh copy of some remote file and to be notified if there are
any changes. The script checks your files every 5 hours (by default) and
sends notifications via Mail.app.

## Installation

```
$ cp watchdog.scpt ~/Library/Scripts/
$ cp watchdog.plist ~/Library/LaunchAgents/

$ vim ~/Library/Scripts/watchdog.scpt
$ vim ~/Library/LaunchAgents/watchdog.plist
```

Notice that you should modify files to make them work (you can see it above as `vim` calls).

* `watchdog.scpt` — folders, filenames, links and message recipients should be provided, check out `property` values and the `checkFiles` section.
* `watchdog.plist` — a path to the script requires your username (`echo $USER`) at least, check out the `ProgramArguments` section.

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
