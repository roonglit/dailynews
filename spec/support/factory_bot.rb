RSpec.configure do |config|
  # Include Factory Bot syntax methods
  config.include FactoryBot::Syntax::Methods

  # Ensure FactoryBot creates records that persist across database connections
  FactoryBot.use_parent_strategy = false

  # # Configure factory_bot to look for factories in spec/factories
  # config.before(:suite) do
  #   FactoryBot.definition_file_paths << File.expand_path('../factories', __FILE__)
  #   FactoryBot.find_definitions
  # end
end
