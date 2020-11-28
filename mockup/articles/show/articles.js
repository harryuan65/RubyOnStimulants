// shared.js
var fetchPage = true;
var previewLength = 0;
var contentChanged = false;
var map = {};
var dev = null;
document.addEventListener('DOMContentLoaded', ()=>{
  //detect two consecutive keys press
  document.onkeyup = (e)=>{
    e = e || window.event;
    map[e.key] = e.type == "keydown";
    map = {}
  }
  document.onkeydown = (e)=>{
    e = e || window.event;
    map[e.key] = e.type == "keydown";
    // console.log(e.type)
    // console.log(e.altKey)
    // console.log(map)
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
function setFlash(success, message){
  let alertMsg = `
  <p class="alert alert-${success ? "success" : "danger"} notosans" ${success ? 'onanimationend="foldAlert(this)' : ""}">
   <span class="alert-txt">${message}</span>
  </p>
  `;
  $("#wrap-alert").html(alertMsg);
}

//articles.js
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
  // $('pre code').each(e=>{
  //   hljs.highlightBlock(this);
  // })
  //markdown autocomplete support
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
function togglePreviewMarkdownV1(togglePreview, raw=null, prod=false){
  contentChanged = raw ? previewLength!=raw.length : false;
  previewLength = raw ? raw.length : previewLength;
  previewPage = document.getElementById('preview-page');
  previewToggle = document.getElementById('preview-toggle');
  editPage = document.getElementById('edit-page');
  editToggle =  document.getElementById('edit-toggle');
  //only toggles to preview and ajax when necessary(don't poke server when smashing preview toggle)
  let previewIsOn = previewToggle.classList.contains('active');

  if(togglePreview && !previewIsOn){
    editPage.classList.remove('display');
    editToggle.classList.remove('active');
    previewPage.classList.add('display');
    previewToggle.classList.add('active');
    var previewMarkdownDiv = document.getElementById('preview-markdown');
    if(fetchPage && raw && contentChanged){ // only fetch preview when there is a difference
      // beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      $.ajax({
          type: "POST",
          url: prod ? "/preview_markdown" : "http://localhost:3005/preview_markdown",
          data: {content: raw},
      dataType: "html"})
      .done(function(data){
        previewMarkdownDiv.innerHTML = data;
        hightlightAllCodes();
      }).fail(function(err){
        console.error(err);
        alert("Something is wrong with server")
        //note that data type doesnot match also triggers fail, event if status==200
      })
    }else{
      // let data = `
      //   <h3>Lorem ipsum dolor sit amet!</h3>
      //   Consectetur adipisicing elit.

      //   Ipsam <b>exercitationem</b> optio enim beatae tempore esse.

      //   Recusandae dolorem ullam <u>debitis</u> officia in nemo. A excepturi at laudantium molestiae repellendus ipsam repudiandae.
      // `
      // let previewMarkdownDiv = document.getElementById('preview-markdown');
      // previewMarkdownDiv.innerHTML = data;
    }
  }
  else if(!togglePreview && previewIsOn){
    // console.log("Edit");
    previewPage.classList.remove('display');
    previewToggle.classList.remove('active');
    editPage.classList.add('display');
    editToggle.classList.add('active');
  }
}