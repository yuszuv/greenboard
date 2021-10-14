<template>
  <div v-if="loading" class="d-flex justify-content-center mb-3">
    <b-spinner label="Loading..."></b-spinner>
  </div>
  <b-form v-else @submit.prevent='requestDelete'>
    <b-form-group
      label="Passwort"
      label-for="password">
      <b-form-input
        id="topic"
        v-model="password"
        autofocus
        type="password"
        :class="error && 'is-invalid'"
        @input="resetError"
        ></b-form-input>
      <small v-if="error" class="form-text invalid-feedback">Passwort stimmt nicht.</small>
      <small class="form-text">Das beim Erstellen angegebene Passwort.</small>
    </b-form-group>

    <b-button type="submit" variant="danger">Löschen</b-button>
  </b-form>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      password: '',
      isAuthorized: false,
      success: false,
      error: false,
      loading: false,
    }
  },
  props: ['id'],
  methods: {
    requestDelete(event) {
      this.loading = true
      axios.post(`/api/cards/${this.id}`, { "_method": "delete", password: this.password })
        .then(response => {
          this.$emit('delete', this.password)
          this.success = true
        })
        .catch(error => {
          this.error = true
        })
        .finally(response => {
          this.loading = false
        })
    },
    resetError() {
      this.error = false
    },
  },
}
</script>
