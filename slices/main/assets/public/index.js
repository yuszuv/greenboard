// Import your JS here

import "@popperjs/core";
import "@fortawesome/fontawesome-free";
import "bootstrap";
import "./photoswipe";

import Vue from "vue";
import { ToastPlugin, BootstrapVue } from "bootstrap-vue";
import PortalVue from "portal-vue";

import App from "./App.vue";
import Form from "./Form.vue";
import ContactToggler from "./ContactToggler.vue";

Vue.use(PortalVue);
// Make BootstrapVue available throughout your project
Vue.use(BootstrapVue);
Vue.use(ToastPlugin);

document.addEventListener("DOMContentLoaded", function() {
  if (document.getElementById("app")) {
    new Vue({
      el: "#app",
      render: h => h(App)
    });
  }

  if (document.getElementById("form")) {
    new Vue({
      el: "#form",
      render: h => h(Form)
    });
  }

  const togglers = document.getElementsByClassName("contact-toggler");
  let res = [];
  for (var i = 0; i < togglers.length; i++) {
    let el = togglers[i];
    const context = { props: { cardId: parseInt(el.dataset.id) } };

    res.push(() => {
      return new Vue({
        el: el,
        render: h => h(ContactToggler, context)
      });
    });
  }
  res.forEach(t => t());
});
