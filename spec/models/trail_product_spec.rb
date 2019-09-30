require 'rails_helper'

RSpec.describe TrailProduct, type: :model do
  it { is_expected.to belong_to(:trail) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to validate_uniqueness_of(:product).scoped_to(:trail_id) }
end
