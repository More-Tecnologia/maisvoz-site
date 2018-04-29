class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = [ENV['SANDBOX_EMAIL']]
  end
end

if ENV['INTERCEPT_EMAILS'] == 'true'
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
