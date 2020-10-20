function insertTextInPos(element, beforePos, newText){
  var startPos = element.selectionStart;
  var endPos = element.selectionEnd;
  element.value = element.value.substring(0, startPos) + newText + element.value.substring(endPos, element.value.length);
  element.selectionStart = element.selectionEnd = beforePos;
}
var mappings = {
  "[": "]",
  "`": "`",
  "(": ")",
  "{": "}",
  "\"": "\"",
  "'": "''",
  "<":">"
}
window.onload = ()=>{
  var prevData = document.getElementById('article_content').value;
  window.onbeforeunload = (event)=>{
    var currentData = document.getElementById('article_content').value;
    var diff = currentData.split(prevData).join('');
    if (diff.length > 0){
      (event || window.event).returnValue = "ask";
    }
  }
}
$("main").ready(()=>{
  //load current state's style
  $('input[type="radio"]:checked').parent().addClass("selected");
  $(".state-pair input[type='radio']:checked").addClass("selected");
  $('pre code').each(e=>{
    hljs.highlightBlock(this);
  })
  //markdown autocomplete support
  $("#article_content").on('keydown', (e)=>{
    if(Object.keys(mappings).includes(e.key)){
      insertTextInPos(e.target, e.target.selectionStart, mappings[e.key]);
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

function togglePreviewMarkdown(togglePreview, raw=null, prod=false){
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