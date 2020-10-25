var list = null;
var listBody = null;
var items = null;
var dragging, draggedOver;
var userActions = [];

$(document).on('turbolinks:load', async ()=>{
  $('#list-container').ready(function(){
    // buildListAndShowLoading();
    // on ajax success
    // loadedAndBuildList();
    // renderItems(items);
  })
})

function buildListAndShowLoading(id){
  list = document.createElement('div');
  list.classList.add('list');
  list.id = id;
  list.innerHTML = '';
  list.classList.add("loading");
}

function renderItems(data){
  listBody.innerText = '';
  data.forEach(item=>{
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
    itemNum.innerText = item.id;

    var itemName = document.createElement("span");
    itemName.classList.add("item-name");
    itemName.classList.add("notosans");
    itemName.innerText = item.name;

    var itemSelect = document.createElement("span");
    itemSelect.classList.add("item-show-toggle");

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

function compare(e){
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
function setDragging(e){
  dragging = parseInt(e.target.querySelector('.item-num').innerText)
}

function showGrabbingcursor(ev){
  ev.target.classList.add("grabbing")
}

function hideGrabbingcursor(ev){
  ev.target.classList.remove("grabbing")
}