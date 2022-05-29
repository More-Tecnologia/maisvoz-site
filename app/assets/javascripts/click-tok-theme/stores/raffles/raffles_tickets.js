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
const addTicket = (element) => {
  element.classList.remove('available');
  element.classList.add('selected');
}
const removeTicket = (element) => {
  element.classList.remove('selected');
  element.classList.add('available');
}
const clearHTML = (targetElement) => {
  targetElement.innerHTML = "";
};
const getElement = (elementName, all = false) => {
  if (all) return document.querySelectorAll(elementName);
  else return document.querySelector(elementName);
};
const getClickedNumber = (event) => {
  return parseInt(event.target.firstElementChild.textContent);
};
const renderHTML = (targetElement, HTMLCode) => {
  targetElement.insertAdjacentHTML("afterbegin", HTMLCode);
};


// Objects
const containers = {
  tickets: getElement(".ticket-container"),
  ticketsSelect: getElement(".selected-tickets-container"),
};

const ticketList = {
  initial: ticketsData,
  current: ticketsData,
  available: filterTickets(ticketsData, 0),
  reserved: filterTickets(ticketsData, 1),
  purched: filterTickets(ticketsData, 2),
  selected: filterTickets(ticketsData, 3),
};

renderTicketList(ticketList.initial.slice().reverse(), containers.tickets);

const ticketItems = getElement(".raffle-tickets-numbers-list-item.available", true);

ticketItems.forEach(ticketItem => {
  ticketItem.addEventListener('click', ticketItemHandler);
});

//  F  U  N  C  T  I  O  N  S
function filterTickets(ticketsArray, stateNumber) {
  const filteredArray = ticketsArray.filter(checkState);

  function checkState(ticket) {
    return ticket[1] === stateNumber;
  }

  return filteredArray;
}

function renderTicketList(ticketsArray, targetElement) {
  const state = ["available", "reserved", "purched", "selected"];
  clearHTML(targetElement);

  ticketsArray.map((ticket) => {
    let ticketNumber;
    
    if (ticket[0] < 10) {
      ticketNumber = "00" + ticket[0];
    } else if (ticket[0] < 100) {
      ticketNumber = "0" + ticket[0];
    } else {
      ticketNumber = ticket[0];
    }

    renderHTML(
      targetElement,
      `<li class="raffle-tickets-numbers-list-item ${state[ticket[1]]}">
         <b>${ticketNumber}</b>
       </li>`
    );
  });
}

function ticketItemHandler(event){
  const {target} = event; 
  
  if(target.classList.contains('selected')){
    removeTicket(target)
  }else{
    addTicket(target)
  }
  
}
