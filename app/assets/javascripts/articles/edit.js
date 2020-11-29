var collecting = false;
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
  var previewPage = document.getElementById('preview-page');
  previewPage.onscroll= (e)=>{
    articleContent.scrollTop = e.target.scrollTop;
  }
  articleContent.onscroll = (e)=>{
    artContent = e.target;
    previewPage.scrollTop = artContent.scrollTop;
    // if(artContent.scrollTop + artContent.offsetHeight > artContent.scrollHeight){
    //   previewPage.scrollTo({
    //     top: previewPage.scrollHeight,
    //     left: 0,
    //     behavior: 'smooth'
    //   });
    // }
  }
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
function previewArticle(raw){
  setStatusText(fetchingPreviewText, true);
  $.ajax({
    type: "POST",
    url: `/articles/preview_markdown`,
    data: {content: articleContent.value},
    dataType: "json"})
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
      setStatusText(savedText, true);
    }).fail(function(jqXHR){
      console.error(jqXHR);
      let errorMsg = jqXHR.responseJSON.error;
      setStatusText(errorMsg, true);
    })
  }
}
// end v2