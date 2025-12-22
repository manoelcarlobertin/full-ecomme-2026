class License < ApplicationRecord
  include LikeSearchable
  searchable_by :key   # <--- Dizemos explicitamente: busque por KEY

  belongs_to :game
  belongs_to :user, optional: true # Licença pode existir sem dono antes de vender? Se sim, optional.
  belongs_to :order_item, optional: true

  # Se a chave deve ser única APENAS dentro da mesma plataforma (pode repetir em plataformas diferentes):
  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :platform }

  # OU, se a chave deve ser única GLOBALMENTE (não pode repetir nunca):
  # validates :key, presence: true, uniqueness: { case_sensitive: false }
  validates :platform, presence: true
  validates :status, presence: true

  # Validação Condicional: Só exige order_item e user se a licença estiver vendida
  validates :order_item, :user, presence: true, if: -> { status == "in_use" }

  # enum platform: { steam: 1, battle_net: 2, origin: 3 } ERRADA SINTAXE
  # Sintaxe correta: :nome_do_campo, { mapa_de_valores }
  enum :platform, { steam: 1, battle_net: 2, origin: 3 }
  enum :status, { available: 1, in_use: 2, inactive: 3 }
end
