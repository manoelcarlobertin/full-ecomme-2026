import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["notification"]

  connect() {
    // Espera 4 segundos (4000ms) e começa a desaparecer
    setTimeout(() => {
      this.dismiss()
    }, 4000)
  }

  dismiss() {
    const element = this.notificationTarget
    
    // Adiciona classes para o efeito de "sumir" (Fade Out + Slide Up)
    element.classList.add("opacity-0", "-translate-y-full")
    
    // Remove do DOM após a transição terminar
    setTimeout(() => {
      element.remove()
    }, 500)
  }
}