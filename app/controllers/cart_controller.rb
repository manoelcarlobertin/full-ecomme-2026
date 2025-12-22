class CartController < ApplicationController
  # O carrinho é público, então não usamos :authenticate_user! nem :require_admin!

  def show
    # 1. Busca Produtos + Imagem (Attached) + Jogo (Productable) + Requisitos
    # Tudo em poucas queries otimizadas
    @cart_products = Product
                      .with_attached_image # Evita N+1 da imagem
                      .includes(productable: :system_requirement) # Evita N+1 dos detalhes técnicos
                      .where(id: session[:cart]) # compact evita nils

    # 2. OTIMIZAÇÃO DE CÁLCULO:
    # Usamos '&:price' para somar usando os dados JÁ carregados na memória,
    # em vez de 'sum(:price)' que faria uma nova consulta SQL ao banco.
    @total_value = @cart_products.sum(&:price)
  end

  def add
    # 1. Inicializa o carrinho se não existir
    session[:cart] ||= []

    product_id = params[:product_id].to_i

    # 2. Adiciona o ID se ainda não estiver lá (Evita duplicados para produtos digitais)
    unless session[:cart].include?(product_id)
      session[:cart] << product_id
    end

    # 2.1 REMOVER da Tela/Lista de Desejos se cliquei no botão COMPRAR lá da Lista!
    # Verificamos se o usuário está logado E se o parâmetro foi enviado
    if user_signed_in? && params[:from_wishlist]
      wish_item = current_user.wish_items.find_by(product_id: params[:product_id])
      wish_item&.destroy # O & evita erro se o item já tiver sido apagado
    end

    # 3. Resposta visual
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          # 1. Substitui o ícone do carrinho pelo novo (com número atualizado)
          turbo_stream.replace("cart_counter", partial: "shared/cart_counter", locals: { count: session[:cart].size }),
          # Feedback visual (Flash message)
          turbo_stream.update("flash_messages", partial: "shared/flash", locals: { notice: "Produto adicionado ao carrinho!" })
        ]
      end
      # o botão "Adicionar ao Carrinho" leve o usuário diretamente para a tela do carrinho,
      format.html { redirect_to cart_path, notice: "Produto foi MOVIDO da Lista de Desejos para o carrinho com sucesso!" }
    end
  end

  def remove
    session[:cart] ||= []
    product_id = params[:product_id].to_i

    session[:cart].delete(product_id)

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Produto foi EXCLUÍDO do carrinho com sucesso." }
      format.turbo_stream do
        render turbo_stream: [
          # 1. Remove a linha do produto visualmente
          turbo_stream.remove("cart_item_#{product_id}"),

          # 2. Atualiza o Total (já tínhamos feito isso)
          turbo_stream.replace("cart_total", partial: "cart/total", locals: { total: Product.where(id: session[:cart]).sum(:price) }),

          # 3. [NOVO] Atualiza a Bolinha Vermelha do Menu
          turbo_stream.replace("cart_counter", partial: "shared/cart_counter", locals: { count: session[:cart].size })
        ]
      end
    end
  end
end
