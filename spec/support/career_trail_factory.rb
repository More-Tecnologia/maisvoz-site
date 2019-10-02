class CareerTrailFactory
  include FactoryBot::Syntax::Methods

  def self.create(count = 5)
    new.create_career_trails(count)
  enduser.current_trail

  def create_career_trails(count = 5)
    careers = create_careers(count)
    trails = (1..count).to_a.map { create(:trail) }
    career_trails = []

    careers.each do |career|
      trails.each do |trail|
        career_trails << create(:career_trail, career: career, trail: trail)
      end
    end
    career_trails
  end

  private

  def create_careers(count)
    subscription_career = create(:career, qualifying_score: 0)
    career_qualifying_score = -1000
    careers = (1..count).to_a.map { create(:career, qualifying_score: career_qualifying_score += 1000) }
    [subscription_career] + careers
  end
end
