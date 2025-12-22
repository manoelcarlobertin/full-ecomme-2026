FactoryBot.define do
  factory :juno_credit_card_payment, class: 'Juno::CreditCardPayment' do
    unique_id { Faker::Internet.uuid }
    status { "CAPTURED" }
    association :charge, factory: :juno_charge
  end
end
