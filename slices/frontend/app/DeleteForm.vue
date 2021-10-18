<template lang="pug">
div
  b-modal#delete-modal(hide-footer hide-backdrop)
    template(#modal-title) {{ modalTitle }}
    template(v-if="!success")
      .spinner-wrapper.d-flex.justify-content-center.mb-3(v-if='loading')
        b-spinner(label='Loading...')

      b-form(@submit.prevent='requestDelete' :class="{ 'form-loading': loading }")
        b-form-group(label='Passwort' label-for='password')
          b-form-input#topic(
            autofocus=''
            type='password'
            v-model='password'
            :class="error && 'is-invalid'"
            @input='resetError'
          )
          small.form-text.invalid-feedback(v-if='error') Passwort stimmt nicht.
          small.form-text Das beim Erstellen angegebene Passwort.

        b-button(type='submit' variant='danger') Löschen

    template(v-else)
      b-alert(variant='success' show='') Eintrag erfolgreich gelöscht
      a.btn.btn-success(type='submit' variant='success' @click.prevent="onSuccessClick") Schließen
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
  computed: {
    modalTitle() {
      return this.success ? "Eintrag gelöscht" : "Löschen bestätigen"
    },
  },
  methods: {
    onSuccessClick() {
      this.$emit('delete', this.id)
      setTimeout(() => {
        this.resetForm()
      }, 1000)
    },
    resetForm() {
      this.success = false
      this.isAuthorized = false
      this.loading = false
      this.error = false
      this.password = ''
    },
    requestDelete(event) {
      this.loading = true

      axios.post(`/api/cards/${this.id}`, { "_method": "delete", password: this.password })
        .then(response => {
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
