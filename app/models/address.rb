class Address < ApplicationRecord
  belongs_to :user

  # Validamos a presença para garantir integridade, já que a Factory agora preenche tudo.
  validates :street, :number, :city, :state, :zipcode, presence: true
end
