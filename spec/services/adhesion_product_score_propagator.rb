require 'rails_helper'

RSpec.describe Bonification::AdhesionProductScorePropagator, type: :service do
  let(:order) { create(:order, :with_order_itens) }

  before do
    CareerTrailFactory.create
    TreeFactory.new.create_unilevel
  end

  it 'propagate adhesion score for ascendant sponsors' do
    Bonification::AdhesionProductScorePropagator.call(order: order)

    ascendant_sponsors = order.user
                              .ascendant_sponsors
    sponsor_adhesion_scores_sum = Score.adhesion
                                       .where(user_id: ascendant_sponsors)
                                       .sum(:cent_amount)
    expected_sum = order.adhesion_product.binary_score * ascendant_sponsors.size
    expect(sponsor_adhesion_scores_sum).to eq(expected_sum)
  end
end
