#! /bin/sh
#
# 17.nov.21	ykim
# 27.apr.22	ykim
# - Add case for when called by (or w/in) Jamf where it calls with the following arguments:
#	arg1 = mount point
# 	arg2 = computername
#	arg3 = username
# 5.may.22	ykim - Adjusted to handle Mac Minis
# 7.may.22	ykim
# - If Jamf passes null username, set it using dscl
# - If HostName is updated then print the previous values
# 11.may.22	ykim - Rename "MacBookAir" as "MBA"
# 12.may.22	ykim - Shorten Hostname & LocalHostName to mask usernames
# 2.sep.22	ykim - Show last 4 chars of the S/N in the Computer Name
#

print_current_values()
{
	echo "# Current values at $SAVETIME"
	echo "# TTY VALUE: $(tty)"
	echo "# ARGS PASSED: "$ARGS_PASSED
	echo "HostName: $(scutil --get HostName)"
	echo "LocalHostName: $(scutil --get LocalHostName)"
	echo "ComputerName: $(scutil --get ComputerName)"
}

############
TESTONLY=false
case $1 in
-h|--h)
	echo "Usage: $(basename $0) [-h -get -testonly]"
	exit
	;;
-get|--get)
	print_current_values
	exit
	;;
-test*|--test*)
	TESTONLY=true
	shift
	;;
esac

case $1 in
"")
	read -p "Enter new hostname: " HOST_NAME
	;;
*)
	HOST_NAME="$*"
	;;
esac

ARGS_PASSED=$(for i in "$@"; do echo "\"$i\""; done)

#   ComputerName   The user-friendly name for the system. <<< Picked up by Jamf Pro
#   LocalHostName  The local (Bonjour) host name.
#   HostName       The name associated with hostname(1) and gethostname(3).

case $TESTONLY in
true)
	echo "# Displaying-only the new values:"
	echo "HostName => $HOST_NAME"
	echo "LocalHostName => $HOST_NAME"
	echo "ComputerName => $HOST_NAME"
	echo "# Nothing has been modified."
	exit
	;;
esac

sudo scutil --set HostName "$HOST_NAME"
sudo scutil --set LocalHostName "$HOST_NAME"
sudo scutil --set ComputerName "$HOST_NAME"

echo "%% NEW VALUES:"
print_current_values
