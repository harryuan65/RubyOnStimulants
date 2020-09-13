function reverseAnimation(this_obj){
    console.log("Reversing...")
    setTimeout( ()=>{
       this_obj.style.animation = "alert-backwards 1s forwards running";
    }, 3000);
}
function toggleSideNav(){
  let navSide = document.getElementById('nav-side');
  navSide.classList.toggle('active');
  let toggle = document.getElementById('nav-side-toggle');
  toggle.classList.toggle('active');
}
function changePage(url){
  // TODO
  toggleSideNav();
}