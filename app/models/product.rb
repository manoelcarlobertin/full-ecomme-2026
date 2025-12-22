class Product < ApplicationRecord
  include LikeSearchable
  searchable_by :name  # <--- Dizemos explicitamente: busque por NOME

  # include Paginatable

  # por enquanto, um produto pode existir sem ser um Jogo ou Hardware. 'optional: true'
  belongs_to :productable, polymorphic: true, optional: true
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :wish_items, dependent: :destroy # Garanta que isso esteja aqui também
  # has_many :line_items
  has_one_attached :image

  # ESSENCIAL: Permite salvar o Game e os Requisitos junto com o Produto, em um único formulário, 
  # usando 'fields_for' no formulário. --- para aceitar atributos aninhados ---
  accepts_nested_attributes_for :productable, reject_if: :all_blank

  # Validações
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :image, presence: true
  validates :status, presence: true

  # Poder marcar um produto como destaque (featured) ou não
  validates :featured, presence: true, if: -> { featured.nil? }

  # Adicionamos o enum para mapear inteiros para texto / disponível/ sem estoque
  enum :status, { available: 1, unavailable: 2 }

  def sells_count
    LineItem.joins(:order).where(orders: { status: :finished }, product: self).sum(:quantity)
  end
end
