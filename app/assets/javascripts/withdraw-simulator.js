$(document).ready(function() {

  function WithdrawSimulator($el) {
    this.$el = $el;
    this.$fee = $el.find('[data-fee-text]');
    this.$total = $el.find('[data-total-text]');
    this.withdrawalFee = parseFloat($el.data('fee'));
    this.withdrawalFeeAbove = parseFloat($el.data('fee-above'));
    this.withdrawalThreshold = parseFloat($el.data('withdrawal-threshold'));
    this.registrationType = $el.data('registration-type');
  }

  WithdrawSimulator.prototype.init = function() {
    var input = new AutoNumeric('[data-input]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var feeText = new AutoNumeric('[data-fee-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var totalText = new AutoNumeric('[data-total-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var $this = this;

    $('[data-input]').on('keyup', function() {
      var val = input.get() || 0;
      var fee = ($this.withdrawalFee).toFixed(2) / 100.0;
      var fee_above = ($this.withdrawalFeeAbove).toFixed(2) / 100.0;
      var withdrawal_threshold = ($this.withdrawalThreshold).toFixed(2);
      var feeTotal = val * fee;

      if(val > withdrawal_threshold) {
        feeTotal = val * fee_above;
      }

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
