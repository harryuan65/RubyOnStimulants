var fetchPage = true;
var previewLength = 0;
var contentChanged = false;
var map = {};
document.addEventListener('DOMContentLoaded', ()=>{
  //detect two consecutive keys press
  document.onkeyup = (e)=>{
    e = e || window.event;
    map[e.key] = e.type == "keydown";
    map = {}
  }
  document.onkeydown = (e)=>{
    e = e || window.event;
    map[e.key] = e.type == "keydown";
    // console.log(e.type)
    // console.log(e.altKey)
    // console.log(map)
    if (map["Alt"] && map["∂"]){
      toggleDarkMode();
    }
  }
})
function toggleDarkMode(){
  document.documentElement.classList.toggle('dark-mode');
  document.querySelectorAll('.no-dark').forEach(e=>{
    e.classList.toggle('invert-again');
  })
}
function foldAlert(this_obj){
    // console.log("Reversing...")
    setTimeout( ()=>{
       this_obj.style.animation = "alert-backwards 1s forwards running";
    }, 3000);
}
function toggleSideNav(forceClose=false){
  let navSide = document.getElementById('nav-side');
  let toggle = document.getElementById('nav-side-toggle');
  if(forceClose){
    navSide.classList.remove('active');
    toggle.classList.remove('active');
  }
  else{
    navSide.classList.toggle('active');
    toggle.classList.toggle('active');
  }
}
function openConfirm(event){
  event.preventDefault();
  document.getElementById('confirm-bkg').classList.toggle('show');
}
function closeConfirm(){
  document.getElementById('confirm-bkg').classList.remove('show');
}
function changePage(event){
  // TODO
  event.preventDefault();
  toggleSideNav();
  let url = event.target.getAttribute('href');
  console.log(url);
  $.get(url, (resText)=>{
    // var find = $('#main', resText); //this jquery object's context is undefined, causing find.length=0
    var find = $(resText).filter('#main'); //equals to the above
    console.log(find.length);
    console.log(find);
    if (find.length>0){
      console.log("Replacing new element");
      $('#main').replaceWith(find);
    }
  })
}



//mockup todolist


// drag and append list
var list = null;
var nums = [0, 1, 2, 3, 4, 5, 6];
var dragging, draggedOver;
var customNums = [0, 1, 2, 3, 4, 5, 6];
var tasks = ["Lorem ipsum",
              "Dolorum",
              "Ut voluptates",
              "Adipisci",
              "Dolore",
              "Id omnis",
              "Accusantium",
              "Quam laborum",
              "Iste molestias",
              "Corporis"
            ]
var userActions = [];

document.addEventListener('DOMContentLoaded',()=>{
  list = document.getElementById('list')
  // customNums = shuffle(nums);
  renderItems(customNums);
})

const shuffle = (numbers) => {
  return numbers.sort(() => Math.random() - 0.5)
}

const renderItems = (data) =>{
  list.innerText = ''
  data.forEach(num=>{
    var listRow = document.createElement("div");
    listRow.classList.add("list-row");
    listRow.draggable = true;//test

    var itemDrag = document.createElement("span");
    itemDrag.classList.add("item-drag");
    var dragTextnode = document.createTextNode("\u2630")
    itemDrag.appendChild(dragTextnode);

    var itemCheck = document.createElement("input");
    itemCheck.setAttribute('type', 'checkbox')
    itemCheck.classList.add("item-check");

    var itemNum = document.createElement("span");
    itemNum.classList.add("item-num");
    itemNum.classList.add("notosans");
    itemNum.innerText = `${num}`;

    var itemName = document.createElement("span");
    itemName.classList.add("item-name");
    itemName.classList.add("notosans");
    itemName.innerText = tasks[num];

    var itemSelect = document.createElement("span");
    itemSelect.classList.add("item-show-toggle");

    itemDrag.draggable = true
    itemDrag.addEventListener('drag', setDragging)
    itemDrag.addEventListener('dragover', allowDrop)
    itemDrag.addEventListener('drop', compare)
    itemDrag.addEventListener('mousedown', showGrabbingcursor)
    itemDrag.addEventListener('mouseup', hideGrabbingcursor)

    listRow.appendChild(itemDrag);
    listRow.appendChild(itemNum);
    listRow.appendChild(itemCheck);
    listRow.appendChild(itemName);
    listRow.appendChild(itemSelect);

    list.appendChild(listRow)
  })
  dragging = null
  draggedOver = null

  console.log("Current numbers:", customNums);
}

const compare = (e) =>{
  console.log(draggedOver);
  var index1 = customNums.indexOf(dragging);
  var index2 = customNums.indexOf(draggedOver);
  customNums.splice(index1, 1)//把dragging從array刪掉
  customNums.splice(index2, 0, dragging) //insert dragging到draggedOver的位置

  renderItems(customNums)
};

function allowDrop(ev) {
  ev.preventDefault();
  draggedOver = parseInt(ev.target.parentNode.querySelector('.item-num').innerText)
}

const setDragging = (e) =>{
  dragging = parseInt(e.target.parentNode.querySelector('.item-num').innerText)
}

const showGrabbingcursor = (ev) =>{
  ev.target.classList.add("grabbing")
}

const hideGrabbingcursor = (ev) =>{
  ev.target.classList.remove("grabbing")
}