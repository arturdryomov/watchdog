UID = $(shell id -u $(USER))


install:
	@cp watchdog.js ${HOME}/Library/Scripts/.
	@cp watchdog.plist ${HOME}/Library/LaunchAgents/.

configuration:
	@vim $(HOME)/Library/Scripts/watchdog.js

start:
	@launchctl bootstrap gui/$(UID) $(HOME)/Library/Scripts/watchdog.js
	@launchctl kickstart gui/$(UID)/com.github.ming13.watchdog

finish:
	@launchctl kill KILL gui/$(UID)/com.github.ming13.watchdog

status:
	@launchctl print gui/$(UID)/com.github.ming13.watchdog
