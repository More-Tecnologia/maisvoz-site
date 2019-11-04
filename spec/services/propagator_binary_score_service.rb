require 'rails_helper'

def create_score_to_left_brother(user)
  left_brother = user.binary_node.parent.left_child.user
  order = create(:order, :with_order_itens, user: left_brother)
  ancestors = left_brother.binary_node.ancestors
  ancestors.each_with_index do |ancestor, generation|
    create(:score, user: ancestor.user,
                   order: order,
                   height: generation,
                   spreader_user: left_brother,
                   cent_amount: order.total_score.to_i,
                   source_leg: :left,
                   score_type: ScoreType.binary_score)
  end
end

def count_ancestors_qualified_inactive_and_shortter_leg_right(user)
  ancestors = user.binary_node.ancestors.select { |n|
    n.user.binary_unqualified? && n.user.inactive? && n.shortter_leg == :right
  }.count
end

RSpec.describe Bonification::Propagator::BinaryScoreService, type: :service do
  let(:user) { User.last }
  let(:order) { create(:order, :with_order_itens, user: user) }

  before(:all) do
    CareerTrailFactory.create
    TreeFactory.new.create_binary
    ScoreTypeFactory.create
  end

  before do
    Bonification::Propagator::BinaryScoreService.call(order: order)
  end

  it 'create binary scores' do
    ancestors_count = user.binary_node.ancestors.count
    expected_score_sum = order.total_score * ancestors_count
    gotten_score_sum = ScoreType.binary_score.scores.sum(:cent_amount)
    expect(gotten_score_sum).to eq(expected_score_sum)
  end

  it 'score sum greater zero' do
    gotten_score_sum = ScoreType.binary_score.scores.sum(:cent_amount)
    score_sum_greater_zero = gotten_score_sum > 0
    expect(score_sum_greater_zero).to be_truthy
  end

  context 'when user binary unqualificated' do
    it 'create unqualification chargeback score' do
      unqualified_ancestors_count = user.binary_node.ancestors.select{ |n| n.user.binary_unqualified? }.count
      expected_score_sum = -order.total_score * unqualified_ancestors_count
      gotten_score_sum = ScoreType.binary_unqualified_chargeback.scores.sum(:cent_amount)
      expect(gotten_score_sum).to eq(expected_score_sum)
    end
  end

  context 'when user qualified and inactive' do

    before do
      create_score_to_left_brother(user)
      Bonification::Propagator::BinaryScoreService.call(order: order)
    end

    it 'creates inactivity chargeback score' do
      ancestor_count = count_ancestors_qualified_inactive_and_shortter_leg_right(user)
      expected_score_sum = -order.total_score * ancestor_count
      gotten_score_sum = ScoreType.inactivity_chargeback.scores.sum(:cent_amount)
      expect(gotten_score_sum).to eq(gotten_score_sum)
    end

  end

end
