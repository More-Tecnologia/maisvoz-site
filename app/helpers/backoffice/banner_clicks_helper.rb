module Backoffice
  module BannerClicksHelper
    def month
      @month ||= ensure_month
    end

    def ensure_month
      date = Date.parse(params[:month])
      valid_months.cover?(date) ? date : Date.current.end_of_month
    rescue StandardError => error
      Date.current.end_of_month
    end

    def weekdays_of_last_month
      weekdays = t('date.day_names')
      days = weekdays.take_while { |d| d != beginning_of_month_name }

      days.map.with_index { |d, i| beginning_of_month - (i+1).days }
          .reverse
    end

    def beginning_of_month
      month.beginning_of_month
    end

    def end_of_month
      beginning_of_month.end_of_month
    end

    def beginning_of_month_name
      l(beginning_of_month, format: '%A')
    end

    def last_month_last_week_days
      last_month_week_day_names.map { |d|  }
    end

    def month_days
      (beginning_of_month..beginning_of_month.end_of_month)
    end

    def weekdays_of_next_month
      end_of_month_weekday = l(end_of_month, format: '%A')
      weekdays = t('date.day_names').reverse

      days = weekdays.take_while { |d| d != end_of_month_weekday  }.reverse
      days.map.with_index { |d, i| end_of_month + (i+1).days }
    end

    def grid_class_by_dayly_task(date)
      return 'grid-weekend' if date.on_weekend?
      return if date > Date.current
      return 'grid-active' if daily_task_completed?(date)

      'grid-desactive'
    end

    def daily_task_completed?(date)
      day = (date.beginning_of_day..date.end_of_day)
      clicked_banners_count = monthly_clicked_banners.count { |b| b.created_at.in?(day) }

      clicked_banners_count >= BannerClick::QUANTITY_MINIMUM_VIEW_PER_DAY
    end

    def monthly_clicked_banners
      @montly_clicked_banners ||= current_user.banner_clicks
                                              .where(created_at: month_days)
    end

    def min_date
      current_user.created_at.beginning_of_month
    end

    def next_date
      (month + 1.month).end_of_month
    end

    def previous_date
      (month - 1.month).beginning_of_month
    end

    def max_date
      Date.current.end_of_month
    end

    def valid_months
      (min_date..max_date)
    end
  end
end
