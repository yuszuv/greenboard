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
import AddButton from "./AddButton.vue";
import SubscribeButton from "./SubscribeButton.vue";
import EditLink from "./EditButton.vue";
import DeleteLink from "./DeleteButton.vue";
import UpdateForm from "./UpdateForm.vue";
import CreateForm from "./CreateForm.vue";
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

  let el = document.getElementById("create-form");
  if (el) {
    new Vue({
      el: el,
      render: h => h(CreateForm)
    });
  }

  el = document.getElementById("update-form");
  if (el) {
    new Vue({
      el: el,
      render: h => h(UpdateForm, { props: { id: el.dataset.id } })
    });
  }

  el = document.getElementById("add-button");
  if (el) {
    new Vue({
      el: el,
      render: h => h(AddButton)
    });
  }

  el = document.getElementById("subscribe-button");
  if (el) {
    new Vue({
      el: el,
      render: h => h(SubscribeButton)
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

  const deleteLinks = document.getElementsByClassName("delete-link");
  let rres = [];
  for (var i = 0; i < deleteLinks.length; i++) {
    let el = deleteLinks[i];
    const context = { props: { id: parseInt(el.dataset.id) } };

    rres.push(() => {
      return new Vue({
        el: el,
        render: h => h(DeleteLink, context)
      });
    });
  }
  rres.forEach(t => t());

  const editLinks = document.getElementsByClassName("edit-link");
  let rrres = [];
  for (var i = 0; i < editLinks.length; i++) {
    let el = editLinks[i];
    const context = { props: { id: parseInt(el.dataset.id) } };

    rrres.push(() => {
      return new Vue({
        el: el,
        render: h => h(EditLink, context)
      });
    });
  }
  rrres.forEach(t => t());
});
