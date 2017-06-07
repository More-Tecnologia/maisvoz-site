module Backoffice
  module Admin
    class CategoriesController < BackofficeController

      def index
        @categories = Category.all
      end

      def new
        render_new
      end

      def edit
        render_edit
      end

      def create
        if CreateCategory.new(form).call
          flash[:success] = I18n.t('defaults.saving_success')
          redirect_to backoffice_admin_categories_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render_new
        end
      end

      def update
        if UpdateCategory.new(form, category).call
          flash[:success] = I18n.t('defaults.saving_success')
          redirect_to backoffice_admin_categories_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render_edit
        end
      end

      def destroy
        if DestroyCategory.new(category).call
          flash[:success] = I18n.t('defaults.destroying_success')
        else
          flash[:error] = I18n.t('defaults.destroying_error')
        end
        redirect_to backoffice_admin_categories_path
      end

      private

      def render_new
        render(:new, locals: { form: form })
      end

      def render_edit
        render(:edit, locals: { form: form, category: category })
      end

      def category
        @category ||= Category.find(params[:id])
      end

      def form
        @form ||= CategoryForm.new(category_params)
      end

      def category_params
        params[:category_form] ||= category.attributes if params[:id].present?
        params.fetch(:category_form, {}).permit!
      end

    end
  end
end
