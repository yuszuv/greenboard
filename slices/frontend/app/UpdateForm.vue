<template>
  <card-form
    v-if="isAuthorized"
    :initialForm='form'
    @submit='requestUpdate'
    :errors="errors"
    :loading="loading"
    :wasValidated="wasValidated"
    :key='form.id'>
  </card-form>
  <b-modal
    v-else
    id="authorize-modal"
    hide-footer
    hide-backdrop>
    <template #modal-title>
      Eintrag freigeben
    </template>
    <authorize-form
      :id="id"
      @authorize='onAuthorize'>
    </authorize-form>
  </b-modal>
</template>

<script>
import axios from 'axios'

import AuthorizeForm from './AuthorizeForm.vue'
import CardForm from './Form.vue'

export default {
  data() {
    return {
      form: {},
      wasValidated: false,
      errors: {},
      isAuthorized: false,
      loading: false,
    }
  },
  components: {
    CardForm,
    AuthorizeForm,
  },
  props: ['id'],
  methods: {
    requestUpdate(form) {
      this.loading = true
      axios.patch(`/api/cards/${this.id}`, this.form)
        .then(response => {
          this.$emit('update')
          this.errors = {}
          this.wasValidated = true
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
