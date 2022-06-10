const list = document.querySelectorAll(".list");
let local = window.location.pathname;
console.log(local)
function itemSelected() {
  if (local.includes("/backoffice/home") || local.includes("/backoffice/admin/dashboard")) {
    list[0].classList.add("menu-selected");
  } else {
    list[0].classList.remove("menu-selected");
  }

  if (local.includes("/backoffice/raffles_tickets") || local.includes("/backoffice/support/users")) {
    list[1].classList.add("menu-selected");
  } else {
    list[1].classList.remove("menu-selected");
  }

  if (local.includes("/backoffice/stores/") || local == "/") {
    list[2].classList.add("menu-selected");
  } else {
    list[2].classList.remove("menu-selected");
  }

  if (
    local.includes("/backoffice/financial_dashboard") ||
    local.includes("/backoffice/financial_transactions") ||
    local.includes("/backoffice/orders") ||
    local.includes("/backoffice/bank_account/") ||
    local.includes("/backoffice/withdrawals") ||
    local.includes("/backoffice/raffle_third_parties_carts")
  ) {
    list[3].classList.add("menu-selected");
  } else {
    list[3].classList.remove("menu-selected");
  }

  if (local.includes("/backoffice/team_dashboard")) {
    list[4].classList.add("menu-selected");
  } else {
    list[4].classList.remove("menu-selected");
  }
}

function navigate(href) {
  window.location.href = href;
}

itemSelected();
