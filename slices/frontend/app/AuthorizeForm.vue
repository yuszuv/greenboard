<template>
  <div class="d-flex justify-content-center flex-column align-items-center">
    <b-spinner v-if="loading" label="Loading..." variant="primary" :class="{ 'form-loading': loading }"></b-spinner>
    <b-form @submit.prevent='requestAuthorize' class="d-inline-block">
      <b-form-group>
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

      <b-button type="submit" variant="primary">Freigeben</b-button>
    </b-form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      password: '',
      isAuthorized: false,
      error: false,
      loading: false,
    }
  },
  props: ['id'],
  methods: {
    requestAuthorize(event) {
      this.loading = true
      axios.post(`/api/cards/${this.id}/authorize`, { password: this.password })
        .then(response => {
          this.$emit('authorize', this.password)
          this.error = false
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

<style>
form {
  width: 100%;
}
</style>
