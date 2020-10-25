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
var list = null;
var listBody = null;
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
  list = document.getElementById('list');
  listBody = document.getElementById('list-body');
  listBodyLoading = document.getElementById('loading-body');
  list.classList.add("loading");
})
const devLoaded = ()=>{
  if (!list){
    alert("List is not defined yet!(DOM not loaded)")
    return;
  }

  list.id = `list-${parseInt(Math.random() * 20)}`; // dummy id

  listBody.classList.add("fade-out");

  setTimeout(function(){
    listBodyLoading.remove();
    renderItems(customNums);
    listBody.classList.remove("fade-out");
    listBody.classList.add("fade-in");
  }, 1500);

  setTimeout(function(){
    list.classList.remove("loading");
  }, 1500);
}
const shuffle = (numbers) => {
  return numbers.sort(() => Math.random() - 0.5)
}

const renderItems = (data) =>{
  listBody.innerText = '';
  data.forEach(num=>{
    var listRow = document.createElement("div");
    listRow.classList.add("list-row");

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
    itemName.contentEditable = true; // test~~~

    var itemSelect = document.createElement("span");
    itemSelect.classList.add("item-show-toggle");

    // itemDrag.draggable = true
    // itemDrag.addEventListener('drag', setDragging)
    // itemDrag.addEventListener('dragover', draggingOver)
    // itemDrag.addEventListener('drop', compare)
    itemDrag.addEventListener('mousedown', showGrabbingcursor)
    itemDrag.addEventListener('mouseup', hideGrabbingcursor)

    listRow.appendChild(itemDrag);
    listRow.appendChild(itemNum);
    listRow.appendChild(itemCheck);
    listRow.appendChild(itemName);
    listRow.appendChild(itemSelect);

    listBody.appendChild(listRow)

    //this is so convenient
    //https://api.jqueryui.com/draggable/

    // listRow.draggable = true
    // listRow.addEventListener('drag', setDragging)
    // listRow.addEventListener('dragend', (ev)=>{renderItems(customNums)})

    // listRow.addEventListener('dragover', draggingOver)
    // listRow.addEventListener('dragenter', draggingOver)
    // listRow.addEventListener('dragleave', draggingOut)
    // listRow.addEventListener('drop', compare)
    $(listRow).draggable({
      drag: setDragging,
      stop: function(ev){
        renderItems(customNums)
      },
      cancel: '.list-row > .item-check, .list-row > .item-name, .list-row > .item-show-toggle', // use this to keep children from being dragged and disabled(cannot select, etc.)
    })
    $(listRow).droppable({
      over: draggingOver,
      out: draggingOut,
      drop: compare
    });
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

function draggingOver(ev) {
  ev.preventDefault();
  var listRowBeingOver = ev.target;
  draggedOver = parseInt(listRowBeingOver.querySelector('.item-num').innerText)
  listRowBeingOver.classList.add("covering")

  //add the border while dragging over something
  if (customNums.indexOf(draggedOver) < customNums.indexOf(dragging)){
    listRowBeingOver.classList.add("will-insert-before")
  }
  else{
    listRowBeingOver.classList.add("will-insert-after")
  }
}
function draggingOut(ev){
  var listRowOuting = ev.target;

  //remove transparency on the listRow leaving
  listRowOuting.classList.remove("covering");

  //remove all borders on the listRow leaving
  listRowOuting.classList.remove("will-insert-before");
  listRowOuting.classList.remove("will-insert-after");
}
const setDragging = (e) =>{
  dragging = parseInt(e.target.querySelector('.item-num').innerText)
}

const showGrabbingcursor = (ev) =>{
  ev.target.classList.add("grabbing")
}

const hideGrabbingcursor = (ev) =>{
  ev.target.classList.remove("grabbing")
}