require "omise"


if Rails.env.test?
  Omise.api_key = "test_secret_key"
else
  Omise.api_key = Rails.application.credentials.dig(:omise, :secret_key)
end
