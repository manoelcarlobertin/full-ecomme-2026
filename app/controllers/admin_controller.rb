class AdminController < ApplicationController
  layout "admin"

  # 1. Exige que o usuário esteja logado (Devise)
  before_action :authenticate_user!

  # 2. Exige que o usuário seja Admin (Nossa regra de negócio)
  ### Blindar o AdminController ###
  before_action :require_admin!

  helper :admin

  private

  def require_admin!
    # Se não for admin, manda de volta para a home com um aviso
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso não autorizado. Área restrita a administradores."
    end
  end
end

# before_action :ensure_admin!      # Lógica futura para garantir que é admin
