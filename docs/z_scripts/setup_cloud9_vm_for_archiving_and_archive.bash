#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function init(){
    local archive_repo_clone_url="";
    local archive_repo_dir_name="";
    
    set_script_vars;

    clone_archive_repo;
    
    archive_vm_into_archive_repo;
}

function set_script_vars(){
    archive_repo_clone_url="git@github.com:EntropyHaos/c9_vm_archives.git";
    archive_repo_dir_name="z_vm_archive_repo";
}

function archive_vm_into_archive_repo(){
    cd $GOPATH;
    bash $archive_repo_dir_name/z_scripts/archive_vm.bash;
}

function clone_archive_repo(){
    git clone $archive_repo_clone_url $archive_repo_dir_name;
}

init
