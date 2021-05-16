#!/bin/bash
set -x
uid=
gid=
while getopts ":i:g:" opt; do
    case ${opt} in
        i )
            uid=$OPTARG
            ;;
        g )
            gid=$OPTARG
            ;;

        \? )
            echo "Invalid option: $OPTARG" 1>&2
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            ;;
    esac
done
shift $((OPTIND -1))
if [ ! -z "${uid}" ]; then
    echo "Remapping uid ${uid} to autotest-admin user"
    usermod -u $uid autotest-admin
    groupmod -g $gid autotest-admin
    exec su - autotest-admin $@
fi
exec $@
