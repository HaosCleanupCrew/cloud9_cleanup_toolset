#!/bin/bash

# The 'set -e' option instructs bash to immediately exit if any command [1] has a non-zero exit status.
# The 'set -u' affects variables. When set, a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error, and causes the program to immediately exit.
# The 'set -o pipefail' option prevents errors in a pipeline from being masked.

set -euo pipefail

# The IFS variable - which stands for Internal Field Separator - controls what Bash calls word splitting.

IFS=$'\n\t'

# Sauce : http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Variables used in script.
script_version_number="0.0001";
cloud_nine_user_name=$C9_FULLNAME

function init() {
    say_hello;
    set_c9_user_name;
    echo_variables;
}

function say_hello() {
    clear;
    echo "";
    echo "Haos Cleanup C9 Script.";
    echo "";
    echo "Version : $script_version_number!";
    echo "";
    echo "This script :";
    echo "   * Prompts for a Cloud9 user name.";
    echo "   * ...";
    echo "";
    prompt_to_continue;
}

function set_c9_user_name() {
    clear;
    echo;    # move to a new line
    read -p "Enter Cloud9 User Name [$cloud_nine_user_name] : " user_input;
    if [ -z "${user_input// }" ]
    then
        printf "\nDefault chosen. ($cloud_nine_user_name)\n";
    else
        cloud_nine_user_name=$user_input;
    fi
}

function echo_variables() {
    printf "\n";
    printf "cloud_nine_user_name : $cloud_nine_user_name\n";
    prompt_to_continue;
}

function prompt_to_continue() {
    echo; # Move to a new line.
    read -p "Press any key to continue ('q' to exit.) : " -n 1 -r
    echo; # Move to a new line.
    
    clear;
    
    # Check if input called for exit.
    if [[ $REPLY =~ ^[Qq]$ ]]
    then
        exit;
    fi
}

init
