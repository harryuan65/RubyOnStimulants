function insertTextInPos(element, newText, isEnter){
  var startPos = element.selectionStart;
  var endPos = element.selectionEnd;
  element.value = element.value.substring(0, startPos) +
  newText +
  element.value.substring(endPos, element.value.length);

  element.selectionStart = element.selectionEnd = startPos;
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
document.addEventListener('DOMContentLoaded',(e)=>{
  document.getElementById('test').addEventListener('keydown',(e)=>{
    document.getElementById('caret_pos').innerHTML = `${e.target.selectionStart} ${e.target.selectionEnd}`;
    // console.log(e.key);
    var previousKey = e.target.value[e.target.selectionStart-1];
    document.getElementById('log').innerHTML = previousKey;

    if(Object.keys(mappings).includes(e.key)){
      insertTextInPos(e.target, mappings[e.key]);
    }

    if(e.key==="Enter" && Object.keys(mappings).includes(previousKey)){
      insertTextInPos(e.target, "  \n",true);
    }
  })
})