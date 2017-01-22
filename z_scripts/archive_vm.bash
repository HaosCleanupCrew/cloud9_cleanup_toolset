#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function init(){
    local vm_to_archive_name="";
    local vm_archive_temp_dir_name="";
    local vm_archive_temp_dir_name_and_path="";
    local directory_being_backed_up="";
    local name_of_vm_being_archive="";
    local archive_repo_dir_and_path="";

    local string_for_identifying_git_directories="";    

    local scripts_log_file_name="";
    local vm_being_archived_log_file_name="";
    local scripts_log_file_name_and_path="";
    local vm_being_archived_log_file_name_and_path="";

    set_script_vars;
    add_note_to_scripts_log_file >> $scripts_log_file_name_and_path;
    add_all_and_commit_in_archive_repo_pre_archiving;
    make_temp_archive_directory;
    initialize_log_for_vm_being_archived  > $vm_being_archived_log_file_name_and_path;
    
    update_git_if_it_is_not_capable_of_allowing_unrelated_histories;
    
    copy_files_to_be_backed_up_into_temp_directory >> $vm_being_archived_log_file_name_and_path;
    # ToDo : Add this output to log.
    deal_with_any_git_tracking_of_copied_files;
    move_into_vm_archive_folder >> $scripts_log_file_name_and_path;
    #prompt_to_continue_with_message_and_offer_to_quit "FINAL STEP!!";
    add_all_and_commit_in_archive_repo;
    update_docs_file_showing_vm_has_been_archived;
    remove_temp_archive_directory;
    push_archive_to_remote;
    
    delete_archive;
}

function delete_archive(){
    prompt_to_continue_with_message_and_offer_to_quit "* * * ARCHIVE WILL NOW BE DELETED FROM VM! * * *";
    cd $GOPATH;
    rm -rf $archive_repo_dir_name;
}

# Git version needs to be 2.9 or above
# per : http://stackoverflow.com/questions/37937984/git-refusing-to-merge-unrelated-histories

function update_git_if_it_is_not_capable_of_allowing_unrelated_histories(){

    local min_git_version_wanted;
    local git_version_found;
    
    min_git_version="git version 2.9.0";
    #git_version_found=$(echo $(git --version) | cut -f3 -d ' ');

    first_digit=$(echo $(echo $(git --version) | cut -f3 -d ' ') | cut -f1 -d '.');
    second_digit=$(echo $(echo $(git --version) | cut -f3 -d ' ') | cut -f2 -d '.');

    
    if [ "$first_digit" -ge "2" ] && [ "$second_digit" -ge "9" ]
    then
        printf "\n\n$(git --version) (Is 2.9 or greater.)\n\n\n";
    else
        printf "\n\n$(git --version)  (Needs to be updated!)\n\n\n";
        update_git_to_newest_version;
    fi
}

function update_git_to_newest_version(){

        printf "\n\nVersion of Git being updated.\n\n";
        sudo add-apt-repository ppa:git-core/ppa -y
        sudo apt-get update
        sudo apt-get install git -y
        git --version
}

function set_script_vars(){
    vm_to_archive_name="$C9_PROJECT";
    vm_archive_temp_dir_name="zz_archive_temp_dir";
    vm_archive_temp_dir_name_and_path="$(printf "$GOPATH/$vm_archive_temp_dir_name")";
    directory_being_backed_up="$PHPRC";
    name_of_vm_being_archive="$C9_PROJECT";
    archive_repo_dir_name="z_vm_archive_repo";

    string_for_identifying_git_directories=".git";

    scripts_log_file_name="archive_script_log_file.md";
    vm_being_archived_log_file_name="vm_archiving_log_file.md";
    scripts_log_file_name_and_path="$archive_repo_dir_name/logs/$scripts_log_file_name";
    vm_being_archived_log_file_name_and_path="$vm_archive_temp_dir_name_and_path/$vm_being_archived_log_file_name";
}

function push_archive_to_remote(){
    cd $GOPATH/$archive_repo_dir_name;
    cat << EOT >> $GOPATH/$scripts_log_file_name_and_path

***Called*** **push_archive_to_remote()**

**VM :** $C9_PROJECT
EOT
    git add --all;
    git commit -m 'Commit before pushing archived VM.'
    git push --all;
}

function update_docs_file_showing_vm_has_been_archived(){
    cd $GOPATH;
    local vm_name_archived="$C9_PROJECT";
    perl -pi -e "s/\/$vm_name_archived\", \"true\"/\/$vm_name_archived\", \"false\"/g" $GOPATH/z_vm_archive_repo/docs/js/add_clickable_urls_to_array.js;
}

function add_note_to_scripts_log_file(){
    printf "### Archive of $C9_PROJECT\n\n";
}

