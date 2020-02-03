class RecaptchaValidatorService < ApplicationService

  prepend SimpleCommand

  def call
    response = request_recaptcha_validation
    return response[:success]
  end

  private

  def initialize(args)
    @token = args[:token]
  end

  def request_recaptcha_validation
    uri = URI('https://www.google.com/recaptcha/api/siteverify')
    response = Net::HTTP.post_form(uri, build_params)
    JSON.parse(response.body)
  rescue StandardError => error
    {}
  end

  def build_params
    { secret: ENV['GOOGLE_RECAPTCHA_SECRET'],
      response: @token }
  end

end
