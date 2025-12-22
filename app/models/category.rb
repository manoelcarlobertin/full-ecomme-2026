class Category < ApplicationRecord
  include NameSearchable
  # include Paginatable

  # Relacionamento M:N
  has_many :product_categories, dependent: :destroy
  # posso chamar Category.first.products (para ver os produtos daquela categoria)
  has_many :products, through: :product_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
