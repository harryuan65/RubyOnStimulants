$(document).ready(function() {
  var formExists = $("form[id^='form']").length>0;

  $("form[id^='form']").on('submit',function(e){
    e.preventDefault(); // cancel default submit
    var form = $("form[id^='form']");
    $.post(form.attr('action'), form.serialize(), function() {})
    .done(function() {
        toggleForm();
        updateTable();
    })
        .fail(function() {
            alert("Something is wrong!")
    });
    return false;
  })
  if(formExists){
    console.log("Set form on submit");}
  else{
    console.log("Something is wrong!")
  }

});

function delete_history(target){
    r = confirm("真的要刪掉嗎?");
   if(r){
       $.post(target.url,{from_page:true, id:target.id})
       .done(data=>{
           updateTable()
           console.log(`刪除了 ${target.id}`);
       })
       .fail(err=>{
           console.log(err);
       })
   }
   else{
       console.log(`沒有刪除`);
   }
}
function updateTable(){
   $.get(window.location.href, (resText)=>{
       var find = $('tbody',resText);
       console.log(find.length)
       if(find.length>0){
           console.log("Updating tbody");
           $('tbody').replaceWith(find);
      }
      else{
        // words
        var find = $('.card-wrap',resText);
        if(find.length>0){
            console.log("Updating card-wrap");
           $('.card-wrap').replaceWith(find);
        }
      }
      var alrt = $('.wrap-alert',resText);
      $('.wrap-alert').replaceWith(alrt);
      console.log(alrt.length);
   })
}

function submit_ph(e){
    e.preventDefault();
    var f = document.forms.namedItem("form-ph")
    var formData = new FormData(f);
    // for (var pair of formData.entries()) {
    //     console.log(pair[0]+ ', ' + pair[1]);
    // }
    var token = $('meta[name="csrf-token"]').attr('content');

    fetch('/accounts/add',{
        headers:{'X-CSRF-TOKEN': token},
        method:"post",
        credentials: 'same-origin',
        body: formData
    })
    .then(r =>  r.json().then(data => ({status: r.status, body: data})))
    .then(obj => {
        // var updateElement = $("#result");
        // if (updateElement) $("#result").html(JSON.stringify(obj,null,2))
        toggleForm();
        console.log(JSON.stringify(obj,null,2))
        $.get(window.location.href, (resText)=>{
            var find = $('.tbody-account',resText);
            console.log("=======");
            // console.log(find.length)
            if(find.length>0){
                $('.tbody-account').replaceWith(find);
            }
        })
    })
    .catch(err=>{
        $("#result").html(err)
    })
    return false;
}

function toggleForm(){
    var FormWrap = document.getElementById("wrap-dropdown-form");
    var FormMenu = document.getElementById("dropdown-form");
    if(FormWrap.classList.contains("show")){
        console.log("====================")
        console.log("Folding")
        FormWrap.classList.add("out");
        // FormMenu = document.getElementById("dropdown-form");
        FormWrap.addEventListener('animationend',stopAnimation)
    }
    else{
        console.log("====================")
        console.log("Dropping")
        FormWrap.classList.add("show");
    }
}
function stopAnimation(event){
    var e = event.target;
    e.classList.remove("out");
    e.classList.remove("show");
    e.classList.add("in")
    e.removeEventListener('animationend', stopAnimation)
}

function delete_todo(target){
    var r = confirm("Are you sure?");
    if(r){
       $.ajax({
               url: target.url,
               method: 'POST'
        })
        .done(data=>{
            console.log(data);
            updateTable();
        })
        .fail(err=>{
            console.error(data);
        })
    }
}