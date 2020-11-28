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
  console.log('set!');
  $("#article-page-content").on('keydown', (e)=>{
    let prevChar = getPreviousChar(e.target);
    let laterChar = getLaterChar(e.target);
    debugRange(e.target);
    // console.log('Input:', e.key ,', Previous:', prevChar, 'Later:', laterChar)
    if(['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown', 'Backspace', "Meta", "Shift", "Control"].includes(e.key) ){return;}
    // console.log(e.target.nodeName)
    // insertElementAtCursor('p', e.key);

    if(Object.keys(mappings).includes(e.key)){
      insertTextAtCursor(mappings[e.key]);
      // document.selection.createRange().text = mappings[e.key];
      // insertTextInPos(e.target, e.target.selectionStart, mappings[e.key]);
    }
    else{
      //check if the text is inside a ``
      if(prevChar=='`'){
        console.log(true)
        insertElementAtCursor('code', e.key);
      }
    }
  })
})
function insertTextAtCursor(text){
    let selection = window.getSelection();
    let range = selection.getRangeAt(0);
    // range.deleteContents();
    let node = document.createTextNode(text);
    range.insertNode(node);

    for(let position = 0; position != text.length; position++){
        // selection.modify("move", "right", "character");
        selection.modify("move", "left", "character");
    };
}
function debugRange(containerEl){
  if (window.getSelection) {
    sel = window.getSelection();
    console.log("Selection.rangeCount=", sel.rangeCount)
    if (sel.rangeCount > 0) {
      range = sel.getRangeAt(0).cloneRange();
      console.log("before collapse PrevRange.toString:", range.toString());
      range.collapse(true);
      console.log("before setEnd PrevRange.toString:", range.toString());
      range.setStart(containerEl, 0);
      console.log("PrevRange.toString:", range.toString());
      precedingChar = range.toString().slice(-1);
      console.log("=====================")
    }
  }
}
function getPreviousChar(containerEl){
  var precedingChar = "", sel, range, precedingRange;
  if (window.getSelection) {
    sel = window.getSelection();
    if (sel.rangeCount > 0) {
      range = sel.getRangeAt(0).cloneRange();
      // console.log("before collapse PrevRange.toString:", range.toString());
      range.collapse(true);
      // console.log("before setEnd PrevRange.toString:", range.toString());
      range.setStart(containerEl, 0);
      // console.log("PrevRange.toString:", range.toString());
      precedingChar = range.toString().slice(-1);
    }
    // For Windows
    // else if ( (sel = document.selection) && sel.type != "Control") {
    //   range = sel.createRange();
    //   precedingRange = range.duplicate();
    //   precedingRange.moveToElementText(containerEl);
    //   precedingRange.setEndPoint("EndToStart", range);
    //   precedingChar = precedingRange.text.slice(-1);
    // }
  }
  return precedingChar;
}
function getLaterChar(containerEl){
  var laterChar = "", sel, range, precedingRange;
  if (window.getSelection) {
    sel = window.getSelection();

    if (sel.rangeCount > 0) {
      range = sel.getRangeAt(0).cloneRange();
      // console.log("before collapse LaterRange.toString:", range.toString());
      // range.collapse(false);
      // console.log("before setEnd LaterRange.toString:", range.toString());
      // range.setEnd(containerEl, 0);
      console.log("LaterRange.toString:", range.toString());
      // laterChar = range.toString().slice(-1);
    }
  }
  return laterChar;
}
function insertElementAtCursor(eleType, text){
  let selection = window.getSelection();
  let range = selection.getRangeAt(0);
  range.deleteContents();
  let code = document.createElement(eleType);
  let node = document.createTextNode(text);
  code.append(node);
  range.insertNode(code);

  // for(let position = 0; position != text.length; position++){
  //     // selection.modify("move", "right", "character");
  //     selection.modify("move", "left", "character");
  // };
}
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