#!/bin/sh
# Managing all crev id sub commands
source ./src/config.sh

function current {
    if [ ! -e $IDENTITY_FILE ]; then
        echo "[!] identity file not found. Creating a new one"
        config_create_identity_file
    fi
    MY_ID=`cat $IDENTITY_FILE | cut -f1`
    MY_URL=`cat $IDENTITY_FILE | cut -f2`

    if [ $MY_URL == "none" ]; then
        MY_URL="<no proof repository set>"
    fi
    return 0
}

if [ $# -eq 0 ]; then
    echo "usage: id.sh [ current | new | set-url | trust | trusted ]"
    exit 0
fi

case "$1" in
    current)
        current
        echo "$MY_ID $MY_URL"
        ;;

    trusted)
        # show user id trust network
        # This command will create also a signed file contaning the whole
        # trusted network for a given user, as described in
        # https://github.com/crev-dev/cargo-crev/blob/master/cargo-crev/src/doc/trust.md
        if [ ! -d $TRUST_ROOT ]; then
            echo "[!] your config is missing $TRUST_ROOT directory. Please create it with config command"
            exit -2
        fi


        TRUSTED_CONTENT="version: -1"$'\n'
        TRUSTED_CONTENT+="date: \"`date -Ins | tr "," "."`\""$'\n'
        TRUSTED_CONTENT+="from:"$'\n'
        TRUSTED_CONTENT+=$'\t'"id-type: crev"$'\n'
        current
        TRUSTED_CONTENT+=$'\t'"id: $MY_ID"$'\n'
        TRUSTED_CONTENT+=$'\t'"url: $MY_URL"$'\n'
        TRUSTED_CONTENT+="ids:"$'\n'

        FILES="$TRUST_ROOT/*"
        for f in $FILES
        do
            if [ -e "$f" ]; then
                CHECK=`$GPG $GPG_FLAGS --verify $f > /dev/null 2> /dev/null`
                if [ $? -eq 0 ]; then
                    ID=`basename $f`
                    TRUST=`cat $f | grep "trust:" | cut -f 2 -d ":" | tr -d " "`
                    URL=`cat $f | grep "url:" | cut -f2- -d ":" | tr -d " "`
                    TRUSTED_CONTENT+=$'\t'"- id:"$'\n'
                    TRUSTED_CONTENT+=$'\t\t'"id: $ID"$'\n'
                    TRUSTED_CONTENT+=$'\t\t'"url: $URL"$'\n'
                    TRUSTED_CONTENT+=$'\t\t'"trust: $TRUST"$'\n'

                    echo -e "$ID\t$TRUST\t$URL"
                else
                    echo "[!] the trust file is corrupted. I will remove it"
                    rm $f
                fi
            fi
        done
        echo "$TRUSTED_CONTENT" > "$TRUST_ROOT/$MY_ID.wot"
        $GPG $GPG_FLAGS --clearsign "$TRUST_ROOT/$MY_ID.wot"
        rm "$TRUST_ROOT/$MY_ID.wot"
        mv "$TRUST_ROOT/$MY_ID.wot.asc" "$TRUST_ROOT/$MY_ID.wot"

        exit 0


        ;;
    trust)

        if [ $# -ne 4 ]; then
            echo "usage: id.sh trust [low|medium|high] 'the crev id you want to trust' 'crev id proof url'"
            exit -2
        fi


        regex_id='[A-Za-z0-9]{16}'
        LEVEL=$2
        ID=$3
        URL=$4

        if [[ "$LEVEL" != "low" && "$LEVEL" != "medium" && "$LEVEL" != "high" ]]; then
            echo "[!] unknown level of trust"
            echo "usage: id.sh trust [low|medium|high] 'the crev id you want to trust'"
            exit -2
        fi

        if [[ $ID =~ regex_id ]]; then
            echo "[!] invalid id. It should be a 16 alphanumeric characters"
            exit -2
        fi

        regex_url='(https?|ftp|file|ssh)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

        if [[ ! $URL =~ $regex_url ]]
        then
            echo "invalid url: $URL"
            echo "usage: id.sh trust [low|medium|high] 'the crev id you want to trust' 'crev id proof url'"
            exit -4
        fi

        if [ -e "$TRUST_ROOT/$ID" ]; then
            CHECK=`$GPG $GPG_FLAGS --verify $TRUST_ROOT/$ID > /dev/null 2> /dev/null`
            if [ $? -eq 0 ]; then
                echo "[*] $ID is already trusted"
                exit 0
            else
                echo "[!] the trust file is corrupted. I will remove it"
                rm $TRUST_ROOT/$ID
                exit -3
            fi
        fi

        if [ ! -d $TRUST_ROOT ]; then
            echo "[!] your config is missing $TRUST_ROOT directory. Please create it with config command"
            exit -2
        fi

        echo "# Trust for $ID" > $TRUST_ROOT/$ID
        echo "trust: $LEVEL" >> $TRUST_ROOT/$ID
        echo "url: $URL" >> $TRUST_ROOT/$ID

        $GPG $GPG_FLAGS --clearsign $TRUST_ROOT/$ID
        rm $TRUST_ROOT/$ID
        mv $TRUST_ROOT/$ID.asc $TRUST_ROOT/$ID
        echo "[*] $ID trusted"


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
