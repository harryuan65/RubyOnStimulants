document.addEventListener('DOMContentLoaded', ()=>{
  document.onkeypress = (e)=>{
    e = e || window.event;
    if(e.key==="Enter"){
      document.documentElement.classList.toggle('dark-mode');
      document.querySelectorAll('.no-dark').forEach(e=>{
        e.classList.toggle('invert-again');
      })
    }
  }
})
function foldAlert(this_obj){
    console.log("Reversing...")
    setTimeout( ()=>{
       this_obj.style.animation = "alert-backwards 1s forwards running";
    }, 3000);
}
function toggleSideNav(forceClose=false){
  let navSide = document.getElementById('nav-side');
  let toggle = document.getElementById('nav-side-toggle');
  if(forceClose){
    navSide.classList.remove('active');
    toggle.classList.remove('active');
  }
  else{
    navSide.classList.toggle('active');
    toggle.classList.toggle('active');
  }
}
function openConfirm(event){
  event.preventDefault();
  document.getElementById('confirm-bkg').classList.toggle('show');
}
function closeConfirm(){
  document.getElementById('confirm-bkg').classList.remove('show');
}
function changePage(event){
  // TODO
  event.preventDefault();
  toggleSideNav();
  let url = event.target.getAttribute('href');
  console.log(url);
  $.get(url, (resText)=>{
    // var find = $('#main', resText); //this jquery object's context is undefined, causing find.length=0
    var find = $(resText).filter('#main'); //equals to the above
    console.log(find.length);
    console.log(find);
    if (find.length>0){
      console.log("Replacing new element");
      $('#main').replaceWith(find);
    }
  })
}