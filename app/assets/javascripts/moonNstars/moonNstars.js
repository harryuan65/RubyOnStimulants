var start_point = 1200;
var moon_size = 100;
var star_sizes = [25,30,20,33,18];
var time = [3400,3000,3100,3200,3300,3500];
var tops = [120,150,170,131,180,200];
var x = ['80%','40%','50%','60%','70%','90%'];
var opacity= 1;
$(document).ready(function(){

  if (window.matchMedia('screen and (max-width: 500px)').matches) {
    console.log("window: detected resize");
    tops = tops.map(pe=>pe-40);
    console.log("Top: Changed to")
    tops.forEach(e=>{
      console.log(e)
    })

    console.log("x:Changed to")
    x = x.map(e=>`${parseInt(e.split('%')[0])-20}%`);
    x.forEach(e=>{
      console.log(e)
    })
    console.log("size:changed to")
    moon_size *= 0.5;
    console.log(moon_size);
    console.log("size:changed to")
    star_sizes = star_sizes.map(s=>s*0.5);
    star_sizes.forEach(s=>{
      console.log(s);
    })
  }

  $("#moon").css({
    position:'absolute',
    top:start_point,
    left: x[0],
    height: moon_size,
    width: moon_size,
    opacity: opacity
  });

  $("#moon").animate({
       top: [tops[0],"easeOutBack"],
     }, time[0],
     function(){
      //  console.log("moon finished");
       $(this).trigger('shine');
      }
  )

  $("#moon").on('shine',function(){
    $(this).get(0).style.setProperty('--shadow','20px');
    $(this).css({'animation':`shine ${Math.random()+5}s ease-in-out alternate infinite`})
    // console.log('moon has set shine')
  })

  for(let i = 0; i < 5; i++){
      $(`#star-${i}`).css({
        position:'absolute' ,
        top:start_point,
        left:x[i+1],
        height:star_sizes[i],
        width: star_sizes[i],
        opacity: opacity
      });
      $(`#star-${i}`).animate({
          top: [tops[i+1],"easeOutBack"],
         }, time[i+1],
         function(){
          // console.log(`star-${i} finished`);
          $(this).trigger('shine');
         }
      )

      $(`#star-${i}`).on('shine',function(){
        let random_deg = (Math.random()*360 + 40)*((Math.random()>=0.5)? 1:-1);
        console.log(`${random_deg}`);
         $(this).get(0).style.setProperty('--d',`${random_deg}deg`);
         $(this).get(0).style.setProperty('--shadow',`20px`);
         $(this).css({'animation':`shine-rotate ${Math.random()+5}s ease-in-out alternate infinite`})
          // console.log(`star-${i} has set shine`)
      })
  }

})