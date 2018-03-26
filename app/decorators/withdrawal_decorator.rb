class WithdrawalDecorator < ApplicationDecorator

  delegate_all

  def pretty_status
    if pending?
      h.content_tag(:span, h.t('pending'), class: 'label label-warning')
    elsif approved?
      h.content_tag(:span, h.t('approved'), class: 'label label-success')
    else
      h.content_tag(:span, h.t('refused'), class: 'label label-danger')
    end
  end

end
