var draggingItem, draggedOverItem;
var removeOtherListsVersion = true;
var savedListNamesMapping = {};
var currentData = {};
(function( $ ){
  $.fn.setSelectedList = function() {
    let list = this;
    list.addClass('selected');
    $(".list-row", list).addClass("grow");
    $(".section-content-container").addClass('jc');
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
  $.fn.updateListByData = function(listData, isNew=false){
    let list = this;
    let {id, name, bg_color} = listData;
    $('.list-name', list).val(name);

    if(bg_color){list.css('background-color', bg_color);}
    if(isNew){
      list.prop('id', `list-${id}`);
      let listBody = list.find('.list-body');
      listBody.before(`<a class="delete-list text-t3" data-remote="true" rel="nofollow" data-method="delete" href="/to_do_lists/${id}">✕</a>`);
      renderItems(`${id}`, []);
    }

    list.setLoading(false);
    saveListNameMapping(); // update restoration mapping;
  }
  $.fn.setCreateListByName = function(){
    let newList = this;
    let newListName = $("input[type='text'].list-name", newList);

    newListName.focusout(function(event){
      let newListName = $(event.target);

      let inputName = newListName.val();
      if(inputName.length>0){
        // console.log('create with ', inputName);
        // ajax to create list
        newList.setLoading(true);

        $.ajax({
          method: "POST",
          url: "/to_do_lists",
          data: {name: inputName},
          dataType: "json"
        })
        .done(function(data){
          // console.log(JSON.stringify(data, null, 2));
          if(data.success){
            let listData = data.list;
            currentData[listData.id] = [];
            newList.updateListByData(listData, true);
            setFlash(true, data.flash);
          }else{
            alert(data.error);
          }
        })
        .fail(function(jqXHR){
          let errorMsg = jqXHR.responseJSON.error;

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
      if(inputName===savedListNamesMapping[listId]){
        return;
      }
      listId = parseInt(listId);

      list.setLoading(true);
      $.ajax({
        method: "PUT",
        url: `/to_do_lists/${listId}`,
        data: {name: inputName},
        dataType: "json"
      })
      .done(function({flash, list, error}){
        if(data.success){
          let listData = list;
          list.updateListByData(listData);
          setFlash(true, flash);
        }else{
          alert(error);
        }
      })
      .fail(function(jqXHR){
        let errorMsg = jqXHR.responseJSON.error;
        // update failed, restore list name
        let listIdStr = list.prop('id').split('list-')[1];

        listName.val(savedListNamesMapping[listIdStr]);
        setFlash(false, errorMsg);
        list.setLoading(false);
      })
    })
  }
  $.fn.updateListItemByData = function(item){
    // {id, name, position, to_do_list_id, state, description, due_date}
    // console.log(`Updateing ListRow: id:${id}, name:${name}, position:${position}`)
    let listRow = $(this);
    let itemName = $('.item-name', listRow);
    itemName.text(item.name);
    itemName.attr('data-current', item.name);

    let currentListItemData = currentData[item.to_do_list_id].find(e=>{return e.id===item.id});
    currentData[item.to_do_list_id].splice(currentData[item.to_do_list_id].indexOf(currentListItemData), 1, Object.assign(item, {i: currentListItemData.i}));
    //TODO: Update other attributes
  }
  $.fn.setCreateUpdateItemByName = function(to_do_list_id){
    let listRow = this;
    // console.log(list);
    let listItemName = $('.item-name', listRow);
    //注意這邊是設定全部。
    // listItemName.prop('original-text', currentText);

    listItemName.blur(function(event){
      //注意item-id 在listRow上面，但是要更新的值還有比較的attr: data-current在listName裡面。
      let updatedItemName = $(event.target);
      let newInput = updatedItemName.text(),
          dataCurrent = updatedItemName.attr('data-current');
      // console.log(`newInput:${newInput}, dataCurrent: ${dataCurrent}`);

      if (newInput !== dataCurrent){
        let list = $(`#list-${to_do_list_id}`);
        list.setLoading(true);
        if(listRow.attr('id')==="item-new"){
          let params = {method: "POST", url: `/to_do_lists/${to_do_list_id}/to_do_items`, data: {to_do_item: {name: newInput}}}
          $.ajax(Object.assign(params, {dataType: "json"}))
          .done(function({flash, item, error}){
            // 沿用createItemRow!
            let newListRow = createItemRow(Object.assign(item,{to_do_list_id, i: currentData[to_do_list_id].length}));
            $(newListRow).setCreateUpdateItemByName(to_do_list_id);
            currentData[to_do_list_id].splice(currentData[to_do_list_id].length-1, 0 ,item);
            listRow.before(newListRow);

            setFlash(true, flash);
            list.setLoading(false);
            updatedItemName.text(''); //新增完後，+的row要清空留著
          })
          .fail(function(jqXHR){
            let errorMsg = jqXHR.responseJSON.error;
            setFlash(false, errorMsg);
            list.setLoading(false);
            updatedItemName.text('');
          })
          // console.log("to create with ", JSON.stringify(params, null, 2));
        }
        else{
          let itemId = parseInt(listRow.attr('id').split('item-')[1]);
          if(newInput==""){
            let params = {method: "DELETE", url: `/to_do_lists/${to_do_list_id}/to_do_items/${itemId}`}
            // console.log("to delete with ", JSON.stringify(params, null, 2));
            $.ajax(Object.assign(params, {dataType: "json"}))
            .done(function({flash, item, error}){
              // console.log(JSON.stringify({flash, item, error}, null, 2));
              listRow.remove();
              currentData[to_do_list_id].splice(currentData[to_do_list_id].indexOf(currentData[to_do_list_id].find(e=>{return e.id===item.id})), 1);
              setFlash(true, flash);
              list.setLoading(false);
            })
            .fail(function(jqXHR){
              // console.log(JSON.stringify(jqXHR, null ,2))
              let errorMsg = jqXHR.responseJSON.error;
              setFlash(false, errorMsg);
              list.setLoading(false);
              updatedItemName.text(dataCurrent);
            })
          }
          else{
            let params = {method: "PUT", url: `/to_do_lists/${to_do_list_id}/to_do_items/${itemId}`, data: {to_do_item: {name: newInput}}}
            // console.log("to update with ", JSON.stringify(params, null, 2));
            $.ajax(Object.assign(params, {dataType: "json"}))
            .done(function({flash, item, error}){
              // console.log(JSON.stringify({flash, item, error}, null, 2));
              listRow.updateListItemByData(item);
              setFlash(true, flash);
              list.setLoading(false);
            })
            .fail(function(jqXHR){
              // console.log(JSON.stringify(jqXHR, null ,2))
              let errorMsg = jqXHR.responseJSON.error;
              setFlash(false, errorMsg);
              list.setLoading(false);
              updatedItemName.text(dataCurrent);
            })
          }
        }
      }
    })
  }
})( jQuery );

function Init(){
  $('#list-container').removeClass("has-selected-list");
  renderAllItems();
  setUpSelectList();
  setUpNewListAction();
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
    selectedList.addClass('ready-select');

    if(removeOtherListsVersion){
      //fade out others and delete
      $(".list:not(.selected):not(.ready-select)").removeList();
    }
    selectedList.setSelectedList();
  })
}
function setUpNewListAction(){
  // on: fires on enery new event
  // one: fires only once
  $("#list-new").one('click', function(){
    let newList = $(this);
    $('.content', newList).removeClass("empty-with-a-plus");
    $('.add-new-list', newList).toggle();

    let newListName = $('<input type="text" name="name" class="list-name font text-t2" autocomplete="off" placeholder="New List Name"/>');
    newList.prepend(newListName);
    newList.setCreateListByName();
    newListName.focus();
  });

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
function createItemRow({to_do_list_id, id, name, due_date, description, state, unDraggable, i}){
  var list = document.getElementById(`list-${to_do_list_id}`);
  var listRow = document.createElement("div");
  var listRowTop = document.createElement("div");
  var listRowBottom = document.createElement("div");

  if(list.classList.contains("selected")){
    listRow.classList.add("grow");
  }
  listRow.classList.add("list-row");
  listRow.id = `item-${id}`;

  listRowTop.classList.add('list-row__top');
  listRowBottom.classList.add('list-row__bottom');
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
  itemNum.innerText = i!=-1 ? i : '+' ;

  var itemName = document.createElement("span");
  itemName.classList.add("item-name");
  itemName.classList.add("notosans");
  itemName.contentEditable = true;
  itemName.setAttribute('data-current', name);
  // console.log(`Setting Item ${itemNum.innerText} of ${listRow.id} to:`, typeof(itemName.getAttribute('data-current')));
  itemName.innerText = name;

  var itemSelect = document.createElement("span");
  itemSelect.classList.add("item-show-toggle");
  if(!unDraggable){
    itemSelect.onclick = (e)=>{
      let itemSelect = e.target;
      let parent = itemSelect.parentNode.parentNode;
      let seletedRowBottom = document.querySelectorAll('.list-row__bottom.selected')
      let selectedShowToggle = document.querySelectorAll('.item-show-toggle.selected')
      console.log(seletedRowBottom.length)
      if(itemSelect.classList.contains('selected')){
        seletedRowBottom.forEach(e=>{e.classList.remove('selected')});
        selectedShowToggle.forEach(e=>{e.classList.remove('selected')});
      }else{
        seletedRowBottom.forEach(e=>{e.classList.remove('selected')});
        selectedShowToggle.forEach(e=>{e.classList.remove('selected')});
        itemSelect.classList.add('selected');
        parent.querySelector('.list-row__bottom').classList.add('selected');
      }
    }
  }

  itemDrag.addEventListener('mousedown', showGrabbingCursor)
  itemDrag.addEventListener('mouseup', hideGrabbingCursor)

  listRowTop.appendChild(itemDrag);
  listRowTop.appendChild(itemNum);
  listRowTop.appendChild(itemCheck);
  listRowTop.appendChild(itemName);
  listRowTop.appendChild(itemSelect);

  var testNode = document.createElement('div');
  testNode.innerHTML = `
    <ul>
      <li>時間：${due_date}</li>
      <li>備註：${description}</li>
      <li>狀態：${state}</li>
    </ul>
  `;
  listRowBottom.appendChild(testNode);
  listRow.appendChild(listRowTop)
  listRow.appendChild(listRowBottom);
  // console.log("List Id is ", to_do_list_id)
  $(listRow).setCreateUpdateItemByName(to_do_list_id);
  if(!unDraggable){
    $(listRow).draggable({
      drag: function(ev){setDragging(ev, currentData[to_do_list_id])},
      stop: function(ev){
        renderItems(to_do_list_id, currentData[to_do_list_id])
      },
      axis: "y",
      cancel: '.list-row > .list-row__up, .list-row > .list-row__bottom, .list-row .item-check, .list-row .item-name, .list-row .item-show-toggle', // use this to keep children from being dragged and disabled(cannot select, etc.)
    })
    $(listRow).droppable({
      over: function(ev){draggingOver(ev, currentData[to_do_list_id])},
      out: draggingOut,
      drop: function(ev){compare(to_do_list_id, currentData[to_do_list_id])}
    });
  }
  return listRow;
}
function saveItem(list_id, data){
  currentData[list_id] = data;
}
function renderAllItems(){
  for(const [key, value] of Object.entries(currentData) ){
    renderItems(key, value);
  }
}
function renderItems(list_id, data){
  list = document.getElementById(`list-${list_id}`);
  if(list==null){
    delete currentData[list_id];
    return;
  }
  listBodyContent = list.querySelector('.list-body .body-content-base.content');
  listBodyContent.innerText = '';

  // push an empty item for new
  if(!data.find(e=>{return e.unDraggable===true})){
    data.push({unDraggable: true, to_do_list_id: list_id, id: 'new', name: '', i:-1});
  }

  let i = 1;
  data.forEach(item=>{
    let itemWithI = item.i==-1 ? item : Object.assign(item, {i: i});
    var listRow = createItemRow(itemWithI);
    listBodyContent.appendChild(listRow);
    i++;
  })
  dragging = null
  draggedOver = null

}
function compare(to_do_list_id, dataInTheList){
  var index1 = dataInTheList.indexOf(draggingItem);
  var index2 = dataInTheList.indexOf(draggedOverItem);
  console.log(`draggingItem=${draggingItem.id} ${draggingItem.name} (${draggingItem.i}), draggedOverItem=${draggedOverItem.id} ${draggedOverItem.name} (${draggedOverItem.i})`);

  let list = $(`list-${draggingItem.to_do_list_id}`);
  list.setLoading(false);
  $.ajax({
    method:"POST",
    url: `/to_do_lists/${draggingItem.to_do_list_id}/to_do_items/${draggingItem.id}/update_position`,
    data: {position: index2+1},
    dataType: "json"
  })
  .done(function(data){
    // console.log("ITEMS:r");
    // console.log(JSON.stringify(draggingItem, null ,2));
    // console.log(JSON.stringify(draggedOverItem, null ,2));
    if(parseInt(draggingItem.to_do_list_id)!==parseInt(draggedOverItem.to_do_list_id)){return ;}

    dataInTheList.splice(index1, 1)//把dragging從array刪掉
    dataInTheList.splice(index2, 0, draggingItem) //insert dragging到draggedOver的位置

    list_id = draggingItem.to_do_list_id;

    renderItems(list_id, dataInTheList);
    setFlash(true, data.flash);
  })
  .fail(function(jqXHR){
    let errorMsg = jqXHR.responseJSON.error;
    setFlash(false, errorMsg);
    list.setLoading(false);
    renderItems(list_id, dataInTheList);
  })
};

function draggingOver(ev, data) {
  ev.preventDefault();
  var listRowBeingOver = ev.target;
  let i = parseInt(listRowBeingOver.querySelector('.item-num').innerText);
  draggedOverItem = data.find(obj=>{return obj.i===i});
  // console.log(JSON.stringify(draggedOverItem, null ,2));

  listRowBeingOver.classList.add("covering")
  //add the border while dragging over something
  // let ids = data.map(e=>e.position);
  if (data.indexOf(draggedOverItem) < data.indexOf(draggingItem)){
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
function setDragging(ev, data){
  let i = parseInt(ev.target.querySelector('.item-num').innerText);
  draggingItem = data.find(e=>{return e.i===i});
  // console.log(JSON.stringify(draggingItem, null ,2));
}

function showGrabbingCursor(ev){
  ev.target.classList.add("grabbing")
}

function hideGrabbingCursor(ev){
  ev.target.classList.remove("grabbing")
}

function debugObject(obj){
  return JSON.stringify(obj, null, 2);
}