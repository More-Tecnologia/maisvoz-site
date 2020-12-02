require 'rails_helper'

RSpec.describe Types::QualifierService, type: :service do
  before(:all) { CareerTrailFactory.create }

  context 'when type qualify by user activity' do
    let(:user) { create(:user, active: true) }
    let(:type) { create(:type, qualify_by_user_activity: true) }

    before do
      type.indications_quantity.times { create(:user, sponsor: user, active: true, type: user.type) }
    end

    subject { Types::QualifierService.call(user: user) }

    it 'update user type' do
      expect(subject.type).to eq(type)
    end
  end

  context 'when type do not qualify by user activity' do
    let(:user) { create(:user, active: false) }
    let(:type) { create(:type, qualify_by_user_activity: false) }

    before do
      type.indications_quantity.times { create(:user, sponsor: user, active: true, type: user.type) }
    end

    subject { Types::QualifierService.call(user: user) }

    it 'update user type' do
      expect(subject.type).to eq(type)
    end
  end
end
