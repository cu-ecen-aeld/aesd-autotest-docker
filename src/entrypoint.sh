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
workdir=$(pwd)
if [ ! -z "${uid}" ]; then
    echo "Remapping uid ${uid} to autotest-admin user"
    usermod -u $uid autotest-admin
    groupmod -g $gid autotest-admin
    # Run as the autotest-admin with newly mapped user and group
    # permissions.  We won't return from this step
    exec su --login autotest-admin /bin/bash -c "cd ${workdir} && $@"
fi
# If we don't specify a user and group to map to, just run as root
exec su --login root /bin/bash -c "cd ${workdir} && $@"
