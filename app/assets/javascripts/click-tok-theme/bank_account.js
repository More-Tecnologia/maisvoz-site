window.onload = function(){
  var pix_input = document.getElementById("pix_input");
  var bitcoin_input = document.getElementById("bitcoin_input");
  var payment_method = document.getElementById("payment_method")
}

function showPixInput() {
  pix_input.style.display = "flex";
  bitcoin_input.style.display = "none";
  payment_method.setAttribute('value', 'pix');
};

function showBitCoinInput() {
  bitcoin_input.style.display = "flex";
  pix_input.style.display = "none";
  payment_method.setAttribute('value', 'bitcoin');
};
