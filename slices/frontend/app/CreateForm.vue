<template>
  <card-form
    :initialForm='form'
    @submit='requestCreate'
    :errors="errors"
    :loading="loading"
    :wasValidated="wasValidated"
    :key='form.id'>
  </card-form>
</template>

<script>
import axios from 'axios'

import CardForm from './Form.vue'

export default {
  data() {
    return {
      form: {
        id: '',
        type: 'SUCHE',
        topic: '',
        text: '',
        contact: '',
        images: [],
        password: '',
        password_confirmation: '',
        tos: false,
      },
      wasValidated: false,
      errors: {},
      loading: false,
    }
  },
  components: {
    CardForm,
  },
  methods: {
    requestCreate(form) {
      this.loading = true
      axios.post('/api/cards', this.form)
        .then(response => {

          this.wasValidated = true
          location.assign("/")
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
