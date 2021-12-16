require 'rails_helper'

RSpec.describe Webhooks::Interspire::ContactAdderService, type: :service do
  context 'with valid params' do
    let(:valid_params) {
                         {
                           email: Faker::Internet.email,
                           confirmed: %i[yes no].sample,
                           custom_fields: {
                             FirstName: Faker::Name.name,
                             LastName: Faker::Name.name
                           }
                         }
                       }

    subject { Webhooks::Interspire::ContactAdderService.call(valid_params) }

    it 'return contact id' do
      expect(subject.dig('data')).to match(/\d+/)
    end
  end
end
