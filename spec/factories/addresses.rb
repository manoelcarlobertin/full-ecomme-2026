FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    number { Faker::Address.building_number }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zipcode { Faker::Address.zip_code }

    # Cria um usuário automaticamente para esse endereço
    user
  end
end
