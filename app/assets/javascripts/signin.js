document.addEventListener('DOMContentLoaded', ()=>{
    document.querySelectorAll('input').forEach(element=>{
        element.addEventListener('focus', (e)=>{
            let label = e.target.parentElement.querySelector(".signin-label");
            label.classList.toggle('focus');
            console.log(label.classList);
            e.target.classList.toggle('focus');
            console.log(e.target.classList);
            console.log("====");
        })
        element.addEventListener('focusout', (e)=>{
            let label = e.target.parentElement.querySelector(".signin-label");
            label.classList.toggle('focus');
            console.log(label.classList);
            e.target.classList.toggle('focus');
            console.log(e.target.classList);
            console.log("====");
        })
    })
})