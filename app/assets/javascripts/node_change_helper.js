function node_change(form){

    infofield();
    coll_add(form);
}




function coll_add(form){

    $.ajax({
        type: form.method,
        url: form.action,
        data: $(form).serialize()
    });
}

function node_change_edit(form){
    infofield_edit();
    coll_add(form);
}



function field_change(id) {
    field = $('#text_area_'+id).val();
    origin = $('#spoiler'+id);

    origin = origin.attr('data-text');

    if(field == origin){
        $('#reset_button_'+id).attr("disabled","disabled");
    }else{
        $('#reset_button_'+id).removeAttr('disabled');
        change_vorhanden_info();
    }

}

function reset_change_field(id) {
    field = $('#text_area_'+id);
    origin = $('#spoiler'+id);

    origin = origin.attr('data-text');

    field.val(origin);
    parent = field.parent();
    parent = parent.parent();

    parent.trigger("submit");
    field_change(id);
}


function save_field(id) {
    $('#wird_gespeichert_div'+id).html('');
}

function save_all_changes(){

    var forms = $(".edit_node");

    for(var i = 0; i<forms.length; i++){
        coll_add(forms[i]);
    }
}


function add_additional_file(){

    add_additional_file_info();
/*    $.ajax({
        type: form.method,
        url: form.action,
        data: $(form).serialize()
    });*/
}

