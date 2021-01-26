var collecting = false;
var previewMarkdownDiv = null;
var articleContent = null;
var collection = [];
var BORDER_SIZE = 4;
function checkCollection(){
  let integration = collection.join('');
  console.log(integration);
  if(!integration.includes("::")){ return; }

  let parts = integration.split('::');
  let input = parts[0];
  let cmd = parts[1];
  console.log(cmd)
  switch(cmd){
    case "link":
      $.ajax({
        url: `/articles/get_link_title?url=${input}`
      })
      .always(function(responseText, textStatus){
        insertTextInCaret(articleContent, `[${responseText}](${input})`)
        collection = [];
      })
      break;
    case "folder":
      articleContent.value = articleContent.value.replace(/::folder/g, "📂");
      prepareToUpdateArticle();
      collection = [];
      break;
    case "file":
      articleContent.value = articleContent.value.replace(/::file/g, "📄");
      prepareToUpdateArticle();
      collection = [];
      break;
    case "nsc":
      articleContent.value = articleContent.value.replace(/::nsc/g, "┣ ");
      prepareToUpdateArticle();
      collection = [];
    case "c":
      articleContent.value = articleContent.value.replace(/::c/g, "┃ ");
      prepareToUpdateArticle();
      collection = [];
    case "ns":
      articleContent.value = articleContent.value.replace(/::ns/g, "┗ ");
      prepareToUpdateArticle();
      collection = [];
    default:
      collection = [];
  }
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
function resize(e){
  const dx = m_pos - e.x;
  m_pos = e.x;
  console.log(`e.x: ${e.x}  dx:${dx}`);
  editPage.style.width = (parseInt(getComputedStyle(editPage, '').width) - dx) + "px";
  previewPage.style.width = (parseInt(getComputedStyle(previewPage, '').width) + dx) + "px";
}
$(".content-article-edit").ready(()=>{
  previewMarkdownDiv = document.getElementById('preview-content');
  articleContent = document.getElementById('article-content');
  editPage = document.getElementById('edit-page');
  previewPage = document.getElementById('preview-page');

  hljs.initHighlighting();
  if(articleContent && typeof(articleContent.onkeydown)!=="undefined"){
    articleContent.onkeydown = (e)=>{
      if(Object.keys(mappings).includes(e.key)){
        insertTextInCaret(e.target, mappings[e.key]);
      }
      if(e.key==="Enter"){
        collection = [];
      }
      if(e.key.length==1){
        collection.push(e.key);
      }
      if(e.key==="Tab"){
        checkCollection();
        e.preventDefault();
      }
      if(e.key==="Backspace"){
        collection.pop();
      }
      console.log(collection);
    }
  }
  if(articleContent && typeof(articleContent.onpaste)!=="undefined"){
    articleContent.onpaste = (e)=>{
      collection.pop();
      let input = e.clipboardData.getData('text');
      collection.push(input);
      if(input.match(/^http:\/\/(.+)$|^https:\/\/(.+)$/i)){
        e.preventDefault();
        $.ajax({
          url: `/articles/get_link_title?url=${input}`
        })
        .always(function(responseText, textStatus){
          insertTextInCaret(articleContent, `[${responseText}](${input})`)
          collection = [];
          prepareToUpdateArticle();
        })
      }
    }
  }
  previewMarkdownDiv.addEventListener("mousedown", function(e){
    if (e.offsetX < BORDER_SIZE) {
      m_pos = e.x;
      console.log(`e.offsetX:${m_pos}`);
      document.addEventListener("mousemove", resize, false);
    }
  }, false);

  document.addEventListener("mouseup", function(){
    document.removeEventListener("mousemove", resize, false);
  }, false);
  previewArticle();
})
//v2
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
  $.ajax({
    type: "PUT",
    url: `/articles/${currentArticleId}/update_state`,
    data: {state: radio.val()},
    dataType: "json"})
  .done(function(data){
    setStatusText(savedText, true);
  }).fail(function(jqXHR){
    console.error(jqXHR);
    let errorMsg = jqXHR.responseJSON.error;
    setStatusText(errorMsg, true);
  })
}
function resizeContent(){
  if(articleContent.scrollTop!==0){
    articleContent.style.height = 10 + articleContent.scrollHeight + 'px';
  }
}
function setStatusText(message=null, keepStaying=false){
  let status = document.getElementById('status');
  status.classList.add('fade-in');
  status.innerText = message;
  status.onanimationend = (e)=>{
    e.target.classList.remove('fade-in');
    if(!keepStaying){
      e.target.classList.add('fade-out');
      e.target.onanimationend = (ev)=>{
        ev.target.classList.remove('fade-out');
        ev.target.innerHTML='';
      }
    }
  }
}
async function sleep(ms=0){
  return new Promise((resolve, reject)=>{setTimeout(resolve, ms)})
}
async function prepareToUpdateArticle(){
  if(!collecting){
    collecting = true;
    setStatusText(savingText, true);
    sleep(1000).then(e=>{
      updateArticle(articleContent.value);
    });
  }
}
function forceUpdate(event){
  event.preventDefault();
  updateArticle(articleContent.value, true);
}
function previewArticle(raw){
  setStatusText(fetchingPreviewText, true);
  $.ajax({
    type: "POST",
    url: `/articles/preview_markdown`,
    data: {content: articleContent.value},
    dataType: "json",
    timeout: 3000})
  .done(function(data){
    previewMarkdownDiv.innerHTML = data.content;
    hightlightAllCodes();
    setStatusText(doneText);
  }).fail(function(jqXHR){
    console.error(jqXHR);
    let errorMsg = jqXHR.responseJSON.error;
    setStatusText(errorMsg, true);
  })
}
function updateArticle(raw=null, force=false){
  contentChanged = raw ? previewLength!=raw.length : false;
  previewLength = raw ? raw.length : previewLength;
  if(raw && contentChanged || force){ // only fetch preview when there is a difference
    $.ajax({
        type: "PUT",
        url: `/articles/${currentArticleId}`,
        data: {content: raw},
        dataType: "json"})
    .done(function(data){
      previewMarkdownDiv.innerHTML = data.content;
      hightlightAllCodes();
      setStatusText(savedText, true);
    }).fail(function(jqXHR){
      console.error(jqXHR);
      let errorMsg = jqXHR.responseJSON.error;
      setStatusText(errorMsg, true);
    })
  }
  collecting = false;
}
// end v2