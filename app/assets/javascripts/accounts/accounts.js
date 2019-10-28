
document.addEventListener("DOMContentLoaded", function(event) {
    console.log("DOM fully loaded and parsed");
    $("#form-ph").on('submit',function(e){
        e.preventDefault(); // cancel default submit
        toggleForm();
        var form = $("#form-ph");
    console.log(form.attr('action'))
    $.post(form.attr('action'), form.serialize(), function(data) {

    })
    .done(function() {
        $.get(window.location.href, (resText)=>{
            var find = $('.tbody-account',resText);
            console.log("=======");
            console.log(find.length)
            if(find.length>0){
                $('.tbody-account').replaceWith(find);
            }
        })})
        .fail(function() {
            alert("Something is wrong!")
    });
  });

});

function details(obj){
    console.log(obj.id.split('_')[1])
}

function updateTable(){
   toggleForm();
   $.get(window.location.href, (resText)=>{
       var find = $('.tbody-account',resText);
       console.log("=======");
       console.log(find.length)
       if(find.length>0){
           $('.tbody-account').replaceWith(find);
       }
   })
}

//deprecated
function submit_ph(){
    var f = document.forms.namedItem("form-ph")
    var formData = new FormData(f);
    // for (var pair of formData.entries()) {
    //     console.log(pair[0]+ ', ' + pair[1]);
    // }
    fetch('/accounts/add',{
        method:"post",
        credentials: 'same-origin',
        body: formData
    })
    .then(r =>  r.json().then(data => ({status: r.status, body: data})))
    .then(obj => {
        // var updateElement = $("#result");
        // if (updateElement) $("#result").html(JSON.stringify(obj,null,2))
        console.log(JSON.stringify(obj,null,2))
        $.get(window.location.href,(resHTML)=>{
            var newTable = $("table-account",resHTML)
            if(newTable.length>0){
                $("table-account").replaceWith(newTable);
            }
        })
    })
    .catch(err=>{
        $("#result").html(err)
    })
}

function toggleForm(){
    var toggler = document.getElementById("dropdown-toggle");
    var FormMenu = toggler.nextElementSibling;
    if(FormMenu.classList.contains("show")){
        console.log("====================")
        console.log("Folding")
        FormMenu.classList.add("out");
        FormMenu = toggler.nextElementSibling;
        FormMenu.addEventListener('animationend',stopAnimation)
    }
    else{
        console.log("====================")
        console.log("Dropping")
        FormMenu.classList.add("show");
    }
}
function stopAnimation(event){
    var e = event.target;
    e.classList.remove("out");
    e.classList.remove("show");
    e.classList.add("in")
    e.removeEventListener('animationend', stopAnimation)
}
function mumi(){
    var data = require('/Users/harry/Desktop/data.json');
    console.table(data.result.fields);
    console.table(data.result.records);
}