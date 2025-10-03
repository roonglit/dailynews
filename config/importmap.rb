# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "filepond" # @4.32.9

# Flipbook pins
pin "flipbook", to: "flipbook/build/js/flipbook.min.js"
pin "flipbook.book3", to: "flipbook/build/js/flipbook.book3.min.js"
pin "flipbook.webgl", to: "flipbook/build/js/flipbook.webgl.min.js"
pin "flipbook.swipe", to: "flipbook/build/js/flipbook.swipe.min.js"
pin "flipbook.scroll", to: "flipbook/build/js/flipbook.scroll.min.js"
pin "flipbook.pdfservice", to: "flipbook/build/js/flipbook.pdfservice.min.js"

# Flipbook dependencies
pin "iscroll", to: "flipbook/build/js/libs/iscroll.min.js"
pin "three", to: "flipbook/build/js/libs/three.min.js"
pin "mark", to: "flipbook/build/js/libs/mark.min.js"
pin "pdf", to: "flipbook/build/js/libs/pdf.min.js"
pin "pdf.worker", to: "flipbook/build/js/libs/pdf.worker.min.js"