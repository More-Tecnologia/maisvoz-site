window.onload = function(){
  var pix_input = document.getElementById("pix_input");
  var bitcoin_input = document.getElementById("bitcoin_input");
}

function showPixInput() {
  pix_input.style.display = "flex";
  bitcoin_input.style.display = "none";
  var payment_method = document.getElementById("payment_method")

  if(payment_method != null){
    payment_method.setAttribute('value', 'pix');
  }
};

function showBitCoinInput() {
  bitcoin_input.style.display = "flex";
  pix_input.style.display = "none";
  var payment_method = document.getElementById("payment_method")

  if(payment_method != null){
    payment_method.setAttribute('value', 'bitcoin');
  }
};
