class ApiController < ActionController::API

  before_action :authenticate_request

  def render_error(error_code, error_message)
    head error_code, json: { error_message: error_message }
  end

  private

  def authenticate_request
    api_key = request.headers['Authorization'].presence || params[:api_key]

    render json: { status: 'ERROR' }, status: :unauthorized if api_key != authorization
  end

  def authorization
    ENV['AUTHORIZATION_KEY']
  end

end
