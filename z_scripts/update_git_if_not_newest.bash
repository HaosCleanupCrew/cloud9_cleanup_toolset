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
        #update_git_to_newest_version;
    fi
}

function update_git_to_newest_version(){

        printf "\n\nVersion of Git being updated.\n\n";
        sudo add-apt-repository ppa:git-core/ppa -y
        sudo apt-get update
        sudo apt-get install git -y
        git --version
}

update_git_if_it_is_not_capable_of_allowing_unrelated_histories;