#!/bin/bash

# global variables, note the convention in this code is to have globals
# defined here be in all caps

# to be sourced
SSH_SOCKET=/tmp/dacb-hyak-socket

RAW_DATA_ROOT=/dacb/globus

LOCAL_ROOT=/dacb/meta4

REMOTE_USER=dacb
REMOTE_HOST=hyak
REMOTE_ROOT=/gscratch/lidstrom/meta4

SAMPLE_INFO=analysis/sample_info.xls
# gather all of the sample names.  Skips over 1st line, which is the column name.
SAMPLES=`awk -F'\t' '{ if (line > 0) print $1; ++line; }' $LOCAL_ROOT/$SAMPLE_INFO`
