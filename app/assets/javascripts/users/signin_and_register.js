document.addEventListener('DOMContentLoaded', ()=>{
    document.querySelectorAll('input[type=password], input[type=email]').forEach(element=>{
        element.addEventListener('focus', (e)=>{
            let label = e.target.parentElement.querySelector(".signin-label");
            label.classList.toggle('focus');
            e.target.classList.toggle('focus');
        })
        element.addEventListener('focusout', (e)=>{
            let label = e.target.parentElement.querySelector(".signin-label");
            label.classList.toggle('focus');
            e.target.classList.toggle('focus');
        })
    })
})