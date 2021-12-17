$(document).ready(function(){
  let btc = $('#btc-amount').val();
  let dollar = $('#dollar-amount').val();
  $("th.crypto").append( `Total: ${btc}`);
  $("th.total").append( `Total: ${dollar}`);
});
