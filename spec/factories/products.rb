FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 100.0..400.0) }


    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/product_image.png")) }

    # Adicionamos o status aqui (obrigatório agora que temos a coluna)
    status { :available }

    # Mais um campo em products que será utilizado para marcar e destacar produtos na loja.
    featured { true }

    # Aqui está o segredo do polimorfismo na Factory:
    # Ele vai criar um system_requirement automaticamente e associar
    association :productable, factory: :system_requirement
    # featured { true }

    after(:build) do |product|
      # Garantir que o productable seja um Game
      product.productable ||= create(:game)

      product.image.attach(
        io: File.open(Rails.root.join("spec/support/images/product_image.png")),
        filename: "product_image.png",
        content_type: "image/png"
      )
    end
  end
end
