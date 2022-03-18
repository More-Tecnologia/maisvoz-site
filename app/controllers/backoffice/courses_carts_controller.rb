# frozen_string_literal: true

module Backoffice
  class CoursesCartsController < BackofficeController
    def show; end

    def update
      command = Shopping::AddToCart.call(current_courses_cart, product_params[:id], params[:country])
      if command.success?
        session[:order_id] = command.result.id
      else
        flash[:error] = t(command.errors)
      end

      redirect_to backoffice_courses_carts_path
    end

    def destroy
      clean_courses_cart

      redirect_to backoffice_courses_carts_path
    end

    private

    def product_params
      params.require(:product).permit(:id)
    end
  end
end