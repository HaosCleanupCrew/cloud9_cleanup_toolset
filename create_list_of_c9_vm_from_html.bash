#!/bin/sh

# This script creates an HTML file that can be used to run the C9 Cleanup Script(s) against.

# STATUS : WORKING ON IT!!

# The input file needs to be manually produced...
# log into Cloud9 at : https://c9.io/login
# copy/paste the view source into a file input.html
# Change <user_name> to whatever your user id is.

# Version 0.000001!

input_file='input.html'
temp_file='virtual_machine_list.temp'
output_file='/docs/js/add_clickable_urls_to_array.js'
user_name='koreahaos'

cat $input_file | grep -Eo "https://ide.c9.io/$user_name/[a-zA-Z0-9./?=_-]*" | sort | uniq > $temp_file

vm_count=0;
num_lines_in_temp_file=$(wc -l < $temp_file);

#echo $num_lines_in_temp_file
cat > ./$output_file << EOF
var array_for_c9_vm_cleanup = [
EOF

while read vm_url
do
    #echo $vm_url
    vm_url_string="$vm_url"
    vm_name=${vm_url_string##*/}
    #echo "$vm_name"
    line_to_add="";
    line_to_add="[\"$vm_name\", \"$vm_url\", \"true\"]";
    
    vm_count=$((vm_count + 1))

    if [ "$vm_count" -lt "$num_lines_in_temp_file" ]
    then
        line_to_add="$line_to_add,";
    fi
    
    cat >> ./$output_file << EOF
    $line_to_add
EOF

done <$temp_file

#echo "Number of Virtual Machines : $vm_count"

cat >> ./$output_file << EOF
];
EOF
