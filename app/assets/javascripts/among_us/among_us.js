var i = [0];
var txt = 'Rails was Not An imposter';
var speed = 20;

function typing(isLast=false){
  var p = document.getElementById("narration");
  p.style.animationPlayState = 'running'
  if(i < txt.length){
      p.innerHTML += txt.charAt(i);
      i++;
      var s = Math.random()*90;
      setTimeout(typing, speed+s);
  }
  else{
    p.style.animationPlayState = 'paused'
    if(isLast) p.style.borderRight = 'none';
  }
}

window.onload = () => {
  setTimeout(typing, 6000);
}