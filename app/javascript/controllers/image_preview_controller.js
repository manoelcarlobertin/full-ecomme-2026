import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Definimos os "alvos" que vamos manipular no HTML
  static targets = ["input", "preview", "placeholder"]

  // Essa função roda toda vez que o input muda (change)
  readURL() {
    const input = this.inputTarget
    const preview = this.previewTarget
    const placeholder = this.placeholderTarget

    if (input.files && input.files[0]) {
      const reader = new FileReader()

      reader.onload = (e) => {
        // 1. Atualiza a fonte da imagem com o arquivo selecionado
        preview.src = e.target.result
        
        // 2. Torna a imagem visível (remove transparência e classes de hidden)
        preview.classList.remove("hidden", "opacity-0")
        preview.classList.add("opacity-100")

        // 3. Esconde o ícone de upload para ficar limpo
        placeholder.classList.add("hidden")
      }

      reader.readAsDataURL(input.files[0])
    }
  }
}