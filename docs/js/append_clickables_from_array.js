function create_clickable_element_for_url(c9_vm_num_in, c9_vm_name, c9_vm_url, c9_vm__needs_to_be_archived) {

    var frag = document.createDocumentFragment();
    var temp = document.createElement('div');

    var insert_string = "";

    var vm_archive_repo_url = "vm_archive_repo_url";
    var vm_archive_script = "vm_archive_script";
    
    var archived_status = "not_archived";
    
    if ( c9_vm__needs_to_be_archived === "false" ) {
        archived_status = "archived";
    }

    insert_string += '  <div id="vm_clickable_div_' + c9_vm_num_in + '">';
    insert_string += '    <label class="' + archived_status + '" for="vm_clickable_label_' + c9_vm_num_in + '">' + c9_vm_name + '</label>';
    insert_string += '    <input type="text" id="clickable_command_' + c9_vm_num_in + '" value="bash <(curl -s https://gist.githubusercontent.com/' + vm_archive_script + c9_vm_num_in + '/raw)" />';
    insert_string += '    <button  class="rightest_button" data_tooltip="Copy command and open VM in new tab." data-copytarget="#clickable_command_' + c9_vm_num_in + '"onclick=" window.open(\'' + c9_vm_url + '\',\'_blank\')">Archive VM!</button>';
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
