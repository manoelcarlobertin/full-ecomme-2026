# pedidos feitos pelos usuários
class Order < ApplicationRecord
  DAYS_TO_DUE = 7

  attribute :address
  attribute :card_hash
  attribute :document, :string
  attribute :status, :integer, default: 1
  attribute :payment_type, :integer, default: 0
  attribute :installments, :integer, default: 1
  attribute :subtotal, :decimal, default: 0.0
  attribute :total_amount, :decimal, default: 0.0
  attribute :discount_amount, :decimal, default: 0.0
  attribute :shipping_amount, :decimal, default: 0.0
  attribute :coupon_code, :string
  # Associações
  belongs_to :user
  belongs_to :coupon, optional: true
  has_many :order_items, dependent: :destroy
  has_many :line_items, class_name: "OrderItem", dependent: :destroy
  belongs_to :address, optional: true
  # --- ADICIONE ESTA LINHA ---
  # Dizemos: "O Pedido tem UMA cobrança Juno".
  # class_name: 'Juno::Charge' é essencial porque estamos usando namespaces.
  has_one :juno_charge, class_name: "Juno::Charge", dependent: :destroy

  validates :status, presence: true
  validates :subtotal, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_type, presence: true
  validates :installments, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # validates :document, presence: true, cpf_cnpj: true, on: :create

  with_options if: -> { credit_card? }, on: :create do
    validates :card_hash, presence: true
    validates :address, presence: true
    validates_associated :address
  end

  enum :status, {
    processing_order: 1, waiting_payment: 2, payment_accepted: 3, payment_denied: 4,
    shipped: 5, delivered: 6, canceled: 7, processing_error: 8, returned: 9
  }

  # Método auxiliar para saber se pode cancelar o pedido ou não pelo cliente.
  def cancellable?
    waiting_payment? || processing_order?
  end

  # prefix: true é uma boa prática Senior para evitar colisão (ex: payment_credit_card?)
  enum :payment_type, { credit_card: 1, billet: 2, pix: 3 }

  # --- Callbacks ---
  before_validation :set_default_status, on: :create
  # after_commit garante que o Job só rode se o pedido foi salvo com sucesso no banco
  after_commit :enqueue_juno_charge_creation, on: :create
  around_update :ship_order, if: -> { self.status_changed?(to: "payment_accepted") }

  def due_date
    self.created_at + DAYS_TO_DUE.days
  end

  private

  def set_default_status
    self.status = :processing_order
  end

  def enqueue_juno_charge_creation
    order_attrs = { 
      document: self.document,
      card_hash: self.card_hash,
      address: self.address&.attributes || {}
    }
    Juno::ChargeCreationJob.perform_later(self, order_attrs)
  end

  def ship_order
  # Salva o pedido primeiro (Isso é o que o 'yield' faz no around_update)
  yield 
  
    # Comentamos a lógica de itens pois OrderItem não tem status ainda
    # self.line_items.each { |line_item| line_item.ship! }
  end
end
