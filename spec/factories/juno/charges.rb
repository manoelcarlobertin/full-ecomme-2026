FactoryBot.define do
  factory :juno_charge, class: 'Juno::Charge' do
    # Gera uma chave única simulando o padrão da API (ex: chr_abc123...)
    key { "chr_#{Faker::Lorem.characters(number: 20)}" }

    # Gera um código numérico aleatório
    code { Faker::Number.number(digits: 20) }

    # Garante que o número da parcela seja sequencial (1, 2, 3...)
    # Isso é CRUCIAL para passar na validação de uniqueness do modelo.
    sequence(:number) { |n| n }

    # Gera um valor monetário aleatório entre 40 e 100
    amount { Faker::Commerce.price(range: 40..100) }

    status { "ACTIVE" }

    # Gera uma URL fake
    billet_url { Faker::Internet.url(host: 'pay.juno.com') }

    # Cria automaticamente uma Order associada para preencher a chave estrangeira
    order
  end
end
