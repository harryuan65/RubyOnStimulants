var fetchPage = true;
var previewLength = 0;
var contentChanged = false;
var map = {};
document.addEventListener('DOMContentLoaded', ()=>{
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
function togglePreviewMarkdown(togglePreview, raw=null, prod=false){
  contentChanged = raw ? previewLength!=raw.length : false;
  previewLength = raw ? raw.length : previewLength;
  previewPage = document.getElementById('preview-page');
  previewToggle = document.getElementById('preview-toggle');
  editPage = document.getElementById('edit-page');
  editToggle =  document.getElementById('edit-toggle');
  // console.log(prod);
  //only toggles to preview and ajax when necessary(don't poke server when smashing preview toggle)
  let previewIsOn = previewToggle.classList.contains('active');

  if(togglePreview && !previewIsOn){
    // console.log("Preview");
    editPage.classList.remove('display');
    editToggle.classList.remove('active');
    previewPage.classList.add('display');
    previewToggle.classList.add('active');
    var previewMarkdownDiv = document.getElementById('preview-markdown');
    if(fetchPage && raw && contentChanged){ // only fetch preview when there is a difference
      $.ajax({
          type: "POST",
          beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
          url: prod ? "/preview_markdown" : "http://localhost:3005/preview_markdown",
        data: {content: raw},
      // success: (e)=>{console.log(e)},
      dataType: "html"})
      .done(function(data){
        // console.log("Fetches");
        previewMarkdownDiv.innerHTML = data;
        // console.log(hljs);
        document.querySelectorAll('pre code').forEach(e=>{
          hljs.highlightBlock(e);
        })
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