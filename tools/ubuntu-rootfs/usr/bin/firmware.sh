#!/bin/bash

#Firmware loader for Kernel under 3.8
#Source: http://rt2x00.serialmonkey.com/phpBB-static/5/t-4594.html

FIRMWARE_DIRS="/lib/firmware /usr/local/lib/firmware"

err() {
echo "$@" >&2
if [ -x /bin/logger ]; then
/bin/logger -t "${0##*/}[$$]" "$@"
fi
}

if [ ! -e /sys$DEVPATH/loading ]; then
err "udev firmware loader misses sysfs directory"
exit 1
fi

for DIR in $FIRMWARE_DIRS; do
[ -e "$DIR/$FIRMWARE" ] || continue
echo 1 > /sys$DEVPATH/loading
cat "$DIR/$FIRMWARE" > /sys$DEVPATH/data
echo 0 > /sys$DEVPATH/loading
exit 0
done

echo -1 > /sys$DEVPATH/loading
err "Cannot find firmware file '$FIRMWARE'"
exit 1
