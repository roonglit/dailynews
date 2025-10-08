# Database Cleaner configuration for proper test isolation
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # For non-system tests, use transaction strategy
  config.before(:each) do |example|
    if example.metadata[:type] == :system
      # Set truncation strategy for system tests
      driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test
      unless driver_shares_db_connection_with_specs
        # puts "Using truncation strategy for system tests with driver: #{Capybara.current_driver}"
        DatabaseCleaner.strategy = :truncation
      end
    else
      # Use transaction strategy for non-system tests
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  # Use append_after to ensure this runs after Capybara's cleanup
  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
