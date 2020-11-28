var listSize = 0;
var newDataSize = 0;

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
// function select(event){
//   let otherRadios = $('input[type="radio"]');
//   otherRadios.parent().removeClass("selected");

//   // also toggles class when clicking on child 'span'
//   if(event.target.nodeName==="SPAN"){
//     var radio = $('input[type="radio"]', event.target.parentNode);
//   }
//   else{
//     var radio = $('input[type="radio"]', event.target);
//   }
//   radio.prop('checked', true); //event.target = pair
//   radio.parent().addClass("selected"); //event.target = pair
// }
function hightlightAllCodes(){
  document.querySelectorAll('pre code').forEach(e=>{
    hljs.highlightBlock(e);
  })
}
function LoadMore(isMine=null){
  $.ajax({
    url: isMine ? `/articles/mine?offset=${listSize}` : `/articles?offset=${listSize}`,
    dataType: "script"
  })
  .done(function(res){
    console.log('OK唷');
  })
  .fail(function(jqXHR){
    let contentType = jqXHR.getResponseHeader('Content-Type');
    if(jqXHR.responseJSON){
      let errorMsg = jqXHR.responseJSON.error;
      setFlash(false, errorMsg);
    }
    else{
      console.log(jqXHR.responseText)
      setFlash(false, `Response Type mismatched: got ${contentType}`);
    }
  })
}