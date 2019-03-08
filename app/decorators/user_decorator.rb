class UserDecorator < ApplicationDecorator

  delegate_all

  def activity
    if active?
      h.content_tag(:span, h.t('active'), class: 'label label-success')
    else
      h.content_tag(:span, h.t('inactive'), class: 'label label-warning')
    end
  end

  def qualification
    if binary_qualified?
      h.content_tag(:span, h.t('qualified'), class: 'label label-success')
    else
      h.content_tag(:span, h.t('unqualified'), class: 'label label-warning')
    end
  end

  def pretty_name
    return name if pf?
    "#{document_company_name} - #{name}"
  end

  def name_or_company_name
    return name if pf?
    document_company_name
  end

  def tr_name_or_company_name
    return '' if name_or_company_name.blank?

    I18n.transliterate(name_or_company_name)
  end

  def tr_document_fantasy_name
    return '' if user.document_fantasy_name.blank?

    I18n.transliterate(user.document_fantasy_name)
  end

  def main_document
    if pj?
      document_cnpj
    else
      document_cpf
    end
  end

  def left_pv
    return '-' if binary_node.blank?
    @left_pv ||= binary_node.left_pv
  end

  def right_pv
    return '-' if binary_node.blank?
    @right_pv ||= binary_node.right_pv
  end

  def career_name
    return '-' if career_kind.blank?
    @career_name ||= career_kind.upcase
  end

  def pretty_address
    @pretty_address ||= [address, address_2, district, city, state, country].delete_if(&:blank?).join(', ')
  end

  def pretty_address_number
    return 'SN' if address_number.blank?
    address_number
  end

  def long_birthdate
    return '-' unless birthdate.present?
    @long_birthdate ||= h.l(birthdate, format: :long)
  end

  def sponsored_count
    @sponsored_count ||= sponsored.count
  end

  def bank_account_present?
    bank_code? && bank_account? && bank_agency? && bank_account_type?
  end

  def pretty_career
    return '-' unless career_kind
    h.t(career_kind)
  end

  def pretty_binary_position
    return '-' unless binary_position
    h.t(binary_position)
  end

  def avatar_image_tag
    if avatar?
      h.cl_image_tag(avatar.path, class: 'img-circle')
    else
      hash = Digest::MD5.hexdigest(email)
      h.image_tag("https://www.gravatar.com/avatar/#{hash}?d=identicon", class: 'img-circle')
    end
  end

  def phone_ddd
    return '' if phone.blank?
    phone[/\d{2}/, 0]
  end

  def phone_number
    return '' if phone.blank?
    phone[/\d+.\d+/, 0]
  end

  def document_cpf_digits
    return '' unless document_cpf
    document_cpf.scan(/\d+/).join
  end

  def document_cnpj_digits
    return '' unless document_cnpj
    document_cnpj.scan(/\d+/).join
  end

end
