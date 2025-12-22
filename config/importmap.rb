# Pin npm packages by running ./bin/importmap
pin "application" # Aponta para app/javascript/application.js

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# Reforço manual (Overrules) para garantir que pegue o .js
pin "controllers/modal_controller", to: "controllers/modal_controller.js"
pin "controllers/application", to: "controllers/application.js"
pin "controllers/hello_controller", to: "controllers/hello_controller.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
