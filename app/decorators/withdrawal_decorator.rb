class WithdrawalDecorator < ApplicationDecorator

  delegate_all

  def pretty_status
    if pending?
      h.content_tag(:span, h.t('pending'), class: 'label label-warning')
    elsif approved?
      h.content_tag(:span, h.t('approved'), class: 'label label-success')
    elsif waiting?
      h.content_tag(:span, h.t('waiting'), class: 'label label-info')
    elsif canceled?
      h.content_tag(:span, h.t('canceled'), class: 'label label-danger')
    else
      h.content_tag(:span, h.t('refused'), class: 'label label-danger')
    end
  end

end
