window.onload = function(){
  var payment_method = document.getElementById("payment_method")
}

function showPixInput() {
  payment_method.setAttribute('value', 'pix');
};

function showBitCoinInput() {
  payment_method.setAttribute('value', 'bitcoin');
};
