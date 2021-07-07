// Import your JS here

import "@popperjs/core";
import "@fortawesome/fontawesome-free";
import "bootstrap";
import "./photoswipe";

// import Vue from "vue";

// document.addEventListener("DOMContentLoaded", function() {
//   var app = new Vue({
//     el: "#app",
//     data: {
//       message: "Hello Vue!"
//     }
//   });
// });

import Vue from "vue";
import App from "./App.vue";

import Example from "./DropzoneExample2.vue";

document.addEventListener("DOMContentLoaded", function() {
  console.log(window.photos);
  new Vue({
    el: "#app",
    data: { images: [{ id: "foobar" }] },
    render: h => h(Example)
  });
});
