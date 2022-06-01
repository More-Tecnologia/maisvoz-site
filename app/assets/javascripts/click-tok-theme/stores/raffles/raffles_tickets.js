const DUMMYTickets = [
  [0, 0],
  [1, 0],
  [2, 0],
  [3, 0],
  [4, 2],
  [5, 0],
  [6, 0],
  [7, 0],
  [8, 0],
  [9, 0],
  [10, 2],
  [11, 0],
  [12, 1],
  [13, 2],
  [14, 0],
  [15, 1],
  [16, 0],
  [17, 2],
  [18, 0],
  [19, 0],
  [20, 0],
  [21, 0],
  [22, 0],
  [23, 0],
  [24, 0],
  [25, 0],
  [26, 0],
  [27, 2],
  [28, 0],
  [29, 0],
  [30, 2],
  [31, 0],
  [32, 0],
  [33, 0],
  [34, 1],
  [35, 0],
  [36, 0],
  [37, 1],
  [38, 0],
  [39, 0],
  [40, 1],
  [41, 0],
  [42, 0],
  [43, 0],
  [44, 0],
  [45, 0],
  [46, 0],
  [47, 0],
  [48, 0],
  [49, 0],
];
const ticketsData = DUMMYTickets;

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

const getTicketByState = (ticketsArray, stateNumber) => {
  const filteredArray = ticketsArray.filter(checkState);

  function checkState(ticket) {
    return ticket[1] === stateNumber;
  }
  return filteredArray;
};

function getTicket(ticketNumber, elementCollection) {
  let ticketElement = false;
  elementCollection.forEach((element) => {
    const elementNumber = parseInt(element.getAttribute("data-ticket"));

    if (elementNumber === ticketNumber) {
      ticketElement = element;
    }
  });
  return ticketElement;
}

// Objects
const containers = {
  tickets: getElement(".tickets-container"),
  ticketsSelect: getElement(".selected-tickets-container"),
};

const buttons = {
  addSearchTicket: getElement(".add-searched"),
  clearTickets: getElement(".raffle-tickets-selected-clear-button"),
  pay: getElement(".raffle-tickets-form-button"),
  randomTicket: getElement(".random-ticket"),
};

const genericElement = {
  cartIcon: getElement(".cart-icon"),
  cartIconNumber: getElement(".cart-icon-number"),
};

const inputs = {
  searchTicket: getElement(".search-ticket"),
};

const ticketList = {
  initial: ticketsData.sort((a, b) => a - b),
  available: getTicketByState(ticketsData, 0).map((item) => item[0]),
  reserved: getTicketByState(ticketsData, 1).map((item) => item[0]),
  purched: getTicketByState(ticketsData, 2).map((item) => item[0]),
  currentAvailable: getTicketByState(ticketsData, 0).map((item) => item[0]),
  selected: [],
};

// Functions
renderTickets(ticketList.initial, containers.tickets);

function addTicket(ticketNumber, element) {
  ticketList.selected.push(ticketNumber);
  ticketList.selected.sort((a, b) => b - a);

  element.classList.remove("available");
  element.classList.add("selected");
}

function filterTickets() {
  
}

function changeTicket(action, ticketNumber = false) {
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
}

function clearTickets(element) {
  ticketList.selected = [];
  element.forEach((ticketItem) => {
    ticketItem.classList.remove("selected");
  });
}

function genRandomTicket() {
  randomNumber = Math.floor(Math.random() * ticketList.currentAvailable.length);

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

function renderTickets(ticketsArray, targetElement) {
  const state = ["available", "reserved", "purched", "selected"];
  targetElement.innerHTML = "";

  ticketsArray.map((ticket) => {
    const onClickFunction =
      ticket[1] === 0 ? `onclick="ticketHandler(${ticket[0]})"` : "";
    const HTMLTicket = `<li style="order: ${formatNumber(
      ticket[0]
    )}" ${onClickFunction} class="raffle-tickets-numbers-list-item ticket-item ${
      state[ticket[1]]
    }" data-ticket="${ticket[0]}">
                          <b>${formatNumber(ticket[0])}</b>
                        </li>`;

    targetElement.insertAdjacentHTML("afterbegin", HTMLTicket);
  });
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
      const HTMLTicket = `<li onclick="selectedTicketHandler(${ticket})" class="raffle-tickets-numbers-list-item" data-ticket="${ticket}">
                            <b>${formatNumber(ticket)}</b>
                          </li>`;

      containers.ticketsSelect.insertAdjacentHTML("afterbegin", HTMLTicket);
    });
  }
}

function setPaymentButton(numberOfTickets) {
  if (numberOfTickets > 0) buttons.pay.disabled = false;
  else buttons.pay.disabled = true;
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

function selectedTicketHandler(ticketNumber) {
  changeTicket("REMOVE", ticketNumber);
}

function ticketHandler(ticketNumber) {
  if (ticketList.selected.indexOf(ticketNumber) === -1) {
    changeTicket("ADD", ticketNumber);
  } else {
    changeTicket("REMOVE", ticketNumber);
  }
}

// EventListeners
buttons.addSearchTicket.addEventListener("click", addSearchedTicketHandler);
buttons.clearTickets.addEventListener("click", clearTicketsHandler);
buttons.randomTicket.addEventListener("click", randomTicketHandler);
inputs.searchTicket.addEventListener("input", searchTicketHandler);
