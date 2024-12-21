import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notice"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add('fade-out');
    }, 2000); // Wait for 3 seconds before starting the fade-out
  }
}
