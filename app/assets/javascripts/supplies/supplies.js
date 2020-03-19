$(document).ready(()=>{ //不知道為什麼window.onload不會work
  console.log('success included supplies');
  setTimeout(() => {
    calculate()
  }, 500);
})

function calculate(){
  tr();
  var meal_aday = document.getElementById('meal-aday').value,
      drink_aday = document.getElementById('drink-aday').value,
      cookie_aday = document.getElementById('cookie-aday').value,
      water_aday = document.getElementById('water-aday').value;
      powdered_drink_aday = document.getElementById('powdered_drink-aday').value;

  var total_meal   = parseInt(document.getElementById('meal-quantity').innerHTML);
      total_drink  = parseInt(document.getElementById('drink-quantity').innerHTML),
      total_cookie = parseInt(document.getElementById('cookies-quantity').innerHTML),
      total_water  = parseInt(document.getElementById('water-quantity').innerHTML),
      total_powdered_drink = parseInt(document.getElementById('powdered_drink-quantity').innerHTML);
      console.log(total_meal, total_drink, total_cookie, total_water);
  let min = Math.min(...[total_meal/meal_aday,total_cookie/cookie_aday, total_drink/drink_aday, total_water/water_aday]);
  console.log(min);
  document.getElementById('remain-days').innerHTML = min;
}

function tr(){
  document.getElementById('meal-aday').value = document.getElementById('meal-aday').value.replace(/[^\d]/g,'');
  document.getElementById('cookie-aday').value = document.getElementById('cookie-aday').value.replace(/[^\d]/g,'');
  document.getElementById('drink-aday').value = document.getElementById('drink-aday').value.replace(/[^\d]/g,'');
  document.getElementById('water-aday').value = document.getElementById('water-aday').value.replace(/[^\d]/g,'');
  document.getElementById('powdered_drink-aday').value = document.getElementById('powdered_drink-aday').value.replace(/[^\d]/g,'');
}