import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notice"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add('fade-out');
    }, 1500); // Wait for 2 seconds before starting the fade-out
    setTimeout(() => {
      this.element.classList.add('hidden');
    }, 3000);
  }
}
