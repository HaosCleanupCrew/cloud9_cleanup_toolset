function create_clickable_element_for_url(c9_vm_num_in, c9_vm_name, c9_vm_url, c9_vm__needs_to_be_archived) {

    var frag = document.createDocumentFragment();
    var temp = document.createElement('div');

    var insert_string = "";

    var vm_archive_repo_url = "vm_archive_repo_url";
    var vm_archive_script = "vm_archive_script";
    
    var archived_status = "not_archived";
    var string_for_clickable = "bash <(curl -s curl http://haos.house/c9_vm_archives/z_scripts/setup_cloud9_vm_for_archiving_and_archive.bash)";
    var text_for_clickable_button = "Archive VM!";
    var tooltip_for_clickable_button = "Copy command and open VM in new tab.";
    var url_to_open_on_click = c9_vm_url;
    
    insert_string += '  <div id="vm_clickable_div_' + c9_vm_num_in + '">';

    if ( c9_vm__needs_to_be_archived === "false" ) {
        archived_status = "archived";
        string_for_clickable = c9_vm_name;
        text_for_clickable_button = "Delete VM!";
        tooltip_for_clickable_button = "Copy VM name to clipboard and open settings page for VM.";
        url_to_open_on_click = 'https://c9.io/koreahaos/' + c9_vm_name + '/settings';
    }

    insert_string += '    <label class="' + archived_status + '" for="vm_clickable_label_' + c9_vm_num_in + '">' + c9_vm_num_in + ' : ' + c9_vm_name + '</label>';
    insert_string += '    <input type="text" id="clickable_command_' + c9_vm_num_in + '" value="' + string_for_clickable + '" />';
    insert_string += '    <button  class="rightest_button" data_tooltip="' + tooltip_for_clickable_button + '" data-copytarget="#clickable_command_' + c9_vm_num_in + '"onclick=" window.open(\'' + url_to_open_on_click + '\',\'_blank\')">' + text_for_clickable_button + '</button>';
    insert_string += '  </div>';

    temp.innerHTML = insert_string;
    while (temp.firstChild) {
        frag.appendChild(temp.firstChild);
    }
    return frag;
}

var num_of_vm_urls_in_array = array_for_c9_vm_cleanup.length;

for (var i = 0; i < num_of_vm_urls_in_array; i++) {
    var vm_num = i + 1;
    var fragment = create_clickable_element_for_url(vm_num, array_for_c9_vm_cleanup[i][0], array_for_c9_vm_cleanup[i][1], array_for_c9_vm_cleanup[i][2]);
    document.getElementById("clickable_scripts_outer_div").appendChild(fragment);
}
