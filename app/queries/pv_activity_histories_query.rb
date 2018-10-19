class PvActivityHistoriesQuery

  def initialize(initial_scope = PvActivityHistory.all)
    @initial_scope = initial_scope
  end

  def call(params, should_paginate = true)
    scoped = filter_by_username(initial_scope, params[:username])
    scoped = filter_by_kind(scoped, params[:kind])
    scoped = filter_by_created_at(scoped, params[:created_at_gteq], params[:created_at_lteq])
    scoped = paginate(scoped, params[:page]) if should_paginate
    scoped = sort(scoped, params[:sort_type], params[:sort_direction])
    scoped
  end

  private

  attr_reader :initial_scope

  def filter_by_username(scoped, username)
    username.present? ? User.find_by(username: username).pv_activity_histories : scoped
  end

  def filter_by_kind(scoped, kind)
    return scoped if kind.blank?

    scoped.where(kind: kind)
  end

  def filter_by_created_at(scoped, gteq, lteq)
    scoped = scoped.where('created_at >= ?', convert_date(gteq).beginning_of_day) if gteq.present?
    scoped = scoped.where('created_at <= ?', convert_date(lteq).end_of_day) if lteq.present?
    scoped
  end

  def paginate(scoped, page = 0)
    scoped.page(page)
  end

  def sort(scoped, sort_type, sort_direction)
    sort_type      ||= :created_at
    sort_direction ||= :desc
    scoped.order(sort_type => sort_direction)
  end

  def convert_date(str)
    DateTime.strptime(str, '%m/%d/%Y').in_time_zone(Time.zone)
  end

end
