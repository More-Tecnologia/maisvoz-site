class UserDecorator < SimpleDelegator

  def left_pv
    return '-' if binary_node.blank?
    @left_pv ||= binary_node.left_pv
  end

  def right_pv
    return '-' if binary_node.blank?
    @right_pv ||= binary_node.right_pv
  end

  def career_name
    return '-' if user.career_kind.blank?
    @career_name ||= user.career_kind
  end

  def pretty_address
    @pretty_address ||= [address, address_2, city, state, country].delete_if(&:blank?).join(', ')
  end

  def long_birthdate
    return '-' unless birthdate.present?
    @long_birthdate ||= h.l(birthdate, format: :long)
  end

  def sponsored_count
    @sponsored_count ||= sponsored.count
  end

  private

  def h
    ApplicationController.helpers
  end

end
