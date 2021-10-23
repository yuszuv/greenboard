<template lang="pug">
div
  b-modal#build-modal(hide-footer='' hide-backdrop='')
    template(#modal-title='') Neuer Eintrag
    card-form(
      :initialForm='form'
      :errors="errors"
      :loading="loading"
      :wasValidated="false"
      :key="'build'"
      @submit='requestCreate'
      )
</template>

<script>
import axios from 'axios'

import CardForm from './Form.vue'

const INITIAL_FORM = {
  id: '',
  type: 'SUCHE',
  topic: '',
  text: '',
  contact: '',
  images: [],
  password: '',
  password_confirmation: '',
  tos: false,
}
const INITIAL_ERRORS = {}

export default {
  data() {
    return {
      form: INITIAL_FORM,
      errors: INITIAL_ERRORS,
      wasValidated: false,
      loading: false,
      success: false,
    }
  },
  components: {
    CardForm,
  },
  methods: {
    resetForm() {
      this.form = INITIAL_FORM
      this.errors = INITIAL_ERRORS
      this.wasValidated = false
    },
    requestCreate(form) {
      this.loading = true
      axios.post('/api/cards', this.form)
        .then(response => {
          // wait for modal to be closed
          // avoids a FOUC
          const card = response.data

          this.$emit('create', card.id.toString())
          setTimeout(() =>{
            this.resetForm()
            this.isAuthorized = false
          }, 1000)
        })
        .catch(e => {
          this.errors = e.response.data
          this.wasValidated = true
          window.scrollTo(0,0)
        })
        .finally(e => {
          this.loading = false
        })
    }
  },
}
</script>
