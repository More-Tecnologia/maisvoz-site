class ApiController < ActionController::API

  before_action :authenticate_request

  private

  def authenticate_request
    api_key = request.headers['Authorization']

    render json: { status: 'ERROR' }, status: :unauthorized if api_key != authorization
  end

  def authorization
    ENV['AUTHORIZATION_KEY']
  end

end
