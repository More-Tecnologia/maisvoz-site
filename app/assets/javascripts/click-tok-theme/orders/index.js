(function ordersIndex() {
  const filterContainer = document.querySelector(".order-filter-container"),
    filterButton = document.querySelector(".order-filter-button");

  filterButton.onclick = (e) => {
    e.stopPropagation();
    filterContainer.classList.toggle("active");
  };

  onclick = () => filterContainer.classList.remove("active");
})();
