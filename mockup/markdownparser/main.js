function newLineReplacer(match, phrase){
  console.log('new line detected');
  console.log('Input:\n', phrase);
  phrase = phrase.replace(/\n/g, '<br>');
  return `${phrase}<br>`;
}
function headerReplacer(match, ...phrase){
  // "###", "1"
//   console.log('header detected');
//   console.log('Input:\n', phrase);
  let count = phrase[0].split('').length;
  let str = phrase[1]
  return `<h${count}>${str}</h${count}>`;
}
function boldReplacer(match, phrase){
//   console.log('bold detected');
//   console.log('Input:\n', phrase);
  phrase = phrase.replace(/\*/g, '');
  return `<b>${phrase}</b>`;
}
function fun(textarea){
  let input = textarea.value;
  try{
    input = input.replace(/(\n|.+)\n/g, newLineReplacer);
    input = input.replace(/(\*\w*\s*\w*\*)/g, boldReplacer);
    input = input.replace(/(#+)+\s(.+)(\n|<br>)/g, headerReplacer);
  } catch(err){
  // input = err
  }
  document.getElementById('output').innerHTML = input;
}

// //parse pure html text
// function fun(textarea){
//   let input = textarea.value;
//   document.getElementById('output').innerHTML = input;
// }