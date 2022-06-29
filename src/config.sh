#!/bin/bash
#
# Implementing crev config
#
CONFIG_ROOT="$HOME/.local/share/crev/"
PROOF_ROOT=$CONFIG_ROOT"proofs/"

IDENTITY_FILE="$CONFIG_ROOT/.identity"
IDENTITY_KEYRING="$CONFIG_ROOT/.crev.keyring"

GPG=`which gpg`
GPG_FLAGS="--no-default-keyring --keyring $IDENTITY_KEYRING"

function config_create_root_dir {
    mkdir -p $CONFIG_ROOT
}

function config_create_proof_dir {
    mkdir -p $PROOF_ROOT
}

function config_create_keypair {
    if [ ! -e $IDENTITY_KEYRING ]; then
        echo "[!] no crev identity keyring found. Creating one."
        $GPG $GPG_FLAGS --full-generate
    fi
}

function config_create_identity_file {
    if [ ! -e $IDENTITY_KEYRING ]; then
        echo "[!] keyring not found. Creating your first pair"
        create_keypair
    fi

    # There is a problem here if there are more than one key pair in the
    # keyring. However this is a small poc

    ID=`$GPG $GPG_FLAGS --list-secret-keys --with-colons | awk -F: '$1 == "sec" {print $5}'`
    if [ -z $1 ]; then
        echo -e "$ID\tnone" > $IDENTITY_FILE
    else
        echo -e "$ID\t$1" > $IDENTITY_FILE
    fi

}

if [ `basename $0` == "config.sh" ]; then
    # we are not sourced from another file...  setting up config
    config_create_root_dir
    config_create_proof_dir

    echo "[*] config ok."
fi
