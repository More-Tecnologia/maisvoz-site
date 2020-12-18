require 'rails_helper'

RSpec.describe Subject, type: :model do
	let(:subject) { create(:subject) }

	it 'has valid factory' do
    expect(subject).to be_valid
  end

  it { should validate_uniqueness_of(:name) }
  it { should validate_length_of(:name).is_at_least(1) }
  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_presence_of(:active) }
  it { should have_many(:tickets) }
end
