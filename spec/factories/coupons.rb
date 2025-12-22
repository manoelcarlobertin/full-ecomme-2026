FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "Coupon #{n}" }
    code { Faker::Commerce.promotion_code }
    status { :active }
    discount_value { 10.00 }
    max_use { 100 }
    due_date { 3.days.from_now } # Sempre gera uma data futura válida
  end
end
