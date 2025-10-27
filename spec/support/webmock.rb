require "webmock/rspec"

allowed_sites = []

WebMock.disable_net_connect!(allow_localhost: true, allow: allowed_sites)

RSpec.configure do |config|
  config.before(:each) do |ex|
    # Reset charges storage before each test
    FakeServers::Omise::Application.reset_charges!

    # Stub all Omise API requests to use our FakeServer via Rack
    stub_request(:any, /api\.omise\.co/).to_rack(FakeServers::Omise::Application)
  end
end
