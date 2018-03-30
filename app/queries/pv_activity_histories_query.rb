class PvActivityHistoriesQuery

  def initialize(initial_scope = PvActivityHistory.all)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_by_username(initial_scope, params[:username])
    scoped = paginate(scoped, params[:page])
    scoped = sort(scoped, params[:sort_type], params[:sort_direction])
    scoped
  end

  private

  attr_reader :initial_scope

  def filter_by_username(scoped, username)
    username.present? ? User.find_by(username: username).pv_activity_histories : scoped
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
