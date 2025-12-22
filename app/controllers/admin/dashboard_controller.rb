module Admin
  class DashboardController < AdminController
    def index
      # Agrupamos os dados em um Hash para manter o controller limpo
      # e a view organizada.
      @dashboard = {
        # Contamos apenas clientes (perfil 1), ignorando admins
        users_count: User.where(profile: :client).count,

        # Contamos produtos totais (você pode filtrar por status: :available se preferir)
        products_count: Product.count,

        # Contamos categorias
        categories_count: Category.count,

        # Receita(revenue)_Total: Multiplica quantidade * preço pago em cada item vendido
        # Se não houver vendas, retorna 0
        # --- A CORREÇÃO ESTÁ AQUI ---
        # 1. joins(:order): Junta a tabela de itens com a de pedidos
        # 2. where.not(...): Filtra EXCLUINDO pedidos cancelados
        total_revenue: OrderItem.joins(:order)
                                .where.not(orders: { status: :canceled })
                                .sum("order_items.quantity * order_items.payed_price") || 0
      }
    end
  end
end
