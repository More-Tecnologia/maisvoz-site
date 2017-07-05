$(document).ready(function() {

  function WithdrawSimulator($el) {
    this.$el = $el;
    this.fee = $el.find('[data-fee]');
    this.total = $el.find('[data-total]');
  }

  WithdrawSimulator.prototype.init = function() {
    var input = this.$el.find("[data-input]");
    var autonumericOptions = input.data('autonumeric');

    var $this = this;

    input.on('keyup', function() {
      var val = $(this).autoNumeric('get') || 0;

      console.log($(this).val());
      console.log($(this).autoNumeric('get'));

      var feeTotal = (val * 0.02).toFixed(2);
      var total = val - feeTotal;

      $this.fee.text($.fn.autoFormat(feeTotal, autonumericOptions));
      $this.total.text($.fn.autoFormat(total.toFixed(2), autonumericOptions));
    })
  }

  $('[data-withdraw-simulator]').each(function() {
    var $el = $(this);
    new WithdrawSimulator($el).init();
  });

});
