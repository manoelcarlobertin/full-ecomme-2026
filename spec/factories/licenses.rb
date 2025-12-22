FactoryBot.define do
  factory :license do
    key { SecureRandom.uuid } # Gera uma chave única
    platform { :steam }
    status { :available }
    game # Associa a um jogo automaticamente

    # NÃO definimos user e order_item aqui, pois eles são opcionais (optional: true)
    # e o padrão da licença é nascer "available" (sem dono).
  end
end
