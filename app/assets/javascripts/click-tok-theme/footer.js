const list = document.querySelectorAll(".list");
let indicator = document.querySelector(".indicator");

function activeLink() {
  list.forEach((item) => {
    item.classList.remove("active");
    this.classList.add("active");
  });
}
list.forEach((item) => {
  item.addEventListener("click", activeLink);
  item.addEventListener("click", moveMenu);
});

function moveMenu() {
  let menu = document.querySelector(".main-list");
  let lists = document.querySelectorAll(".list");
  let indicator = document.querySelector(".indicator");
  let x = 0;

  list.forEach((item, i) => {
      if(item.className == "list active"){
        indicator.style.transition = "0.5s"
          indicator.style.transform = `translateX(calc(${item.offsetWidth+"px"} * ${x}))`;
      }
      x++;
  })
  console.log(x);
}

function itemSelected(){
  let links = document.querySelectorAll('.link-nav');
  let sizeNav = document.querySelector('.list').offsetWidth;

  list.forEach((item) => {

      if(window.location.pathname == "/backoffice/dashboard" || window.location.pathname == "/backoffice/dashboard"){
        indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 1))`;
        indicator.style.transition = "none";
      }
      if(window.location.pathname == "/backoffice/support/users" || window.location.pathname == "/backoffice/dashboard"){
        indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 1))`;
        indicator.style.transition = "none";
      }
      if(window.location.pathname == "/backoffice/products"){
        indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 2))`;
        indicator.style.transition = "none";
      }
      if(window.location.pathname == "/backoffice/financial_dashboard"){
        indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 3))`;
        indicator.style.transition = "none";
      }
      if(window.location.pathname == "/backoffice/team_dashboard"){
          indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 4))`;
          indicator.style.transition = "none";
        }
      if(item.children[0].pathname == window.location.pathname){
        item.classList.add('active');
      }
      else {
        item.classList.remove('active');
      }
      if(window.location.pathname !== "/backoffice/support/users" && window.location.pathname !== "/backoffice/products" && window.location.pathname !== "/backoffice/financial_dashboard" && window.location.pathname !== "/backoffice/team_dashboard" && window.location.pathname !== "/backoffice/dashboard"){
        console.log(window.location.pathname)
        indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 0))`;
        indicator.style.transition = "none";
      }
  });
}

itemSelected();
