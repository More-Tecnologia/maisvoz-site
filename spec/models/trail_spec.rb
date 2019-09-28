require 'rails_helper'

RSpec.describe Trail, type: :model do
  let(:trail) { create(:trail) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it 'has valid factory' do
    expect(trail.valid?).to be_truthy
  end
end
