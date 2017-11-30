$(document).ready(function() {

  function WithdrawSimulator($el) {
    this.$el = $el;
    this.$fee = $el.find('[data-fee-text]');
    this.$total = $el.find('[data-total-text]');
    this.withdrawalFee = parseFloat($el.data('fee'));
  }

  WithdrawSimulator.prototype.init = function() {
    var input = new AutoNumeric('[data-input]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var feeText = new AutoNumeric('[data-fee-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var totalText = new AutoNumeric('[data-total-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)

    var $this = this;

    $('[data-input]').on('keyup', function() {
      var val = input.get() || 0;

      var feeTotal = (val * $this.withdrawalFee).toFixed(2);
      var total = val - feeTotal;

      feeText.set(feeTotal)
      totalText.set(total)
    })
  }

  $('[data-withdraw-simulator]').each(function() {
    var $el = $(this);
    new WithdrawSimulator($el).init();
  });

});
