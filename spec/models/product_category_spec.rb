require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  # Testando se a tabela intermediária cumpre seu papel de unir as duas pontas
  it { is_expected.to belong_to(:product) }
  it { is_expected.to belong_to(:category) }
end
