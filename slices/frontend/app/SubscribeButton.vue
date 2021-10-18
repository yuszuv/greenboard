<template lang="pug">
div
  a.btn.btn-outline-warning.bg-white.shadow.m-2(v-b-modal.subscribe-modal='' href='#') #[i.fas.fa-bullhorn] Updates abonnieren
  b-modal#subscribe-modal(hide-footer='' hide-backdrop='')
    template(#modal-title)
      | Bei neuen Eintr&auml;gen benachrichtigen lassen
    .d-flex.justify-content-center.flex-column.align-items-center(v-if='!success')
      b-spinner(
        v-if='loading'
        label='Loading...'
        variant='primary'
        :class="{ 'form-loading': loading }"
      )
      b-form.d-inline-block.mx-5(
        :class="{ 'form-loading': loading }"
        @submit.prevent='onSubmit'
      )

        b-form-group(label='E-Mail-Addresse:' label-for='subscribe-email')
          b-form-input#subscribe-email(
            v-model='form.email'
            type='email'
            :class="{ 'is-invalid': hasErrorOn('email') }"
            autofocus=''
            required=''
            )
          small.text-danger {{ errorsOn(&apos;email&apos;) }}
          small.form-text.text-muted Wir geben die Adresse #[em niemals] weiter
        b-form-group(label='Nutzungsbedingungen' label-for='subscribe-tos')
          b-form-checkbox#subscribe-tos(
            v-model='form.tos'
            name='subscribe-tos'
            :state="validationState('tos')"
            @change='resetErrors()'
            )
            | Ich habe die #[a(href='#' @click.prevent="$bvModal.show('tos-modal')" v-b-modal.tos-modal='') Nutzungsbedingungen] gelesen und akzeptiert

        b-button(type='submit' variant='primary') Abonnieren
        b-button(variant='danger' @click.prevent="$bvModal.hide('subscribe-modal')") Schlie&szlig;en

        tos-modal

    div(v-else)
      h4 #[i.fas.fa-envelope] Bestätigungs-Mail versendet
      p Vielen Dank für deine Eintragung. Wir haben gerade eine Email geschickt, mit der sie noch bestätigen musst.
      b-button(variant='primary' @click.prevent="$bvModal.hide('subscribe-modal')") Schließen
</template>

<script>
import axios from 'axios'

import TosModal from './TosModal.vue'

export default {
  data() {
    return {
      loading: false,
      errors: {},
      success: false,
      form: {
        email: '',
        tos: false,
      },
    }
  },
  computed: {
    error() {
      return Object.keys(this.errors).length !== 0
    },
  },
  components: {
    TosModal,
  },
  methods: {
    onSubmit() {
      this.loading = true
      this.resetErrors()
      axios.post('/api/subscribe_updates', this.form)
        .then(res => {
          this.success = true
        })
        .catch(res => {
          this.errors = res.response.data
        })
        .finally(() => {
          this.loading = false
        })
    },
    hasErrorOn(key) {
      return key in this.errors
    },
    errorsOn(key) {
      const errors = this.errors[key]
      if (errors != null && errors.length > 0) {
        return errors.join(", ")
      } else {
        return null;
      }
    },
    resetErrors() {
      this.errors = {}
    },
    validationState(key) {
      if (this.loading == false && (key in this.errors)) {
        return false
      } else if (this.success) {
        return true
      } else {
        return null
      }
    },
  }
}
</script>
