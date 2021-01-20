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
    });
    // Want to use I18n in javascript -> put in view as javascript_tag
    // let signupForm = document.getElementById('form-signup');
    // if (signupForm){
    //   signupForm.addEventListener('submit',(event)=>{
    //     event.preventDefault();
    //     let pwd = signupForm.querySelector('#user_password');
    //     let pwdConfirmation = signupForm.querySelector('#user_password_confirmation');
    //     if (pwd!==pwdConfirmation){
    //       alert("<%= I18n.t('devise.registration.password_inconsistent') %>");
    //     }
    //   });
    // }
})