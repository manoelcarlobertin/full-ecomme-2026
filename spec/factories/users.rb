FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    # O .unique garante que o Faker não repita e-mails já gerados nesta execução
    email { Faker::Internet.unique.email }
    password { "123456" }
    password_confirmation { "123456" }
    profile { :client }

    # CPF válido gerado pelo Faker guardado na coluna document:
    # document { Faker::IdNumber.brazilian_citizen_number(formatted: true) }
    # MUDANÇA: Usamos string fixa ou Faker::Number genérico para não quebrar
    document { "123.456.789-00" }
    # observação: Ele não se importa se o CPF é matematicamente válido (ainda). Só quer um formato válido.
  end
end
