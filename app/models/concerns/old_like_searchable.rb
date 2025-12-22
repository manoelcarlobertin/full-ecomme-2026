module OldLikeSearchable
  extend ActiveSupport::Concern

  class_methods do
    # Método de classe que gera o escopo dinamicamente
    # Ex: searchable_by(:name) -> cria scope :search_by_name
    def searchable_by(field)
      scope "search_by_#{field}", -> (value) {
        where("#{field} LIKE ?", "%#{value}%")
      }
    end
  end
end

# Generalizar o Concern (O Código Real)

# Agora precisamos que o seu Concern LikeSearchable saiba criar buscas para outros campos, não só para name.
