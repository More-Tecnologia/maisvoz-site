// Helpers
const formatNumber = (number, numberArray) => {
  const lastArrayNumber = numberArray[numberArray.length - 1][0];
  const size = lastArrayNumber.toString().length;
  number = number.toString();

  while (number.length < size) number = "0" + number;

  return number;
};

const getElement = (elementName, all = false) => {
  if (all) return document.querySelectorAll(elementName);
  return document.querySelector(elementName);
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
  stickyBar: getElement(".raffle-tickets-bar"),
};

const inputs = {
  searchTicket: getElement(".search-ticket"),
  hiddenTicketArray: getElement(".ticket-numbers-array"),
};

const genericElement = {
  addSearchTicketText: getElement(".add-searched span"),
  cartIcon: getElement(".cart-icon"),
  cartIconNumber: getElement(".cart-icon-number"),
  raffleNumber: getElement(".raffle-tickets-number b"),
  stickyBarLimit: getElement(".sticky-bar-limit"),
  floatSearchBox: getElement(".raffle-tickets-search-numbers-container"),
};

const buttons = {
  addSearchTicket: getElement(".add-searched"),
  addSearchTicketSpan: getElement(".add-searched span"),
  clearTickets: getElement(".clear-tickets-button"),
  closeSearch: getElement(".search-box-close"),
  openSearch: getElement(".ticket-search-button"),
  pay: getElement(".raffle-tickets-buy-form .buy-tickets-button"),
  randomTicket: getElement(".random-ticket"),
  filterAvailable: getElement(".filter-button.available"),
  filterReserved: getElement(".filter-button.reserved"),
  filterPurched: getElement(".filter-button.purched"),
  filterTag: getElement(".footer--item--number.filter-tag"),
};

const sizes = {
  stickyBar: containers.stickyBar.offsetTop,
};

const handlers = {};

