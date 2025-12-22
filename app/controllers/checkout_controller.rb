class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def create
    # 1. Validação Básica
    if session[:cart].blank?
      redirect_to cart_path, alert: "Seu carrinho está vazio."
      return
    end

    # --- NOVO: Validação de Pré-requisitos do Usuário ---
    # Se o usuário não tem documento, mandamos ele editar o perfil antes de comprar.
    if current_user.document.blank?
      # O ideal é ter uma rota para editar perfil, ex: edit_user_registration_path
      redirect_to edit_user_registration_path, alert: "Para finalizar a compra, precisamos que você preencha seu CPF/CNPJ no perfil."
      return
    end

    # if current_user.address.blank?
    #   redirect_to new_address_path, alert: "Cadastre um endereço para entrega."
    #   return
    # end
    # -----------------------------------------------------

    # 2. Busca os produtos do banco para pegar preços reais (Segurança)
    # Nunca confie em preços vindos do front-end/sessão
    @products = Product.where(id: session[:cart])

    # 3. Cria o Pedido (Transação de Banco de Dados)
    # Usamos transaction para garantir que cria TUDO ou NADA.
    ActiveRecord::Base.transaction do
      @order = Order.create!(
        user: current_user,
        address: current_user.address, # Assumindo que user tem address, senão redirecionar para cadastro
        payment_type: :billet, # Ou :billet, dependendo da sua regra default
        subtotal: @products.sum(&:price),
        total_amount: @products.sum(&:price), # Adicione frete/desconto aqui se houver
        installments: 1,
        document: current_user.document # Assumindo que user tem document
      )

      # 4. Cria os Itens do Pedido
      @products.each do |product|
        @order.order_items.create!(
          product: product,
          quantity: 1, # Seu carrinho atual não tem quantidade, assumimos 1
          payed_price: product.price,
        )
      end
    end

    # 5. Limpa o carrinho
    session[:cart] = []

    # MUDANÇA 2: REMOVEMOS A LINHA DO JOB AQUI!
    # Juno::ChargeCreationJob.perform_later(@order)  <-- APAGADA
    # O model Order já tem 'after_commit :enqueue_juno_charge_creation'

    redirect_to pay_test_path(@order.id), notice: "Pedido realizado com sucesso!"

  rescue ActiveRecord::RecordInvalid => e
    # Mantemos o debug por enquanto caso precise
    puts "\n🔴 ERRO: #{e.record.errors.full_messages.join(', ')} 🔴\n"

    redirect_to cart_path, alert: "Erro ao criar pedido: #{e.message}"
  end

  def pay_test
    # O .includes evita o problema de N+1 queries carregando os produtos junto
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  # Exemplo de como DEVE estar se o document vier do formulário
  def checkout_params
    params.require(:order).permit(:address_id, :payment_method, :document) # O :document está aqui?
  end

  def sandbox
    @order = Order.find(params[:id])
  end
end
