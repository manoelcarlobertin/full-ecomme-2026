FactoryBot.define do
  factory :order_item do
    quantity { 1 }
    payed_price { 100.00 }
    association :order
    association :product
  end
end
