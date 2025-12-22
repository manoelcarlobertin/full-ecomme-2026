module AdminHelper
  # Helper de Navegação:
  # Para que o menu lateral saiba qual item ficar azul (ativo) automaticamente
  def admin_nav_link(text, path, icon_svg)
    # Verifica se a URL atual contém o caminho do link para marcar como ativo
    active = request.path.include?(path.split("/").last)

    base_classes = "flex items-center p-3 text-base font-medium rounded-lg group transition-colors duration-200"
    active_classes = active ? "text-blue-400 bg-gray-800" : "text-gray-400 hover:bg-gray-800 hover:text-white"

    link_to path, class: "#{base_classes} #{active_classes}" do
      # Concatena o Ícone com o Texto com segurança
      (icon_svg + content_tag(:span, text, class: "ml-3")).html_safe
    end
  end
end
