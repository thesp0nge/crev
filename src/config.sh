#!/bin/bash
#
# Implementing crev config
#
CONFIG_ROOT="$HOME/.local/share/crev/"
PROOF_ROOT=$CONFIG_ROOT"proofs/"

function create_config_root {
    mkdir -p $CONFIG_ROOT
}

function create_config_proof {
    mkdir -p $PROOF_ROOT
}

create_config_root
create_config_proof
