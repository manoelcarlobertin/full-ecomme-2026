FactoryBot.define do
  factory :game do
    # O erro provavelmente estava aqui no 'mode'
    mode { %i[pvp pve both].sample }

    release_date { Faker::Date.forward(days: 365) }
    developer { Faker::Company.name }

    # Associação obrigatória
    association :system_requirement
  end
end
