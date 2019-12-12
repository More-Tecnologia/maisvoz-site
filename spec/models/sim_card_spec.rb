require 'rails_helper'

RSpec.describe SimCard, type: :model do
  let(:sim_card) { build(:sim_card) }

  it 'have a valid factory' do
    expect(sim_card.valid?).to be_truthy
  end

  it { is_expected.to(validate_presence_of(:iccid)) }
  it { is_expected.to(validate_uniqueness_of(:iccid)) }
  it { is_expected.to(validate_length_of(:phone_number).is_at_least(9)) }
  it { is_expected.to(validate_length_of(:phone_number).is_at_most(13)) }
  it { is_expected.to(validate_numericality_of(:phone_number).only_integer) }

end
