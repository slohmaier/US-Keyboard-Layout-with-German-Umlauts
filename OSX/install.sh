#!/bin/sh

LAYOUTDIR="/Library/Keyboard Layouts"

if [ "`whoami`" != "root" ]; then
	echo "Restarting script as root..."
	sudo sh $0
else
	if [ ! -d "$LAYOUTDIR" ]; then
		mkdir -p "$LAYOUTDIR"
	fi
	echo cp \"US German Umlauts.keylayout\" \"$LAYOUTDIR/US German Umlauts.keylayout\"
	echo '[y/n] '
	read answer
	if [ "$answer" = "y" ]; then
		cp "US German Umlauts.keylayout" "$LAYOUTDIR/US German Umlauts.keylayout"
		echo Restart now.
	fi
fi