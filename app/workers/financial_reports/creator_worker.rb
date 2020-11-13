module FinancialReports
  class CreatorWorker
    include Sidekiq::Worker

    def perform
      FinancialReports::CreatorService.call(begin_datetime: 1.week.ago.beginning_of_week,
                                            end_datetime: 1.week.ago.end_of_week)
      enqueue_other_performing_at_next_week
    end

    private

    def enqueue_other_performing_at_next_week
      next_week = 1.week.from_now.beginning_of_week

      FinancialReports::CreatorWorker.perform_at(next_week)
    end
  end
end
