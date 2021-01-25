function toggleRotate(element) {
  element.classList.toggle("rotate");
}
function toggleForm() {
  var FormWrap = document.getElementById("wrap-dropdown-form");
  if (FormWrap.classList.contains("show")) {
    FormWrap.classList.add("out");
    FormWrap.addEventListener("animationend", stopAnimation);
  } else {
    FormWrap.classList.add("show");
  }
}
function stopAnimation(event) {
  var e = event.target;
  e.classList.remove("out");
  e.classList.remove("show");
  e.classList.add("in");
  e.removeEventListener("animationend", stopAnimation);
}
