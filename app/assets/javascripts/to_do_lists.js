var list = null;
var listBody = null;
var items = null;
var dragging, draggedOver;
var loadedData = [];
var userActions = [];

$(document).on('turbolinks:load', async ()=>{
  $('#list-container').ready(function(){
    setUpListener();
  })
})
function setUpListener(){
  $(".list").on('click', function(){
    let selectedList = $(this);
    list = selectedList; //use loading.js
    let dummyList = $(selectedList).find(".dummy-list");

    //turn off transform via add show class
    selectedList.addClass('show');
    //fade out others
    $(".list:not(.show)").addClass("fade-out");

    // wait for fading out;
    let fadeOutTime = 500;
    let waitTime = fadeOutTime;
    setTimeout(function(){
      $(".list:not(.show)").remove();
    }, fadeOutTime);

    // create list-body, loading-body, append loading-body into list-body
    listBody = document.createElement('div');
    listBody.id = 'list-body';

    loadingBody = document.createElement('div');
    loadingBody.id = "loading-body";

    listBody.append(loadingBody);

    // fade out the dummy list
    waitTime+=fadeOutTime;
    setTimeout(function(){
      dummyList.addClass('fade-out');
    }, waitTime)

    // after dummylist fade out, make list's justify content to center by adding "loading" class
    waitTime+=fadeOutTime;
    setTimeout(function(){
      dummyList.remove();
      selectedList.addClass("loading");

      // append listBody, will show its loading-body spinning
      selectedList.append(listBody);
    }, waitTime);

    let fakeLoadDataTime = 600;
    waitTime+=fakeLoadDataTime;
    setTimeout(function(){
      $.ajax({
        url: `/to_do_lists/${selectedList.attr('id')}`,
        contentType: 'application/json',
        dataType: 'script'
      }).done(function(data){
        selectedList.addClass("loading");
        listBody.classList.add("fade-out");

        setTimeout(function(){
          loadingBody.remove();
          data = JSON.parse(data);
          loadedData = data;
          console.log(data)
          console.log(JSON.stringify(data, null ,2))
          renderItems(data);
          listBody.classList.remove("fade-out");
          listBody.classList.add("fade-in");
        }, 1500);

        setTimeout(function(){
          selectedList.removeClass("loading");
        }, 1500);
      }).fail(function(err){
        alert(err);
      })
    }, waitTime);
  })
}
//dev
// function buildListAndShowLoading(id){
//   list = document.createElement('div');
//   list.classList.add('list');
//   list.id = id;
//   list.innerHTML = '';
//   list.classList.add("loading");
// }

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

    $(listRow).draggable({
      drag: setDragging,
      stop: function(ev){
        renderItems(loadedData)
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

  // console.log("Current numbers:", loadedData);
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