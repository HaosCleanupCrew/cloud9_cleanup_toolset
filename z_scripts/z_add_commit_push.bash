#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# WOOT WOOT!

function init() {
    local commit_message="Scripted Commit!"; 
    add_all;
    commit_staged;
    push_to_remote;
}

function add_all() {
    git add --all;
}

function commit_staged() {
    git commit -m "$commit_message";
}

function push_to_remote() {
    git push --all;
}

init
