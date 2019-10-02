require 'rails_helper'

def find_next_career
  careers = Career.all.to_a
  next_career = careers.shift
  careers.detect { |career| career.higher?(next_career) }
end

RSpec.describe UpgraderCareerService, type: :service do
  let(:user) { create(:user) }
  let(:new_career_trail_user) { UpgraderCareerService.call(user: user) }

  before { CareerTrailFactory.create }

  it 'upgrade career' do
    new_career_trail_user
    gotten_career = user.current_career
    expected_career = find_next_career
    expect(gotten_career.id).to eq(expected_career.id)
  end

  it 'keep same trail' do
    old_trail = user.current_trail
    new_career_trail_user
    new_trail = user.current_trail
    expect(new_trail.id).to eq(old_trail.id)
  end
end
