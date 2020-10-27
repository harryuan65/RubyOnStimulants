var dragging, draggedOver;

$(document).on('turbolinks:load', async ()=>{
  $('#list-container').ready(function(){
    // setUpListener();
  })
})
function setUpListener(){
  $(".list").on('click', function(){
    let selectedList = $(this);
    list = selectedList; //use loading.js

    //turn off transform via add show class
    selectedList.addClass('selected');
    //fade out others
    $(".list:not(.selected)").addClass("list-before-delete");
    $(".list-row", selectedList).addClass("grow");

    // wait for fading out;
    $(".list:not(.selected)").on('animationend',()=>{
      $(".list:not(.selected)").remove();
    })
  })
}

function renderItems(list_id, data){
  console.log(JSON.stringify(data, null, 2));
  list = document.getElementById(`list-${list_id}`);
  listBody = list.querySelector('.list-body');
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

    if(list.classList.contains("show")){
      listRow.classList.add("in-selected-list");
    }

    $(listRow).draggable({
      drag: setDragging,
      stop: function(ev){
        renderItems(list_id, data)
      },
      cancel: '.list-row > .item-check, .list-row > .item-name, .list-row > .item-show-toggle', // use this to keep children from being dragged and disabled(cannot select, etc.)
    })
    $(listRow).droppable({
      over: function(ev){draggingOver(ev, data)},
      out: draggingOut,
      drop: function(ev){compare(data)}
    });
  })
  dragging = null
  draggedOver = null

  // console.log("Current numbers:", loadedData);
}

function compare(dataInTheList){
  console.log(draggedOver);
  draggingItem = dataInTheList.find(obj => obj.id==dragging);
  draggedOverItem = dataInTheList.find(obj => obj.id==draggedOver);
  if(draggingItem.to_do_list_id!==draggedOverItem.to_do_list_id){return ;}

  var index1 = dataInTheList.indexOf(draggingItem);
  var index2 = dataInTheList.indexOf(draggedOverItem);
  dataInTheList.splice(index1, 1)//把dragging從array刪掉
  dataInTheList.splice(index2, 0, draggingItem) //insert dragging到draggedOver的位置

  list_id = draggingItem.to_do_list_id;
  renderItems(list_id, dataInTheList);
};

function draggingOver(ev, data) {
  ev.preventDefault();
  var listRowBeingOver = ev.target;
  draggedOver = parseInt(listRowBeingOver.querySelector('.item-num').innerText)
  listRowBeingOver.classList.add("covering")
  //add the border while dragging over something
  let ids = data.map(e=>e.id);
  if (ids.indexOf(draggedOver) < ids.indexOf(dragging)){
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
  dragging = parseInt(e.target.querySelector('.item-num').innerText);
  console.log(dragging)
}

function showGrabbingcursor(ev){
  ev.target.classList.add("grabbing")
}

function hideGrabbingcursor(ev){
  ev.target.classList.remove("grabbing")
}