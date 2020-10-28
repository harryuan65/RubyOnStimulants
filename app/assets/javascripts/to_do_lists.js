var dragging, draggedOver;
var removeOtherListsVersion = false;
(function( $ ){
  $.fn.setSelectedList = function() {
    let list = this;
    list.addClass('selected');
    $(".list-row", list).addClass("grow");
  };

  $.fn.unsetSelectedList = function() {
    let list = this;
    list.removeClass('selected');
    $(".list-row", list).removeClass("grow");
  };
  $.fn.removeList = function(){
    let list = this;
    list.addClass("list-before-delete");
    list.on('animationend', ()=>{
      list.remove();
    })
  }
})( jQuery );

function setUpListener(){
  setUpSelectList();
  setUpNewListAction();
  // $('input[type="checkbox"].item-check').on('change', function(e){
  //   let checkbox = $(this);
  //   // TODO: ajax
  //   if(checkbox.checked){
  //     true;
  //   }
  //   else{
  //     false;
  //   }
  // })
}
function setUpSelectList(){
  $(".list").on('click', function(){
    let selectedList = $(this);

    if(removeOtherListsVersion){
      //fade out others and delete
      $(".list:not(.selected)").removeList();
    }
    else{
      $(".list.selected").unsetSelectedList();
      selectedList.setSelectedList();
    }
    selectedList.setSelectedList();
  })
}
function setUpNewListAction(){
  // on: fires on enery new event
  // one: fires only once
  $("#list-new").one('click', function(){
    let newList = $(this);
    newList.removeClass("empty-flex-center");
    $('.add-new-list', newList).remove();
    let newListName = $('<input type="text" name="name" class="list-name notosans text-2b" autocomplete="off" placeholder="New List Name"/>');

    newList.prepend(newListName);
    renderItems('new', []);
    newListName.focus();
  })
}
function renderItems(list_id, data){
  console.log(JSON.stringify(data, null, 2));
  list = document.getElementById(`list-${list_id}`);
  listBody = list.querySelector('.list-body');
  listBody.innerText = '';

  // push an empty item for new
  data.push({id: '+', name: ''});

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
    itemName.contentEditable = true;
    itemName.setAttribute('data-current', '');
    itemName.onblur = (event)=>{
      let itemName = event.target;
      let nameText = itemName.innerText;
      if(nameText===itemName.getAttribute('data-current')){
        console.log('no change');
      }else{
        itemName.setAttribute('data-current', nameText);
        console.log('new value');
      }
    };
    itemName.innerText = item.name;

    var itemSelect = document.createElement("span");
    itemSelect.classList.add("item-show-toggle");

    itemDrag.addEventListener('mousedown', showGrabbingCursor)
    itemDrag.addEventListener('mouseup', hideGrabbingCursor)

    listRow.appendChild(itemDrag);
    listRow.appendChild(itemNum);
    listRow.appendChild(itemCheck);
    listRow.appendChild(itemName);
    listRow.appendChild(itemSelect);

    listBody.appendChild(listRow)

    if(list.classList.contains("selected")){
      listRow.classList.add("grow");
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

function showGrabbingCursor(ev){
  ev.target.classList.add("grabbing")
}

function hideGrabbingCursor(ev){
  ev.target.classList.remove("grabbing")
}