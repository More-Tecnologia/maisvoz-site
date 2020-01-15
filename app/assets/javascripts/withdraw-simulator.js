$(document).ready(function() {

  function WithdrawSimulator($el) {
    this.$el = $el;
    this.$fee = $el.find('[data-fee-text]');
    this.$total = $el.find('[data-total-text]');
    this.irpf = parseFloat($el.data('irpf'));
    this.inss = parseFloat($el.data('inss'));
    this.withdrawalFee = parseFloat($el.data('fee'));
    this.registrationType = $el.data('registration-type]');
  }

  WithdrawSimulator.prototype.init = function() {
    var input = new AutoNumeric('[data-input]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var feeText = new AutoNumeric('[data-fee-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var totalText = new AutoNumeric('[data-total-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    var $this = this;

    if ($this.registrationType == 'pf'){
      var irpfText = new AutoNumeric('[data-irpf-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
      var inssText = new AutoNumeric('[data-inss-text]', AutoNumeric.getPredefinedOptions().commaDecimalCharDotSeparator)
    }

    $('[data-input]').on('keyup', function() {

      var val = input.get() || 0;
      var feeTotal = ($this.withdrawalFee).toFixed(2);
      var irpf = 0
      var inss = 0

      if ($this.registrationType == 'pf'){
        var irpf = (($this.irpf).toFixed(2) || 0) * val / 100;
        var inss = (($this.inss).toFixed(2) || 0) * val / 100;
      }

      var total = val - feeTotal - inss - irpf;

      feeText.set(feeTotal)
      totalText.set(total)

      if ($this.registrationType == 'pf'){
        irpfText.set(irpf)
        inssText.set(inss)
      }

    })

    function calculate_total_to_pf() {

    }

  }

  $('[data-withdraw-simulator]').each(function() {
    var $el = $(this);
    new WithdrawSimulator($el).init();
  });

});
