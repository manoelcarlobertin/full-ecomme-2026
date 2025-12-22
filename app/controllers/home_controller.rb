class HomeController < ApplicationController
  def index
    # Busca apenas produtos disponíveis para vender
    @products = Product.where(status: :available).includes(:categories)
  end
end
# Diferente do admin, este controller não herda de AdminController e não exige login.

# Estou criando a "Loja Pública" (Storefront) onde os usuários comuns verão os produtos.
