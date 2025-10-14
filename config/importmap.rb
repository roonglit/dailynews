# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/activestorage", to: "@rails--activestorage.js" # @8.0.300

pin_all_from "app/javascript/controllers", under: "controllers"
pin "filepond" # @4.32.9
pin "filepond-plugin-image-preview" # @4.6.12pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
