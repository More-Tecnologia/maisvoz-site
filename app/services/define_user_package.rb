class DefineUserPackage

  STANDARD = 'standard'.freeze
  MASTER   = 'master'.freeze
  PREMIUM  = 'premium'.freeze

  def initialize(product:)
    @product = product
  end

  def call
    define_package
  end

  private

  attr_reader :product

  def define_package
    return if product.blank?

    if include_package?(STANDARD)
      :standard
    elsif include_package?(MASTER)
      :master
    elsif include_package?(PREMIUM)
      :premium
    end
  end

  def include_package?(package)
    product.name.downcase.include?(package)
  end

end
