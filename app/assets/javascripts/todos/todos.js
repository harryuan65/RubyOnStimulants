$(document).ready(function() {
    console.log('yeet');
    $("#form-add-todo").on('submit',function(e){
        e.preventDefault();
        var form = $("#form-add-todo");
        $.post(form.attr('action'), form.serialize(), function() {})
        .done(function() {
            updateTable();
        })
            .fail(function() {
                alert("Something is wrong!")
        });
        return false;

    })
      console.log("Set form on submit");
});


function updateTable(){
    $.get(window.location.href, (resText)=>{
        var find = $('.tbody-todo',resText);
        console.log(find.length)
        if(find.length>0){
            console.log("Updating tbody-todo");
            $('.tbody-todo').replaceWith(find);
       }
       var alrt = $('.wrap-alert',resText);
       $('.wrap-alert').replaceWith(alrt);
       console.log(alrt.length);
    })
 }
