class CareerHistoriesQuery

  def initialize(initial_scope = CareerHistory.all)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_by_username(initial_scope, params[:username])
    scoped = filter_by_career(scoped, params[:career])
    scoped = paginate(scoped, params[:page])
    scoped = sort(scoped, params[:sort_type], params[:sort_direction])
    scoped
  end

  private

  attr_reader :initial_scope

  def filter_by_username(scoped, username)
    username.present? ? User.find_by(username: username).career_histories : scoped
  end

  def filter_by_career(scoped, career)
    career.present? ? scoped.where(new_career: career) : scoped
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
