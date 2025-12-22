module LikeSearchable
  extend ActiveSupport::Concern

  included do
    # Nada aqui por enquanto
  end

  class_methods do
    # 1. Método de classe que gera o escopo dinamicamente
    # Ex: searchable_by(:name) -> cria scope :search_by_name
    def searchable_by(field)
      scope "search_by_#{field}", -> (value) {
        where("#{field} LIKE ?", "%#{value}%")
      }

      # 2. Cria o método genérico 'search' que redireciona para o específico
      # Isso permite que no Controller a gente chame apenas Model.search("termo")

      define_singleton_method :search do |value|
        return all if value.blank?
        send("search_by_#{field}", value)
      end
    end
  end
end


# --- Essa é uma ótima ideia! ---

# Para tornar o LikeSearchable verdadeiramente útil

# --- nas Views e Controllers de forma genérica ---
# (sem precisar ficar lembrando se o model busca por name, key ou email),
# --- precisamos CRIAR uma Interface Padrão. ---

# No controller, você sempre chamará apenas isso abaixo:

# --- Model.search(params[:search]) ---

# independente do campo que está sendo buscado por baixo dos panos!

# Para isso, cada model que incluir o LikeSearchable DEVE
# chamar o método de classe 'searchable_by' passando o campo
# que será buscado.

# Exemplo de uso em um model:

# class User < ApplicationRecord
#   include LikeSearchable
#
#   searchable_by :name
# end

# Com isso, o User terá um escopo chamado 'search_by_name'
# e um método de classe 'search' que redireciona para ele.

# Assim, no controller, você pode fazer:

# class UsersController < ApplicationController
#   def index
#     @users = User.search(params[:search])
#   end
# end

# E isso funcionará corretamente buscando pelo campo 'name'.
