require "omise"

Omise.api_key = Rails.application.credentials.dig(:omise, :secret_key)