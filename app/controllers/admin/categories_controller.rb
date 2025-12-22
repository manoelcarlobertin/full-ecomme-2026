module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = Category.order(name: :asc)
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Categoria criada com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # O @category já é buscado pelo before_action set_category
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Categoria atualizada com sucesso!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      # Turbo Stream poderia ser usado aqui para remover a linha sem recarregar a página
      redirect_to admin_categories_path, notice: "Categoria excluída."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
