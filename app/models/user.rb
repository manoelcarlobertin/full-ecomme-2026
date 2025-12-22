class User < ApplicationRecord
  before_validation :sanitize_document
  include LikeSearchable
  searchable_by :name  # Ou :email, se preferir
  # include Paginatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associações
  has_many :wish_items
  # --- ADICIONE ESTA LINHA ---
  # dependent: :nullify significa que se o usuário for apagado,
  # o pedido fica no banco (sem dono) para histórico financeiro.
  # Em projetos de estudo, pode usar :destroy se preferir limpar tudo.
  has_many :orders, dependent: :destroy
  # O usuário tem muitos itens de desejo. Se deletar o usuário, apaga a lista dele.
  has_many :wish_items, dependent: :destroy
  has_one :address, dependent: :destroy
  # Enum -> ensinamos ao Rails quem é Admin e quem é Cliente.
  # 0 = Admin, 1 = Cliente
  enum :profile, { admin: 0, client: 1 }

  validates :name, presence: true
  validates :profile, presence: true

  private

  def sanitize_document
    # Remove tudo que não for número antes de salvar
    self.document = document.gsub(/\D/, '') if document.present?
  end
end
