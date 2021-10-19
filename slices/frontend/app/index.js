import Vue from "vue";

import { ToastPlugin, BootstrapVue } from "bootstrap-vue";
import PortalVue from "portal-vue";
import Photoswipe from "vue-pswipe";

import Board from "./Board.vue";

const pswipeOptions = {};

Vue.use(PortalVue);
Vue.use(BootstrapVue);
Vue.use(ToastPlugin);
Vue.use(Photoswipe, pswipeOptions);

document.addEventListener("DOMContentLoaded", function() {
  if (document.getElementById("board")) {
    new Vue({
      el: "#board",
      render: h => h(Board)
    });
  }
});