function raffleTickets(ticketsData) {
  // Objects
  const baseSettings = {
    filterOptions: { available: 0, reserved: 1, purched: 2 },
    maxSelectedTickets: 10,
    paginationSize: 200,
  };

  const ticketList = {
    initial: ticketsData.sort((a, b) => a - b),
    available: getTicketByState(ticketsData, 0).map((item) => item[0]),
    reserved: getTicketByState(ticketsData, 1).map((item) => item[0]),
    purched: getTicketByState(ticketsData, 2).map((item) => item[0]),
    currentAvailable: getTicketByState(ticketsData, 0).map((item) => item[0]),
    rendered: ticketsData.sort((a, b) => a - b),
    selected: [],
  };

  const state = {
    filter: null,
    ticketPosition: 0,
  };

  // Start
  containers.tickets.innerHTML = "";
  renderTicketsRange();
  resetElements();

  // Functions
  function addTicket(ticketNumber, element) {
    ticketList.selected.push(ticketNumber);
    ticketList.selected.sort((a, b) => b - a);

    toggleClass(element, "available", "selected");
  }

  function crud(setAction, ticketNumber) {
    const ticketCollection = getElement(".ticket-list .ticket-item", true);
    const element =
      ticketNumber !== false && getTicket(ticketNumber, ticketCollection);

    const actions = {
      add: () => addTicket(ticketNumber, element),
      clear: () => clearTickets(ticketCollection),
      remove: () => removeTicket(ticketNumber, element),
    };

    return actions[setAction]();
  }

  function changeTicket(setAction, ticketNumber = false) {
    const stopAdd =
      ticketList.selected.length >= baseSettings.maxSelectedTickets;
    if (setAction === "add" && stopAdd) return;

    crud(setAction, ticketNumber);
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
    if (filter !== false) {
      ticketList.rendered = getTicketByState(ticketList.initial, filter);
      containers.tickets.innerHTML = "";
    } else {
      ticketList.rendered = ticketList.initial;
    }
    state.ticketPosition = 0;
    renderTicketsFilterLazy();
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
    toggleClass(element, "selected", "available");
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

  function renderTicketsRange(ticketRange = [0, baseSettings.paginationSize]) {
    const state = ["available", "reserved", "purched", "selected"];

    let HTMLObject = "";
    showTicketCount();

    ticketList.rendered.slice(...ticketRange).map((ticket) => {
      const ticketClass = ticketList.selected.includes(ticket[0])
        ? state[3]
        : state[ticket[1]];

      const onClickFunction =
        ticket[1] === 0 ? `onclick="handlers.ticketHandler(${ticket[0]})"` : "";
      const HTMLTicket = `<li style="order: ${formatNumber(
        ticket[0],
        ticketList.initial
      )}" ${onClickFunction} class="raffle-tickets-numbers-list-item ticket-item ${ticketClass}" data-ticket="${
        ticket[0]
      }">
                          <b>${formatNumber(ticket[0], ticketList.initial)}</b>
                        </li>`;
      containers.tickets.insertAdjacentHTML("beforeend", HTMLTicket);
    });
  }

  function renderTicketsLazy() {
    if (state.ticketPosition > ticketList.rendered.length) return;

    state.ticketPosition += baseSettings.paginationSize;
    const ticketRange = [
      state.ticketPosition,
      state.ticketPosition + baseSettings.paginationSize,
    ];

    renderTicketsRange(ticketRange);
  }

  function renderTicketsFilterLazy() {
    if (state.ticketPosition > ticketList.rendered.length) return;

    const ticketRange = [
      state.ticketPosition,
      state.ticketPosition + baseSettings.paginationSize,
    ];

    state.ticketPosition += baseSettings.paginationSize;

    renderTicketsRange(ticketRange);
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
                            <b>${formatNumber(ticket, ticketList.initial)}</b>
                          </li>`;

        containers.ticketsSelect.insertAdjacentHTML("afterbegin", HTMLTicket);
      });
    }
  }

  function resetElements() {
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

  function showTicketCount() {
    genericElement.raffleNumber.innerHTML = ticketList.initial.length;
    buttons.filterAvailable.innerHTML = ticketList.available.length;
    buttons.filterPurched.innerHTML = ticketList.purched.length;
    buttons.filterReserved.innerHTML = ticketList.reserved.length;
  }

  function toggleClass(element, classToRemove, classToAdd) {
    if (!element) return;

    element.classList.remove(classToRemove);
    element.classList.add(classToAdd);
  }
  // Handlers
  function addSearchedTicketHandler(event) {
    event.preventDefault();
    const searchedNumber = parseInt(inputs.searchTicket.value);
    const searchedIndex = ticketList.currentAvailable.indexOf(searchedNumber);
    if (ticketList.currentAvailable[searchedIndex] !== undefined) {
      changeTicket("add", ticketList.currentAvailable[searchedIndex]);
      closeSearchHandler();
    }
  }

  function clearSearchBox() {
    inputs.searchTicket.value = "";
    buttons.addSearchTicket.classList.remove("denied", "allowed");
    inputs.searchTicket.classList.remove(
      "purched",
      "reserved",
      "available",
      "denied",
      "selected"
    );
  }

  function clearTicketsHandler() {
    changeTicket("clear");
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
      changeTicket("add", ticketNumber);
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
    buttons.addSearchTicket.classList.remove(
      "denied",
      "allowed",
      "purched",
      "reserved",
      "available",
      "selected"
    );
    buttons.addSearchTicket.classList.add("disabled");
    inputs.searchTicket.classList.remove(
      "purched",
      "reserved",
      "available",
      "denied",
      "selected"
    );

    const buttonText = buttons.addSearchTicket.dataset[state];

    buttons.addSearchTicketSpan.innerHTML = buttonText;

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

  function searchTicketOnKeyHandler(event) {
    if (event.keyCode === 13) {
      event.preventDefault();
      addSearchedTicketHandler(event);
    }
  }

  function openSearchHandler() {
    genericElement.floatSearchBox.classList.add("open");
    buttons.openSearch.classList.add("close");
    inputs.searchTicket.focus();
  }

  function closeSearchHandler() {
    genericElement.floatSearchBox.classList.remove("open");
    buttons.openSearch.classList.remove("close");
    inputs.searchTicket.blur();
    clearSearchBox();
  }

  function windowResizeHandler() {
    sizes.stickyBar = containers.stickyBar.offsetTop;
  }

  function setStickyBar(stickyBarOnTop) {
    stickyBarOnTop
      ? containers.stickyBar.classList.remove("sticky")
      : containers.stickyBar.classList.add("sticky");
  }

  function setFloatSearchBox(ticketsOnView) {
    ticketsOnView
      ? containers.stickyBar.classList.add("search-float")
      : containers.stickyBar.classList.remove("search-float");
  }

  function windowScrollHandler() {
    const stickyBarOnTop = isTouchingTopViewPort(genericElement.stickyBarLimit);
    const ticketsOnView = isInViewport(containers.tickets);

    setFloatSearchBox(ticketsOnView);
    setStickyBar(stickyBarOnTop);

    const scrollFinished =
      window.scrollY + window.innerHeight >=
      document.documentElement.scrollHeight;
    if (scrollFinished) renderTicketsLazy();
  }

  function isTouchingTopViewPort(element) {
    const bounding = element.getBoundingClientRect();

    if (bounding.top >= 0) return true;
    else return false;
  }

  function isInViewport(element) {
    const rect = element.getBoundingClientRect();
    return rect.top - window.innerHeight <= -100;
  }

  // Exposed Handlers
  handlers.selectedTicketHandler = function selectedTicketHandler(
    ticketNumber
  ) {
    changeTicket("remove", ticketNumber);
  };

  handlers.ticketHandler = function ticketHandler(ticketNumber) {
    if (ticketList.selected.indexOf(ticketNumber) === -1) {
      changeTicket("add", ticketNumber);
    } else {
      changeTicket("remove", ticketNumber);
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
  buttons.openSearch.addEventListener("click", openSearchHandler);
  buttons.closeSearch.addEventListener("click", closeSearchHandler);
  inputs.searchTicket.addEventListener("input", searchTicketHandler);
  inputs.searchTicket.addEventListener("keypress", searchTicketOnKeyHandler);
  window.addEventListener("resize", windowResizeHandler);
  window.addEventListener("scroll", windowScrollHandler);
}

(function fetchData() {
  containers.tickets.innerHTML = `<li class="ticket-loading">Carregando...</li>`;

  fetch(window.location.pathname + "/tickets")
    .then((response) => response.json())
    .then((tickets) => {
      return raffleTickets(tickets.data);
    })
    .catch((error) => console.log(error));
})();

//RaffleGalleryDesktop
function raffleGalleryDesktop() {
  const elements = {
    stage: getElement(".raffle-tickets-image"),
    thumbs: getElement(".raffle-tickets-image-list img", true),
  };

  //Event Handlers

  function thumbMouseOverHandler(event) {
    elements.stage.src = event.target.src;

    elements.thumbs.forEach((thumb) => thumb.classList.remove("active"));

    event.target.classList.add("active");
  }

  //Event Listeners

  elements.thumbs.forEach((thumb) => {
    thumb.addEventListener("mouseover", thumbMouseOverHandler);
  });
}
raffleGalleryDesktop();

//RaffleGalleryMoblie
function raffleGalleryMobile() {
  const elements = {
    stage: getElement(".raffle-tickets-image"),
    thumbs: getElement(".raffle-tickets-image-list img", true),
  };

  const imageList = (() => {
    const srcList = [];
    elements.thumbs.forEach((thumb) => srcList.push(thumb.src));

    return srcList;
  })();
}

raffleGalleryMobile();
