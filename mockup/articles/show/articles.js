// shared.js
var fetchPage = true;
var previewLength = 0;
var contentChanged = false;
var map = {};
var dev = null;
document.addEventListener('DOMContentLoaded', ()=>{
  document.onkeyup = (e)=>{
    e = e || window.event;
    map[e.key] = e.type == "keydown";
    map = {}
  }
  document.onkeydown = (e)=>{
    e = e || window.event;
    map[e.key] = e.type == "keydown";
    if (map["Alt"] && map["∂"]){
      toggleDarkMode();
    }
  }
})
function toggleDarkMode(){
  document.documentElement.classList.toggle('dark-mode');
  document.querySelectorAll('.no-dark').forEach(e=>{
    e.classList.toggle('invert-again');
  })
}
function foldAlert(this_obj){
    // console.log("Reversing...")
    setTimeout( ()=>{
       this_obj.style.animation = "alert-backwards 1s forwards running";
    }, 3000);
}
function toggleSideNav(forceClose=false){
  let navSide = document.getElementById('nav-side');
  let svgs = $("svg",".nav-top-option");
  dev = svgs;
  if(forceClose){
    navSide.classList.remove('active');
    svgs.removeClass('active');
  }
  else{
    navSide.classList.toggle('active');
    svgs.toggleClass('active');
  }
}
function setFlash(success, message){
  let alertMsg = `
  <p class="alert alert-${success ? "success" : "danger"} notosans" ${success ? 'onanimationend="foldAlert(this)' : ""}">
   <span class="alert-txt">${message}</span>
  </p>
  `;
  $("#wrap-alert").html(alertMsg);
}
function insertTextInCaret(element, newText){
  var startPos = element.selectionStart;
  var endPos = element.selectionEnd;
  element.value = element.value.substring(0, startPos) + newText + element.value.substring(endPos, element.value.length);
  element.selectionStart = element.selectionEnd = startPos;
}
var mappings = {
  "[": "]",
  "`": "`",
  "(": ")",
  "{": "}",
  "\"": "\"",
  "'": "'",
  "<":">"
}
window.onload = ()=>{
  var articleContent = document.getElementById('article_content');
  if(articleContent){
    let prevData = articleContent.value;
    window.onbeforeunload = (event)=>{
      var currentData = document.getElementById('article_content').value;
      var diff = currentData.split(prevData).join('');
      if (diff.length > 0){
        (event || window.event).returnValue = "ask";
      }
    }
  }
}
$("main").ready(()=>{
  //load current state's style
  $('input[type="radio"]:checked').parent().addClass("selected");
  $(".state-pair input[type='radio']:checked").addClass("selected");
  hljs.initHighlighting();
  $("#article_content").on('keydown', (e)=>{
    if(Object.keys(mappings).includes(e.key)){
      insertTextInCaret(e.target, mappings[e.key]);
    }
  })
})
function select(event){
  let otherRadios = $('input[type="radio"]');
  otherRadios.parent().removeClass("selected");

  // also toggles class when clicking on child 'span'
  if(event.target.nodeName==="SPAN"){
    var radio = $('input[type="radio"]', event.target.parentNode);
  }
  else{
    var radio = $('input[type="radio"]', event.target);
  }
  radio.prop('checked', true); //event.target = pair
  radio.parent().addClass("selected"); //event.target = pair
}
function hightlightAllCodes(){
  document.querySelectorAll('pre code').forEach(e=>{
    hljs.highlightBlock(e);
  })
}