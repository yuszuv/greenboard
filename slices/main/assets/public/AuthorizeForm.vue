<template>
  <b-form @submit='requestAuthorize'>
    <b-form-group
      label="Passwort"
      label-for="password">
      <b-form-input
        id="topic"
        v-model="password"
        autofocus
        type="password"
        :class="(requestSent && !isAuthorized) && 'is-invalid'"
        @input="resetRequestSent"
        ></b-form-input>
      <small v-if="hasShowErrors" class="form-text invalid-feedback">Passwort stimmt nicht.</small>
      <small class="form-text">Das beim Erstellen angegebene Passwort.</small>
    </b-form-group>

    <b-button type="submit" variant="primary">Freigeben</b-button>
  </b-form>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      password: '',
      isAuthorized: false,
      requestSent: false,
    }
  },
  computed: {
    hasShowErrors() {
      return this.requestSent && !this.isAuthorized
    },
  },
  props: ['id'],
  methods: {
    requestAuthorize(event) {
      event.preventDefault()
      axios.post(`/api/cards/${this.id}/authorize`, { password: this.password })
        .then(response => {
          this.$emit('authorize', this.password)
          this.isAuthorized = true
        })
        .catch(error => {
          this.isAuthorized = false
        })
        .finally(response => {
          this.requestSent = true
        })
    },
    resetRequestSent() {
      this.requestSent = false
    },
  },
}
</script>
