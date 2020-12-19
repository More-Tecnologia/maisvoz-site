require 'rails_helper'

RSpec.describe Interaction, type: :model do
	let(:interaction) { create(:interaction) }

  before(:all) do
    CareerTrailFactory.create
  end

	it 'has valid factory' do
    expect(interaction).to be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:ticket) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(30000) }
  it { should validate_presence_of(:active) }
  it { should define_enum_for(:status).with_values(Ticket::STATUSES) }
end
