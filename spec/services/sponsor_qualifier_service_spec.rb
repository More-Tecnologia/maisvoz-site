require 'rails_helper'

RSpec.describe Multilevel::SponsorQualifierService, type: :service do

  let(:sponsor_node) { BinaryNode.first }
  let(:binary_node) { sponsor_node.left_child }

  before(:all) do
    CareerTrailFactory.create
    TreeFactory.new.create_binary
  end

  it 'qualify sponsor' do
    binary_node.user.update_attributes!(sponsor: sponsor_node.user)
    Multilevel::SponsorQualifierService.call(user: binary_node.user)
    expect(binary_node.user.sponsor.binary_qualified).to be_truthy
  end

end
