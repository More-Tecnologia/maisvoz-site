function showPixInput() {
  var pix_input = document.getElementById("pix_input");
  var bitcoin_input = document.getElementById("bitcoin_input");
  pix_input.style.display = "flex";
  bitcoin_input.style.display = "none";
};

function showBitCoinInput() {
  var pix_input = document.getElementById("pix_input");
  var bitcoin_input = document.getElementById("bitcoin_input");
  bitcoin_input.style.display = "flex";
  pix_input.style.display = "none";
};
