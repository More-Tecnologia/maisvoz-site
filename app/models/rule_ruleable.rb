class RuleRuleable < ApplicationRecord
  belongs_to :rule
  belongs_to :ruleable, polymorphic: true

  default_scope { includes(:ruleable, rule: [:rule_type]) }

  validate :ruleable_type_equal_rule_type_model_name

  private

  def ruleable_type_equal_rule_type_model_name
    return if ruleable_type == rule.rule_type.model_name
    message = I18n.t('activerecord.errors.messages.rule_type_missmatch',
                      ruleable_type: I18n.t("activerecord.models.#{ruleable_type.tableize.singularize}"),
                      rule_type_title: rule.rule_type.title)
    errors.add(:base, message)
  end
end
