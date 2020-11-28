var collecting = false;
var currentArticleId = null;
var previewMarkdownDiv = null;
var articleContent = null;

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
$(".container").ready(()=>{
  previewMarkdownDiv = document.getElementById('preview-content');
  articleContent = document.getElementById('article-content-v2');

  hljs.initHighlighting();
  if(articleContent && typeof(articleContent.onkeydown)!=="undefined"){
    articleContent.onkeydown = (e)=>{
      if(Object.keys(mappings).includes(e.key)){
        insertTextInCaret(e.target, mappings[e.key]);
      }
    }
  }
  $("#edit-page").resizable();
  $("#article-option-bar").resizable();

  var previewPage = document.getElementById('preview-page');
  previewPage.onscroll= (e)=>{
    articleContent.scrollTop = e.target.scrollTop;
  }
  articleContent.onscroll = (e)=>{
    previewPage.scrollTop = e.target.scrollTop;
  }
  previewArticle();
})
//v2
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
async function prepareToUpdateArticle(delay=1000){
  // resizeContent();
  if(!collecting){
    collecting = true;
    setStatusText("Saving...", true);
    await sleep(delay);
    updateArticle(articleContent.value);
  }
}
function previewArticle(raw){
  setStatusText("Fetching preview...", true);
  $.ajax({
    type: "POST",
    url: `/articles/preview_markdown`,
    data: {content: articleContent.value},
    dataType: "json"})
  .done(function(data){
    previewMarkdownDiv.innerHTML = data.content;
    hightlightAllCodes();
    setStatusText("Done.");
  }).fail(function(jqXHR){
    console.error(jqXHR);
    let errorMsg = jqXHR.responseJSON.error;
    setStatusText(errorMsg, true);
  })
}
function updateArticle(raw=null){
  contentChanged = raw ? previewLength!=raw.length : false;
  previewLength = raw ? raw.length : previewLength;
  if(raw && contentChanged){ // only fetch preview when there is a difference
    $.ajax({
        type: "PUT",
        url: `/articles/${currentArticleId}`,
        data: {content: raw},
        dataType: "json"})
    .done(function(data){
      previewMarkdownDiv.innerHTML = data.content;
      hightlightAllCodes();
      collecting = false;
      setStatusText("Saved", true);
    }).fail(function(jqXHR){
      console.error(jqXHR);
      let errorMsg = jqXHR.responseJSON.error;
      setStatusText(errorMsg, true);
    })
  }
}
// end v2