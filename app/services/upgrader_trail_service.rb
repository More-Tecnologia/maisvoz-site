class UpgraderTrailService < ApplicationService

  def call
    new_career_trail = find_trail_in_same_career
    ActiveRecord::Base.transaction do
      user.update!(trail: new_career_trail.trail)
      user.career_trail_users.create!(career_trail: new_career_trail)
    end
  end

  private

  attr_reader :user, :new_trail

  def initialize(args)
    @user = args[:user]
    @new_trail = args[:new_trail]
  end

  def find_trail_in_same_career
    CareerTrail.find_by(career: user.current_career, trail: new_trail)
  end
  
end
