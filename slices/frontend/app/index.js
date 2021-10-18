import Vue from "vue";
import { ToastPlugin, BootstrapVue } from "bootstrap-vue";
import PortalVue from "portal-vue";

import Board from "./Board.vue";

Vue.use(PortalVue);
Vue.use(BootstrapVue);
Vue.use(ToastPlugin);

document.addEventListener("DOMContentLoaded", function() {
  if (document.getElementById("board")) {
    new Vue({
      el: "#board",
      render: h => h(Board)
    });
  }
});
