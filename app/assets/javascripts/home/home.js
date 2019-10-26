function toggleDropdown(this_obj){
  var next = this_obj.nextElementSibling;
  next.classList.toggle("show");
}

function disableDropdown(this_obj){
  $('.dropdown-menu').removeClass("show");
}

function f1(str){
  alert(str);
}

function f2(str){
  alert(str);
}

function reverseAnimation(this_obj){
    console.log("Reversing...")
    setTimeout( ()=>{
       this_obj.style.animation = "alert-backwards 1s forwards running";
    }, 2000);
}
