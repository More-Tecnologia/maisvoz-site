require 'rails_helper'

RSpec.describe PoolTranding, type: :model do
  let(:pool_tranding) { create(:pool_tranding) }

  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount) }

  it 'have a valid factory' do
    expect(pool_tranding.valid?).to be_truthy
  end

end
