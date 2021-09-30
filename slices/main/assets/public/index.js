// Import your JS here

import "@popperjs/core";
import "@fortawesome/fontawesome-free";
import "bootstrap";
import "./photoswipe";

import Vue from "vue";
import App from "./App.vue";

document.addEventListener("DOMContentLoaded", function() {
  if (document.getElementById("app")) {
    new Vue({
      el: "#app",
      render: h => h(App)
    });
  }
});
