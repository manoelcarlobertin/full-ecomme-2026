module Admin
  class ProductsController < AdminController
    before_action :load_product, only: %i[show edit update destroy]

    # Diminuir a complexidade cognitiva da action index, criando métodos auxiliares:
        # @loading_service = Admin::ModelLoadingService.new(Product.all, searchable_params)
        #  @loading_service.call
    #                             note --- aqui abaixo --- refatorado no futuro
    def index
      # Inclui :categories e :image_attachment para evitar consultas N+1 (Performance) 'Eager Loading'
      # A ordem das chamadas geralmente não altera o resultado final do SQL,
      # mas é uma 'boa prática' filtrar (search) antes de ordenar (order).
      @products = Product.with_attached_image
                         .includes(:categories)
                         .search(params[:search])
                         .order(name: :asc)
    end

    def new
      @product = Product.new
      # Inicializa um Game vazio associado ao produto para o formulário aparecer
      @product.productable = Game.new
    end

    # rodou um service PARA SALVAR produto, --- aqui abaixo --- refatorado no futuro
    # colocou um 'rescue' para lidar com falhas em: create e update

    def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to admin_products_path, notice: "Produto criado com sucesso!"
      else
        # Se falhar, garantimos que o objeto productable exista para o form não quebrar
        @product.productable ||= Game.new
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # Se o produto não tem um jogo associado (ou o link está quebrado),
      # inicializamos um novo Game para que os campos apareçam no formulário.
      @product.productable ||= Game.new
    end

    def show; end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: "Produto atualizado!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      # @product.productable.destroy! if @product.productable.present? # Remover o objeto associado primeiro
      begin
        @product.destroy! # Usando 'bang!' para lançar exceção em falha
        redirect_to admin_products_path, notice: "Produto removido."

        # Implementar render_error em ApplicationController -- aqui abaixo --- refatorado no futuro
      rescue ActiveRecord::RecordNotDestroyed
        render_error(fields: @product.errors.messages.merge(@product.productable.errors.messages))
      end
    end

    private

    def load_product
      @product = Product.find(params[:id])
    end

    def product_params
      return {} unless params.has_key?(:product)

      params.require(:product).permit(
        :id, :name, :description, :price, :status, :featured, :image,
        :productable_type,
        category_ids: [],
        # Aqui está o segredo: Aceitamos a lista de atributos do jogo diretamente.
        # Não precisamos calcular 'type_key'. O Rails faz o mapeamento sozinho
        # porque o formulário enviou "productable_attributes".
        productable_attributes: [:id, :mode, :developer, :release_date, :system_requirement_id]
      )
    end
    # --- acima ---
    # "Pode aceitar o pacote 'productable_attributes' com os campos id, mode, developer, etc.".
    # É simples, seguro e elimina a lógica quebrada.

    def game_params
      # Aqui garantimos que o 'ID' dos requisitos de sistema 'seja aceito' aqui abaixo no final
      params.require(:product).permit(:mode, :release_date, :developer, :system_requirement_id)
    end
  end
end

# Note: na action index;
# Por que isso funciona?

# Product... Inicia a query. E depois...

# .with_attached_image.includes(:categories): Prepara o Eager Loading para evitar o problema de N+1 (Performance mantida).

# .search(params[:search]):

# Se você digitou "FIFA", ele adiciona WHERE name LIKE '%FIFA%'.

# Se não digitou nada, ele retorna all (não muda a query) e segue o fluxo.

# .order(name: :asc): Ordena o resultado final (seja ele filtrado ou a lista completa).
