import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "input" ]

  connect() {

  }

  updateResults() {
    const searchInput = this.inputTarget.value
    $.ajax({
      url: "/search_results",
      method: "POST",
      data: {
        query:  searchInput
      }
    });
  }
}