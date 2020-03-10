class UpgraderCareerService < ApplicationService

  def call
    new_career = find_new_career
    return unless upgraded_career?(new_career)
    create_career_trail_user(new_career)
    send_congratulations_email_to_user(new_career)
  end

  private

  attr_reader :user, :careers

  def initialize(args)
    @user = args[:user]
    @careers = Career.order(:qualifying_score)
  end

  def upgraded_career?(new_career)
    new_career && new_career != user.current_career
  end

  def create_career_trail_user(new_career)
    new_career_trail = find_new_career_trail(new_career)
    ActiveRecord::Base.transaction do
      user.career_trail_users.create!(career_trail: new_career_trail)
      user.update!(career: new_career_trail.career)
    end
  end

  def find_new_career_trail(new_career)
    CareerTrail.find_by(career: new_career, trail: user.current_trail)
  end

  def find_new_career
    descendent_careers = careers.reverse
    descendent_careers.detect { |career| career.qualify?(user) }
  end

  def send_congratulations_email_to_user(new_career)
    UserMailer.upgrade_career(user, new_career).deliver_later
  end

end
