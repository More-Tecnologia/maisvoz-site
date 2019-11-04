require 'rails_helper'

def create_binary_score_to_legs(binary_node, range_amount)
  children = [binary_node.left_child.user, binary_node.right_child.user]
  source_legs = [:left, :right]
  children.each do |child|
    order = create(:order, :with_order_itens, user: child)
    Score.create!(user: binary_node.user,
                 order: order,
                 source_leg: source_legs.shift,
                 cent_amount: rand(range_amount).to_i,
                 height: 1,
                 score_type: ScoreType.binary_score)
  end
end

RSpec.describe Bonification::CreatorBinaryBonusService, type: :service do

  let(:user) { User.first }
  let(:binary_node) { user.binary_node }
  let(:binary_bonus_percent) { user.current_trail.product.binary_bonus_percent }
  let(:total_bonus) { (binary_node.shortter_leg_score * binary_bonus_percent).to_i }
  let(:minimum_score_paid) { ENV['BINARY_SCORE_MINIMUM_PAID'].to_i }
  let(:random_score) { Faker::Number.positive.to_i }
  let(:maximun_score) { minimum_score_paid + random_score }
  let(:range_score) { (minimum_score_paid..maximun_score) }
  let(:monthly_maximum_binary_score) { user.current_career.monthly_maximum_binary_score }

  before(:all) do
    CareerTrailFactory.create
    TreeFactory.new.create_binary
    ScoreTypeFactory.create
    FinancialReasonFactory.create
  end

  context 'when user invalid to receive bonus' do
    before do
      user.binary_unqualify!
      Bonification::CreatorBinaryBonusService.call(binary_node)
    end

    it 'do not create bonus' do
      binary_bonus_count = FinancialReason.binary_bonus.financial_transactions.count
      expect(binary_bonus_count).to eq(0)
    end
  end

  context 'when user valid to receive bonus' do
    before do
      user.binary_unqualify!
      create_binary_score_to_legs(binary_node, range_score)
      Bonification::CreatorBinaryBonusService.call(binary_node)
    end
    it 'create binary bonus' do
      gotten_score_sum =
        FinancialReason.binary_bonus.financial_transactions.sum(:cent_amount)
      expect(gotten_score_sum).to eq(total_bonus)
    end
  end

  context 'when user inactive' do
    before do
      user.activate!
      Bonification::CreatorBinaryBonusService.call(binary_node)
    end

    it 'chargeback by inactivity' do
      gotten_score_sum =
        FinancialReason.chargeback_by_inactivity.financial_transactions.sum(:cent_amount)
      expect(gotten_score_sum).to eq(total_bonus)
    end
  end

  context 'when to exceed monthly bonus' do
    let(:minimum_score) {
      (monthly_maximum_binary_score + ENV['BINARY_SCORE_MINIMUM_PAID'].to_i) / binary_bonus_percent }
    let(:range_amount) { (minimum_score..(minimum_score + random_score)) }
    let(:monthly_maximum_binary_bonus) { monthly_maximum_binary_score * binary_bonus_percent }

    before do
      user.binary_qualify!
      user.activate!
      create_binary_score_to_legs(binary_node, range_amount)
      Bonification::CreatorBinaryBonusService.call(binary_node)
    end

    it 'chargeback bonus excess' do
      expected_excess = (total_bonus - monthly_maximum_binary_bonus).to_i
      gotten_excess =
        FinancialReason.chargeback_excess_monthly.financial_transactions.sum(:cent_amount)
      expect(gotten_excess).to eq(expected_excess)
    end
  end

  context 'when to exceed weekly bonus' do
    let(:weekly_maximum_binary_score) { user.current_career.weekly_maximum_binary_score }
    let(:minimum_score) {
      (weekly_maximum_binary_score + ENV['BINARY_SCORE_MINIMUM_PAID'].to_i) / binary_bonus_percent }
    let(:range_amount) { (minimum_score..(minimum_score + 110)) }
    let(:weekly_maximum_binary_bonus) { weekly_maximum_binary_score * binary_bonus_percent }

    before do
      user.binary_qualify!
      user.activate!
      create_binary_score_to_legs(binary_node, range_amount)
      Bonification::CreatorBinaryBonusService.call(binary_node)
    end

    it 'chargeback bonus excess' do
      expected_excess = (total_bonus - weekly_maximum_binary_bonus).to_i
      gotten_excess =
        FinancialReason.chargeback_excess_weekly.financial_transactions.sum(:cent_amount)
      expect(gotten_excess).to eq(expected_excess)
    end
  end

end
