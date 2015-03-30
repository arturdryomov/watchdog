UID = $(shell id -u $(USER))

PACKAGE = "com.github.ming13.watchdog.plist"

PATH_PLIST = $(HOME)/Library/LaunchAgents/$(PACKAGE).plist
PATH_SCRIPT = $(HOME)/Library/Scripts/watchdog.js


install:
	@cp watchdog.js $(PATH_SCRIPT)
	@cp watchdog.plist $(PATH_PLIST)

clean:
	@rm -f $(PATH_SCRIPT)
	@rm -f $(PATH_PLIST)

configuration:
	@vim $(PATH_SCRIPT)

start:
	@launchctl bootstrap gui/$(UID) $(PATH_PLIST)
	@launchctl enable gui/$(UID)/$(PACKAGE)
	@launchctl kickstart -k gui/$(UID)/$(PACKAGE)

finish:
	@launchctl kill KILL gui/$(UID)/$(PACKAGE)

status:
	@launchctl print gui/$(UID)/$(PACKAGE)
