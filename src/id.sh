#!/bin/sh
# Managing all crev id sub commands
source ./src/config.sh

function current {
    if [ ! -e $IDENTITY_FILE ]; then
        echo "[!] identity file not found. Creating a new one"
        config_create_identity_file
    fi
    ID=`cat $IDENTITY_FILE | cut -f1`
    URL=`cat $IDENTITY_FILE | cut -f2`

    if [ $URL == "none" ]; then
        URL="<no proof repository set>"
    fi
    return 0
}

if [ $# -eq 0 ]; then
    echo "usage: id.sh [ current | new | set-url ]"
    exit 0
fi

case "$1" in
    current)
        current
        echo "$ID $URL"
        ;;

    set-url)
        if [ $# -ne 2 ]; then
            echo "usage: id.sh set-utl 'proof repository url'"
            exit -2
        fi

        regex='(https?|ftp|file|ssh)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
        PROOF_URL=$2

        if [[ ! $PROOF_URL =~ $regex ]]
        then
            echo "invalid url: $PROOF_URL"
            echo "usage: id.sh new --url proof repository url"
            exit -4
        fi

        config_create_identity_file $PROOF_URL
        ;;
    new)
        if [ $# -ne 3 ]; then
            echo "usage: id.sh new --url 'proof repository url'"
            exit -2
        fi

        if [[ "$2" != "--url"  &&  "$2" != "-u" ]]; then
            echo "usage: id.sh new --url proof repository url"
            exit -3
        fi
        regex='(https?|ftp|file|ssh)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
        PROOF_URL=$3

        if [[ ! $PROOF_URL =~ $regex ]]
        then
            echo "invalid url: $PROOF_URL"
            echo "usage: id.sh new --url proof repository url"
            exit -4
        fi

        config_create_identity_file $PROOF_URL
        ;;
    *)
        echo "Invalid option"
        exit -1
        ;;
esac
