module UsersHelper

  def render_blocked_user_attribute_link(user)
    html_class = user.blocked ? 'fa fa-thumbs-up text-danger' : 'fa fa-thumbs-down'
    link_to( backoffice_support_blocked_user_path(user, blocked: !user.blocked),
             method: :put,
             remote: true,
             id: "user-#{user.id}-blocked" ) do
      content_tag :i, '', class: html_class
    end
  end

  def render_canceled_user_attribute_link(user)
    html_class = user.canceled ? 'fa fa-thumbs-up text-danger' : 'fa fa-thumbs-down'
    link_to( backoffice_support_canceled_user_path(user, canceled: !user.canceled),
             method: :put,
             remote: true,
             id: "user-#{user.id}-canceled" ) do
      content_tag :i, '', class: html_class
    end
  end

  def dashboard_direction(user)
    if user.admin?
      backoffice_admin_dashboard_index_path
    else
      backoffice_dashboard_index_path
    end
  end

  def hide_name(name)
    name.reverse.sub(/(?<=.).{4}?(?=.)/, '****').reverse
  end

end
