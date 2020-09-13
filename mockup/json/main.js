// test string
// "{\"query\":{\"from\":2,\"size\":100,\"bool\":{\"must\":[{\"bool\":{\"should\":[{\"multi_match\":{\"query\":\"Mumi\",\"fields\":[\"name\",\"intro\"]}}]}},{\"term\":{\"gender\":false}},{\"term\":{\"age\":20}}]}}}"
function parse(str){
  let jsonString = str.substring(1, str.length-1).replace(/\\/g, '');
  let output = document.getElementById('output');
  let dev = document.getElementById('dev');
  try{
    dev.textContent = str;
    output.textContent = JSON.stringify(JSON.parse(jsonString), null, 2);
  }
  catch(e){
    output.textContent = e;
  }
}

function pp(str){
  let j = JSON.parse(str);
  let output = JSON.stringify(j,null,2);
  console.log(output);
  return output;
}
function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}
function objStrToPP(str){
//   let str = "{a:5, b:{c:5}}";
  let str = "{a:5, b:{c:12345}}";
  let matchGroup = str.match(/[^\{\},]*:[^\{\},]*/g);
  let target = matchGroup.map(e=>e.split(':')).flat().map(e=>e.replace(/ /g,'')).filter(e=>e!="")
//   let allChars = target.map(e=>e.split('')).flat()
//   let uniqChars = allChars.filter(onlyUnique);
  let output = str;
  target.forEach(e=>{
    output = output.replace(new RegExp(e, 'g'), `"${e}"`);
  })
  parse(`"${output}"`);
}
