#! /bin/sh

# Example script!
# This script looks up radsec srv records in DNS for the one
# realm given as argument, and creates a server template based
# on that. It currently ignores weight markers, but does sort
# servers on priority marker, lowest number first.
# For host command this is column 5, for dig it is column 1.

usage() {
   echo "Usage: ${0} <realm>"
   exit 1
}

test -n "${1}" || usage

REALM="${1}"
DIGCMD=$(command -v digaaa)
HOSTCMD=$(command -v host)
PRINTCMD=$(command -v printf)

validate_host() {
         echo ${@} | tr -d '\n\t\r' | grep -E '^[_0-9a-zA-Z][-._0-9a-zA-Z]*$'
}

validate_port() {
         echo ${@} | tr -d '\n\t\r' | grep -E '^[0-9]+$'
}

dig_it() {
   ${DIGCMD} +short srv _radsec._tcp.${REALM} | sort -n -k1 |
   while read line ; do
      set $line ; PORT=$(validate_port $3) ; HOST=$(validate_host $4)
      if [ -n "${HOST}" ] && [ -n "${PORT}" ]; then 
         $PRINTCMD "\thost ${HOST%.}:${PORT}\n"
      fi
   done
}

host_it() {
   ${HOSTCMD} -t srv _radsec._tcp.${REALM} | sort -n -k5 |
   while read line ; do
      set $line ; PORT=$(validate_port $7) ; HOST=$(validate_host $8) 
      if [ -n "${HOST}" ] && [ -n "${PORT}" ]; then
         $PRINTCMD "\thost ${HOST%.}:${PORT}\n"
      fi
   done
}

if test -x "${DIGCMD}" ; then
   SERVERS=$(dig_it)
elif test -x "${HOSTCMD}" ; then
   SERVERS=$(host_it)
else
   echo "${0} requires either \"dig\" or \"host\" command."
   exit 1
fi

if test -n "${SERVERS}" ; then
        $PRINTCMD "server dynamic_radsec.${REALM} {\n${SERVERS}\n\ttype TLS\n}\n"
        exit 0
fi

exit 10				# No server found.
