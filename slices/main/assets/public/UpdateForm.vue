<template>
  <div>
    <card-form
      :initialForm='form'
      @submit='requestUpdate'
      :errors="errors"
      :wasValidated="wasValidated"
      :key='form.id'>
    </card-form>
    <b-modal v-if="!isAuthorized" id="authorize-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Eintrag freigeben
      </template>
      <div class="d-block text-center">
        <authorize-form
          :id="id"
          @authorize='onAuthorize'>
        </authorize-form>
      </div>
    </b-modal>
  </div>
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
    }
  },
  components: {
    CardForm,
    AuthorizeForm,
  },
  props: {
    id: {
      type: String,
      required: true,
    }
  },
  methods: {
    requestUpdate(form) {
      axios.patch(`/api/cards/${this.id}`, this.form)
        .then(response => {
          this.wasValidated = true
          window.location.href = "/"
        })
        .catch(function(err) {
          console.log(err)
          //this.errors = e.response.data
          //this.wasValidated = true
          window.scrollTo(0,0)
        })
    },
    onAuthorize(password) {
      this.isAuthorized = true
      this.form['current_password'] = password
      axios.get(`/api/cards/${this.id}`)
        .then(response => {
          this.form = response.data
          this.form['current_password'] = password
        })
        .catch(e => {
          console.log(e.response.data)
          this.errors = e.response.data
          this.wasValidated = true
          window.scrollTo(0,0)
      })
    },
  },
  mounted() {
    this.$bvModal.show('authorize-modal')
  },
}
</script>
