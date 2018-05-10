class UsersQuery

  def initialize(initial_scope = User.all)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_by_username(initial_scope, params[:username])
    scoped = filter_by_role(scoped, params[:role])
    scoped = filter_by_name(scoped, params[:name])
    scoped = filter_by_email(scoped, params[:email])
    scoped = filter_by_cpf(scoped, params[:document_cpf])
    scoped = paginate(scoped, params[:page])
    scoped = sort(scoped, params[:sort_type], params[:sort_direction])
    scoped
  end

  private

  attr_reader :initial_scope

  def filter_by_username(scoped, username)
    username.present? ? scoped.where("username LIKE ?", "%#{username}%") : scoped
  end

  def filter_by_role(scoped, role)
    role.present? ? scoped.where(role: role) : scoped
  end

  def filter_by_name(scoped, name)
    name.present? ? scoped.where("LOWER(name) LIKE LOWER(?)", "%#{name}%") : scoped
  end

  def filter_by_email(scoped, email)
    email.present? ? scoped.where(email: email) : scoped
  end

  def filter_by_cpf(scoped, document_cpf)
    document_cpf.present? ? scoped.where(document_cpf: document_cpf) : scoped
  end

  def paginate(scoped, page = 0)
    scoped.page(page)
  end

  def sort(scoped, sort_type, sort_direction)
    sort_type      ||= :created_at
    sort_direction ||= :desc
    scoped.order(sort_type => sort_direction)
  end

end
