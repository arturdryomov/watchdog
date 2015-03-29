UID = $(shell id -u $(USER))


install:
	@cp watchdog.js $(HOME)/Library/Scripts/watchdog.js
	@cp watchdog.plist $(HOME)/Library/LaunchAgents/com.github.ming13.watchdog.plist

clean:
	@rm -f $(HOME)/Library/Scripts/watchdog.js
	@rm -f $(HOME)/Library/LaunchAgents/com.github.ming13.watchdog.plist

configuration:
	@vim $(HOME)/Library/Scripts/watchdog.js

start:
	@launchctl bootstrap gui/$(UID) $(HOME)/Library/LaunchAgents/com.github.ming13.watchdog.plist
	@launchctl enable gui/$(UID)/com.github.ming13.watchdog
	@launchctl kickstart -k gui/$(UID)/com.github.ming13.watchdog

finish:
	@launchctl kill KILL gui/$(UID)/com.github.ming13.watchdog

status:
	@launchctl print gui/$(UID)/com.github.ming13.watchdog
