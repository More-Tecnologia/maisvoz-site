require 'rails_helper'

def randomize_trail_in_current_career(user)
  user.current_career.trails.to_a.sample
end

RSpec.describe UpgraderTrailService, type: :service do
  let(:user) { create(:user) }
  let(:new_trail) { randomize_trail_in_current_career(user) }
  let(:career_trail_user) { UpgraderTrailService.call(user: user, new_trail: new_trail) }

  before { CareerTrailFactory.create }

  it 'upgrade user trail' do
    trail = career_trail_user.career_trail.trail
    expect(user.current_trail).to eq(trail)
  end

  it 'keep same career' do
    expected_career = user.current_career
    gotten_career = career_trail_user.career_trail.career
    expect(gotten_career).to eq(expected_career)
  end
end
