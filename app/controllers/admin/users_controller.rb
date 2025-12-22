# Atenção: A atualização de usuário tem um "truque" importante com a senha.

# Se o admin deixar a senha em branco na edição, o Rails não deve tentar alterá-la. Adicionei essa lógica no método update.
module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[edit update destroy]

    def index
      # O método .search agora procura por ID, Nome ou Email automaticamente
      @users = User.search(params[:search]).order(id: :asc)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: "Usuário criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # @user já é setado pelo before_action
    end

    def update
      # Se o admin deixar a senha em branco na edição, o Rails NÃO deve tentar alterá-la.
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if @user.update(user_params)
        redirect_to admin_users_path, notice: "Usuário atualizado com sucesso!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "Você não pode excluir a si mesmo!"
      else
        @user.destroy
        redirect_to admin_users_path, notice: "Usuário excluído."
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
    end
  end
end
