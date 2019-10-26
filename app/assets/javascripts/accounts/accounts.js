$.not("#dropdown-toggle").find("*").on('click',function(e){
    console.log($(this));
         var find = $(".dropdown-form.show");
        if(find.length>0 && find.hasClass("show")) {
          find.removeClass("show");
          console.log(`${find.length}`)
       }
})

$("#form-ph").on('submit',function(event){
    var formData = new FormData();
    for(e in this){
        console.log(e.name,' ', e.value);
    }
});

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
        console.log(JSON.stringify(obj,null,2))
        // if (updateElement) $("#result").html(JSON.stringify(obj,null,2))
    })
    .catch(err=>{
        $("#result").html(err)
    })
}

function toggleForm(this_obj){
    var FormMenu = this_obj.nextElementSibling;
    FormMenu.classList.toggle("show");
}