// $(document).ready(function(){
//     // create_stars(10)
// })
// function getRandom(min, max,toRound) {
//     res = Math.random() * (max - min) + min;
//    if (toRound) {return Math.round(res);}
//    else {return res};
// }
// function create_stars(count){
//     console.log(`creating ${count} stars...`)
//     moon = document.getElementById('moon');
//     for(let i = 0;i<count;i++){
//        star = document.createElement('img');
//        star.setAttribute('src',document.getElementById('star-path').firstElementChild.id);
//        star.classList.add('star');
//        star.style.animation = `star-rotate ${getRandom(2,4,false)}s infinite alternate`;
//        starWrap = document.createElement('div');
//        starWrap.style.position = "fixed";
//        starWrap.style.top = getRandom(30,200,true) + 'px';
//        starWrap.style.left = getRandom(400,1000,true) + 'px';
//        starWrap.style.transform = `scale(${getRandom(0.1,0.6,false)})`;
//        starWrap.appendChild(star);
//     //    console.log(`appending on ${star.style.top} ${star.style.left }`)
//        document.body.insertBefore(starWrap,moon);
//     }
// }