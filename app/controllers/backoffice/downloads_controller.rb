module Backoffice
  class DownloadsController < BackofficeController
    def index
      q = current_user.admin? ? MediaFile : MediaFile.actives
      @media_files = q.order(created_at: :desc)
                      .page(params[:page])
                      .per(8)
    end
  end
end
