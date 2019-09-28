require 'rails_helper'

RSpec.describe RuleRuleable, type: :model do
  let(:missmatch_rule_ruleable) { build(:rule_ruleable, :ruleable_missmatch_rule_type) }
  context 'when ruleable missmatch rule type' do
    before { missmatch_rule_ruleable.valid? }

    it 'add error message' do
      ruleable_type =
        I18n.t("activerecord.models.#{missmatch_rule_ruleable.ruleable_type.tableize.singularize}")
      rule_type_title = missmatch_rule_ruleable.rule.rule_type.title
      error_message = I18n.t('activerecord.errors.messages.rule_type_missmatch',
                             ruleable_type: ruleable_type,
                             rule_type_title: rule_type_title)
      gotten_error_message = missmatch_rule_ruleable.errors.full_messages
      expect(gotten_error_message).to include(error_message)
    end
  end
end
