require 'rails_helper'

RSpec.describe Category, type: :model do
	let(:category) { create(:category) }

	it 'has valid factory' do
    expect(category).to be_valid
  end

  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should have_many(:products) }
end