function add_all_and_commit_in_archive_repo_pre_archiving(){
    cd $GOPATH;
    cd $archive_repo_dir_name;

    cat << EOT >> $GOPATH/$scripts_log_file_name_and_path

***Called*** **add_all_and_commit_in_archive_repo_pre_archiving()**

**VM :** $C9_PROJECT
EOT
    
    git add --all;
    git commit -m 'Commit before running archive script.';
    cd $GOPATH;
}

function move_into_vm_archive_folder(){
    cd $GOPATH;
    mkdir -p TEMP_$vm_archive_temp_dir_name/VM_ARCHIVES;
    mv $vm_archive_temp_dir_name TEMP_$vm_archive_temp_dir_name/VM_ARCHIVES/;
    mv TEMP_$vm_archive_temp_dir_name/VM_ARCHIVES/$vm_archive_temp_dir_name TEMP_$vm_archive_temp_dir_name/VM_ARCHIVES/$C9_PROJECT;
    mv TEMP_$vm_archive_temp_dir_name/VM_ARCHIVES/$C9_PROJECT/.git TEMP_$vm_archive_temp_dir_name/.git
    mv TEMP_$vm_archive_temp_dir_name $vm_archive_temp_dir_name
    cd $vm_archive_temp_dir_name
    git add -u;
    #git add --all;
    git commit -m 'Commit pre-merge into VM archive.';
    #git add -u;
    git add --all;
    git commit -m 'Commit pre-merge into VM archive.';
    cd $GOPATH;
    printf "";
}

function add_all_and_commit_in_archive_repo(){
    #prompt_to_continue_with_message_and_offer_to_quit "IN : add_all_and_commit_in_archive_repo";
    cd $GOPATH;
    cd z_vm_archive_repo;
    #git add -u;
    git add --all;
    git commit -v -m 'Commit pre-merge of VM being archived.';
    #prompt_to_continue_with_message_and_offer_to_quit "git pull command about to be called...";
    
    # THIS COMMAND CREATES AN ERROR WITH GIT... SO EXIT ON ERROR IS DISABLED
    set +e;
    git pull $GOPATH/$vm_archive_temp_dir_name --allow-unrelated-histories --no-edit;
    
    git add --all;
    git commit -m 'FIX MERGE ISSUES BEING CAUSED BY SCRIPT!';
    set -e; # AND RE-ENABLED...
    # ToDo : FIX THIS PROBLEM!!
    
    cd $GOPATH;
}

function say_hello(){
    clear;
    printf "\nHello World!\n";
}

function initialize_log_for_vm_being_archived(){
    printf "# VM SCRIPTED ARCHIVE LOG!\n\n";
    printf "## *$name_of_vm_being_archive*\n\n";
}

function make_temp_archive_directory(){
    if [ -d "$vm_archive_temp_dir_name_and_path" ]
    then
      printf "\n* * * TEMP DIRECTORY EXISTS! * * *\n";
      remove_temp_archive_directory;
    fi    
    mkdir $vm_archive_temp_dir_name_and_path;
}

function copy_files_to_be_backed_up_into_temp_directory(){
    printf "***CALLED*** **: copy_files_to_be_backed_up_into_temp_directory**\n\n";
    printf "* directory_being_backed_up = %s\n" "$directory_being_backed_up";
    printf "* vm_archive_temp_dir_name_and_path = %s\n" "$vm_archive_temp_dir_name_and_path";
    printf "\n";

    printf "***OUTPUT*** **:**\n\n";
    printf "\`\`\`bash\n";
    rsync -av --progress $directory_being_backed_up/. $vm_archive_temp_dir_name_and_path --exclude $archive_repo_dir_name --exclude $vm_archive_temp_dir_name;
    printf "\`\`\`\n";
}

function deal_with_any_git_tracking_of_copied_files() {
    cd $vm_archive_temp_dir_name_and_path;
    check_for_nested_or_buried_git_directories;
    cd $GOPATH;
    merge_git_repositories_in_temp_directory;
}

