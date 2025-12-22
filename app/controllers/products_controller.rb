class ProductsController < ApplicationController
  # Permite que qualquer um veja os produtos (não precisa de authenticate_user!)
  # Se quiser restringir, adicione o before_action

  def show
    @product = Product.find(params[:id])
  end
end
