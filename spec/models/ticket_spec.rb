require 'rails_helper'

RSpec.describe Ticket, type: :model do
	let(:ticket) { create(:ticket) }

  before(:all) do
    CareerTrailFactory.create
  end

  it 'has valid factory' do
    expect(ticket).to be_valid
  end

  it { should belong_to(:subject) }
  it { should belong_to(:user) }
  it { should belong_to(:attendant_user).class_name('User') }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(255) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(30000)}
  it { should have_many(:interactions) }
  it { should define_enum_for(:status).with_values(Ticket::STATUSES) }
  it { should validate_presence_of(:active) }
end