function merge_git_repositories_in_temp_directory(){
    cd $vm_archive_temp_dir_name_and_path;
    
    local git_directories_to_merge;
    local git_repos_temp_directory_name;
    local git_repos_temp_directory_name_and_path;

    git_repos_temp_directory="temp_repos_directory";
    git_repos_temp_directory_name_and_path="./$git_repos_temp_directory"
    
    git_directories_to_merge="$(find . -maxdepth 2 -name $string_for_identifying_git_directories -type d -printf '%h\n' -prune)";
    
    mkdir $git_repos_temp_directory_name_and_path;
    for git_directory_to_merge in $git_directories_to_merge
    do
        mv $git_directory_to_merge ./$git_repos_temp_directory/
    done
    
    mv $git_repos_temp_directory $GOPATH/
    #mkdir temp_archive_directory
    
    git init;
    git add --all;
    git commit -m 'Commit of untracked files.';

    for git_directory_to_merge in $git_directories_to_merge
    do
        cd $GOPATH/$git_repos_temp_directory/$git_directory_to_merge
        local direc_name;
        repo_directory_name=${git_directory_to_merge##./};
        mkdir $GOPATH/$git_repos_temp_directory/temp_$repo_directory_name
        mv $GOPATH/$git_repos_temp_directory/$repo_directory_name $GOPATH/$git_repos_temp_directory/temp_$repo_directory_name
        mv $GOPATH/$git_repos_temp_directory/temp_$repo_directory_name $GOPATH/$git_repos_temp_directory/$repo_directory_name
        mv $GOPATH/$git_repos_temp_directory/$repo_directory_name/$repo_directory_name/.git $GOPATH/$git_repos_temp_directory/$repo_directory_name/
        cd $GOPATH/$git_repos_temp_directory/$repo_directory_name
        git add --all;
        git commit -m 'Commit before merging multiple repos.';
    done
    cd $GOPATH;
    
    for git_directory_to_merge in $git_directories_to_merge
    do
        repo_directory_name=${git_directory_to_merge##./};
        cd $vm_archive_temp_dir_name_and_path;
        git pull $GOPATH/$git_repos_temp_directory/$repo_directory_name --allow-unrelated-histories --no-edit;
    done

    cd $GOPATH;
    
    rm -rf $GOPATH/$git_repos_temp_directory/
}

function check_for_nested_or_buried_git_directories(){
    
    num_of_nested_or_burried_repos=0;
    local num_first_level_git_directories=0;
    
    list_of_all_git_directories="$(find  -name $string_for_identifying_git_directories -type d -printf '%h\n' -prune)"
    for directory in $list_of_all_git_directories
    do
        ((num_of_nested_or_burried_repos+=1))
    done

    list_of_first_level_git_directories="$(find . -maxdepth 2 -name $string_for_identifying_git_directories -type d -printf '%h\n' -prune)"
    for directory in $list_of_first_level_git_directories
    do
        ((num_first_level_git_directories+=1));
    done
    printf "\n";
    
    
    if [ "$num_of_nested_or_burried_repos" -ne "$num_first_level_git_directories" ]
    then
        printf "\n";
        printf "* * * NESTED OR BURRIED GIT REPOSITORIES FOUND!\n";
        printf "\n";
        printf "num_of_nested_or_burried_repos : %s\n" "$num_of_nested_or_burried_repos";
        printf "num_first_level_git_directories : %s\n" "$num_first_level_git_directories";
        remove_temp_archive_directory;
        exit;
    else
        printf "num_of_nested_or_burried_repos : %s\n" "$num_of_nested_or_burried_repos";
        printf "num_first_level_git_directories : %s\n" "$num_first_level_git_directories";
        printf "\n";
    fi
}

function count_and_display_num_of_git_directories_found(){
    cd $vm_archive_temp_dir_name_and_path;

    local git_directory_paths="";
    git_directory_paths=$(find . -name $string_for_identifying_git_directories -type d -prune);
    
    if [ -n git_directory_paths ]
    then

        local num_git_directories=0;
        
        for git_directory_path in $git_directory_paths
        do
            ((num_git_directories+=1));
            echo "$num_git_directories : $git_directory_path";
        done
    fi
    
}

function remove_temp_archive_directory(){
    printf "\n* * * Continue to Delete Temp Directory! * * *\n";
    #prompt_to_continue_with_offer_to_quit;
    rm -rf $vm_archive_temp_dir_name_and_path;
}

function prompt_to_continue_with_offer_to_quit(){
    echo; # Move to a new line.
    read -p "Press any key to continue ('q' to exit.) : " -n 1 -r
    echo; # Move to a new line.

    # Check if input called for exit.
    if [[ $REPLY =~ ^[Qq]$ ]]
    then
        exit;
    else
        clear;
    fi
}

function prompt_to_continue_with_message_and_offer_to_quit(){
    echo; # Move to a new line.
    echo "MESSAGE : $1";
    echo; # Move to a new line.
    read -p "Press any key to continue ('q' to exit.) : " -n 1 -r
    echo; # Move to a new line.

    # Check if input called for exit.
    if [[ $REPLY =~ ^[Qq]$ ]]
    then
        exit;
    else
        clear;
    fi
}

function prompt_to_continue(){
    echo; # Move to a new line.
    read -p "Press any key to continue : " -n 1 -r
    echo; # Move to a new line.
}

init
