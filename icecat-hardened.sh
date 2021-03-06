#!/bin/sh
# Slackware build script for icecat-hardened which make your icecat start
# under firejail and eqquiped with several privacy-enhanced add-ons:
# Noscript, ublock and User-Agent Switcher.

# Written by MDrights <mdrights@tutanota.de>
# With some code copy-pasted from the PKGBUILDs (iceweasel-hardened-
# preferences et al) in Parabola GNU/linux-libre.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version, with the following exception:
# the text of the GPL license may be omitted.

# This program is distributed in the hope that it will be useful, but
# without any warranty; without even the implied warranty of
# merchantability or fitness for a particular purpose. Compiling,
# interpreting, executing or merely reading the text of the program
# may result in lapses of consciousness and/or very being, up to and
# including the end of all existence and the Universe as we know it.
# See the GNU General Public License for more details.

# You may have received a copy of the GNU General Public License along
# with this program (most likely, a file named COPYING).  If not, see
# <http://www.gnu.org/licenses/>.

# NOTE: You don't need to run it as root.

##############################################
# Icecat-Hardened Jail and Cleaner Script #
##############################################
echo "Closing any other instances of Icecat to avoid crashes..."
pkill -x icecat
wait
# cp /usr/lib/iceweasel/browser/defaults/preferences/iceweasel-branding.js /usr/lib/iceweasel/browser/defaults/preferences/icecat-branding.js
# wait

# Copying...$ICVER is the version number of icecat; $INIDIR is the profile directory.
echo "Copying Hardened Prefs and Addons......"
ICVER=$(ls /var/log/packages/icecat* | awk -F"-" '{ print $2 }' | sed -n '1 p')
INIDIR=$(find $HOME/.mozilla/icecat -type d -name "*.default")

if [ "$INIDIR" = "" ]; then
	echo "It seems you haven't start icecat for the first time. Please start it and close it, then you can run icecat-hardened. :)"
	exit 1
elif [ ! -e "$INIDIR"/user.js ]
then
	cp /usr/lib64/icecat-${ICVER}/defaults/pref/user.js ${INIDIR}
	# It doesn't need to copy them. The addons works in the system-wide dir.
#	cp usr/lib64/icecat-${ICVER}/browser/extensions/jid1-MnnxcxisBPnSXQ-eff\@jetpack.xpi ${INIDIR}/extensions/
#	cp usr/lib64/icecat-${ICVER}/browser/extensions/langpack-zh-CN\@icecat.mozilla.org.xpi ${INIDIR}/extensions/
#	cp usr/lib64/icecat-${ICVER}/browser/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi ${INIDIR}/extensions/
#	cp usr/lib64/icecat-${ICVER}/browser/extensions/https-everywhere-eff\@eff.org.xpi ${INIDIR}/extensions/
fi

echo "Waking the Icecat..."

# Trap cleaner function for Icecat exit cleaning
#function finish {
# echo "Removing hardened preferences..."
# echo "" > /usr/lib/iceweasel/browser/defaults/preferences/icecat-branding.js
#    }

## Firejail icecat startup
## /usr/bin/firejail --profile=/etc/firejail/icecat.profile --noroot --nogroups --caps.drop=all --private-etc=nsswitch.conf,resolv.conf  --private-bin=bash,icecat --private-tmp --private-dev /usr/bin/icecat --private-window

/usr/bin/firejail --profile=/etc/firejail/icecat.profile /usr/bin/icecat 1>$HOME/.firejail-icecat.output 2>&1


## Exiting Icecat triggers the trap
#trap finish EXIT
