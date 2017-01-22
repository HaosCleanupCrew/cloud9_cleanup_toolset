function update_docs_file_showing_vm_has_been_archived(){
    cd $GOPATH;
    local vm_name_archived="$C9_PROJECT";
    perl -pi -e "s/$vm_name_archived\", \"true\"/$vm_name_archived\", \"false\"/g" $GOPATH/z_vm_archive_repo/docs/js/add_clickable_urls_to_array.js;
}

update_docs_file_showing_vm_has_been_archived