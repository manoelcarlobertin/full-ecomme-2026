class WishItemsController < ApplicationController
  before_action :authenticate_user! # 1. Segurança Essencial

  # Listar os itens de produto da lista de desejos do 'usuário atual'
  def index
      @wish_items = current_user.wish_items.joins(:product)
                                           .includes(product: :image_attachment) # Otimização para imagens
                                           .order("products.name ASC")
  end

  # Favoritar
  def create
    @wish_item = current_user.wish_items.build(wish_item_params)

    if @wish_item.save
      respond_to do |format|
        # 2. Suporte a Turbo Stream (Atualiza só o ícone de coração se quiser)
        format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "favorite_button_#{@wish_item.product_id}",
              partial: "products/favorite_button",
              locals: { product: @wish_item.product }
            )
        end
        # 3. Fallback HTML (Redireciona de volta para onde o usuário estava)
        format.html { redirect_back(fallback_location: root_path, notice: "Produto foi FAVORITADO/ADICIONADO na Minha Lista de Desejos com sucesso!") }
      end
    else
      # Se falhar (ex: já favoritou), redireciona com alerta
      redirect_back(fallback_location: root_path, alert: "NÃO foi possível favoritar/colocar produto na Lista de Desejos!")
    end
  end

  # Desfavoritar
  def destroy
    @wish_item = current_user.wish_items.find(params[:id])
    @wish_item.destroy

    respond_to do |format|
      format.turbo_stream do
        # Remove o card da lista visualmente ou atualiza o botão
        render turbo_stream: turbo_stream.remove(@wish_item)
      end
      # Se for HTML normal (o botão que acabamos de configurar com turbo: false), vai para a lista
      format.html { redirect_to wish_items_path, notice: "Produto foi DESFAVORITADO/REMOVIDO da Lista de Desejos." }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to wish_items_path, alert: "Produto NÃO foi encontrado!"
  end

  private

  def wish_item_params
    params.require(:wish_item).permit(:product_id)
  end
end
