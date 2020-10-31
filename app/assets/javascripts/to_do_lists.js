var dragging, draggedOver;
var removeOtherListsVersion = true;
var savedListNamesMapping = {};
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
  $.fn.setLoading = function(isLoading){
    let list = this;
    let listName = $('.list-name', list);
    listName.prop('disabled', isLoading);

    let listBody = $('.list-body', list);
    let content = $('.content', listBody);
    let mask = $('.mask', listBody);

    let current = isLoading ? content : mask, //現在要是isLoading就代表content是被display的
        other = !isLoading ? content : mask;
    // console.log("current is ", current.prop('class'), "other is ", other.prop('class'));

    current.removeClass("display");
    other.addClass("display");
  }
  $.fn.updateByData = function(isNew=false, listData){
    let list = this;
    let {id, name, bgColor} = listData;
    $('.list-name', list).val(name);

    if(bgColor){list.css('background-color', bgColor);}
    if(isNew){
      list.prop('id', `list-${id}`);
      renderItems(`${id}`, []);
    }

    list.setLoading(false);
  }
  $.fn.setCreateListByName = function(){
    let newList = this;
    let newListName = $("input[type='text'].list-name", newList);

    newListName.focusout(function(event){
      let newListName = $(event.target);

      let inputName = newListName.val();
      if(inputName.length>0){
        console.log('create with ', inputName);
        // ajax to create list
        newList.setLoading(true);

        $.ajax({
          method: "POST",
          url: "/to_do_lists",
          data: {name: inputName},
          dataType: "json"
        })
        .done(function(data){
          console.log(JSON.stringify(data, null, 2));
          if(data.success){
            let listData = data.list;
            newList.updateByData(true, listData);
            setFlash(true, data.flash);
          }else{
            alert(data.error);
          }
        })
        .fail(function(jqXHR){
          let errorMsg = jqXHR.responseJSON.error;
          // console.error(JSON.stringify(jqXHR.responseJSON, null, 2));
          setFlash(false, errorMsg);
          newList.setLoading(false);
        })
      }
    })
  }
  $.fn.setUpdateListName = function(){
    let list = this;
    let listName = $('.list-name', list);
    listName.focusout(function(event){
      let listName = $(event.target);
      let inputName = listName.val();
      let listId = list.prop('id').split("list-")[1];
      console.log(`listId=${listId}`);
      listId = parseInt(listId);

      list.setLoading(true);
      $.ajax({
        method: "PUT",
        url: `/to_do_lists/${listId}`,
        data: {name: inputName},
        dataType: "json"
      })
      .done(function(data){
        console.log(JSON.stringify(data, null, 2));
        if(data.success){
          let listData = data.list;
          list.updateByData(listData);
          setFlash(true, data.flash);
        }else{
          alert(data.error);
        }
      })
      .fail(function(jqXHR){
        let errorMsg = jqXHR.responseJSON.error;
        // update failed, restore list name
        let listIdStr = list.prop('id').split('list-')[1];
        alert(`restoring ${listIdStr}`);
        listName.val(savedListNamesMapping[listIdStr]);
        setFlash(false, errorMsg);
        list.setLoading(false);
      })
    })
  }
})( jQuery );
function pretendToLoadNewList(){
  // fuck you and i will see you tomorrow
  // $('#list-new').animate({backgroundColor: "#daf7a6"},2000,function(ev){$(ev.target).setLoading(false);});

  $('#list-new').css('background-color', "#daf7a6");
  $('#list-new').setLoading(false);
}
function setUpListener(){
  setUpSelectList();
  setUpNewListAction();
  setUpListEditEvents();
  saveListNameMapping();
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

    $(".list.selected").unsetSelectedList();
    selectedList.setSelectedList();

    if(removeOtherListsVersion){
      //fade out others and delete
      $(".list:not(.selected)").removeList();
    }
  })
}
function setUpNewListAction(){
  // on: fires on enery new event
  // one: fires only once
  $("#list-new").one('click', function(){
    let newList = $(this);
    $('.content', newList).removeClass("empty-with-a-plus")
    $('.add-new-list', newList).toggle();

    let newListName = $('<input type="text" name="name" class="list-name notosans text-2b" autocomplete="off" placeholder="New List Name"/>');
    newList.prepend(newListName);
    newList.setCreateListByName();
    // renderItems('new', []);
    newListName.focus();
  })
  // $("#list-new").on('click', function(){
  //   let newList = $(this);
  //   let newListName = $("input[type='text'].list-name", newList);
  //   newListName.focus();
  // })
}
function setUpListEditEvents(){
  // 這樣是錯的: $(".list:not(#list-new)").setUpdateListName();
  //自己定義的個別function，就要個別處理。不然大家都吃到第一個list
  $(".list:not(#list-new)").each(function(){
    let list = $(this);
    list.setUpdateListName();
  })
}
function saveListNameMapping(){
  // set saved list names mapping for restoration;
  $('.list').each(function(){
    let list = $(this);
    let listName = $('.list-name', list);
    let listIdStr = list.prop('id').split('list-')[1];
    savedListNamesMapping[listIdStr] = listName.val();
  })
}
function renderItems(list_id, data){
  // console.log(JSON.stringify(data, null, 2));
  list = document.getElementById(`list-${list_id}`);
  listBodyContent = list.querySelector('.list-body .body-content-base.content');
  listBodyContent.innerText = '';
  // listBodyContent.style.backgroundColor = list.style.backgroundColor; // 確保ToDoItem有背景顏色，才不會一開始loading就被透過來看到（其實loading在下面)
  // push an empty item for new
  if(!data.find(e=>{return e.unDraggable===true})){
    data.push({unDraggable: true, position: '+', name: ''});
  }

  data.forEach(item=>{
    var listRow = document.createElement("div");
    listRow.classList.add("list-row");
    listRow.id = item.id;

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
    itemNum.innerText = item.position;

    var itemName = document.createElement("span");
    itemName.classList.add("item-name");
    itemName.classList.add("notosans");
    itemName.contentEditable = true;
    itemName.setAttribute('data-current', '');
    itemName.onblur = (event)=>{
      let itemName = event.target;
      let nameText = itemName.innerText;
      if(nameText===itemName.getAttribute('data-current')){
      }else{
        itemName.setAttribute('data-current', nameText);
        console.log(`new itemName${listRow.id} value is ${nameText}`);
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

    listBodyContent.appendChild(listRow)

    if(list.classList.contains("selected")){
      listRow.classList.add("grow");
    }

    if(item.unDraggable){return;}

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

}

function compare(dataInTheList){
  draggingItem = dataInTheList.find(obj => obj.position==dragging);
  draggedOverItem = dataInTheList.find(obj => obj.position==draggedOver);
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
  let ids = data.map(e=>e.position);
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
}

function showGrabbingCursor(ev){
  ev.target.classList.add("grabbing")
}

function hideGrabbingCursor(ev){
  ev.target.classList.remove("grabbing")
}