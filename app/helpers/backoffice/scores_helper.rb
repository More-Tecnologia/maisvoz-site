module Backoffice
  module ScoresHelper
    def find_scores_by(tree_type)
      return ScoreType.binary.pluck(:name, :id) if tree_type == 'binary'
      return ScoreType.unilevel.pluck(:name, :id) if tree_type == 'unilevel'
      ScoreType.all.pluck(:name, :id)
    end

    def find_scores_search_url(tree_type)
      return backoffice_binary_scores_path if tree_type == 'binary'
      return backoffice_unilevel_scores_path if tree_type == 'unilevel'
      backoffice_admin_scores_path
    end

    def find_scores_page_title_by(tree_type)
      return t('backoffice.scores.index.title.binary') if tree_type == 'binary'
      return t('backoffice.scores.index.title.unilevel') if tree_type == 'unilevel'
      t('backoffice.scores.index.title.all')
    end

    def translate_source_leg(source_leg)
      I18n.t("attributes.#{source_leg}")
    end

    def sum_cent_amount(scores)
      @cent_amount_sum ||= scores.map(&:cent_amount).sum
    end
  end
end
