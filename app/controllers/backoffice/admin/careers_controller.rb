module Backoffice
  module Admin
    class CareersController < AdminController

      def index
        @careers = Career.includes(:unilevel_qualifying_career)
                         .order(:qualifying_score)
      end

      def new
        render_new
      end

      def edit
        render_edit
      end

      def create
        if CreateCareer.new(form).call
          flash[:success] = I18n.t('defaults.saving_success')
          redirect_to backoffice_admin_careers_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render_new
        end
      end

      def update
        if UpdateCareer.new(form, career).call
          flash[:success] = I18n.t('defaults.saving_success')
          redirect_to backoffice_admin_careers_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render_edit
        end
      end

      def destroy
        if DestroyCareer.new(career).call
          flash[:success] = I18n.t('defaults.destroying_success')
        else
          flash[:error] = I18n.t('defaults.destroying_error')
        end
        redirect_to backoffice_admin_careers_path
      end

      private

      def render_new
        render(:new, locals: { form: form })
      end

      def render_edit
        render(:edit, locals: { form: form, career: career })
      end

      def career
        @career ||= Career.find(params[:id])
      end

      def form
        @form ||= CareerForm.new(form_params)
      end

      def form_params
        params[:career_form] ||= career.attributes if params[:id].present?
        params.fetch(:career_form, {}).permit!
      end

    end
  end
end
