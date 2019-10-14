require 'rails_helper'

def find_next_career
  careers = Career.all.to_a
  current_career = user.current_career
  careers.detect { |career| career.higher?(current_career) }
end

RSpec.describe UpgraderCareerService, type: :service do
  let(:user) { create(:user) }
  let(:new_career_trail_user) { UpgraderCareerService.call(user: user) }

  before { CareerTrailFactory.create }

  it 'upgrade career' do
    expected_career = find_next_career
    new_career_trail_user
    gotten_career = user.current_career
    expect(gotten_career.id).to eq(expected_career.id)
  end

  it 'keep same trail' do
    old_trail = user.current_trail
    new_career_trail_user
    new_trail = user.current_trail
    expect(new_trail.id).to eq(old_trail.id)
  end
end
