module Backoffice
  module Installer
    class DashboardController < InstallerController

      def index
        render(:index, locals: { installations: installations })
      end

      private

      def installations
        current_user.product_setups.group(:status).count
      end

    end
  end
end
