install:
	cp watchdog.js ${HOME}/Library/Scripts/.
	cp watchdog.plist ${HOME}/Library/LaunchAgents/.

configuration:
	vim ${HOME}/Library/Scripts/watchdog.js

kickstart:
	launchctl bootstrap gui/${UID} ${HOME}/Library/Scripts/watchdog.js
	launchctl kickstart gui/${UID}/com.github.ming13.watchdog

status:
	launchctl list | grep com.github.ming13.watchdog
	launchctl print gui/${UID}/com.github.ming13.watchdog
