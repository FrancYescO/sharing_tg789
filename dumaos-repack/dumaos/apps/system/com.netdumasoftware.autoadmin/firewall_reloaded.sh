#!/bin/sh

# (C) 2016 NETDUMA Software <iainf@netduma.com>
#
# Script to reload DumaOS firewall. Beware! do not call fw_restart directly.
# Run this script instead to avoid synchronisation issues such as deadlocks.
#
# Worth mentioning deadlock issue. A deadlock can occur in the following
# rare circumstances:
# 1) fw3 acquires fw3.lock
# 2) other process long calls AA and tries to acquire fw3.lock
# 3) fw3 runs this script which tries to long_call AA
#
# Now this script is waiting for AA, and AA is waiting for this script 
# (indirectly through fw3). We solved this by running this script in 
# background and acquiring net-wall lock first.

# This wont cause a deadlock, this call will block
ubus list com.netdumasoftware.autoadmin &>/dev/null
if [ $? -eq 0 ];then
				(
								flock -x 200
								flock -x /var/run/fw3.lock -c "ubus call com.netdumasoftware.autoadmin fw_restart '{}' &>/dev/null"
				) 200>/var/run/nd-net-wall.lock &
else
        echo "DumaOS is down or not started properly"
fi
exit 0
