// Helpers
const formatNumber = (number) => {
  if (number < 10) return "00" + number;
  else if (number < 100) return "0" + number;
  else return number;
};

const getElement = (elementName, all = false) => {
  if (all) return document.querySelectorAll(elementName);
  else return document.querySelector(elementName);
};

function getTicket(ticketNumber, elementCollection) {
  let ticketElement = false;

  elementCollection.forEach((element) => {
    const elementNumber = parseInt(element.getAttribute("data-ticket"));
    if (elementNumber === ticketNumber) ticketElement = element;
  });
  return ticketElement;
}

const getTicketByState = (ticketsArray, stateNumber) => {
  const filteredArray = ticketsArray.filter(checkState);

  function checkState(ticket) {
    return ticket[1] === stateNumber;
  }
  return filteredArray;
};

// Global Objects
const containers = {
  tickets: getElement(".tickets-container"),
  ticketsSelect: getElement(".selected-tickets-container"),
};

const inputs = {
  searchTicket: getElement(".search-ticket"),
  hiddenTicketArray: getElement(".ticket-numbers-array"),
};

const genericElement = {
  cartIcon: getElement(".cart-icon"),
  cartIconNumber: getElement(".cart-icon-number"),
  raffleNumber: getElement(".raffle-tickets-number b")
};

const buttons = {
  addSearchTicket: getElement(".add-searched"),
  clearTickets: getElement(".raffle-tickets-selected-clear-button"),
  pay: getElement(".raffle-tickets-form-button"),
  randomTicket: getElement(".random-ticket"),
  filterAvailable: getElement(".filter-button.available"),
  filterReserved: getElement(".filter-button.reserved"),
  filterPurched: getElement(".filter-button.purched"),
  filterTag: getElement(".footer--item--number.filter-tag"),
};

const handlers = {};

