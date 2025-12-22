require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  # Associações
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:product) }

  # Validações
  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }

  it { is_expected.to validate_presence_of(:payed_price) }
  it { is_expected.to validate_numericality_of(:payed_price).is_greater_than(0) }
end
