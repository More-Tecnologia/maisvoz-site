window.onload = function(){
  var payment_method = document.getElementById("payment_method")
}

function showBalanceInput() {
  payment_method.setAttribute('value', 'balance');
};

function showBitCoinInput() {
  payment_method.setAttribute('value', 'btc');
};
