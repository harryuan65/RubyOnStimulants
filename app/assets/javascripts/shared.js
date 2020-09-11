function reverseAnimation(this_obj){
    console.log("Reversing...")
    setTimeout( ()=>{
       this_obj.style.animation = "alert-backwards 1s forwards running";
    }, 3000);
}