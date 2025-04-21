#!/bin/sh
#
# Support script to aid in the use of the "command" attribute of the compose
# configuration file.
#
#
# NOTE(JEFF): root privileges are disabled until a password is set at build 
# time. We run this service entirely as an unprivileged user account called 
# "code" that is a part of the "src" group.
#

#USE_SU=1

#shellcheck disable=SC2209
cmd=exec
for i; do
  cmd="$cmd '$i'"
done


if [ -n "$(command -v su)" ] && [ -n "$USE_SU" ]; then
  SU_BIN="$(command -v su)"
fi

# usage run.sh <COMMAND>
#
# ...where COMMAND is the value from the command attribute.
if [ -n "$SU_BIN" ] && [ -n "$USE_SU" ]; then
  [ -n "$DEBUG" ] && echo "$SU_BIN" -s /bin/sh -c "$cmd" code
  [ -z "$DEBUG" ] && "$SU_BIN" -s /bin/sh -c "$cmd" code
else # su is not available
  [ -n "$DEBUG" ] && echo /bin/sh -c "$cmd" code
  [ -z "$DEBUG" ] && /bin/sh -c "$cmd" code
fi

fg

