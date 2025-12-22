import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["window", "backdrop"]

  connect() {
    console.log("✅ Controller do Modal Conectado com Sucesso!") // <--- ADICIONE ISSO
    this.close()
  }

  open(event) {
    if (event) event.preventDefault() // Impede que o botão recarregue a página ou envie form
    this.windowTarget.classList.remove("hidden")
    this.backdropTarget.classList.remove("hidden")
    
    // Animação de entrada
    setTimeout(() => {
        this.windowTarget.classList.remove("opacity-0", "scale-95")
        this.windowTarget.classList.add("opacity-100", "scale-100")
    }, 10)
  }

  close(event) {
    if (event) event.preventDefault()
    // Animação de saída
    this.windowTarget.classList.remove("opacity-100", "scale-100")
    this.windowTarget.classList.add("opacity-0", "scale-95")
    
    setTimeout(() => {
        this.windowTarget.classList.add("hidden")
        this.backdropTarget.classList.add("hidden")
    }, 300)
  }
}