module Sendgrid
  def category(category)
    headers['X-SMTPAPI'] = "{\"category\": \"#{category}\"}"
  end
end
