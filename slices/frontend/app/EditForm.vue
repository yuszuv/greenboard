<template lang="pug">
div
  b-modal#edit-modal(hide-footer hide-backdrop)
    template(#modal-title) {{ modalTitle }}
    template(v-if="isAuthorized && !success")
      card-form(
        :key="form.id"
        :wasValidated="wasValidated"
        :loading="loading"
        :initialForm="form"
        :errors="errors"
          @submit="requestUpdate"
      )
    template(v-if="!isAuthorized")
      authorize-form(
        :id="id"
        @authorize="onAuthorize"
        )
</template>

<script>
import axios from 'axios'

import AuthorizeForm from './AuthorizeForm.vue'
import CardForm from './Form.vue'

const INITIAL_FORM = {}
const INITIAL_ERRORS = {}

export default {
  data() {
    return {
      form: INITIAL_FORM,
      errors: INITIAL_ERRORS,
      wasValidated: false,
      loading: false,
      success: false,
      isAuthorized: false,
    }
  },
  computed: {
    modalTitle() {
      if (!this.wasValidated) {
        return "Eintrag freigeben"
      } else if (this.wasValidated && !success) {
        return "Eintrag bearbeiten"
      }
    },
  },
  components: {
    CardForm,
    AuthorizeForm,
  },
  props: ['id'],
  methods: {
    resetForm() {
      this.form = INITIAL_FORM
      this.errors = INITIAL_ERRORS
      this.wasValidated = false
    },
    requestUpdate(form) {
      this.loading = true
      axios.patch(`/api/cards/${this.id}`, this.form)
        .then(response => {
          // wait for modal to be closed
          // avoids a FOUC
          this.$emit('update')
          setTimeout(() =>{
            this.resetForm()
            this.isAuthorized = false
          }, 1000)
        })
        .catch(err => {
          this.errors = err.response.data
          this.wasValidated = true
          window.scrollTo(0,0)
        })
        .finally(e => {
          this.loading = false
        })
    },
    onAuthorize(password) {
      this.isAuthorized = true
      this.form['current_password'] = password
      this.loading = true
      this.errors = {}
      axios.get(`/api/cards/${this.id}`)
        .then(response => {
          this.form = response.data
          this.form['current_password'] = password
        })
        .catch(e => {
          this.errors = e.response.data
          this.wasValidated = true
          window.scrollTo(0,0)
        })
        .finally(e => {
          this.loading = false
        })
    },
  },
  mounted() {
    this.$bvModal.show('authorize-modal')
  },
}
</script>
