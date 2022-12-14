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

  def pretty_username
    username
  end

  def pretty_name
    name
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
    @career_name ||= try(:current_career).try(:name)
    @career_name || '-'
  end

  def pretty_address
    @pretty_address ||= [address, address_2, district, city, state, country].delete_if(&:blank?).join(', ')
  end

  def pretty_address_number
    return 'SN' if address_number.blank?
    address_number
  end

  def long_birthdate
    @long_birthdate ||= h.l(birthdate, format: '%m/%d/%Y') if birthdate
  end

  def sponsored_count
    @sponsored_count ||= sponsored.count
  end

  def pretty_career
    career_name
  end

  def pretty_binary_position
    return '-' unless binary_position
    h.t(binary_position)
  end

  def avatar_image_tag(klass = 'img-circle')
    if avatar?
      h.cl_image_tag(avatar.path, class: klass)
    else
      hash = Digest::MD5.hexdigest(email)
      h.image_tag("https://www.gravatar.com/avatar/#{hash}?d=identicon", class: klass)
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

  def sponsor_username
    try(:sponsor).try(:username)
  end

  def pretty_username
    username
  end

  def trail_name
    current_trail.try(:name)
  end

  def support_point_pretty_name
    support_point_user.try(:username).to_s
  end

end
