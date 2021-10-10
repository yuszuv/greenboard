<template>
  <card-form :initialForm='form' @submit='requestUpdate' :errors="errors" :wasValidated="wasValidated" :key='form.id'></card-form>
</template>

<script>
import axios from 'axios'

import CardForm from './Form.vue'

export default {
  data() {
    return {
      form: {},
      wasValidated: false,
      errors: {},
    }
  },
  components: {
    CardForm,
  },
  props: {
    id: {
      type: String,
      required: true,
    }
  },
  created() {
    axios.get(`/api/cards/${this.id}`)
      .then(response => {
        this.form = response.data
      })
      .catch(e => {
        console.log(e.response.data)
        this.errors = e.response.data
        this.wasValidated = true
        window.scrollTo(0,0)
      })
  },
  methods: {
    requestUpdate(form) {
      axios.patch(`/api/cards/${this.id}`, this.form)
        .then(response => {
          this.wasValidated = true
          local.assign("/")
          //this.form = response.data
        })
        .catch(e => {
          this.errors = e.response.data
          this.wasValidated = true
          window.scrollTo(0,0)
        })
    }
  }
}
</script>
