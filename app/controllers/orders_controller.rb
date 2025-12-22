class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    # Lista todos os pedidos do usuário, do mais recente para o mais antigo
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    # Busca um pedido específico, garantindo que pertence ao usuário logado
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Pedido não encontrado."
  end

  # NOVO MÉTODO
  def cancel
    # garantir que 'ninguém cancele' o pedido de outra pessoa por segurança.
    @order = current_user.orders.find(params[:id])

    if @order.cancellable?
      @order.update(status: :canceled)
      redirect_to orders_path, notice: "Pedido ##{@order.id} cancelado com sucesso."
    else
      redirect_to order_path(@order), alert: "Este pedido não pode ser cancelado (já foi enviado ou finalizado)."
    end
  end
end
