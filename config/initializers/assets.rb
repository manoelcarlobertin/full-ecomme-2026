# config/initializers/assets.rb

# Esta linha diz ao Propshaft: "Olhe também dentro da pasta app/javascript"
Rails.application.config.assets.paths << Rails.root.join("app/javascript")