function raffleTickets(ticketsData) {
  // Objects
  const ticketList = {
    initial: ticketsData.sort((a, b) => a - b),
    available: getTicketByState(ticketsData, 0).map((item) => item[0]),
    reserved: getTicketByState(ticketsData, 1).map((item) => item[0]),
    purched: getTicketByState(ticketsData, 2).map((item) => item[0]),
    currentAvailable: getTicketByState(ticketsData, 0).map((item) => item[0]),
    selected: [],
  };

  const state = {
    filter: null,
  };

  const baseSettings = {
    filterOptions: { available: 0, reserved: 1, purched: 2 },
    maxSelectedTickets: 10,
  };

  // Start
  renderTickets(ticketList.initial);
  resetElements();  

  // Functions
  function addTicket(ticketNumber, element) {
    ticketList.selected.push(ticketNumber);
    ticketList.selected.sort((a, b) => b - a);

    element.classList.remove("available");
    element.classList.add("selected");
  }

  function changeTicket(action, ticketNumber = false) {
    if (
      action === "ADD" &&
      ticketList.selected.length >= baseSettings.maxSelectedTickets
    )
      return;

    const ticketCollection = getElement(".ticket-list .ticket-item", true);
    const element =
      ticketNumber !== false && getTicket(ticketNumber, ticketCollection);

    switch (action) {
      case "ADD":
        addTicket(ticketNumber, element);
        break;
      case "CLEAR":
        clearTickets(ticketCollection);
        break;
      case "REMOVE":
        removeTicket(ticketNumber, element);
        break;
    }

    renderSelectedTickets();

    ticketList.currentAvailable = ticketList.available.filter(
      (item) => !ticketList.selected.includes(item)
    );

    const selectedLength = ticketList.selected.length;

    renderCartIconNumber(selectedLength);
    setPaymentButton(selectedLength);
    setFormData();
  }

  function clearTickets(element) {
    ticketList.selected = [];
    element.forEach((ticketItem) => {
      ticketItem.classList.remove("selected");
    });
  }

  function filterTickets(filter) {
    let filteredTickets = ticketList.initial;
    if (filter !== false)
      filteredTickets = getTicketByState(ticketList.initial, filter);

    renderTickets(filteredTickets);
  }

  function genRandomTicket() {
    randomNumber = Math.floor(
      Math.random() * ticketList.currentAvailable.length
    );

    return ticketList.currentAvailable[randomNumber];
  }

  function removeTicket(ticketNumber, element) {
    const arrayPosition = ticketList.selected.indexOf(ticketNumber);

    ticketList.selected.splice(arrayPosition, 1);
    element.classList.add("available");
    element.classList.remove("selected");
  }

  function renderCartIconNumber(numberOfTickets) {
    if (numberOfTickets > 0) {
      genericElement.cartIcon.classList.add("active");
      genericElement.cartIconNumber.innerHTML = numberOfTickets;
    } else {
      genericElement.cartIcon.classList.remove("active");
      genericElement.cartIconNumber.innerHTML = numberOfTickets;
    }
  }

  function renderTickets(ticketsArray) {
    const state = ["available", "reserved", "purched", "selected"];
    containers.tickets.innerHTML = "";
    let HTMLObject = '';
    showTicketCount();

    ticketsArray.map((ticket) => {
      const onClickFunction =
        ticket[1] === 0 ? `onclick="handlers.ticketHandler(${ticket[0]})"` : "";
      const HTMLTicket = `<li style="order: ${formatNumber(
        ticket[0]
      )}" ${onClickFunction} class="raffle-tickets-numbers-list-item ticket-item ${
        state[ticket[1]]
      }" data-ticket="${ticket[0]}">
                          <b>${formatNumber(ticket[0])}</b>
                        </li>`;
      HTMLObject += HTMLTicket;
    });
    containers.tickets.innerHTML = HTMLObject;
  }

  function renderSelectedTickets() {
    const HTMLMessage = `<li class="raffle-tickets-numbers-list-item message">
                         <b>Escolha um número</b>
                       </li>`;

    containers.ticketsSelect.innerHTML = "";

    if (ticketList.selected.length === 0) {
      containers.ticketsSelect.insertAdjacentHTML("afterbegin", HTMLMessage);
    } else {
      ticketList.selected.map((ticket) => {
        const HTMLTicket = `<li onclick="handlers.selectedTicketHandler(${ticket})" class="raffle-tickets-numbers-list-item" data-ticket="${ticket}">
                            <b>${formatNumber(ticket)}</b>
                          </li>`;

        containers.ticketsSelect.insertAdjacentHTML("afterbegin", HTMLTicket);
      });
    }
  }

  function resetElements(){
    buttons.pay.disabled = true;
  }

  function setPaymentButton(numberOfTickets) {
    if (numberOfTickets > 0) buttons.pay.disabled = false;
    else buttons.pay.disabled = true;
  }

  function setFormData() {
    if (ticketList.selected.length > 0)
      inputs.hiddenTicketArray.value = ticketList.selected;
  }

  function showTicketCount(){
    genericElement.raffleNumber.innerHTML = ticketList.initial.length;
    buttons.filterAvailable.innerHTML = ticketList.available.length;
    buttons.filterPurched.innerHTML = ticketList.purched.length;
    buttons.filterReserved.innerHTML = ticketList.reserved.length;
  }
  // Handlers
  function addSearchedTicketHandler(event) {
    event.preventDefault();
    const searchedNumber = parseInt(inputs.searchTicket.value);
    const searchedIndex = ticketList.currentAvailable.indexOf(searchedNumber);
    if (ticketList.currentAvailable[searchedIndex] !== undefined)
      changeTicket("ADD", ticketList.currentAvailable[searchedIndex]);
  }

  function clearTicketsHandler() {
    changeTicket("CLEAR");
  }

  function filterHandler(event) {
    const filter = event.target.dataset.filter;
    const capFilter = filter.charAt(0).toUpperCase() + filter.slice(1);
    let filterNumber = false;

    if (baseSettings.filterOptions[filter] !== state.filter) {
      filterNumber = state.filter = baseSettings.filterOptions[filter];

      for (option in baseSettings.filterOptions) {
        const capitalOption = option.charAt(0).toUpperCase() + option.slice(1);
        const clickedButton = buttons["filter" + capitalOption];

        clickedButton.classList.remove("active");
        buttons.filterTag.classList.remove(option);

        if (option == filter) clickedButton.classList.add("active");
      }
      buttons.filterTag.dataset.filter = filter;
      buttons.filterTag.innerHTML = `<i>${capFilter}</i>`;
      buttons.filterTag.classList.add(filter);
    } else {
      state.filter = null;
      buttons.filterTag.innerHTML = "";

      for (option in baseSettings.filterOptions) {
        const capitalOption = option.charAt(0).toUpperCase() + option.slice(1);
        const clickedButton = buttons["filter" + capitalOption];
        clickedButton.classList.remove("active");
        buttons.filterTag.classList.remove(option);
      }
    }

    filterTickets(filterNumber);
  }

  function filterTagHandler() {
    buttons.filterTag.classList.remove("available", "purched", "reserved");
    buttons.filterAvailable.classList.remove("active");
    buttons.filterPurched.classList.remove("active");
    buttons.filterReserved.classList.remove("active");
    buttons.filterTag.innerHTML = "";
    filterTickets(false);
  }

  function randomTicketHandler(event) {
    event.preventDefault();

    if (ticketList.currentAvailable.length > 0) {
      const ticketNumber = genRandomTicket();
      changeTicket("ADD", ticketNumber);
    }
  }

  function searchTicketHandler() {
    const searchedNumber = parseInt(inputs.searchTicket.value);
    let state;
    for (ticketArray in ticketList) {
      if (ticketArray != "initial" && ticketArray != "available") {
        if (ticketList[ticketArray].indexOf(searchedNumber) >= 0) {
          state = ticketArray;
          break;
        }
      }
    }

    state = state === "currentAvailable" ? "available" : state;
    state = state === undefined ? "disabled" : state;
    const availableIndex = ticketList.currentAvailable.indexOf(searchedNumber);
    buttons.addSearchTicket.classList.remove("denied", "allowed");
    buttons.addSearchTicket.classList.add("disabled");
    inputs.searchTicket.classList.remove(
      "purched",
      "reserved",
      "available",
      "denied",
      "selected"
    );

    inputs.searchTicket.classList.add(state);
    buttons.addSearchTicket.classList.add(state);

    if (availableIndex >= 0) {
      if (ticketList.currentAvailable[availableIndex] !== undefined) {
        buttons.addSearchTicket.classList.add("allowed");
        buttons.addSearchTicket.classList.remove("disabled");
      } else {
        buttons.addSearchTicket.classList.remove("disabled");
      }
    } else if (state === "purched" || state === "reserved") {
      buttons.addSearchTicket.classList.add("denied");
    }
  }

  // Exposed Handlers
  handlers.selectedTicketHandler = function selectedTicketHandler(
    ticketNumber
  ) {
    changeTicket("REMOVE", ticketNumber);
  };

  handlers.ticketHandler = function ticketHandler(ticketNumber) {
    if (ticketList.selected.indexOf(ticketNumber) === -1) {
      changeTicket("ADD", ticketNumber);
    } else {
      changeTicket("REMOVE", ticketNumber);
    }
  };

  // EventListeners
  buttons.addSearchTicket.addEventListener("click", addSearchedTicketHandler);
  buttons.clearTickets.addEventListener("click", clearTicketsHandler);
  buttons.randomTicket.addEventListener("click", randomTicketHandler);
  buttons.filterAvailable.addEventListener("click", filterHandler);
  buttons.filterReserved.addEventListener("click", filterHandler);
  buttons.filterPurched.addEventListener("click", filterHandler);
  buttons.filterTag.addEventListener("click", filterTagHandler);
  inputs.searchTicket.addEventListener("input", searchTicketHandler);
}

containers.tickets.innerHTML = `<li class="ticket-loading">Carregando...</li>`;

fetch(window.location.pathname + "/tickets")
  .then((response) => response.json())
  .then((tickets) => {
    return raffleTickets(tickets.data);
  })
  .catch((error) => console.log(error));
