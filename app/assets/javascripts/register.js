document.addEventListener('DOMContentLoaded',()=>{
  let signupForm = document.getElementById('form-signup');
  if (signupForm){
    signupForm.addEventListener('submit',(event)=>{
      event.preventDefault();
      let pwd = signupForm.querySelector('#user_password').value;
      let pwdConfirmation = signupForm.querySelector('#user_password_confirmation').value;
      if (pwd!==pwdConfirmation){
        let alert = document.createElement("div");
        let alertText = document.createElement("span");
        alert.classList.add("alert");
        alert.classList.add("alert-danger");
        alert.setAttribute("onanimationend", "foldAlert(this)");
        alertText.innerText = "<%= I18n.t('devise.registrations.password_inconsistent') %>";
        alert.animationPlayState = "running";
        alert.appendChild(alertText);
        document.getElementById('wrap-alert').appendChild(alert);
        let inputs = document.querySelectorAll('.signin-option.input');
        inputs.forEach(e=>e.value = "");
        inputs[0].focus();
      }
      else{
        signupForm.submit();
      }
    });
  }
})