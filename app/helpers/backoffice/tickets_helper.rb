module Backoffice
  module TicketsHelper
    def active_subject_options
      Subject.where(active: true).map { |subject| [t("defaults.#{subject.name.downcase.gsub(/\s/, '_')}"), subject.id] }
    end

    def ticket_statuses_options
      Ticket.statuses.map { |status| [t(status.first), status.last] }
    end

    def active_users_options
      User.where(active: true).map { |user| [user.username, user.id] }
    end
  end
end
