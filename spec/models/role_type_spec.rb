require 'rails_helper'

RSpec.describe RoleType, type: :model do
  let(:role_type) { build(:role_type) }

  it 'have a valid factory' do
    expect(role_type.valid?).to be_truthy
  end

  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_uniqueness_of(:name).case_insensitive) }
  it { is_expected.to(validate_presence_of(:code)) }
  it { is_expected.to(validate_uniqueness_of(:code)) }
  it { is_expected.to(validate_numericality_of(:code).only_integer) }
  it { is_expected.to(validate_numericality_of(:code).is_greater_than(0)) }

end
