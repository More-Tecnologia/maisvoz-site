module Backoffice
  module CategorizationHelper
    def categorizations_title_for_select
      @categorizations_title_for_select ||=
        Categorization.select(:id, :title).pluck(:title, :id)
    end

    def categorizations_tag_for_select
      @categorizations_tag_for_select ||=
        Categorization.select(:id, :tag).pluck(:tag, :id)
    end
  end
end
