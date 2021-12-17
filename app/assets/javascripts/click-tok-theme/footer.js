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
    if (item.className == "list active") {
      indicator.style.transition = "0.5s"
      indicator.style.transform = `translateX(calc(${item.offsetWidth+"px"} * ${x}))`;
    }
    x++;
  })
}

function itemSelected() {
  let links = document.querySelectorAll('.link-nav');
  let sizeNav = document.querySelector('.list').offsetWidth;
  let firstList = list[0];
  
  let footerDashboardHome = ["/",
    "/backoffice/admin/dashboard",
    "/backoffice/home"
  ];

  let footerTasksUsers = ["/backoffice/dashboard",
    "/backoffice/banners",
    "/backoffice/support/users"
  ];

  let footerShop = ["/backoffice/products",
    "/backoffice/stores/games",
    "/backoffice/stores/courses",
    "/backoffice/stores/ads",
    "/backoffice/cart"
  ];

  let footerFinancial = ["/backoffice/financial_dashboard",
    "/backoffice/withdrawals",
    "/backoffice/financial_transactions",
    "/backoffice/orders",
    "/backoffice/bank_account/edit.1",
    "/backoffice/withdrawals/new",
    "/backoffice/admin/withdrawals",
    "/backoffice/admin/credits_debits/find_user",
    "/backoffice/admin/expenses/new",
    "/backoffice/admin/orders",
    "/backoffice/admin/financial_transactions",
    "/backoffice/admin/bonus_contracts"
  ];

  let footerTeam = ["/backoffice/team_dashboard"]

  if (footerDashboardHome.includes(window.location.pathname)) {
    indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 0))`;
    indicator.style.transition = "none";
    list[0].classList.add('active');
  } else {
    list[0].classList.remove('active');
  }
  if (footerTasksUsers.includes(window.location.pathname)) {
    indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 1))`;
    indicator.style.transition = "none";
    list[1].classList.add('active');
  } else {
    list[1].classList.remove('active');
  }
  if (footerShop.includes(window.location.pathname)) {
    indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 2))`;
    indicator.style.transition = "none";
    list[2].classList.add('active');
  } else {
    list[2].classList.remove('active');
  }
  if (footerFinancial.includes(window.location.pathname)) {
    indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 3))`;
    indicator.style.transition = "none";
    list[3].classList.add('active');
  } else {
    list[3].classList.remove('active');
  }
  if (footerTeam.includes(window.location.pathname)) {
    indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 4))`;
    indicator.style.transition = "none";
    list[4].classList.add('active');
  } else {
    list[4].classList.remove('active');
  }

  if (footerDashboardHome.includes(window.location.pathname) == false &&
    footerTasksUsers.includes(window.location.pathname) == false &&
    footerShop.includes(window.location.pathname) == false &&
    footerFinancial.includes(window.location.pathname) == false &&
    footerTeam.includes(window.location.pathname) == false) {

    firstList.classList.add('active')
    indicator.style.transform = `translateX(calc(${sizeNav+"px"} * 0))`;
    indicator.style.transition = "none";
  }
}

itemSelected();
