module OmiseHelpers
  def user_pays_with_omise(overrides = {})
    token = overrides[:token] || 'tokn_test_5mokdpoelz84n3ai99l'

    page.execute_script <<-JS
      // Mock OmiseCard to avoid the dialog
      window.OmiseCard = {
        configure: function() {},
        open: function(config) {
          // Simulate immediate success with a fake token
          config.onCreateTokenSuccess(token);
        }
      };
    JS
  end
end