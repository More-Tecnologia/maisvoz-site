module Tax
  class IRPFCalculatorService

    #  +-------------+----------+----------+
    #  |  Intervalo  | Alíquota | Desconto |
    #  +-------------+----------+----------+
    #  | até 1903.98 | 0%       |        0 |
    #  | até 2826.65 | 7.5%     |   142.80 |
    #  | até 3751.05 | 15%      |   354.80 |
    #  | até 4664.68 | 22.5%    |   636.13 |
    #  +-------------+----------+----------+

    ZERO        = 0
    TAX_1       = 0.075
    DEDUCTION_1 = 142_80
    TAX_2       = 0.15
    DEDUCTION_2 = 354_80
    TAX_3       = 0.225
    DEDUCTION_3 = 636_13

    def initialize(amount_cents)
      @amount_cents = amount_cents
    end

    def call
      calculate_tax.to_i
    end

    private

    attr_reader :amount_cents

    def calculate_tax
      if amount_cents <= 190398
        ZERO
      elsif amount_cents <= 282665
        amount_cents * TAX_1 - DEDUCTION_1
      elsif amount_cents <= 375105
        amount_cents * TAX_2 - DEDUCTION_2
      elsif amount_cents <= 466468
        amount_cents * TAX_3 - DEDUCTION_3
      else
        raise "The value is not taxable: #{amount_cents / 1e2}"
      end
    end

  end
end
