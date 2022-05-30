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
  [50, 1],
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

const getClickedNumber = (event) => {
  return parseInt(event.target.firstElementChild.textContent);
};

// Objects
const containers = {
  tickets: getElement(".tickets-container"),
  ticketsSelect: getElement(".selected-tickets-container"),
};

const buttons = {
  clearTickets: getElement(".raffle-tickets-selected-clear-button"),
};

const ticketList = {
  initial: ticketsData,
  current: ticketsData,
  available: filterTickets(ticketsData, 0),
  reserved: filterTickets(ticketsData, 1),
  purched: filterTickets(ticketsData, 2),
  selected: [],
};

renderTicketList(ticketList.initial.slice().reverse(), containers.tickets);

const renderedTickets = getElement(
  ".raffle-tickets-numbers-list-item.available",
  true
);

//  F  U  N  C  T  I  O  N  S
function addTicketToArray(ticketNumber) {
  ticketList.selected.push(ticketNumber);
  ticketList.selected.sort().reverse();
}

function removeTicketOfArray(arrayPosition) {
  ticketList.selected.splice(arrayPosition, 1);
}

function filterTickets(ticketsArray, stateNumber) {
  const filteredArray = ticketsArray.filter(checkState);

  function checkState(ticket) {
    return ticket[1] === stateNumber;
  }

  return filteredArray;
}

function renderSelectedTickets() {
  const targetElement = containers.ticketsSelect;
  const ticketsArray = ticketList.selected;
  const HTMLMessage = `<li class="raffle-tickets-numbers-list-item message">
                         <b>Escolha um número</b>
                       </li>`;

  targetElement.innerHTML = "";

  if (ticketsArray.length === 0) {
    targetElement.insertAdjacentHTML("afterbegin", HTMLMessage);
  } else {
    ticketsArray.map((ticket) => {
      const HTMLTicket = `<li class="raffle-tickets-numbers-list-item">
                            <b>${formatNumber(ticket)}</b>
                          </li>`;

      targetElement.insertAdjacentHTML("afterbegin", HTMLTicket);
    });
  }
}

function renderTicketList(ticketsArray, targetElement) {
  const state = ["available", "reserved", "purched", "selected"];
  targetElement.innerHTML = "";

  ticketsArray.map((ticket) => {
    const HTMLTicket = `<li class="raffle-tickets-numbers-list-item ${
      state[ticket[1]]
    }">
                          <b>${formatNumber(ticket[0])}</b>
                        </li>`;

    targetElement.insertAdjacentHTML("afterbegin", HTMLTicket);
  });
}

function clickedTicketHandler(event) {
  const ticketNumber = getClickedNumber(event);
  const selected = ticketList.selected.indexOf(ticketNumber);
  console.log("Clicked");
  selectTicket(ticketNumber);

  if (selected > -1) {
    removeTicketOfArray(selected);
  } else {
    addTicketToArray(ticketNumber);
  }
  renderSelectedTickets();

  const renderedSelectedTickets = getElement(
    ".selected-tickets-container .raffle-tickets-numbers-list-item",
    true
  );

  renderedSelectedTickets.forEach((ticketItem) => {
    ticketItem.addEventListener("click", clickedSelectedTicketHandler);
  });
}

function clickedSelectedTicketHandler(event) {
  const ticketNumber = getClickedNumber(event);
  const selected = ticketList.selected.indexOf(ticketNumber);
  
  
  removeTicketOfArray(selected);  
  deleteTicket(ticketNumber);
  renderSelectedTickets();
  selectTicket(ticketNumber);
  
}

//EventListners
renderedTickets.forEach((ticketItem) => {
  ticketItem.addEventListener("click", clickedTicketHandler);
});

buttons.clearTickets.addEventListener("click", clearTicketsHandler);

//Ready Functions
function clearTicketsHandler() {
  ticketList.selected = [];
  renderedTickets.forEach((ticketItem) => {
    ticketItem.classList.remove("selected");
  });

  renderSelectedTickets();
}

function deleteTicket(ticketNumber) {
  const selectedTickets = getElement(
    ".selected-tickets-container .raffle-tickets-numbers-list-item",
    true
  );
  const element = getTicket(ticketNumber, selectedTickets);
  if (element) element.remove();
}

function getTicket(ticketNumber, elementCollection) {
  let ticketElement = false;
  elementCollection.forEach((element) => {
    const elementNumber = parseInt(element.innerText);

    if (elementNumber === ticketNumber) {
      ticketElement = element;
    }
  });
  return ticketElement;
}

function selectTicket(ticketNumber) {
  const ticketCollection = getElement(
    ".tickets-container .raffle-tickets-numbers-list-item",
    true
  );
  const element = getTicket(ticketNumber, ticketCollection);
  if (ticketList.selected.indexOf(ticketNumber) === -1) {
    element.classList.remove("available");
    element.classList.add("selected");
  }else{
    element.classList.remove("selected");
    element.classList.add("available");
  }
}
