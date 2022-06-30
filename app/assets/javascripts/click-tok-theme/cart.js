window.onload = function() {
    var payment_method = document.getElementById("payment_method")
}

function showBalanceInput() {
    payment_method.setAttribute('value', 'balance');
};

function showPromotionalBalanceInput() {
    payment_method.setAttribute('value', 'promotional_balance');
};

function showBitCoinInput() {
    payment_method.setAttribute('value', 'btc');
};

function showPixInput() {
    payment_method.setAttribute('value', 'pix');
};